import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';

/// A hand-drawn downward chevron with slightly wobbly strokes.
class SketchChevron extends StatelessWidget {
  const SketchChevron({
    super.key,
    this.seed = 1,
    this.color,
    this.size = 24,
    this.strokeWidth = 1.8,
  });

  final int seed;
  final Color? color;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _SketchChevronPainter(
            seed: seed,
            color: color ?? context.colors.textPrimary,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _SketchChevronPainter extends CustomPainter {
  _SketchChevronPainter({
    required this.seed,
    required this.color,
    required this.strokeWidth,
  });

  final int seed;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final roughness = size.width * .04;
    Offset p(double x, double y) => Offset(
      size.width * x + (rnd.nextDouble() - .5) * 2 * roughness,
      size.height * y + (rnd.nextDouble() - .5) * 2 * roughness,
    );

    final left = p(.25, .38);
    final tip = p(.5, .64);
    final right = p(.75, .36);
    final c1 = p(.38, .5);
    final c2 = p(.62, .5);
    final path = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(c1.dx, c1.dy, tip.dx, tip.dy)
      ..quadraticBezierTo(c2.dx, c2.dy, right.dx, right.dy);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SketchChevronPainter o) =>
      o.seed != seed || o.color != color || o.strokeWidth != strokeWidth;
}
