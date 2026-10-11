enum TreatmentRoute {
  oral,
  injection,
  topical,
  intramuscular,
  subcutaneous,
  eye,
  other,
}

extension TreatmentRouteLabel on TreatmentRoute {
  String get label => switch (this) {
    TreatmentRoute.oral => 'Oral',
    TreatmentRoute.injection => 'Injection',
    TreatmentRoute.topical => 'Topical',
    TreatmentRoute.intramuscular => 'Intramuscular',
    TreatmentRoute.subcutaneous => 'Subcutaneous',
    TreatmentRoute.eye => 'Eye',
    TreatmentRoute.other => 'Other',
  };
}

enum MedicationCategory {
  antibiotic,
  antiparasitic,
  antiInflammatory,
  painRelief,
  vitaminMineral,
  electrolyte,
  eyeTreatment,
  topicalTreatment,
  hoofTreatment,
  other,
}

/// Regulatory/label status. Never invent this; a medication without verified
/// source information must be shown as requiring verification.
enum LabelStatus {
  approvedForSheep,
  approvedForIndication,
  veterinaryDirected,
  verificationRequired,
  unknown,
}

class MedicationRecord {
  MedicationRecord({
    required this.id,
    required this.name,
    required this.activeIngredient,
    required Iterable<String> species,
    required this.route,
    required this.doseUnit,
    required this.meatWithdrawalDays,
    required this.milkWithdrawalDays,
    this.notes = '',
    this.followUpAfterDays,
    this.category = MedicationCategory.other,
    this.formulation,
    this.concentration,
    Iterable<TreatmentRoute>? routeOptions,
    this.reference,
    this.active = true,
    this.brandName,
    this.productionClass,
    this.indication,
    this.contraindications = const [],
    this.minimumAge,
    this.pregnancyRestrictions,
    this.dosageReference,
    this.labelStatus = LabelStatus.verificationRequired,
    this.region,
    this.country,
    this.source,
    this.lastVerifiedAt,
  }) : species = List.unmodifiable(species),
       routeOptions = List.unmodifiable(
         routeOptions ?? <TreatmentRoute>[route],
       );

  final String id;
  final String name;
  final String activeIngredient;
  final List<String> species;
  final TreatmentRoute route;
  final List<TreatmentRoute> routeOptions;
  final String doseUnit;
  final int meatWithdrawalDays;
  final int milkWithdrawalDays;
  final String notes;
  final int? followUpAfterDays;
  final MedicationCategory category;
  final String? formulation;
  final String? concentration;
  final String? reference;
  final bool active;
  final String? brandName;
  final String? productionClass;
  final String? indication;
  final List<String> contraindications;
  final int? minimumAge;
  final String? pregnancyRestrictions;
  final String? dosageReference;
  final LabelStatus labelStatus;
  final String? region;
  final String? country;
  final String? source;
  final DateTime? lastVerifiedAt;
}

class TreatmentRecord {
  const TreatmentRecord({
    required this.id,
    required this.sheepId,
    required this.medicationId,
    required this.dose,
    required this.doseUnit,
    required this.route,
    required this.administeredAt,
    required this.administeredBy,
    required this.withdrawalDays,
    required this.milkWithdrawalDays,
    required this.clearanceDate,
    required this.milkClearanceDate,
    this.notes = '',
    this.medicationNameSnapshot,
    this.activeIngredientSnapshot,
    this.observationId,
    this.eventId,
    this.createdAt,
    this.updatedAt,
    this.treatmentReason = '',
  });

  final String id;
  final String sheepId;
  final String medicationId;
  final double dose;
  final String doseUnit;
  final TreatmentRoute route;
  final DateTime administeredAt;
  final String administeredBy;
  final int withdrawalDays;
  final int milkWithdrawalDays;
  final DateTime clearanceDate;
  final DateTime milkClearanceDate;
  final String notes;

  /// Medication information stored on the treatment record at recording time,
  /// so later changes to the library do not rewrite history.
  final String? medicationNameSnapshot;
  final String? activeIngredientSnapshot;

  /// The health observation (or event) that triggered this treatment.
  final String? observationId;
  final String? eventId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Why the treatment was recorded (Health Observation, Confirmed Diagnosis,
  /// Preventive protocol, etc.).
  final String treatmentReason;
}

sealed class FarmEvent {
  const FarmEvent({
    required this.id,
    required this.sheepId,
    required this.occurredAt,
    required this.recordedBy,
  });

  final String id;
  final String sheepId;
  final DateTime occurredAt;
  final String recordedBy;
}

final class TreatmentEvent extends FarmEvent {
  const TreatmentEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.treatmentId,
    required this.medicationName,
    required this.dose,
    required this.doseUnit,
  });

  final String treatmentId;
  final String medicationName;
  final double dose;
  final String doseUnit;
}

final class WeightEvent extends FarmEvent {
  const WeightEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.weightKg,
    this.unit = 'kg',
    this.method,
    this.notes = '',
  });

  final double weightKg;
  final String unit;
  final String? method;
  final String notes;
}

final class BcsEvent extends FarmEvent {
  const BcsEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.score,
    this.notes = '',
  });

  final double score;
  final String notes;
}

final class AnimalActionEvent extends FarmEvent {
  const AnimalActionEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.action,
    this.notes = '',
  });

  final String action;
  final String notes;
}

/// A structured, auditable identity change (e.g. "Tag changed from A to B").
final class IdentityChangeEvent extends FarmEvent {
  const IdentityChangeEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.field,
    required this.oldValue,
    required this.newValue,
  });

  final String field;
  final String oldValue;
  final String newValue;
}

/// A recorded health observation, shown in the timeline and connected to any
/// subsequent treatment.
final class HealthObservationEvent extends FarmEvent {
  HealthObservationEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.observationId,
    required Iterable<String> symptomIds,
    required this.severity,
    required this.summary,
    this.notes = '',
  }) : symptomIds = List.unmodifiable(symptomIds);

  final String observationId;
  final List<String> symptomIds;
  final String severity;
  final String summary;
  final String notes;
}

final class HeatCheckEvent extends FarmEvent {
  HeatCheckEvent({
    required super.id,
    required super.sheepId,
    required super.occurredAt,
    required super.recordedBy,
    required this.temperatureC,
    required this.humidityPercent,
    required this.thi,
    required this.riskLevel,
    required Iterable<String> symptoms,
    required this.waterAvailable,
    required this.shadeAvailable,
    required Iterable<String> actionsTaken,
    this.notes = '',
  }) : symptoms = List.unmodifiable(symptoms),
       actionsTaken = List.unmodifiable(actionsTaken);

  final double temperatureC;
  final double humidityPercent;
  final double thi;
  final String riskLevel;
  final List<String> symptoms;
  final bool waterAvailable;
  final bool shadeAvailable;
  final List<String> actionsTaken;
  final String notes;
}

class FollowUpTask {
  const FollowUpTask({
    required this.id,
    required this.sheepId,
    required this.title,
    required this.dueAt,
    required this.createdAt,
  });

  final String id;
  final String sheepId;
  final String title;
  final DateTime dueAt;
  final DateTime createdAt;
}
