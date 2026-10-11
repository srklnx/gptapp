import 'package:flutter/foundation.dart';

enum TreatmentType {
  supportiveCare,
  antiparasitic,
  anticoccidial,
  antimicrobial,
  antiInflammatory,
  electrolyte,
  nutritional,
  topical,
  footbath,
  isolation,
  surgical,
  monitoring,
  preventiveVaccination,
  other,
}

enum MedicationOptionRank { preferred, alternative, veterinaryOnly, notAppropriate }

/// A versioned treatment protocol associated with a condition.
@immutable
class TreatmentProtocol {
  const TreatmentProtocol({
    required this.id,
    required this.name,
    required this.treatmentType,
    this.conditionId = '',
    this.objective = '',
    this.requiredAssessment = const [],
    this.medicationOptions = const [],
    this.supportiveActions = const [],
    this.contraindications = const [],
    this.duration,
    this.followUpDays,
    this.veterinaryRequired = false,
    this.veterinaryRecommended = false,
    this.foodAnimalRestrictions = const [],
    this.withdrawalRequired = false,
    this.source = '',
    this.region = '',
    this.version = 1,
    this.effectiveFrom,
    this.effectiveUntil,
    this.verifiedAt,
    this.active = true,
  });

  final String id;
  final String conditionId;
  final String name;
  final TreatmentType treatmentType;
  final String objective;
  final List<String> requiredAssessment;
  final List<MedicationOption> medicationOptions;
  final List<String> supportiveActions;
  final List<String> contraindications;
  final String? duration;
  final int? followUpDays;
  final bool veterinaryRequired;
  final bool veterinaryRecommended;
  final List<String> foodAnimalRestrictions;
  final bool withdrawalRequired;
  final String source;
  final String region;
  final int version;
  final DateTime? effectiveFrom;
  final DateTime? effectiveUntil;
  final DateTime? verifiedAt;
  final bool active;
}

/// Region-specific applicability of a medication within a protocol.
@immutable
class TreatmentProtocolRegion {
  const TreatmentProtocolRegion({
    required this.region,
    required this.country,
    required this.medicationId,
    required this.approved,
    required this.source,
    required this.verifiedAt,
  });

  final String region;
  final String country;
  final String medicationId;
  final bool approved;
  final String source;
  final DateTime verifiedAt;
}

/// A medication option within a treatment protocol, ranked conservatively.
@immutable
class MedicationOption {
  const MedicationOption({
    required this.medicationId,
    required this.rank,
    this.indication = '',
    this.verificationRequired = true,
  });

  final String medicationId;
  final MedicationOptionRank rank;
  final String indication;
  final bool verificationRequired;
}
