import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:taschenwoerterbuch/core/paths.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';

class DictionaryMissingException implements Exception {
  const DictionaryMissingException();

  @override
  String toString() => 'Dictionary not installed';
}

class DictionaryLoader {
  DictionaryLoader();

  final _open = <LangPair, Future<Database>>{};

  /// Open database for given [LangPair].
  Future<Database> open(LangPair pair) {
    return _open.putIfAbsent(pair, () => _load(pair));
  }

  /// Close all open databases.
  Future<void> close() async {
    final pending = _open.values.toList();
    _open.clear();
    for (final future in pending) {
      try {
        await (await future).close();
      } catch (_) {}
    }
  }

  /// Load the given [LangPair] and open its database.
  Future<Database> _load(LangPair pair) async {
    try {
      final path = await Paths.dictionaryFile(pair);
      if (!await File(path).exists()) throw const DictionaryMissingException();
      return await openDatabase(path, readOnly: true, singleInstance: true);
    } catch (_) {
      _open.remove(pair);
      rethrow;
    }
  }
}
