import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/data/models/entry.dart';
import 'package:taschenwoerterbuch/features/search/search_controller.dart';
import 'package:taschenwoerterbuch/l10n/generated/app_localizations.dart';

/// A single search result: the term with its part-of-speech labels below.
class SearchRow extends StatelessWidget {
  const SearchRow({super.key, required this.hit, required this.onTap});

  final SearchHit hit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final labels = {for (final e in hit.entries) ?posLabel(l10n, e.pos)};
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hit.term,
                    style: AppTypography.body.copyWith(
                      fontSize: 22,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  if (labels.isNotEmpty)
                    Text(
                      labels.join(', '),
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        color: context.colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
