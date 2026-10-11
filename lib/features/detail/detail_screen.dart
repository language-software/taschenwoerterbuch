import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/models/entry.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';
import 'package:taschenwoerterbuch/features/conjugation/conjugation_screen.dart';
import 'package:taschenwoerterbuch/features/detail/detail_controller.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_button.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_progress_indicator.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_text_button.dart';
import 'package:taschenwoerterbuch/features/detail/widgets/speaker_button.dart';

/// Detailed information screen for one or more dictionary entries.
class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.entryIds, required this.pair});

  /// IDs of the entries to display, in display order.
  final List<int> entryIds;

  /// Language pair in which the entries are looked up.
  final LangPair pair;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (final (i, id) in entryIds.indexed) ...[
                      if (i > 0) const Divider(height: 32),
                      _EntrySection(entryId: id, pair: pair),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SketchButton(
                label: AppLocalizations.of(context).back,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loads a single entry and, depending on the state of [entryProvider], shows
/// the [_EntryView], a loading indicator or an error message.
class _EntrySection extends ConsumerWidget {
  const _EntrySection({required this.entryId, required this.pair});

  /// ID of the entry to load.
  final int entryId;

  /// Language pair in which the entry is looked up.
  final LangPair pair;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(entryProvider((id: entryId, pair: pair)))
        .when(
          data: (e) => _EntryView(entry: e, pair: pair),
          loading: () => const Center(child: SketchSpinner()),
          error: (e, _) => Text(AppLocalizations.of(context).entryLoadError(e)),
        );
  }
}

/// Presentation of a loaded [Entry].
///
/// Shows the lemma as a heading, followed by a meta line (part of speech,
/// gender, plural, auxiliary verb), an optional IPA pronunciation with a
/// [SpeakerButton], and the numbered senses with their definitions.
class _EntryView extends StatelessWidget {
  const _EntryView({required this.entry, required this.pair});

  /// The entry to display.
  final Entry entry;

  /// Language pair in which the entry is looked up.
  final LangPair pair;

  /// Abbreviations for the gender values from the data. Unknown values are
  /// displayed unchanged.
  static const _genderLabels = {'masc': 'm', 'fem': 'f', 'neut': 'n'};

  bool _conjugationAvailable() =>
      entry.pos == 'verb' && entry.template != null && pair == LangPair.frDe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    final meta = <String>[
      ?posLabel(l10n, entry.pos),
      if (entry.gender != null)
        entry.gender!.split('/').map((g) => _genderLabels[g] ?? g).join('/'),
      if (entry.plural != null) l10n.pluralAbbr(entry.plural!),
      if (entry.auxiliary != null) l10n.auxiliaryVerb(entry.auxiliary!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            entry.lemma,
            style: AppTypography.headlineSerif.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            meta.join(' · '),
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
        ],
        if (entry.ipa != null || entry.audioUrl != null)
          Row(
            children: [
              if (entry.ipa != null)
                Text(
                  '[${entry.ipa}]',
                  style: AppTypography.ipa,
                ),
              if (entry.audioUrl != null) ...[
                const SizedBox(width: 20),
                SpeakerButton(audioUrl: entry.audioUrl!),
              ],
            ],
          ),
        if (_conjugationAvailable())
          SketchTextButton(
            label: l10n.conjugations(entry.template!.replaceAll(":", "")),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    ConjugationScreen(entryId: entry.id, pair: pair),
              ),
            ),
          ),
        if (entry.senses.isNotEmpty)
          Semantics(
            header: true,
            child: Text(
              l10n.senses,
              style: AppTypography.sectionTitle.copyWith(
                color: colors.textLabel,
              ),
            ),
          ),
        for (final (i, s) in entry.senses.indexed)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. ${s.translations.join('; ')}',
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
                for (final d in s.definitions)
                  Text(
                    d,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
