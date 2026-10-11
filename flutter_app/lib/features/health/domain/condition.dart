import 'package:flutter/foundation.dart';

/// Life stage of a sheep. Health logic treats a neonatal lamb and a pregnant
/// adult ewe very differently.
enum AgeGroup {
  neonatal('neonatal'),
  youngLamb('young_lamb'),
  growingLamb('growing_lamb'),
  adult('adult'),
  senior('senior');

  const AgeGroup(this.key);
  final String key;

  static AgeGroup fromBirthDate(DateTime birthDate, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final days = reference.difference(birthDate).inDays;
    if (days < 0) return AgeGroup.adult;
    if (days < 7) return AgeGroup.neonatal;
    if (days < 56) return AgeGroup.youngLamb;
    if (days < 182) return AgeGroup.growingLamb;
    if (days < 1825) return AgeGroup.adult;
    return AgeGroup.senior;
  }
}

/// Broad category a condition belongs to.
enum ConditionCategory { digestive, respiratory, eye, hoof, metabolic, parasite, skin, general, reproductive }

/// Describes how strongly a recorded pattern matches a condition.
///
/// These are descriptive categories, never medical certainty.
enum CompatibilityLevel { stronglyCompatible, compatible, possible, lessLikely, insufficient }

extension CompatibilityLevelRank on CompatibilityLevel {
  int get rank => switch (this) {
    CompatibilityLevel.stronglyCompatible => 4,
    CompatibilityLevel.compatible => 3,
    CompatibilityLevel.possible => 2,
    CompatibilityLevel.lessLikely => 1,
    CompatibilityLevel.insufficient => 0,
  };
}

/// Derived risk level shown to the farmer (never stored as a manual field).
enum HealthRiskLevel { routine, needsAttention, urgent }

enum VeterinaryReviewLevel { none, recommended, urgent }

/// The context the decision engine uses in addition to the raw symptoms.
@immutable
class HealthContext {
  const HealthContext({
    this.ageGroup,
    this.pregnant = false,
    this.lateGestation = false,
    this.lowBcs = false,
    this.riskFactorKeys = const {},
  });

  final AgeGroup? ageGroup;
  final bool pregnant;
  final bool lateGestation;
  final bool lowBcs;
  final Set<String> riskFactorKeys;

  Set<String> get effectiveRiskFactors => {
    if (ageGroup != null) ageGroup!.key,
    if (pregnant) 'pregnant',
    if (lateGestation) 'late_gestation',
    if (lowBcs) 'low_bcs',
    ...riskFactorKeys,
  };
}

/// A condition in the health knowledge library.
///
/// The matching configuration (compatible/required/supporting/contradicting
/// symptoms, risk factors) is the transparent "rule" the engine evaluates.
@immutable
class HealthCondition {
  const HealthCondition({
    required this.id,
    required this.category,
    this.species = const ['Sheep'],
    this.ageGroups = const [],
    this.compatibleSymptoms = const [],
    this.requiredSymptoms = const [],
    this.supportingSymptoms = const [],
    this.contradictingSymptoms = const [],
    this.riskFactors = const [],
    this.redFlags = const [],
    this.recommendedChecks = const [],
    this.diagnosticTests = const [],
    this.immediateActions = const [],
    this.treatmentProtocolIds = const [],
    this.preventionActions = const [],
    this.contagious = false,
    this.isolationRecommended = false,
    this.veterinaryReviewLevel = VeterinaryReviewLevel.none,
    this.pregnancySpecific = false,
    this.source = '',
    this.sourceTitle = '',
    this.sourceUrl = '',
    this.region = '',
    this.lastVerifiedAt,
    this.version = 1,
    this.active = true,
  });

  final String id;
  final ConditionCategory category;
  final List<String> species;

  /// Empty means "all ages".
  final List<AgeGroup> ageGroups;
  final List<String> compatibleSymptoms;
  final List<String> requiredSymptoms;
  final List<String> supportingSymptoms;
  final List<String> contradictingSymptoms;
  final List<String> riskFactors;
  final List<String> redFlags;
  final List<String> recommendedChecks;
  final List<String> diagnosticTests;
  final List<String> immediateActions;
  final List<String> treatmentProtocolIds;
  final List<String> preventionActions;
  final bool contagious;
  final bool isolationRecommended;
  final VeterinaryReviewLevel veterinaryReviewLevel;
  final bool pregnancySpecific;
  final String source;
  final String sourceTitle;
  final String sourceUrl;
  final String region;
  final DateTime? lastVerifiedAt;
  final int version;
  final bool active;
}

/// A condition plus the engine's explanation for why it was ranked that way.
@immutable
class ConditionCandidate {
  const ConditionCandidate({
    required this.condition,
    required this.compatibility,
    required this.matchedRequired,
    required this.matchedSupporting,
    required this.matchedRiskFactors,
    required this.contradictions,
    required this.missingChecks,
  });

  final HealthCondition condition;
  final CompatibilityLevel compatibility;
  final List<String> matchedRequired;
  final List<String> matchedSupporting;
  final List<String> matchedRiskFactors;
  final List<String> contradictions;
  final List<String> missingChecks;
}
