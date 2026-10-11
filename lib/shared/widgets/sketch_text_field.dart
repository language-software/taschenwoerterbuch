import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taschenwoerterbuch/core/theme/app_colors.dart';
import 'package:taschenwoerterbuch/core/theme/app_typography.dart';
import 'package:taschenwoerterbuch/shared/widgets/sketch_painter.dart';

class SketchTextField extends StatefulWidget {
  const SketchTextField({
    super.key,
    this.label,
    this.controller,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.minHeight = 56,
  });

  final String? label;
  final TextEditingController? controller;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double minHeight;

  @override
  State<SketchTextField> createState() => _SketchTextFieldState();
}

class _SketchTextFieldState extends State<SketchTextField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = widget.errorText != null;
    final focused = _focusNode.hasFocus;
    final textStyle = AppTypography.body.copyWith(
      color: widget.enabled ? colors.textPrimary : colors.deactivatedTextLink,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              widget.label!.toUpperCase(),
              style: AppTypography.sectionTitle.copyWith(
                color: colors.textLabel,
              ),
            ),
          ),
          const SizedBox(height: 2),
        ],
        CustomPaint(
          painter: SketchPainter(
            seed: (widget.label ?? widget.hint).hashCode,
            paper: Colors.transparent,
            scribble: focused && widget.enabled ? colors.scribble : null,
            stroke: hasError ? colors.danger : colors.sketchStroke,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: widget.minHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Center(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  style: textStyle,
                  cursorColor: colors.textPrimary,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: textStyle.copyWith(
                      color: colors.deactivatedTextLink,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 2),
            child: Text(
              widget.errorText!,
              style: AppTypography.body.copyWith(
                color: colors.danger,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
