import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/app/app_settings.dart';
import 'package:herd_hub_sheep/core/models/entities.dart';
import 'package:herd_hub_sheep/core/services/in_memory_repositories.dart';
import 'package:herd_hub_sheep/features/sync/data/sync_providers.dart';

void main() {
  group('sync queue', () {
    test('enqueue is idempotent for the same mutation key', () {
      final repository = InMemorySyncRepository(seedDemoQueue: false);
      final first = repository.enqueue(
        entityType: 'Treatment',
        entityId: 'treatment-1',
        operation: SyncOperation.create,
        payload: const {'sheepId': '184'},
        idempotencyKey: 'treatment-1:create',
      );
      final duplicate = repository.enqueue(
        entityType: 'Treatment',
        entityId: 'treatment-1',
        operation: SyncOperation.create,
        payload: const {'sheepId': '184'},
        idempotencyKey: 'treatment-1:create',
      );

      expect(duplicate.id, first.id);
      expect(repository.getQueue(), hasLength(1));
      expect(first.idempotencyKey, 'treatment-1:create');
    });

    test('retry increments count and uses increasing capped backoff', () {
      final repository = InMemorySyncRepository(seedDemoQueue: false);
      final item = repository.enqueue(
        entityType: 'Event',
        entityId: 'event-1',
        operation: SyncOperation.create,
        payload: const {},
        idempotencyKey: 'event-1:create',
      );
      repository.updateStatus(item.id, SyncStatus.syncing);
      repository.updateStatus(item.id, SyncStatus.failed);
      repository.retry(item.id);

      final retried = repository.getQueue().single;
      expect(retried.retryCount, 1);
      expect(retried.status, SyncStatus.pending);
      expect(retryDelay(1), greaterThan(retryDelay(0)));
      expect(retryDelay(50), const Duration(milliseconds: 6400));
    });

    test(
      'critical records require review; scalar conflicts use latest write',
      () {
        final earlier = DateTime.utc(2026, 10, 1);
        final later = earlier.add(const Duration(minutes: 1));

        expect(
          SyncConflictPolicy.resolve(
            entityType: 'Treatment',
            localUpdatedAt: later,
            remoteUpdatedAt: earlier,
          ),
          ConflictResolution.reviewRequired,
        );
        expect(
          SyncConflictPolicy.resolve(
            entityType: 'Sheep',
            localUpdatedAt: later,
            remoteUpdatedAt: earlier,
          ),
          ConflictResolution.useLocal,
        );
        expect(
          SyncConflictPolicy.resolve(
            entityType: 'Sheep',
            localUpdatedAt: earlier,
            remoteUpdatedAt: later,
          ),
          ConflictResolution.useRemote,
        );
      },
    );

    test('tombstones enqueue idempotent delete mutations', () {
      final repository = InMemorySyncRepository(seedDemoQueue: false);
      repository.createTombstone('Event', 'event-1');
      repository.createTombstone('Event', 'event-1');

      expect(repository.getTombstones(), hasLength(1));
      expect(repository.getQueue(), hasLength(1));
      expect(repository.getQueue().single.operation, SyncOperation.delete);
    });
  });

  group('sync center controller', () {
    test(
      'offline blocks sync and online syncs once while advancing cursor',
      () async {
        final repository = InMemorySyncRepository(seedDemoQueue: false);
        final mutation = repository.enqueue(
          entityType: 'Treatment',
          entityId: 'treatment-1',
          operation: SyncOperation.create,
          payload: const {},
          idempotencyKey: 'treatment-1:create',
        );
        final container = ProviderContainer(
          overrides: [syncRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        expect(container.read(syncCenterProvider).isOnline, isFalse);
        await expectLater(
          container.read(syncCenterProvider.notifier).syncNow(),
          throwsStateError,
        );
        expect(repository.getQueue().single.status, SyncStatus.pending);

        container.read(appSettingsProvider.notifier).setOnline(true);
        await container.read(syncCenterProvider.notifier).syncNow();

        expect(repository.getQueue(), hasLength(1));
        expect(repository.getQueue().single.id, mutation.id);
        expect(repository.getQueue().single.status, SyncStatus.synced);
        expect(repository.getCursor().syncCursor, isNotNull);
      },
    );

    test(
      'critical conflict stays reviewable and cannot be silently synced',
      () async {
        final repository = InMemorySyncRepository(seedDemoQueue: false);
        final mutation = repository.enqueue(
          entityType: 'Treatment',
          entityId: 'treatment-conflict',
          operation: SyncOperation.create,
          payload: const {'conflictDetected': true},
          idempotencyKey: 'treatment-conflict:create',
        );
        final container = ProviderContainer(
          overrides: [syncRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        container.read(appSettingsProvider.notifier).setOnline(true);

        await container.read(syncCenterProvider.notifier).syncNow();
        expect(repository.getQueue().single.status, SyncStatus.conflict);

        container.read(syncCenterProvider.notifier).reviewConflict(mutation.id);
        expect(repository.getQueue().single.status, SyncStatus.pending);
        expect(repository.getQueue().single.retryCount, 1);
      },
    );
  });
}
