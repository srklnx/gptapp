import 'package:flutter/material.dart';

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.healthy,
    required this.attention,
    required this.urgent,
    required this.breeding,
    required this.withdrawal,
    required this.heatRisk,
  });

  final Color healthy;
  final Color attention;
  final Color urgent;
  final Color breeding;
  final Color withdrawal;
  final Color heatRisk;

  @override
  AppStatusColors copyWith({
    Color? healthy,
    Color? attention,
    Color? urgent,
    Color? breeding,
    Color? withdrawal,
    Color? heatRisk,
  }) => AppStatusColors(
    healthy: healthy ?? this.healthy,
    attention: attention ?? this.attention,
    urgent: urgent ?? this.urgent,
    breeding: breeding ?? this.breeding,
    withdrawal: withdrawal ?? this.withdrawal,
    heatRisk: heatRisk ?? this.heatRisk,
  );

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      healthy: Color.lerp(healthy, other.healthy, t)!,
      attention: Color.lerp(attention, other.attention, t)!,
      urgent: Color.lerp(urgent, other.urgent, t)!,
      breeding: Color.lerp(breeding, other.breeding, t)!,
      withdrawal: Color.lerp(withdrawal, other.withdrawal, t)!,
      heatRisk: Color.lerp(heatRisk, other.heatRisk, t)!,
    );
  }
}

@immutable
class AppFieldSettings extends ThemeExtension<AppFieldSettings> {
  const AppFieldSettings({
    required this.minimumTouchTarget,
    required this.strongBorders,
    required this.reducedDecoration,
    required this.textScale,
  });

  final double minimumTouchTarget;
  final bool strongBorders;
  final bool reducedDecoration;
  final double textScale;

  @override
  AppFieldSettings copyWith({
    double? minimumTouchTarget,
    bool? strongBorders,
    bool? reducedDecoration,
    double? textScale,
  }) => AppFieldSettings(
    minimumTouchTarget: minimumTouchTarget ?? this.minimumTouchTarget,
    strongBorders: strongBorders ?? this.strongBorders,
    reducedDecoration: reducedDecoration ?? this.reducedDecoration,
    textScale: textScale ?? this.textScale,
  );

  @override
  AppFieldSettings lerp(ThemeExtension<AppFieldSettings>? other, double t) {
    if (other is! AppFieldSettings) return this;
    return AppFieldSettings(
      minimumTouchTarget: _lerp(
        minimumTouchTarget,
        other.minimumTouchTarget,
        t,
      ),
      strongBorders: t < 0.5 ? strongBorders : other.strongBorders,
      reducedDecoration: t < 0.5 ? reducedDecoration : other.reducedDecoration,
      textScale: _lerp(textScale, other.textScale, t),
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;
