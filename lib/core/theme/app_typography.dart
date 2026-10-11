import 'package:flutter/widgets.dart';

class AppTypography {
  AppTypography._();

  static const _main = "Caveat Brush";
  static const _body = "Patrick Hand";
  static const _ipaFont = "Charis SIL";

  /// Page titles (e.g. box name), Newsreader 32/600.
  static const headlineSerif = TextStyle(
    fontFamily: _main,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  /// Section title with letter spacing of 1.25
  static const sectionTitle = TextStyle(
    fontFamily: _main,
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.25,
  );

  /// Regular body text, Work Sans 16/400.
  static const body = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const ipa = TextStyle(
    fontFamily: _ipaFont,
    fontSize: 16
  );
}
