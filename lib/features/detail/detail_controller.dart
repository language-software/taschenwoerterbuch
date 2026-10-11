import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/data/dictionary_providers.dart';
import 'package:taschenwoerterbuch/data/fold.dart';
import 'package:taschenwoerterbuch/data/models/entry.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

/// Identifies a dictionary entry: its row [id] within the database of [pair].
typedef EntryKey = ({int id, LangPair pair});

/// Loads a complete [Entry] for the given [EntryKey].
///
/// Reads the entry row, its senses ordered by position, and the translations
/// and definitions of each sense.
///
/// Throws a [StateError] if no entry with the given id exists.
final entryProvider = FutureProvider.family<Entry, EntryKey>((ref, key) async {
  final db = await ref.watch(dictionaryDbProvider(key.pair).future);

  final entryRows = await db.query(
    'entry',
    where: 'id = ?',
    whereArgs: [key.id],
    limit: 1,
  );
  if (entryRows.isEmpty) {
    throw StateError('Eintrag ${key.id} nicht gefunden');
  }
  final e = entryRows.first;

  final senseRows = await db.query(
    'sense',
    columns: ['id'],
    where: 'entry_id = ?',
    whereArgs: [key.id],
    orderBy: 'position',
  );
  final senseIds = [for (final r in senseRows) r['id']! as int];

  /// Fetches all texts from [table] (`translation` or `definition`) in one
  /// query, grouped by sense id and ordered by position. Every sense id is
  /// present in the result, with an empty list if it has no texts.
  Future<Map<int, List<String>>> texts(String table) async {
    final result = {for (final id in senseIds) id: <String>[]};
    if (senseIds.isEmpty) return result;
    final rows = await db.query(
      table,
      columns: ['sense_id', 'text'],
      where: 'sense_id IN (${List.filled(senseIds.length, '?').join(',')})',
      whereArgs: senseIds,
      orderBy: 'sense_id, position',
    );
    for (final r in rows) {
      result[r['sense_id']! as int]!.add(r['text']! as String);
    }
    return result;
  }

  final translations = await texts('translation');
  final definitions = await texts('definition');

  /// Returns the trimmed value of [column] in the entry row, or `null` if it
  /// is missing or blank.
  String? str(String column) {
    final v = e[column] as String?;
    return (v == null || v.trim().isEmpty) ? null : v.trim();
  }

  return Entry(
    id: key.id,
    lemma: e['lemma']! as String,
    pos: str('pos'),
    gender: str('gender'),
    plural: str('plural'),
    ipa: str('ipa'),
    audioUrl: str('audio_url'),
    auxiliary: str('auxiliary'),
    template: str('template'),
    senses: [
      for (final id in senseIds)
        Sense(translations: translations[id]!, definitions: definitions[id]!),
    ],
  );
});

/// Finds the counterpart entries of an entry's translations.
///
/// The translations of [EntryKey.pair] are headwords of the opposite
/// direction, so they are looked up there by exact match. The result
/// maps each translation that has at least one counterpart to the ids of the
/// matching entries; translations without counterpart are absent.
final translationTargetsProvider =
    FutureProvider.family<Map<String, List<int>>, EntryKey>((ref, key) async {
      final entry = await ref.watch(entryProvider(key).future);
      final terms = {for (final s in entry.senses) ...s.translations};
      if (terms.isEmpty) return {};

      try {
        final db = await ref.watch(
          dictionaryDbProvider(key.pair.reversed).future,
        );
        final folded = {for (final t in terms) t: fold(t)};
        final rows = await db.query(
          'lookup',
          columns: ['term_fold', 'entry_id'],
          where: 'term_fold IN (${List.filled(folded.length, '?').join(',')})',
          whereArgs: folded.values.toSet().toList(),
          orderBy: 'kind, entry_id',
        );
        final idsByFold = <String, List<int>>{};
        for (final r in rows) {
          final ids = idsByFold.putIfAbsent(
            r['term_fold']! as String,
            () => [],
          );
          final id = r['entry_id']! as int;
          if (!ids.contains(id)) ids.add(id);
        }
        return {for (final t in terms) t: ?idsByFold[folded[t]]};
      } catch (_) {
        return {};
      }
    });
