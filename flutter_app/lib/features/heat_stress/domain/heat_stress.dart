enum HeatRiskLevel { safe, alert, danger, emergency }

class HeatStressThresholds {
  const HeatStressThresholds({
    this.alertThi = 72,
    this.dangerThi = 79,
    this.emergencyThi = 84,
  }) : assert(alertThi < dangerThi && dangerThi < emergencyThi);

  final double alertThi;
  final double dangerThi;
  final double emergencyThi;
}

class HeatStressAssessment {
  const HeatStressAssessment({required this.thi, required this.level});

  final double thi;
  final HeatRiskLevel level;
}

abstract final class HeatStressService {
  static HeatStressAssessment assess({
    required double temperatureC,
    required double relativeHumidity,
    HeatStressThresholds thresholds = const HeatStressThresholds(),
  }) {
    if (!temperatureC.isFinite ||
        !relativeHumidity.isFinite ||
        relativeHumidity < 0 ||
        relativeHumidity > 100) {
      throw ArgumentError('Temperature and humidity must be valid readings.');
    }
    final temperatureF = temperatureC * 9 / 5 + 32;
    final thi =
        temperatureF -
        (0.55 - 0.0055 * relativeHumidity) * (temperatureF - 26);
    final level = thi >= thresholds.emergencyThi
        ? HeatRiskLevel.emergency
        : thi >= thresholds.dangerThi
        ? HeatRiskLevel.danger
        : thi >= thresholds.alertThi
        ? HeatRiskLevel.alert
        : HeatRiskLevel.safe;
    return HeatStressAssessment(thi: thi, level: level);
  }
}
