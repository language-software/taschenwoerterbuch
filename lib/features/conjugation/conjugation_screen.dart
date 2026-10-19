import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/models/conjugation.dart';
import 'package:taschenwoerterbuch/data/models/lang_pair.dart';
import 'package:taschenwoerterbuch/features/conjugation/conjugation_controller.dart';
import 'package:taschenwoerterbuch/features/conjugation/labels.dart';
import 'package:taschenwoerterbuch/features/conjugation/widgets/conjugation_table.dart';
import 'package:taschenwoerterbuch/features/conjugation/widgets/tense_accordion.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_button.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_progress_indicator.dart';

/// Screen showing the infinitive of a verb and all of its tenses.
class ConjugationScreen extends ConsumerWidget {
  const ConjugationScreen({
    super.key,
    required this.entryId,
    required this.pair,
  });

  /// ID of the verb entry.
  final int entryId;

  /// Language pair in which the entry is looked up.
  final LangPair pair;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final conjugation = ref.watch(
      conjugationProvider((id: entryId, pair: pair)),
    );
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: conjugation.when(
                  data: (c) => _ConjugationView(conjugation: c),
                  loading: () => const Center(child: SketchSpinner()),
                  error: (e, _) => Text(l10n.conjugationLoadError(e)),
                ),
              ),
              const SizedBox(height: 12),
              SketchButton(
                label: l10n.back,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConjugationView extends StatelessWidget {
  const _ConjugationView({required this.conjugation});

  final Conjugation conjugation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = AppLocalizations.of(context);
    return ListView(
      children: [
        Semantics(
          header: true,
          child: Text(
            conjugation.infinitive,
            style: AppTypography.headlineSerif.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (final (i, pane) in conjugation.tenses.indexed)
          TenseAccordion(
            title: tenseLabel(l10n, pane.mood, pane.tense),
            initiallyExpanded: i == 0,
            dividerSeed: i + 1,
            child: ConjugationTable(pane: pane),
          ),
      ],
    );
  }
}
