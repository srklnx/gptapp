import 'package:flutter/foundation.dart';

/// The farmer's own assessment of how severe the observation is.
///
/// Severity is an observation of what the farmer sees, never a diagnosis.
enum HealthSeverity { mild, moderate, severe }

/// Organizes symptoms so the selection interface stays readable in the field.
enum SymptomCategory { eating, breathing, eyes, movement, skin, general, other }

/// A single selectable symptom in the observation catalog.
@immutable
class HealthSymptom {
  const HealthSymptom({
    required this.id,
    required this.category,
    this.causesRedFlag = false,
  });

  final String id;
  final SymptomCategory category;

  /// Convenience flag used by [HealthRiskService] when the symptom itself is
  /// an urgent warning sign (for example "not drinking").
  final bool causesRedFlag;
}

/// The catalog of symptoms a farmer can observe.
///
/// Labels are resolved from localization using the stable [id]; no
/// user-visible text lives in the domain.
abstract final class HealthSymptomCatalog {
  static const all = <HealthSymptom>[
    // Eating & Digestion
    HealthSymptom(id: 'not_eating', category: SymptomCategory.eating),
    HealthSymptom(id: 'reduced_appetite', category: SymptomCategory.eating),
    HealthSymptom(id: 'diarrhea', category: SymptomCategory.eating),
    HealthSymptom(id: 'constipation', category: SymptomCategory.eating),
    HealthSymptom(id: 'bloating', category: SymptomCategory.eating),
    HealthSymptom(id: 'abnormal_stool', category: SymptomCategory.eating),
    HealthSymptom(id: 'drinking_less', category: SymptomCategory.eating),
    HealthSymptom(
      id: 'not_drinking',
      category: SymptomCategory.eating,
      causesRedFlag: true,
    ),
    // Breathing
    HealthSymptom(id: 'coughing', category: SymptomCategory.breathing),
    HealthSymptom(id: 'difficulty_breathing', category: SymptomCategory.breathing),
    HealthSymptom(id: 'nasal_discharge', category: SymptomCategory.breathing),
    HealthSymptom(id: 'rapid_breathing', category: SymptomCategory.breathing),
    // Eyes
    HealthSymptom(id: 'eye_redness', category: SymptomCategory.eyes),
    HealthSymptom(id: 'eye_discharge', category: SymptomCategory.eyes),
    HealthSymptom(id: 'eye_cloudiness', category: SymptomCategory.eyes),
    HealthSymptom(id: 'eye_swelling', category: SymptomCategory.eyes),
    HealthSymptom(id: 'keeps_eye_closed', category: SymptomCategory.eyes),
    HealthSymptom(id: 'possible_eye_injury', category: SymptomCategory.eyes),
    HealthSymptom(id: 'tearing', category: SymptomCategory.eyes),
    // Movement
    HealthSymptom(id: 'lameness', category: SymptomCategory.movement),
    HealthSymptom(id: 'swollen_joint', category: SymptomCategory.movement),
    HealthSymptom(id: 'hoof_problem', category: SymptomCategory.movement),
    HealthSymptom(id: 'hoof_swelling', category: SymptomCategory.movement),
    HealthSymptom(id: 'hoof_bad_odor', category: SymptomCategory.movement),
    // Skin
    HealthSymptom(id: 'itching', category: SymptomCategory.skin),
    HealthSymptom(id: 'hair_loss', category: SymptomCategory.skin),
    HealthSymptom(id: 'skin_lesion', category: SymptomCategory.skin),
    HealthSymptom(id: 'crusts', category: SymptomCategory.skin),
    HealthSymptom(id: 'visible_parasites', category: SymptomCategory.skin),
    // General
    HealthSymptom(id: 'weakness', category: SymptomCategory.general),
    HealthSymptom(id: 'lethargy', category: SymptomCategory.general),
    HealthSymptom(id: 'fever', category: SymptomCategory.general),
    HealthSymptom(id: 'weight_loss', category: SymptomCategory.general),
    HealthSymptom(id: 'pale_eyelids', category: SymptomCategory.general),
    HealthSymptom(id: 'abnormal_urine', category: SymptomCategory.general),
    HealthSymptom(id: 'bottle_jaw', category: SymptomCategory.general),
    HealthSymptom(id: 'recumbent', category: SymptomCategory.general),
    HealthSymptom(id: 'neurologic_signs', category: SymptomCategory.general),
    HealthSymptom(id: 'abdominal_pain', category: SymptomCategory.general),
    HealthSymptom(id: 'sudden_illness', category: SymptomCategory.general),
    HealthSymptom(id: 'sudden_death', category: SymptomCategory.general),
    // Other
    HealthSymptom(id: 'other', category: SymptomCategory.other),
  ];

  static HealthSymptom? byId(String id) {
    for (final symptom in all) {
      if (symptom.id == id) return symptom;
    }
    return null;
  }

  static List<HealthSymptom> forCategory(SymptomCategory category) =>
      List.unmodifiable(
        all.where((symptom) => symptom.category == category),
      );
}

/// Who the health observation applies to.
enum HealthTargetScope { individual, group, flock }

/// A recorded health observation (the "Observe → Record" output).
@immutable
class HealthObservation {
  const HealthObservation({
    required this.id,
    required this.targetScope,
    required this.sheepIds,
    required this.symptomIds,
    required this.answers,
    required this.severity,
    required this.occurredAt,
    required this.recordedBy,
    this.notes = '',
  });

  final String id;
  final HealthTargetScope targetScope;
  final List<String> sheepIds;
  final List<String> symptomIds;
  final Map<String, List<String>> answers;
  final HealthSeverity severity;
  final DateTime occurredAt;
  final String recordedBy;
  final String notes;

  HealthObservation copyWith({
    String? notes,
  }) => HealthObservation(
    id: id,
    targetScope: targetScope,
    sheepIds: sheepIds,
    symptomIds: symptomIds,
    answers: answers,
    severity: severity,
    occurredAt: occurredAt,
    recordedBy: recordedBy,
    notes: notes ?? this.notes,
  );
}
