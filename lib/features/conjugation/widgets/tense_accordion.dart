import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_chevron.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_divider.dart';

/// One accordion pane: a tappable [title] that expands or collapses [child].
class TenseAccordion extends StatefulWidget {
  const TenseAccordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.dividerSeed = 1,
  });

  final String title;
  final Widget child;
  final bool initiallyExpanded;
  final int dividerSeed;

  @override
  State<TenseAccordion> createState() => _TenseAccordionState();
}

class _TenseAccordionState extends State<TenseAccordion> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _expanded,
          label: widget.title,
          excludeSemantics: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _expanded = !_expanded),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppTypography.body.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: SketchChevron(
                      seed: widget.dividerSeed,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: _expanded
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: widget.child,
                )
              : const SizedBox(width: double.infinity),
        ),
        SketchDivider(seed: widget.dividerSeed),
      ],
    );
  }
}
