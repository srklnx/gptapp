import 'package:flutter/foundation.dart';

import 'health_observation.dart';

/// A red flag is an urgent warning sign that deserves prompt veterinary
/// assessment. It is rule-based and always phrased conservatively — never as a
/// diagnosis or a prescription.
@immutable
class HealthRiskResult {
  const HealthRiskResult({required this.isUrgent, required this.reasons});

  final bool isUrgent;

  /// Stable reason ids mapped to localized, conservative warning text.
  final List<String> reasons;
}

/// Identifies urgent warning signs from selected symptoms, answers and the
/// farmer's own severity rating.
///
/// Rules are intentionally explicit so each one can be unit-tested and none
/// accidentally presents a medical conclusion.
abstract final class HealthRiskService {
  static HealthRiskResult assess({
    required Set<String> symptomIds,
    required Map<String, List<String>> answers,
    required HealthSeverity severity,
  }) {
    final reasons = <String>[];

    void flag(String reason) {
      if (!reasons.contains(reason)) reasons.add(reason);
    }

    final isSevere = severity == HealthSeverity.severe;

    if (symptomIds.contains('difficulty_breathing') && isSevere) {
      flag('severe_breathing');
    }
    if (symptomIds.contains('bloating') && isSevere) {
      flag('severe_bloating');
    }
    if (symptomIds.contains('weakness') && isSevere) {
      flag('severe_weakness');
    }
    if (symptomIds.contains('not_drinking') ||
        answers['drinking']?.contains('not_drinking') == true) {
      flag('not_drinking');
    }
    if (answers['lameness_severity']?.contains('unable_to_walk') == true) {
      flag('unable_to_stand');
    }
    if ((symptomIds.contains('possible_eye_injury') && isSevere) ||
        answers['eye_injury']?.contains('yes') == true) {
      flag('severe_eye_injury');
    }
    if (symptomIds.contains('neurologic_signs')) {
      flag('neurologic_signs');
    }
    if (symptomIds.contains('sudden_death')) {
      flag('sudden_death');
    }
    if (symptomIds.contains('recumbent')) {
      flag('unable_to_stand');
    }
    if (symptomIds.contains('not_drinking') && isSevere) {
      flag('severe_dehydration');
    }

    return HealthRiskResult(isUrgent: reasons.isNotEmpty, reasons: reasons);
  }
}
