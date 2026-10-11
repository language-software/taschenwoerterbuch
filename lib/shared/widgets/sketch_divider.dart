import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';

/// A hand-drawn horizontal divider with a slight wobble.
class SketchDivider extends StatelessWidget {
  const SketchDivider({
    super.key,
    this.seed = 1,
    this.color,
    this.strokeWidth = 1.2,
  });

  final int seed;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 6,
        width: double.infinity,
        child: CustomPaint(
          painter: _SketchLinePainter(
            seed: seed,
            color: color ?? context.colors.borderStrong,
            strokeWidth: strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _SketchLinePainter extends CustomPainter {
  _SketchLinePainter({
    required this.seed,
    required this.color,
    required this.strokeWidth,
  });

  final int seed;
  final Color color;
  final double strokeWidth;

  static const _segmentLength = 40.0;
  static const _roughness = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    double j() => (rnd.nextDouble() - .5) * 2 * _roughness;

    final y = size.height / 2;
    final segments = max(1, (size.width / _segmentLength).round());
    final path = Path()..moveTo(0, y + j());
    for (var s = 1; s <= segments; s++) {
      final from = size.width * (s - .5) / segments;
      final to = size.width * s / segments;
      path.quadraticBezierTo(from, y + j(), to, y + j());
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_SketchLinePainter o) =>
      o.seed != seed || o.color != color || o.strokeWidth != strokeWidth;
}
