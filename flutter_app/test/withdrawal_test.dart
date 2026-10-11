import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/record_treatment.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/withdrawal_calculator.dart';

final _now = DateTime(2026, 9, 30, 12);

TreatmentRecord _treatment(
  String id, {
  required DateTime meatClearance,
  required DateTime milkClearance,
}) => TreatmentRecord(
  id: id,
  sheepId: '184',
  medicationId: 'medication-$id',
  dose: 1,
  doseUnit: 'ml',
  route: TreatmentRoute.oral,
  administeredAt: DateTime(2026, 9, 29),
  administeredBy: 'Ahmed',
  withdrawalDays: meatClearance.difference(DateTime(2026, 9, 29)).inDays,
  milkWithdrawalDays: milkClearance.difference(DateTime(2026, 9, 29)).inDays,
  clearanceDate: meatClearance,
  milkClearanceDate: milkClearance,
);

void main() {
  group('WithdrawalCalculator', () {
    test('no treatment is clear for meat and milk', () {
      final result = WithdrawalCalculator.calculate([], now: _now);

      expect(result.meatState, WithdrawalState.clear);
      expect(result.milkState, WithdrawalState.clear);
      expect(result.meatClearanceDate, isNull);
      expect(result.milkClearanceDate, isNull);
      expect(result.notClearForSale, isFalse);
    });

    test('one active treatment returns its meat and milk clearances', () {
      final treatment = _treatment(
        'one',
        meatClearance: DateTime(2026, 10, 5, 12),
        milkClearance: DateTime(2026, 10, 2, 12),
      );

      final result = WithdrawalCalculator.calculate([treatment], now: _now);

      expect(result.meatClearanceDate, DateTime(2026, 10, 5, 12));
      expect(result.milkClearanceDate, DateTime(2026, 10, 2, 12));
      expect(result.meatState, WithdrawalState.active);
      expect(result.milkState, WithdrawalState.active);
      expect(result.daysUntilMeatClearance(_now), 5);
      expect(result.notClearForSale, isTrue);
    });

    test('overlapping treatments use latest clearance per product', () {
      final earlier = _treatment(
        'earlier',
        meatClearance: DateTime(2026, 10, 2),
        milkClearance: DateTime(2026, 10, 3),
      );
      final later = _treatment(
        'later',
        meatClearance: DateTime(2026, 10, 5),
        milkClearance: DateTime(2026, 10, 4),
      );

      final result = WithdrawalCalculator.calculate([
        earlier,
        later,
      ], now: _now);

      expect(result.meatClearanceDate, DateTime(2026, 10, 5));
      expect(result.milkClearanceDate, DateTime(2026, 10, 4));
    });

    test('expired withdrawal does not remain active', () {
      final expired = _treatment(
        'expired',
        meatClearance: DateTime(2026, 9, 30, 11),
        milkClearance: DateTime(2026, 9, 29),
      );

      final result = WithdrawalCalculator.calculate([expired], now: _now);

      expect(result.meatState, WithdrawalState.clear);
      expect(result.milkState, WithdrawalState.clear);
      expect(result.meatClearanceDate, isNull);
      expect(result.milkClearanceDate, isNull);
    });

    test('meat and milk withdrawal are calculated independently', () {
      final treatment = _treatment(
        'milk-only',
        meatClearance: DateTime(2026, 9, 30, 11),
        milkClearance: DateTime(2026, 10, 5),
      );

      final result = WithdrawalCalculator.calculate([treatment], now: _now);

      expect(result.meatState, WithdrawalState.clear);
      expect(result.milkState, WithdrawalState.active);
      expect(result.notClearForSale, isFalse);
      expect(result.milkClearanceDate, DateTime(2026, 10, 5));
    });
  });

  test('recording treatment writes record, event and follow-up task', () {
    final repository = InMemoryCareRepository();
    var nextId = 0;
    final useCase = RecordTreatment(
      repository: repository,
      createId: () => 'new-${nextId++}',
    );
    final medication = repository.getMedications().firstWhere(
      (record) => record.id == 'albendazole',
    );

    final treatment = useCase(
      sheepId: '311',
      medication: medication,
      dose: 8.5,
      administeredAt: _now,
      administeredBy: 'Ahmed',
      notes: 'Test dose',
    );

    expect(treatment.clearanceDate, DateTime(2026, 10, 5, 12));
    expect(treatment.milkClearanceDate, _now);
    expect(repository.getTreatments(sheepId: '311'), [treatment]);
    expect(
      repository.getEvents(sheepId: '311').single,
      isA<TreatmentEvent>()
          .having(
            (event) => event.medicationName,
            'medicationName',
            'Albendazole',
          )
          .having((event) => event.dose, 'dose', 8.5),
    );
    expect(
      repository.getFollowUpTasks(sheepId: '311').single.dueAt,
      DateTime(2026, 10, 7, 12),
    );
  });
}
