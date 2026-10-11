import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/features/health/domain/famacha.dart';
import 'package:herd_hub_sheep/features/health/domain/flock_outbreak_service.dart';
import 'package:herd_hub_sheep/features/health/domain/health_observation.dart';
import 'package:herd_hub_sheep/features/medications/domain/medication_search.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';

void main() {
  group('FlockOutbreakService', () {
    HealthObservation observation(
      String id,
      String sheepId,
      String symptom,
    ) => HealthObservation(
      id: id,
      targetScope: HealthTargetScope.individual,
      sheepIds: [sheepId],
      symptomIds: [symptom],
      answers: const {},
      severity: HealthSeverity.moderate,
      occurredAt: DateTime(2026, 10, 1),
      recordedBy: 'Ahmed',
    );

    test('multiple similar cases trigger flock-level warning', () {
      final observations = [
        observation('o1', '184', 'diarrhea'),
        observation('o2', '209', 'diarrhea'),
      ];
      expect(
        FlockOutbreakService.isOutbreak(
          observations: observations,
          now: DateTime(2026, 10, 2),
        ),
        isTrue,
      );
    });

    test('a single case is not an outbreak', () {
      final observations = [observation('o1', '184', 'diarrhea')];
      expect(
        FlockOutbreakService.isOutbreak(
          observations: observations,
          now: DateTime(2026, 10, 2),
        ),
        isFalse,
      );
    });
  });

  group('FamachaRecord', () {
    test('validates 1-5 range', () {
      expect(FamachaRecord.isValid(1), isTrue);
      expect(FamachaRecord.isValid(5), isTrue);
      expect(FamachaRecord.isValid(0), isFalse);
      expect(FamachaRecord.isValid(6), isFalse);
    });
  });

  group('Medication concentration independence', () {
    MedicationRecord product(String id, String concentration, int withdrawal) =>
        MedicationRecord(
          id: id,
          name: 'Oxytetracycline $concentration',
          activeIngredient: 'Oxytetracycline',
          species: const ['Sheep'],
          route: TreatmentRoute.intramuscular,
          routeOptions: const [TreatmentRoute.intramuscular],
          doseUnit: 'ml',
          meatWithdrawalDays: withdrawal,
          milkWithdrawalDays: 0,
          category: MedicationCategory.antibiotic,
          concentration: concentration,
        );

    test('different concentrations are distinct, not interchangeable', () {
      final productA = product('oxy-100', '100 mg/mL', 14);
      final productB = product('oxy-200', '200 mg/mL', 28);

      expect(productA.concentration, isNot(productB.concentration));
      expect(productA.meatWithdrawalDays, isNot(productB.meatWithdrawalDays));

      final results = MedicationSearchService.search(
        [productA, productB],
        query: 'oxytetracycline',
      );
      expect(results, hasLength(2));
    });

    test('a treatment snapshot preserves the specific product withdrawal', () {
      final productB = product('oxy-200', '200 mg/mL', 28);
      final treatment = TreatmentRecord(
        id: 't1',
        sheepId: '184',
        medicationId: productB.id,
        dose: 2,
        doseUnit: 'ml',
        route: productB.route,
        administeredAt: DateTime(2026, 10, 1),
        administeredBy: 'Ahmed',
        withdrawalDays: productB.meatWithdrawalDays,
        milkWithdrawalDays: 0,
        clearanceDate: DateTime(2026, 10, 29),
        milkClearanceDate: DateTime(2026, 10, 1),
        medicationNameSnapshot: productB.name,
        activeIngredientSnapshot: productB.activeIngredient,
      );
      expect(treatment.withdrawalDays, 28);
      expect(treatment.medicationNameSnapshot, productB.name);
    });
  });
}
