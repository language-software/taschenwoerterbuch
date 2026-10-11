import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_painter.dart';

class SketchNavItem {
  const SketchNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SketchNavBar extends StatelessWidget {
  const SketchNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  }) : assert(items.length >= 2);

  final List<SketchNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomPaint(
      child: Material(
        color: colors.background,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 80,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavBarItem(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SketchNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.textPrimary : colors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: CustomPaint(
          painter: selected
              ? SketchPainter(
                  seed: item.label.hashCode,
                  stroke: colors.sketchStroke,
                  scribble: colors.scribble,
                  roughness: 1,
                  outline: false,
                  scribbleWidth: 5,
                  overshoot: 3,
                )
              : null,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 24, color: color),
                const SizedBox(height: 2),
                Text(
                  item.label,
                  style: AppTypography.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
