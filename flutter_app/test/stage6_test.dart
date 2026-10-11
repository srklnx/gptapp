import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/features/breeding/data/breeding_providers.dart';
import 'package:herd_hub_sheep/features/quick_log/data/care_providers.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/eid/domain/eid_readiness.dart';
import 'package:herd_hub_sheep/features/heat_stress/domain/heat_stress.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/withdrawal_calculator.dart';
import 'package:herd_hub_sheep/features/sheep/data/mock_sheep_directory_repository.dart';
import 'package:herd_hub_sheep/features/sheep/domain/sheep_record.dart';
import 'package:herd_hub_sheep/features/sync/data/sync_providers.dart';

void main() {
  group('HeatStressService', () {
    test('uses configurable THI thresholds for every risk band', () {
      const thresholds = HeatStressThresholds(
        alertThi: 60,
        dangerThi: 70,
        emergencyThi: 80,
      );
      final safe = HeatStressService.assess(
        temperatureC: 20,
        relativeHumidity: 30,
        thresholds: thresholds,
      );
      final alert = HeatStressService.assess(
        temperatureC: 30,
        relativeHumidity: 50,
        thresholds: thresholds,
      );
      final danger = HeatStressService.assess(
        temperatureC: 35,
        relativeHumidity: 50,
        thresholds: thresholds,
      );
      final emergency = HeatStressService.assess(
        temperatureC: 43,
        relativeHumidity: 50,
        thresholds: thresholds,
      );

      expect(safe.level, HeatRiskLevel.safe);
      expect(alert.level, HeatRiskLevel.alert);
      expect(danger.level, HeatRiskLevel.danger);
      expect(emergency.level, HeatRiskLevel.emergency);
    });

    test('rejects invalid humidity and non-finite readings', () {
      expect(
        () => HeatStressService.assess(temperatureC: 32, relativeHumidity: 101),
        throwsArgumentError,
      );
      expect(
        () => HeatStressService.assess(
          temperatureC: double.nan,
          relativeHumidity: 50,
        ),
        throwsArgumentError,
      );
    });
  });

  group('EidReadinessCalculator', () {
    final sheep = MockSheepDirectoryRepository().getById('311')!;
    final now = DateTime(2026, 10, 1);
    final clear = WithdrawalCalculator.calculate([], now: now);

    test(
      'derives ready status from weight, BCS, health and clear withdrawal',
      () {
        final readiness = EidReadinessCalculator.calculate(
          sheep: sheep,
          events: const [],
          withdrawal: clear,
          criteria: const EidCriteria(),
        );

        expect(readiness.status, EidReadinessStatus.ready);
        expect(readiness.clearForSale, isTrue);
      },
    );

    test('active meat withdrawal immediately removes sale readiness', () {
      final treatment = TreatmentRecord(
        id: 'treatment-eid',
        sheepId: sheep.id,
        medicationId: 'medicine',
        dose: 1,
        doseUnit: 'ml',
        route: TreatmentRoute.oral,
        administeredAt: now,
        administeredBy: 'Ahmed',
        withdrawalDays: 5,
        milkWithdrawalDays: 0,
        clearanceDate: now.add(const Duration(days: 5)),
        milkClearanceDate: now,
      );
      final withdrawal = WithdrawalCalculator.calculate([treatment], now: now);
      final readiness = EidReadinessCalculator.calculate(
        sheep: sheep,
        events: const [],
        withdrawal: withdrawal,
        criteria: const EidCriteria(),
      );

      expect(readiness.status, EidReadinessStatus.withdrawal);
      expect(readiness.clearForSale, isFalse);
    });

    test('latest weight and BCS events override the animal snapshot', () {
      final events = [
        WeightEvent(
          id: 'weight-latest',
          sheepId: sheep.id,
          occurredAt: now,
          recordedBy: 'Ahmed',
          weightKg: 30,
        ),
        BcsEvent(
          id: 'bcs-latest',
          sheepId: sheep.id,
          occurredAt: now,
          recordedBy: 'Ahmed',
          score: 2,
        ),
      ];
      final readiness = EidReadinessCalculator.calculate(
        sheep: sheep,
        events: events,
        withdrawal: clear,
        criteria: const EidCriteria(),
      );

      expect(readiness.weightKg, 30);
      expect(readiness.bcs, 2);
      expect(readiness.status, EidReadinessStatus.lowBcs);
    });

    test(
      'dynamic health status is used instead of the stored sheep snapshot',
      () {
        final readiness = EidReadinessCalculator.calculate(
          sheep: sheep,
          effectiveHealthStatus: SheepHealthStatus.attention,
          events: const [],
          withdrawal: clear,
          criteria: const EidCriteria(),
        );

        expect(readiness.status, EidReadinessStatus.healthConcern);
        expect(readiness.clearForSale, isFalse);
      },
    );

    test('milk-only withdrawal does not block meat sale readiness', () {
      final treatment = TreatmentRecord(
        id: 'treatment-milk-only',
        sheepId: sheep.id,
        medicationId: 'medicine',
        dose: 1,
        doseUnit: 'ml',
        route: TreatmentRoute.oral,
        administeredAt: now,
        administeredBy: 'Ahmed',
        withdrawalDays: 0,
        milkWithdrawalDays: 5,
        clearanceDate: now,
        milkClearanceDate: now.add(const Duration(days: 5)),
      );
      final withdrawal = WithdrawalCalculator.calculate([treatment], now: now);
      final readiness = EidReadinessCalculator.calculate(
        sheep: sheep,
        effectiveHealthStatus: SheepHealthStatus.withdrawal,
        events: const [],
        withdrawal: withdrawal,
        criteria: const EidCriteria(),
      );

      expect(withdrawal.notClearForSale, isFalse);
      expect(readiness.status, EidReadinessStatus.ready);
      expect(readiness.clearForSale, isTrue);
    });
  });

  test('recording heat check saves a typed event, task and sync mutations', () {
    final careRepository = InMemoryCareRepository();
    final syncRepository = InMemorySyncRepository(seedDemoQueue: false);
    final container = ProviderContainer(
      overrides: [
        careRepositoryProvider.overrideWithValue(careRepository),
        syncRepositoryProvider.overrideWithValue(syncRepository),
      ],
    );
    addTearDown(container.dispose);

    final event = container
        .read(careProvider.notifier)
        .recordHeatCheck(
          sheepId: 'flock',
          temperatureC: 43,
          humidityPercent: 50,
          symptoms: const ['Panting'],
          waterAvailable: true,
          shadeAvailable: false,
          actionsTaken: const ['Move to shade'],
          occurredAt: DateTime(2026, 10, 1, 12),
          recordedBy: 'Ahmed',
        );

    expect(event.riskLevel, HeatRiskLevel.emergency.name);
    expect(careRepository.getEvents().whereType<HeatCheckEvent>(), [event]);
    expect(
      careRepository.getFarmTasks().where(
        (task) => task.title == 'Recheck heat stress',
      ),
      hasLength(1),
    );
    expect(
      syncRepository.getQueue().where((item) => item.entityType == 'HeatCheck'),
      hasLength(1),
    );
  });

  test('breeding mutation creates a record, timeline event and sync item', () {
    final breedingRepository = InMemoryBreedingRepository(
      initialData: const {'records': <Object?>[]},
    );
    final syncRepository = InMemorySyncRepository(seedDemoQueue: false);
    final container = ProviderContainer(
      overrides: [
        breedingRepositoryProvider.overrideWithValue(breedingRepository),
        careRepositoryProvider.overrideWithValue(InMemoryCareRepository()),
        syncRepositoryProvider.overrideWithValue(syncRepository),
      ],
    );
    addTearDown(container.dispose);

    final record = container
        .read(breedingProvider.notifier)
        .recordMating(
          sheepId: '184',
          matingDate: DateTime(2026, 10, 1),
          ramTag: 'R12',
        );

    expect(record.expectedLambingDate, DateTime(2027, 2, 25));
    expect(
      container.read(careProvider).events.whereType<AnimalActionEvent>(),
      contains(
        isA<AnimalActionEvent>().having(
          (event) => event.action,
          'action',
          'Mating',
        ),
      ),
    );
    expect(
      syncRepository.getQueue().where((item) => item.entityType == 'Breeding'),
      hasLength(2),
    );
  });
}
