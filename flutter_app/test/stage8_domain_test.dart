import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/features/health/domain/health_observation.dart';
import 'package:herd_hub_sheep/features/health/domain/health_questionnaire.dart';
import 'package:herd_hub_sheep/features/health/domain/health_recommendation.dart';
import 'package:herd_hub_sheep/features/health/domain/health_risk.dart';

void main() {
  group('HealthQuestionnaireService', () {
    test('appetite symptoms select appetite questions', () {
      final ids = HealthQuestionnaireService.questionsFor({'reduced_appetite'})
          .map((q) => q.id)
          .toList();
      expect(ids, contains('appetite_duration'));
      expect(ids, contains('drinking'));
      expect(ids, contains('appetite_other_signs'));
    });

    test('diarrhea selects diarrhea questions', () {
      final ids = HealthQuestionnaireService.questionsFor({'diarrhea'})
          .map((q) => q.id)
          .toList();
      expect(ids, contains('diarrhea_duration'));
      expect(ids, contains('stool_appearance'));
    });

    test('eye symptoms select eye questions', () {
      final ids = HealthQuestionnaireService.questionsFor({'eye_redness'})
          .map((q) => q.id)
          .toList();
      expect(ids, contains('eye_what_see'));
      expect(ids, contains('eye_one_or_both'));
    });

    test('lameness selects lameness questions', () {
      final ids = HealthQuestionnaireService.questionsFor({'lameness'})
          .map((q) => q.id)
          .toList();
      expect(ids, contains('lameness_severity'));
      expect(ids, contains('lameness_leg'));
      expect(ids, contains('hoof_appearance'));
    });

    test('unrelated questions are not shown', () {
      final ids = HealthQuestionnaireService.questionsFor({'coughing'})
          .map((q) => q.id)
          .toList();
      // Only the always-present context question remains.
      expect(ids.where((id) => id != 'risk_factors'), isEmpty);
      expect(ids, contains('risk_factors'));
    });
  });

  group('HealthRiskService', () {
    test('severe breathing difficulty is urgent', () {
      final result = HealthRiskService.assess(
        symptomIds: {'difficulty_breathing'},
        answers: const {},
        severity: HealthSeverity.severe,
      );
      expect(result.isUrgent, isTrue);
      expect(result.reasons, contains('severe_breathing'));
    });

    test('unable to stand is urgent', () {
      final result = HealthRiskService.assess(
        symptomIds: {'lameness'},
        answers: const {
          'lameness_severity': ['unable_to_walk'],
        },
        severity: HealthSeverity.moderate,
      );
      expect(result.isUrgent, isTrue);
      expect(result.reasons, contains('unable_to_stand'));
    });

    test('severe bloating is urgent', () {
      final result = HealthRiskService.assess(
        symptomIds: {'bloating'},
        answers: const {},
        severity: HealthSeverity.severe,
      );
      expect(result.isUrgent, isTrue);
      expect(result.reasons, contains('severe_bloating'));
    });

    test('ordinary mild appetite reduction is not urgent', () {
      final result = HealthRiskService.assess(
        symptomIds: {'reduced_appetite'},
        answers: const {
          'drinking': ['less_than_normal'],
        },
        severity: HealthSeverity.mild,
      );
      expect(result.isUrgent, isFalse);
    });
  });

  group('HealthRecommendationService', () {
    test('reduced appetite suggests checks and areas, not a diagnosis', () {
      final result = HealthRecommendationService.forSymptoms({
        'reduced_appetite',
      });
      expect(result.checks, contains('check_temperature'));
      expect(result.areas, contains('digestive_problem'));
      expect(result.areas, isNot(contains('diagnosis')));
    });

    test('eye symptoms suggest eye checks', () {
      final result = HealthRecommendationService.forSymptoms({'eye_redness'});
      expect(result.checks, contains('examine_eye_light'));
      expect(result.areas, contains('eye_infection'));
    });

    test('lameness suggests hoof inspection', () {
      final result = HealthRecommendationService.forSymptoms({'lameness'});
      expect(result.checks, contains('inspect_hoof'));
    });
  });
}
