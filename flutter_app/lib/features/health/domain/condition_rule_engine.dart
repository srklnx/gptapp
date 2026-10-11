import 'condition.dart';

/// Transparent, deterministic rule engine that ranks conditions by how well
/// the recorded pattern matches their required/supporting/contradicting
/// observations and risk factors.
///
/// It never produces a medical certainty or a numeric "score" presented as a
/// diagnosis. It produces descriptive compatibility levels plus an explanation.
abstract final class ConditionRuleEngine {
  static List<ConditionCandidate> evaluate({
    required List<HealthCondition> conditions,
    required Set<String> observedSymptoms,
    required HealthContext context,
  }) {
    final candidates = <ConditionCandidate>[];
    for (final condition in conditions) {
      if (!condition.active) continue;

      final matchedCompatible = condition.compatibleSymptoms
          .where(observedSymptoms.contains)
          .toList();
      final triggered =
          condition.compatibleSymptoms.isEmpty || matchedCompatible.isNotEmpty;
      if (!triggered) continue;

      // Exclude a condition only when the life stage is known and differs.
      if (condition.ageGroups.isNotEmpty &&
          context.ageGroup != null &&
          !condition.ageGroups.contains(context.ageGroup)) {
        continue;
      }

      final matchedRequired = condition.requiredSymptoms
          .where(observedSymptoms.contains)
          .toList();
      final matchedSupporting = condition.supportingSymptoms
          .where(observedSymptoms.contains)
          .toList();
      final contradictions = condition.contradictingSymptoms
          .where(observedSymptoms.contains)
          .toList();
      final matchedRisk = condition.riskFactors
          .where(context.effectiveRiskFactors.contains)
          .toList();

      var compatibility = _compatibility(
        condition,
        matchedRequired,
        matchedSupporting,
        contradictions,
        matchedRisk,
      );

      // If a condition is specific to a life stage but the age is unknown, we
      // cannot confirm it — downgrade rather than over-state compatibility.
      if (condition.ageGroups.isNotEmpty && context.ageGroup == null) {
        compatibility = _downgrade(compatibility);
      }

      candidates.add(
        ConditionCandidate(
          condition: condition,
          compatibility: compatibility,
          matchedRequired: matchedRequired,
          matchedSupporting: matchedSupporting,
          matchedRiskFactors: matchedRisk,
          contradictions: contradictions,
          missingChecks: List.unmodifiable(condition.recommendedChecks),
        ),
      );
    }
    candidates.sort(_rank);
    return List.unmodifiable(candidates);
  }

  static CompatibilityLevel _compatibility(
    HealthCondition condition,
    List<String> matchedRequired,
    List<String> matchedSupporting,
    List<String> contradictions,
    List<String> matchedRisk,
  ) {
    if (contradictions.isNotEmpty) return CompatibilityLevel.lessLikely;
    if (condition.requiredSymptoms.isNotEmpty) {
      if (matchedRequired.length == condition.requiredSymptoms.length) {
        return CompatibilityLevel.stronglyCompatible;
      }
      if (matchedRequired.isNotEmpty) return CompatibilityLevel.compatible;
    }
    if (matchedSupporting.length >= 2 || matchedRisk.isNotEmpty) {
      return CompatibilityLevel.compatible;
    }
    return CompatibilityLevel.possible;
  }

  static CompatibilityLevel _downgrade(CompatibilityLevel level) =>
      switch (level) {
        CompatibilityLevel.stronglyCompatible => CompatibilityLevel.compatible,
        CompatibilityLevel.compatible => CompatibilityLevel.possible,
        CompatibilityLevel.possible => CompatibilityLevel.possible,
        CompatibilityLevel.lessLikely => CompatibilityLevel.lessLikely,
        CompatibilityLevel.insufficient => CompatibilityLevel.insufficient,
      };

  static int _rank(ConditionCandidate a, ConditionCandidate b) {
    final byCompatibility = b.compatibility.rank.compareTo(a.compatibility.rank);
    if (byCompatibility != 0) return byCompatibility;
    final aImportance = a.matchedRequired.length + a.matchedRiskFactors.length;
    final bImportance = b.matchedRequired.length + b.matchedRiskFactors.length;
    final byImportance = bImportance.compareTo(aImportance);
    if (byImportance != 0) return byImportance;
    return b.matchedSupporting.length.compareTo(a.matchedSupporting.length);
  }
}
