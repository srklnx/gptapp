import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/features/health/data/health_providers.dart';
import 'package:herd_hub_sheep/features/health/domain/health_observation.dart';
import 'package:herd_hub_sheep/features/quick_log/data/care_providers.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';
import 'package:herd_hub_sheep/features/sync/data/sync_providers.dart';

void main() {
  test('recording a health observation emits a timeline event and sync item', () {
    final careRepository = InMemoryCareRepository();
    final syncRepository = InMemorySyncRepository(seedDemoQueue: false);
    final healthRepository = InMemoryHealthObservationRepository();
    final container = ProviderContainer(
      overrides: [
        careRepositoryProvider.overrideWithValue(careRepository),
        syncRepositoryProvider.overrideWithValue(syncRepository),
        healthRepositoryProvider.overrideWithValue(healthRepository),
      ],
    );
    addTearDown(container.dispose);

    final observation = container.read(healthProvider.notifier).recordObservation(
      targetScope: HealthTargetScope.individual,
      sheepIds: const ['184'],
      symptomIds: const ['reduced_appetite', 'diarrhea'],
      answers: const {
        'drinking': ['less_than_normal'],
      },
      severity: HealthSeverity.moderate,
      occurredAt: DateTime(2026, 10, 1, 9),
      recordedBy: 'Ahmed',
    );

    expect(observation.sheepIds, ['184']);
    expect(
      careRepository.getEvents(sheepId: '184').whereType<HealthObservationEvent>(),
      isNotEmpty,
    );
    expect(
      syncRepository
          .getQueue()
          .where((item) => item.entityType == 'HealthObservation'),
      hasLength(1),
    );
  });

  test('treatment connects to a health observation', () {
    final careRepository = InMemoryCareRepository();
    final syncRepository = InMemorySyncRepository(seedDemoQueue: false);
    final container = ProviderContainer(
      overrides: [
        careRepositoryProvider.overrideWithValue(careRepository),
        syncRepositoryProvider.overrideWithValue(syncRepository),
      ],
    );
    addTearDown(container.dispose);

    final medication = careRepository.getMedications().first;
    final treatment = container.read(careProvider.notifier).recordTreatment(
      sheepId: '184',
      medication: medication,
      dose: 5,
      administeredAt: DateTime(2026, 10, 1),
      administeredBy: 'Ahmed',
      observationId: 'obs-123',
    );

    expect(treatment.observationId, 'obs-123');
    expect(treatment.medicationNameSnapshot, medication.name);
  });
}
