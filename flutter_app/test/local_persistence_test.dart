import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/core/models/entities.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/core/services/local_json_store.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/quick_log/domain/care_records.dart';

void main() {
  test('care records and tombstones survive repository recreation', () {
    final directory = Directory.systemTemp.createTempSync('herdhub-care-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final store = LocalJsonStore(directory);
    final repository = InMemoryCareRepository(
      persist: (snapshot) => store.write('care.json', snapshot),
    );
    final medication = repository.getMedications().first;
    final now = DateTime.utc(2026, 10, 5);
    const treatmentId = 'persisted-treatment';
    repository.saveTreatment(
      TreatmentRecord(
        id: treatmentId,
        sheepId: '184',
        medicationId: medication.id,
        dose: 2,
        doseUnit: medication.doseUnit,
        route: medication.route,
        administeredAt: now,
        administeredBy: 'Ahmed',
        withdrawalDays: medication.meatWithdrawalDays,
        milkWithdrawalDays: medication.milkWithdrawalDays,
        clearanceDate: now.add(const Duration(days: 5)),
        milkClearanceDate: now,
      ),
    );
    repository.saveEvent(
      TreatmentEvent(
        id: 'persisted-event',
        sheepId: '184',
        occurredAt: now,
        recordedBy: 'Ahmed',
        treatmentId: treatmentId,
        medicationName: medication.name,
        dose: 2,
        doseUnit: medication.doseUnit,
      ),
    );

    var restored = InMemoryCareRepository(
      initialData: store.read('care.json'),
      persist: (snapshot) => store.write('care.json', snapshot),
    );
    expect(
      restored.getTreatments().singleWhere((item) => item.id == treatmentId).id,
      treatmentId,
    );
    expect(
      restored
          .getEvents()
          .whereType<TreatmentEvent>()
          .singleWhere((event) => event.treatmentId == treatmentId)
          .treatmentId,
      treatmentId,
    );

    restored.removeEvents(['persisted-event']);
    restored = InMemoryCareRepository(
      initialData: store.read('care.json'),
      persist: (snapshot) => store.write('care.json', snapshot),
    );
    expect(
      restored.getEvents().any((event) => event.id == 'persisted-event'),
      isFalse,
    );
    expect(restored.toSnapshot()['deletedEventIds'], ['persisted-event']);
  });

  test(
    'sync queue, idempotency keys, tombstones and cursor survive restart',
    () {
      final directory = Directory.systemTemp.createTempSync('herdhub-sync-');
      addTearDown(() => directory.deleteSync(recursive: true));
      final store = LocalJsonStore(directory);
      final repository = InMemorySyncRepository(
        seedDemoQueue: false,
        onChanged: (snapshot) => store.write('sync.json', snapshot),
      );
      final item = repository.enqueue(
        entityType: 'Treatment',
        entityId: 'treatment-1',
        operation: SyncOperation.create,
        payload: const {'sheepId': '184'},
        idempotencyKey: 'treatment-1:create',
      );
      repository.createTombstone('Event', 'event-1');
      repository.setCursor('cursor-42');

      final restored = InMemorySyncRepository(
        seedDemoQueue: false,
        initialState: store.read('sync.json'),
      );
      expect(restored.getQueue(), hasLength(2));
      expect(restored.getQueue().first.id, item.id);
      expect(restored.getCursor().syncCursor, 'cursor-42');
      expect(restored.getTombstones(), hasLength(1));
      expect(
        restored
            .enqueue(
              entityType: 'Treatment',
              entityId: 'treatment-1',
              operation: SyncOperation.create,
              payload: const {'sheepId': '184'},
              idempotencyKey: 'treatment-1:create',
            )
            .id,
        item.id,
      );
    },
  );
}
