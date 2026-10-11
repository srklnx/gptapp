import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_settings.dart';
import '../../../core/models/entities.dart';
import '../../../core/services/in_memory_repositories.dart';
import '../../../core/services/repository_contracts.dart';

final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => InMemorySyncRepository(),
);

class SyncCenterState {
  SyncCenterState({
    required Iterable<SyncQueueItem> items,
    required this.isOnline,
    required this.cursor,
  }) : items = List.unmodifiable(items);

  final List<SyncQueueItem> items;
  final bool isOnline;
  final SyncCursor cursor;

  int count(SyncStatus status) =>
      items.where((item) => item.status == status).length;
}

class SyncCenterController extends Notifier<SyncCenterState> {
  late SyncRepository _repository;

  @override
  SyncCenterState build() {
    _repository = ref.watch(syncRepositoryProvider);
    final online = ref.watch(
      appSettingsProvider.select((settings) => settings.isOnline),
    );
    return _snapshot(isOnline: online);
  }

  SyncCenterState _snapshot({required bool isOnline}) => SyncCenterState(
    items: _repository.getQueue(),
    isOnline: isOnline,
    cursor: _repository.getCursor(),
  );

  SyncQueueItem enqueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) {
    final item = _repository.enqueue(
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: payload,
      idempotencyKey: idempotencyKey,
    );
    _refresh();
    return item;
  }

  void retry(String id) {
    _repository.retry(id);
    _refresh();
  }

  void reviewConflict(String id) {
    _repository.resolveConflict(id);
    _refresh();
  }

  void dismiss(String id) {
    _repository.dismiss(id);
    _refresh();
  }

  void refreshQueue() => _refresh();

  Future<void> syncNow() async {
    if (!ref.read(appSettingsProvider).isOnline) {
      throw StateError('Sync cannot run while offline.');
    }
    final pending = _repository
        .getQueue()
        .where((item) => item.status == SyncStatus.pending)
        .toList();
    for (final item in pending) {
      _repository.updateStatus(item.id, SyncStatus.syncing);
      _refresh();
      await Future<void>.delayed(retryDelay(item.retryCount));
      final remoteUpdatedAt = item.payload['remoteUpdatedAt'];
      if (item.payload['conflictDetected'] == true &&
          (remoteUpdatedAt is! String ||
              SyncConflictPolicy.resolve(
                    entityType: item.entityType,
                    localUpdatedAt: item.updatedAt,
                    remoteUpdatedAt: DateTime.parse(remoteUpdatedAt),
                  ) ==
                  ConflictResolution.reviewRequired)) {
        _repository.updateStatus(item.id, SyncStatus.conflict);
      } else {
        _repository.updateStatus(item.id, SyncStatus.synced);
      }
      _refresh();
    }
    if (pending.isNotEmpty) {
      _repository.setCursor(DateTime.now().toUtc().toIso8601String());
      _refresh();
    }
  }

  void _refresh() {
    state = _snapshot(isOnline: ref.read(appSettingsProvider).isOnline);
  }
}

final syncCenterProvider =
    NotifierProvider<SyncCenterController, SyncCenterState>(
      SyncCenterController.new,
    );

Duration retryDelay(int retryCount) {
  if (retryCount < 0) {
    throw ArgumentError.value(retryCount, 'retryCount', 'Cannot be negative.');
  }
  final exponent = retryCount.clamp(0, 6);
  return Duration(milliseconds: 100 * (1 << exponent));
}

enum ConflictResolution { useLocal, useRemote, reviewRequired }

abstract final class SyncConflictPolicy {
  static const criticalEntityTypes = {'Treatment', 'Weight', 'BCS', 'Breeding'};

  static ConflictResolution resolve({
    required String entityType,
    required DateTime localUpdatedAt,
    required DateTime remoteUpdatedAt,
  }) {
    if (criticalEntityTypes.contains(entityType)) {
      return ConflictResolution.reviewRequired;
    }
    return localUpdatedAt.isAfter(remoteUpdatedAt)
        ? ConflictResolution.useLocal
        : ConflictResolution.useRemote;
  }
}
