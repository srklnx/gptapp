import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/core/services/local_json_store.dart';
import 'package:herd_hub_sheep/features/health/data/health_case_providers.dart';
import 'package:herd_hub_sheep/features/health/domain/famacha.dart';
import 'package:herd_hub_sheep/features/health/domain/health_case.dart';
import 'package:herd_hub_sheep/features/parasites/data/parasite_providers.dart';
import 'package:herd_hub_sheep/features/parasites/domain/parasite_records.dart';
import 'package:herd_hub_sheep/features/parasites/domain/parasite_service.dart';
import 'package:herd_hub_sheep/features/quick_log/data/care_providers.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';
import 'package:herd_hub_sheep/features/sync/data/sync_providers.dart';

void main() {
  group('Famacha', () {
    test('valid scores 1-5, invalid 0/6', () {
      expect(FamachaRecord.isValid(1), isTrue);
      expect(FamachaRecord.isValid(5), isTrue);
      expect(FamachaRecord.isValid(0), isFalse);
      expect(FamachaRecord.isValid(6), isFalse);
    });

    test('trend calculation', () {
      final records = [
        FamachaRecord(id: '1', sheepId: '184', score: 2, date: DateTime(2026, 9, 1), observer: 'A'),
        FamachaRecord(id: '2', sheepId: '184', score: 4, date: DateTime(2026, 9, 15), observer: 'A'),
      ];
      expect(FamachaService.trend(records), FamachaTrend.worsening);
      expect(FamachaService.trend([records.first]), FamachaTrend.insufficient);
    });
  });

  group('ParasiteRiskService', () {
    test('diarrhea alone does not auto-deworm', () {
      final risk = ParasiteRiskService.assess(diarrhea: true);
      expect(risk.riskLevel, ParasiteRiskLevel.monitor);
      expect(risk.needsAction, isFalse);
    });

    test('FAMACHA 3 alone is needs assessment, not a treatment decision', () {
      final risk = ParasiteRiskService.assess(famachaScore: 3);
      expect(risk.riskLevel, ParasiteRiskLevel.needsAssessment);
    });

    test('FAMACHA 4 raises high concern', () {
      final risk = ParasiteRiskService.assess(famachaScore: 4);
      expect(risk.riskLevel, ParasiteRiskLevel.highConcern);
      expect(risk.needsAction, isTrue);
      expect(risk.reasons, contains('famacha_high'));
    });
  });

  group('DoseCalculator', () {
    test('calculates volume from verified mg/kg and mg/mL', () {
      expect(DoseCalculator.calculateVolume(weightKg: 60, mgPerKg: 7.5, mgPerMl: 100), 4.5);
    });

    test('returns null when data is missing', () {
      expect(DoseCalculator.calculateVolume(weightKg: 0, mgPerKg: 7.5, mgPerMl: 100), isNull);
    });
  });

  group('ParasiteController', () {
    late ProviderContainer container;
    late InMemoryCareRepository care;
    late InMemorySyncRepository sync;

    setUp(() {
      care = InMemoryCareRepository();
      sync = InMemorySyncRepository(seedDemoQueue: false);
      container = ProviderContainer(
        overrides: [
          careRepositoryProvider.overrideWithValue(care),
          syncRepositoryProvider.overrideWithValue(sync),
          parasiteRepositoryProvider.overrideWithValue(InMemoryParasiteRepository()),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('recordDeworming stores snapshot, event, withdrawal and follow-up', () {
      final medication = care.getMedications().firstWhere((m) => m.id == 'albendazole');
      final record = container.read(parasiteProvider.notifier).recordDeworming(
        sheepId: '184',
        reason: DewormingReason.treatment,
        medication: medication,
        dose: 10,
        administeredAt: DateTime(2026, 10, 1),
        administeredBy: 'Ahmed',
        followUpDate: DateTime(2026, 10, 8),
      );

      expect(record.activeIngredient, 'Albendazole');
      expect(record.withdrawalDays, medication.meatWithdrawalDays);
      expect(
        care.getEvents(sheepId: '184').any((e) => e is AnimalActionEvent && e.action == 'Deworming'),
        isTrue,
      );
      expect(care.getFarmTasks().any((t) => t.title == 'Recheck parasite status'), isTrue);
      expect(sync.getQueue().any((i) => i.entityType == 'Deworming'), isTrue);
    });

    test('recordFamacha and recordResponse', () {
      container.read(parasiteProvider.notifier).recordFamacha(
        sheepId: '184',
        score: 4,
        date: DateTime(2026, 10, 1),
        observer: 'Ahmed',
      );
      expect(container.read(parasiteProvider).famachaFor('184'), hasLength(1));

      final medication = care.getMedications().first;
      final record = container.read(parasiteProvider.notifier).recordDeworming(
        sheepId: '184',
        reason: DewormingReason.famachaAnemia,
        medication: medication,
        dose: 10,
        administeredAt: DateTime(2026, 10, 1),
        administeredBy: 'Ahmed',
      );
      container.read(parasiteProvider.notifier).recordResponse(
        dewormingId: record.id,
        response: TreatmentResponse.improved,
      );
      expect(
        container.read(parasiteProvider).dewormingsFor('184').first.responseStatus,
        TreatmentResponse.improved,
      );
    });
  });

  group('HealthCaseController', () {
    test('create and update status', () {
      final sync = InMemorySyncRepository(seedDemoQueue: false);
      final container = ProviderContainer(
        overrides: [
          careRepositoryProvider.overrideWithValue(InMemoryCareRepository()),
          syncRepositoryProvider.overrideWithValue(sync),
        ],
      );
      addTearDown(container.dispose);

      final healthCase = container.read(healthCaseProvider.notifier).createCase(
        sheepIds: const ['184'],
        startedAt: DateTime(2026, 10, 1),
        symptoms: const ['diarrhea'],
        severity: 'moderate',
      );
      expect(container.read(healthCaseProvider).forSheep('184'), hasLength(1));
      container.read(healthCaseProvider.notifier).updateStatus(healthCase.id, HealthCaseStatus.monitoring);
      expect(
        container.read(healthCaseProvider).forSheep('184').first.status,
        HealthCaseStatus.monitoring,
      );
    });
  });

  group('Offline persistence', () {
    test('parasite records survive repository recreation', () {
      final directory = Directory.systemTemp.createTempSync('herdhub-parasite-');
      addTearDown(() => directory.deleteSync(recursive: true));
      final store = LocalJsonStore(directory);
      final repository = InMemoryParasiteRepository(
        persist: (snapshot) => store.write('parasite.json', snapshot),
      );
      repository.saveFamacha(
        FamachaRecord(id: 'f1', sheepId: '184', score: 4, date: DateTime(2026, 10, 1), observer: 'A'),
      );
      final restored = InMemoryParasiteRepository(initialData: store.read('parasite.json'));
      expect(restored.famacha(sheepId: '184'), hasLength(1));
      expect(restored.famacha(sheepId: '184').first.score, 4);
    });
  });
}
