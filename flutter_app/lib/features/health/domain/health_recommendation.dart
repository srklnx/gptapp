import 'package:flutter/foundation.dart';

import 'health_observation.dart';

/// Practical, non-diagnostic guidance shown after an observation.
///
/// Checks are things the farmer can look at, areas are "possible areas to
/// investigate", and actions are sensible next steps. None of these are a
/// diagnosis or a prescription.
@immutable
class HealthRecommendation {
  const HealthRecommendation({
    required this.checks,
    required this.areas,
    required this.actions,
  });

  final List<String> checks;
  final List<String> areas;
  final List<String> actions;
}

/// Produces transparent, conservative guidance from selected symptoms.
abstract final class HealthRecommendationService {
  static const _alwaysCheck = <String>[
    'check_temperature',
    'check_hydration',
    'check_eyelid_color',
  ];

  static const _generalChecks = <String>[
    'check_feces',
    'check_feed_changes',
    'check_other_sheep',
    'monitor_water',
  ];

  static const _eyeChecks = <String>[
    'examine_eye_light',
    'check_foreign_material',
    'monitor_vision',
  ];

  static const _lamenessChecks = <String>['inspect_hoof'];

  static HealthRecommendation forSymptoms(Set<String> symptomIds) {
    final checks = <String>[];
    final areas = <String>[];
    final actions = <String>[];

    void addUnique(List<String> target, Iterable<String> values) {
      for (final value in values) {
        if (!target.contains(value)) target.add(value);
      }
    }

    final eatingConcern = symptomIds.contains('reduced_appetite') ||
        symptomIds.contains('not_eating');
    final eyeConcern = symptomIds.any(
      (id) => HealthSymptomCatalog.byId(id)?.category == SymptomCategory.eyes,
    );
    final movementConcern = symptomIds.any(
      (id) =>
          HealthSymptomCatalog.byId(id)?.category == SymptomCategory.movement,
    );
    final generalConcern = symptomIds.contains('weakness') ||
        symptomIds.contains('lethargy') ||
        symptomIds.contains('fever') ||
        symptomIds.contains('pale_eyelids');

    addUnique(checks, _alwaysCheck);

    if (eatingConcern) {
      addUnique(checks, _generalChecks);
      addUnique(areas, [
        'digestive_problem',
        'feed_related',
        'parasite_burden',
        'infection',
        'dental_mouth',
        'pain_injury',
        'underlying',
      ]);
      actions.add('monitor_closely');
    }

    if (symptomIds.contains('diarrhea')) {
      addUnique(checks, ['check_feces', 'check_hydration']);
      addUnique(areas, ['digestive_problem', 'infection', 'parasite_burden']);
      actions.add('monitor_closely');
    }

    if (eyeConcern) {
      addUnique(checks, _eyeChecks);
      addUnique(areas, [
        'eye_irritation',
        'eye_injury',
        'eye_infection',
        'eye_foreign_material',
      ]);
      actions.add('inspect_eye');
    }

    if (movementConcern) {
      addUnique(checks, _lamenessChecks);
      addUnique(areas, ['hoof_problem', 'injury', 'joint_problem', 'infection']);
      actions.add('inspect_hoof');
    }

    if (generalConcern) {
      addUnique(checks, ['check_temperature', 'check_hydration']);
      actions.add('monitor_closely');
    }

    if (actions.isEmpty) {
      actions.add('monitor_closely');
    }

    return HealthRecommendation(
      checks: List.unmodifiable(checks),
      areas: List.unmodifiable(areas),
      actions: List.unmodifiable(actions),
    );
  }
}
