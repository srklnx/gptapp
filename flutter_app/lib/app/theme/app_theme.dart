import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

enum AppThemeMode { light, dark, sun }

abstract final class AppTheme {
  static ThemeData fromMode(AppThemeMode mode) {
    final isDark = mode == AppThemeMode.dark;
    final isSun = mode == AppThemeMode.sun;
    final foreground = isDark
        ? const Color(0xFFF4F1E9)
        : isSun
        ? const Color(0xFF171B18)
        : AppColors.text;
    final primary = isDark ? const Color(0xFFA6C69D) : AppColors.primary;
    final background = isDark
        ? AppColors.darkBackground
        : isSun
        ? Colors.white
        : AppColors.background;
    final surface = isDark
        ? AppColors.darkSurface
        : isSun
        ? Colors.white
        : AppColors.surface;
    final outline = isDark
        ? AppColors.darkOutline
        : isSun
        ? const Color(0xFF333333)
        : AppColors.outline;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      secondary: isDark ? const Color(0xFFBAC58D) : AppColors.secondary,
      surface: surface,
      error: AppColors.urgent,
    );
    final field = AppFieldSettings(
      minimumTouchTarget: isSun ? 56 : 48,
      strongBorders: isSun,
      reducedDecoration: isSun,
      textScale: isSun ? 1.12 : 1,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: surface,
      dividerColor: outline,
      visualDensity: isSun
          ? VisualDensity.standard
          : VisualDensity.adaptivePlatformDensity,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: foreground,
        displayColor: foreground,
        fontSizeFactor: field.textScale,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: foreground,
          fontSize: isSun ? 21 : 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: isDark
            ? const Color(0xFF344438)
            : const Color(0xFFE8F0E8),
        height: isSun ? 76 : 68,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(fontSize: isSun ? 12 : 11, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: isSun ? 0 : 1,
        color: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          side: isSun ? BorderSide(color: outline, width: 2) : BorderSide.none,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: outline, width: isSun ? 2 : 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: outline, width: isSun ? 2 : 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: BorderSide(color: primary, width: isSun ? 3 : 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: Size(48, field.minimumTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
            side: isSun
                ? BorderSide(color: foreground, width: 2)
                : BorderSide.none,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(48, field.minimumTouchTarget),
          side: BorderSide(color: outline, width: isSun ? 2 : 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppStatusColors(
          healthy: isDark ? AppColors.darkHealthy : AppColors.healthy,
          attention: isDark ? AppColors.darkAttention : AppColors.attention,
          urgent: isDark ? AppColors.darkUrgent : AppColors.urgent,
          breeding: isDark ? AppColors.darkBreeding : AppColors.breeding,
          withdrawal: isDark ? AppColors.darkWithdrawal : AppColors.withdrawal,
          heatRisk: isDark ? AppColors.darkHeatRisk : AppColors.heatRisk,
        ),
        field,
      ],
    );
  }
}
