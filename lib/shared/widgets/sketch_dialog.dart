import 'package:flutter/material.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_painter.dart';

class SketchDialog extends StatelessWidget {
  const SketchDialog({
    super.key,
    required this.title,
    this.content,
    this.actions = const [],
  });

  final String title;
  final Widget? content;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = AppTypography.body;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: CustomPaint(
        painter: SketchPainter(
          seed: title.hashCode,
          stroke: colors.sketchStroke,
          paper: colors.background,
          shadow: const Offset(4, 4),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 32, 36, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: textTheme.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (content != null) ...[
                const SizedBox(height: 12),
                DefaultTextStyle.merge(
                  style: textTheme.copyWith(
                    color: colors.textSecondary,
                  ),
                  child: content!,
                ),
              ],
              if (actions.isNotEmpty) ...[
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.end,
                    children: actions,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showSketchDialog<T>({
  required BuildContext context,
  required String title,
  Widget? content,
  List<Widget> actions = const [],
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) =>
        SketchDialog(title: title, content: content, actions: actions),
  );
}
