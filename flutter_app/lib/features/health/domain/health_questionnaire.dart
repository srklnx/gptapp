import 'package:flutter/foundation.dart';

import 'health_observation.dart';

/// A single follow-up question dynamically shown after symptoms are selected.
@immutable
class HealthQuestion {
  const HealthQuestion({
    required this.id,
    required this.options,
    this.multiSelect = false,
  });

  final String id;
  final List<HealthOption> options;
  final bool multiSelect;
}

/// A selectable answer option for a [HealthQuestion].
@immutable
class HealthOption {
  const HealthOption(this.id);

  final String id;
}

/// Selects the relevant follow-up questions for a set of symptom ids.
///
/// The engine deliberately keeps the mapping small and rule-based so it can be
/// tested and reasoned about. It never diagnoses; it only asks better
/// questions based on what the farmer already reported.
abstract final class HealthQuestionnaireService {
  static const _appetiteDuration = HealthQuestion(
    id: 'appetite_duration',
    options: [
      HealthOption('less_12h'),
      HealthOption('12_24h'),
      HealthOption('1_2_days'),
      HealthOption('more_2_days'),
      HealthOption('unknown'),
    ],
  );

  static const _drinking = HealthQuestion(
    id: 'drinking',
    options: [
      HealthOption('normally'),
      HealthOption('less_than_normal'),
      HealthOption('not_drinking'),
      HealthOption('unknown'),
    ],
  );

  static const _appetiteOtherSigns = HealthQuestion(
    id: 'appetite_other_signs',
    multiSelect: true,
    options: [
      HealthOption('diarrhea'),
      HealthOption('coughing'),
      HealthOption('nasal_discharge'),
      HealthOption('bloating'),
      HealthOption('lameness'),
      HealthOption('fever'),
      HealthOption('teeth_grinding'),
      HealthOption('weakness'),
      HealthOption('other'),
    ],
  );

  static const _diarrheaDuration = HealthQuestion(
    id: 'diarrhea_duration',
    options: [
      HealthOption('less_1_day'),
      HealthOption('1_2_days'),
      HealthOption('3_5_days'),
      HealthOption('more_5_days'),
      HealthOption('unknown'),
    ],
  );

  static const _stoolAppearance = HealthQuestion(
    id: 'stool_appearance',
    options: [
      HealthOption('loose'),
      HealthOption('watery'),
      HealthOption('very_watery'),
      HealthOption('mucus'),
      HealthOption('blood'),
      HealthOption('unknown'),
    ],
  );

  static const _diarrheaOtherSigns = HealthQuestion(
    id: 'diarrhea_other_signs',
    multiSelect: true,
    options: [
      HealthOption('weakness'),
      HealthOption('fever'),
      HealthOption('reduced_appetite'),
      HealthOption('weight_loss'),
      HealthOption('bloating'),
      HealthOption('other'),
    ],
  );

  static const _eyeWhatSee = HealthQuestion(
    id: 'eye_what_see',
    multiSelect: true,
    options: [
      HealthOption('redness'),
      HealthOption('cloudiness'),
      HealthOption('discharge'),
      HealthOption('swelling'),
      HealthOption('keeps_closed'),
      HealthOption('tearing'),
      HealthOption('possible_injury'),
      HealthOption('difficulty_seeing'),
      HealthOption('unknown'),
    ],
  );

  static const _eyeOneOrBoth = HealthQuestion(
    id: 'eye_one_or_both',
    options: [
      HealthOption('left'),
      HealthOption('right'),
      HealthOption('both'),
      HealthOption('unknown'),
    ],
  );

  static const _eyeRubbing = HealthQuestion(
    id: 'eye_rubbing',
    options: [
      HealthOption('yes'),
      HealthOption('no'),
      HealthOption('unknown'),
    ],
  );

  static const _eyeInjury = HealthQuestion(
    id: 'eye_injury',
    options: [
      HealthOption('yes'),
      HealthOption('no'),
      HealthOption('not_sure'),
    ],
  );

  static const _lamenessSeverity = HealthQuestion(
    id: 'lameness_severity',
    options: [
      HealthOption('slight'),
      HealthOption('moderate'),
      HealthOption('severe'),
      HealthOption('unable_to_walk'),
    ],
  );

  static const _lamenessLeg = HealthQuestion(
    id: 'lameness_leg',
    options: [
      HealthOption('front_left'),
      HealthOption('front_right'),
      HealthOption('rear_left'),
      HealthOption('rear_right'),
      HealthOption('unknown'),
    ],
  );

  static const _hoofAppearance = HealthQuestion(
    id: 'hoof_appearance',
    multiSelect: true,
    options: [
      HealthOption('normal'),
      HealthOption('overgrown'),
      HealthOption('damaged'),
      HealthOption('swollen'),
      HealthOption('discharge'),
      HealthOption('bad_odor'),
      HealthOption('unknown'),
    ],
  );

  static List<HealthQuestion> questionsFor(Set<String> symptomIds) {
    final questions = <HealthQuestion>[];

    if (symptomIds.contains('reduced_appetite') ||
        symptomIds.contains('not_eating')) {
      questions
        ..add(_appetiteDuration)
        ..add(_drinking)
        ..add(_appetiteOtherSigns);
    }

    if (symptomIds.contains('diarrhea')) {
      questions
        ..add(_diarrheaDuration)
        ..add(_stoolAppearance)
        ..add(_drinking)
        ..add(_diarrheaOtherSigns);
    }

    if (symptomIds.any(_isEyeSymptom)) {
      questions
        ..add(_eyeWhatSee)
        ..add(_eyeOneOrBoth)
        ..add(_eyeRubbing)
        ..add(_eyeInjury);
    }

    if (symptomIds.contains('lameness')) {
      questions
        ..add(_lamenessSeverity)
        ..add(_lamenessLeg)
        ..add(_hoofAppearance);
    }

    // Context question always shown so the engine can weigh risk factors.
    questions.add(_riskFactors);

    // Deduplicate shared questions (for example "drinking") while preserving
    // the original order.
    final seen = <String>{};
    return List.unmodifiable(
      questions.where((question) => seen.add(question.id)),
    );
  }

  static const _riskFactors = HealthQuestion(
    id: 'risk_factors',
    multiSelect: true,
    options: [
      HealthOption('recent_feed_change'),
      HealthOption('recent_grain_access'),
      HealthOption('multiple_affected'),
      HealthOption('crowded'),
      HealthOption('pasture_exposure'),
      HealthOption('wet_conditions'),
      HealthOption('recent_transport'),
      HealthOption('recent_stress'),
    ],
  );

  static bool _isEyeSymptom(String id) =>
      HealthSymptomCatalog.byId(id)?.category == SymptomCategory.eyes;
}
