import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/features/health/data/condition_library.dart';
import 'package:herd_hub_sheep/features/health/domain/condition.dart';
import 'package:herd_hub_sheep/features/health/domain/condition_rule_engine.dart';
import 'package:herd_hub_sheep/features/health/domain/health_assessment.dart';
import 'package:herd_hub_sheep/features/health/domain/health_observation.dart';
import 'package:herd_hub_sheep/features/health/domain/health_risk.dart';
import 'package:herd_hub_sheep/features/health/domain/treatment_protocol.dart';

void main() {
  final conditions = ConditionLibrary.conditions;
  final protocols = ConditionLibrary.protocols;

  String topId(Set<String> symptoms, {HealthContext context = const HealthContext()}) {
    final candidates = ConditionRuleEngine.evaluate(
      conditions: conditions,
      observedSymptoms: symptoms,
      context: context,
    );
    return candidates.isEmpty ? '' : candidates.first.condition.id;
  }

  HealthAssessment assess(
    Set<String> symptoms, {
    HealthContext context = const HealthContext(),
    HealthSeverity severity = HealthSeverity.moderate,
  }) {
    final risk = HealthRiskService.assess(
      symptomIds: symptoms,
      answers: const {},
      severity: severity,
    );
    return HealthAssessmentService.assess(
      conditions: conditions,
      protocols: protocols,
      observedSymptoms: symptoms,
      context: context,
      severity: severity,
      redFlagReasons: risk.reasons,
    );
  }

  group('Case A adult parasitism', () {
    test('ranks haemonchosis and includes GI parasitism', () {
      const context = HealthContext(
        ageGroup: AgeGroup.adult,
        riskFactorKeys: {'pasture_exposure'},
      );
      final symptoms = {'diarrhea', 'weight_loss', 'pale_eyelids', 'weakness'};
      expect(topId(symptoms, context: context), 'haemonchosis');
      final candidates = ConditionRuleEngine.evaluate(
        conditions: conditions,
        observedSymptoms: symptoms,
        context: context,
      );
      expect(
        candidates.map((c) => c.condition.id),
        contains('gastrointestinal_parasitism'),
      );
    });
  });

  group('Case B young lamb coccidiosis', () {
    test('ranks coccidiosis', () {
      const context = HealthContext(
        ageGroup: AgeGroup.youngLamb,
        riskFactorKeys: {'crowded', 'contaminated'},
      );
      final id = topId({'diarrhea', 'reduced_appetite', 'weakness'}, context: context);
      expect(id, 'coccidiosis');
    });
  });

  group('Case C pregnancy toxemia', () {
    test('ranks pregnancy toxemia for late-pregnant ewe', () {
      const context = HealthContext(
        ageGroup: AgeGroup.adult,
        pregnant: true,
        lateGestation: true,
        lowBcs: true,
      );
      final id = topId({'reduced_appetite', 'weakness', 'recumbent'}, context: context);
      expect(id, 'pregnancy_toxemia');
    });
  });

  group('Case D pneumonia', () {
    test('ranks bacterial pneumonia', () {
      final id = topId({'coughing', 'fever', 'nasal_discharge', 'rapid_breathing'});
      expect(id, 'bacterial_pneumonia');
    });
  });

  group('Case E pinkeye', () {
    test('ranks pinkeye for red cloudy eye', () {
      final id = topId({'eye_redness', 'tearing', 'keeps_eye_closed', 'eye_cloudiness'});
      expect(id, 'pinkeye');
    });
  });

  group('Case F footrot', () {
    test('ranks footrot for lameness + hoof odor', () {
      const context = HealthContext(riskFactorKeys: {'multiple_affected'});
      final id = topId({'lameness', 'hoof_swelling', 'hoof_bad_odor'}, context: context);
      expect(id, 'footrot');
    });
  });

  group('Case G grain overload', () {
    test('ranks grain overload and marks urgent', () {
      const context = HealthContext(
        ageGroup: AgeGroup.adult,
        riskFactorKeys: {'recent_grain_access'},
      );
      final id = topId({'bloating', 'diarrhea', 'weakness', 'abdominal_pain'}, context: context);
      expect(id, 'grain_overload');
      final assessment = assess(
        {'bloating', 'diarrhea', 'weakness', 'abdominal_pain'},
        context: context,
        severity: HealthSeverity.severe,
      );
      expect(assessment.riskLevel, HealthRiskLevel.urgent);
    });
  });

  group('Safety', () {
    test('antibiotics are not automatically indicated for nonspecific signs', () {
      final assessment = assess({'diarrhea', 'weakness'});
      expect(assessment.antibioticNotAutomaticallyIndicated, isTrue);
      expect(
        assessment.pathways.any(
          (p) => p.protocol.treatmentType == TreatmentType.antimicrobial,
        ),
        isFalse,
      );
    });

    test('bacterial pneumonia can surface an antimicrobial pathway', () {
      final assessment = assess({
        'coughing',
        'fever',
        'nasal_discharge',
        'rapid_breathing',
      });
      expect(
        assessment.pathways.any(
          (p) => p.protocol.treatmentType == TreatmentType.antimicrobial,
        ),
        isTrue,
      );
    });

    test('red flags override to urgent risk level', () {
      final assessment = assess(
        {'difficulty_breathing'},
        severity: HealthSeverity.severe,
      );
      expect(assessment.riskLevel, HealthRiskLevel.urgent);
      expect(assessment.urgentFlags, contains('severe_breathing'));
    });

    test('unknown medication cannot be presented as verified', () {
      final anticoccidial = ConditionLibrary.protocolById('protocol_anticoccidial')!;
      expect(anticoccidial.medicationOptions, isEmpty);
      final antimicrobial = ConditionLibrary.protocolById('protocol_antimicrobial')!;
      expect(
        antimicrobial.medicationOptions.every((o) => o.verificationRequired),
        isTrue,
      );
    });

    test('conditions explain why they appear (no bare score)', () {
      final candidates = ConditionRuleEngine.evaluate(
        conditions: conditions,
        observedSymptoms: {'diarrhea', 'weight_loss', 'pale_eyelids', 'weakness'},
        context: const HealthContext(
          ageGroup: AgeGroup.adult,
          riskFactorKeys: {'pasture_exposure'},
        ),
      );
      final top = candidates.first;
      expect(top.matchedRequired, contains('pale_eyelids'));
      expect(top.condition.recommendedChecks, contains('famacha_score'));
    });
  });
}
