import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String? latinFontFamily = null;
  static const String? arabicFontFamily = null;

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
    titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 16),
    bodySmall: TextStyle(fontSize: 14),
    labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
  );
}
