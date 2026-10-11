import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_painter.dart';

class SketchButton extends StatefulWidget {
  const SketchButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  State<SketchButton> createState() => _SketchButtonState();
}

class _SketchButtonState extends State<SketchButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final colors = context.colors;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: widget.onPressed,
        child: Transform.translate(
          offset: _down ? const Offset(3, 3) : Offset.zero,
          child: CustomPaint(
            painter: SketchPainter(
              seed: widget.label.hashCode,
              stroke: colors.sketchStroke,
              scribble: enabled ? colors.scribble : colors.scribbleDisabled,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64, minWidth: 112),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 20,
                ),
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    widget.label,
                    style: AppTypography.body,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
