import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/models/conjugation.dart';
import 'package:taschenwoerterbuch/features/conjugation/labels.dart';

/// Two-column table of one tense: the person on the left, the conjugated
/// form on the right.
class ConjugationTable extends StatelessWidget {
  const ConjugationTable({super.key, required this.pane});

  final TensePane pane;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      children: [
        for (final row in pane.rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  personLabel(pane.mood, pane.tense, row.person),
                  style: AppTypography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  row.forms.join(' / '),
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
