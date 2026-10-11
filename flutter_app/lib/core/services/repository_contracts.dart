import '../models/entities.dart';

abstract interface class EntityRepository<T extends Entity> {
  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<void> save(T entity);
}

abstract interface class SheepRepository implements EntityRepository<Sheep> {
  Future<Sheep?> findByTagNumber(String farmId, String tagNumber);
}

abstract interface class GroupRepository implements EntityRepository<Group> {}

abstract interface class TaskRepository implements EntityRepository<Task> {}

abstract interface class TreatmentRepository
    implements EntityRepository<Treatment> {}

abstract interface class EventRepository implements EntityRepository<Event> {}

abstract interface class SyncRepository
    implements EntityRepository<SyncQueueItem> {
  List<SyncQueueItem> getQueue();
  SyncQueueItem enqueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  });
  void updateStatus(String id, SyncStatus status);
  void retry(String id);
  void resolveConflict(String id);
  void dismiss(String id);
  void createTombstone(String entityType, String entityId);
  List<SyncTombstone> getTombstones();
  SyncCursor getCursor();
  void setCursor(String? cursor);
}
