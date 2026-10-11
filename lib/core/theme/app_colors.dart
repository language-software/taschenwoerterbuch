import 'package:flutter/material.dart';

/// Warm, typewriter-minimalist color palette. Values are converted from the
/// oklch() colors defined in new-design.html (Dart has no native oklch()
/// support) via the reference OKLab/OKLCH -> sRGB matrices.
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLabel;
  final Color textLink;
  final Color deactivatedTextLink;
  final Color borderStrong;
  final Color borderSubtle;
  final Color danger;
  final Color highlight;
  final Color sketchStroke;
  final Color scribble;
  final Color scribbleDisabled;
  final Color paper;
  final Color paperDisabled;

  const AppColors({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLabel,
    required this.textLink,
    required this.deactivatedTextLink,
    required this.borderStrong,
    required this.borderSubtle,
    required this.danger,
    required this.highlight,
    required this.sketchStroke,
    required this.scribble,
    required this.scribbleDisabled,
    required this.paper,
    required this.paperDisabled,
  });

  static const light = AppColors(
    background: Color(0xFFFBF7EE),
    textPrimary: Color(0xFF3B3B3B),
    textSecondary: Color(0xFF66635D),
    textLabel: Color(0xFF58554F),
    textLink: Color(0xFF302D28),
    deactivatedTextLink: Color(0xFF6B6B6B),
    borderStrong: Color(0xFFD8D4CD),
    borderSubtle: Color(0xFFE7E4E0),
    danger: Color(0xFF8C3019),
    highlight: Color(0xFF324967),
    sketchStroke: Color(0xFF2B2B3A),
    scribble: Color(0xFFFFB5D4),
    scribbleDisabled: Color(0xFFE6E2D8),
    paper: Color(0xFFFFFFFF),
    paperDisabled: Color(0xFFF1EEE6),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? textPrimary,
    Color? textSecondary,
    Color? textLabel,
    Color? textLink,
    Color? deactivatedTextLink,
    Color? borderStrong,
    Color? borderSubtle,
    Color? danger,
    Color? highlight,
    Color? sketchStroke,
    Color? scribble,
    Color? scribbleDisabled,
    Color? paper,
    Color? paperDisabled,
    Color? ratingAgain,
    Color? ratingHard,
    Color? ratingGood,
    Color? ratingEasy,
  }) {
    return AppColors(
      background: background ?? this.background,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textLabel: textLabel ?? this.textLabel,
      textLink: textLink ?? this.textLink,
      deactivatedTextLink: deactivatedTextLink ?? this.deactivatedTextLink,
      borderStrong: borderStrong ?? this.borderStrong,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      danger: danger ?? this.danger,
      highlight: highlight ?? this.highlight,
      sketchStroke: sketchStroke ?? this.sketchStroke,
      scribble: scribble ?? this.scribble,
      scribbleDisabled: scribbleDisabled ?? this.scribbleDisabled,
      paper: paper ?? this.paper,
      paperDisabled: paperDisabled ?? this.paperDisabled,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textLabel: Color.lerp(textLabel, other.textLabel, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      deactivatedTextLink: Color.lerp(
        deactivatedTextLink,
        other.deactivatedTextLink,
        t,
      )!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      sketchStroke: Color.lerp(sketchStroke, other.sketchStroke, t)!,
      scribble: Color.lerp(scribble, other.scribble, t)!,
      scribbleDisabled: Color.lerp(
        scribbleDisabled,
        other.scribbleDisabled,
        t,
      )!,
      paper: Color.lerp(paper, other.paper, t)!,
      paperDisabled: Color.lerp(paperDisabled, other.paperDisabled, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
