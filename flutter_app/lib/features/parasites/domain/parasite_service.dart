import '../../health/domain/famacha.dart';
import 'parasite_records.dart';

enum FamachaTrend { improving, stable, worsening, insufficient }

/// Computes a FAMACHA trend from history (a trend is more useful than one
/// isolated score). Never claims FAMACHA alone diagnoses anemia.
abstract final class FamachaService {
  static FamachaTrend trend(List<FamachaRecord> records) {
    if (records.length < 2) return FamachaTrend.insufficient;
    final sorted = [...records]
      ..sort((a, b) => a.date.compareTo(b.date));
    final first = sorted.first.score;
    final last = sorted.last.score;
    if (last > first) return FamachaTrend.worsening;
    if (last < first) return FamachaTrend.improving;
    return FamachaTrend.stable;
  }
}

/// Derives a parasite risk profile (never a diagnosis, and never an automatic
/// deworming decision). The output is descriptive and explainable.
abstract final class ParasiteRiskService {
  static ParasiteRiskAssessment assess({
    int? famachaScore,
    double? bcs,
    bool? bottleJaw,
    bool? diarrhea,
    bool? weightLoss,
    bool? paleEyelids,
    bool? recentFecalTest,
    DateTime? lastDewormingAt,
    int similarSheepAffected = 0,
    DateTime? now,
  }) {
    final reasons = <String>[];
    void flag(String reason) {
      if (!reasons.contains(reason)) reasons.add(reason);
    }

    if (famachaScore != null && famachaScore >= 4) flag('famacha_high');
    if (famachaScore == 3) flag('famacha_borderline');
    if (bottleJaw == true) flag('bottle_jaw');
    if (paleEyelids == true) flag('pale_eyelids');
    if (weightLoss == true) flag('weight_loss');
    if (diarrhea == true) flag('diarrhea');
    if (recentFecalTest == false) flag('no_recent_fecal_test');
    if (bcs != null && bcs <= 2) flag('low_bcs');
    if (lastDewormingAt != null &&
        (now ?? DateTime.now()).difference(lastDewormingAt).inDays > 90) {
      flag('no_recent_deworming');
    }
    if (similarSheepAffected >= 3) flag('flock_similar_signs');

    final ParasiteRiskLevel level;
    if (reasons.contains('famacha_high') ||
        reasons.contains('bottle_jaw') ||
        reasons.contains('pale_eyelids')) {
      level = ParasiteRiskLevel.highConcern;
    } else if (reasons.contains('famacha_borderline') ||
        reasons.contains('weight_loss') ||
        reasons.contains('no_recent_fecal_test')) {
      level = ParasiteRiskLevel.needsAssessment;
    } else if (reasons.contains('low_bcs') ||
        reasons.contains('no_recent_deworming') ||
        reasons.contains('diarrhea')) {
      level = ParasiteRiskLevel.monitor;
    } else {
      level = ParasiteRiskLevel.low;
    }

    return ParasiteRiskAssessment(riskLevel: level, reasons: reasons);
  }
}

/// Transparent weight-based dosing. Only calculates when a verified protocol
/// supplies mg/kg and the product supplies concentration (mg/mL).
abstract final class DoseCalculator {
  static double? calculateVolume({
    required double weightKg,
    required double mgPerKg,
    required double mgPerMl,
  }) {
    if (weightKg <= 0 || mgPerKg <= 0 || mgPerMl <= 0) return null;
    final mg = weightKg * mgPerKg;
    final volume = mg / mgPerMl;
    return (volume * 100).round() / 100;
  }
}

/// Validation helpers for fecal tests and treatment response.
abstract final class ParasiteValidation {
  static bool isValidFamacha(int score) => score >= 1 && score <= 5;

  static bool isValidFecalEggCount(int? count) => count == null || count >= 0;

  static String? responseConcern(TreatmentResponse? response) =>
      response == TreatmentResponse.worse || response == TreatmentResponse.unchanged
          ? 'possible_reduced_effectiveness'
          : null;
}
