import '../errors/repository_exception.dart';
import '../models/entities.dart';
import 'repository_contracts.dart';

class _InMemoryEntityRepository<T extends Entity>
    implements EntityRepository<T> {
  final Map<String, T> _entities = {};

  @override
  Future<T?> getById(String id) async => _entities[id];

  @override
  Future<List<T>> getAll() async => List.unmodifiable(_entities.values);

  @override
  Future<void> save(T entity) async {
    _entities[entity.id] = entity;
  }
}

class InMemorySheepRepository extends _InMemoryEntityRepository<Sheep>
    implements SheepRepository {
  @override
  Future<Sheep?> findByTagNumber(String farmId, String tagNumber) async {
    for (final sheep in await getAll()) {
      if (sheep.farmId == farmId && sheep.tagNumber == tagNumber) {
        return sheep;
      }
    }
    return null;
  }

  @override
  Future<void> save(Sheep entity) async {
    final existing = await findByTagNumber(entity.farmId, entity.tagNumber);
    if (existing != null && existing.id != entity.id) {
      throw DuplicateSheepTagException(entity.farmId, entity.tagNumber);
    }
    await super.save(entity);
  }
}

class InMemoryGroupRepository extends _InMemoryEntityRepository<Group>
    implements GroupRepository {}

class InMemoryTaskRepository extends _InMemoryEntityRepository<Task>
    implements TaskRepository {}

class InMemoryTreatmentRepository extends _InMemoryEntityRepository<Treatment>
    implements TreatmentRepository {}

class InMemoryEventRepository extends _InMemoryEntityRepository<Event>
    implements EventRepository {}

class InMemorySyncRepository extends _InMemoryEntityRepository<SyncQueueItem>
    implements SyncRepository {
  InMemorySyncRepository({
    bool seedDemoQueue = true,
    Map<String, Object?>? initialState,
    this.onChanged,
  }) {
    if (initialState != null) {
      _restore(initialState);
    } else if (seedDemoQueue) {
      _seedDemoQueue();
      _persist();
    }
  }

  final void Function(Map<String, Object?> snapshot)? onChanged;
  final Map<String, String> _idByIdempotencyKey = {};
  final List<SyncTombstone> _tombstones = [];
  SyncCursor _cursor = SyncCursor(
    syncCursor: null,
    schemaVersion: 1,
    updatedAt: DateTime.utc(1970),
  );

  @override
  List<SyncQueueItem> getQueue() => List.unmodifiable(
    _entities.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt)),
  );

  @override
  Future<void> save(SyncQueueItem entity) async {
    final existingId = _idByIdempotencyKey[entity.idempotencyKey];
    if (existingId != null && existingId != entity.id) {
      throw StateError(
        'Idempotency key ${entity.idempotencyKey} already belongs to $existingId.',
      );
    }
    _entities[entity.id] = entity;
    _idByIdempotencyKey[entity.idempotencyKey] = entity.id;
    _persist();
  }

  @override
  SyncQueueItem enqueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
    required Map<String, Object?> payload,
    required String idempotencyKey,
  }) {
    final existingId = _idByIdempotencyKey[idempotencyKey];
    if (existingId != null) {
      final existing = _entities[existingId];
      if (existing != null) return existing;
      throw StateError('Idempotent mutation $idempotencyKey was dismissed.');
    }
    final now = DateTime.now();
    final item = SyncQueueItem(
      id: 'sync-${now.microsecondsSinceEpoch}-${_idByIdempotencyKey.length}',
      createdAt: now,
      updatedAt: now,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      payload: payload,
      idempotencyKey: idempotencyKey,
    );
    _idByIdempotencyKey[idempotencyKey] = item.id;
    _entities[item.id] = item;
    _persist();
    return item;
  }

  @override
  void updateStatus(String id, SyncStatus status) {
    final item = _entities[id];
    if (item == null) throw StateError('Sync queue item $id does not exist.');
    final validTransition =
        item.status == status ||
        (item.status == SyncStatus.pending && status == SyncStatus.syncing) ||
        (item.status == SyncStatus.syncing &&
            (status == SyncStatus.synced ||
                status == SyncStatus.failed ||
                status == SyncStatus.conflict));
    if (!validTransition) {
      throw StateError(
        'Invalid sync state transition ${item.status.name} → ${status.name}.',
      );
    }
    _entities[id] = item.copyWith(updatedAt: DateTime.now(), status: status);
    _persist();
  }

  @override
  void retry(String id) {
    final item = _entities[id];
    if (item == null) throw StateError('Sync queue item $id does not exist.');
    if (item.status != SyncStatus.failed) {
      throw StateError('Only failed mutations can be retried.');
    }
    _entities[id] = item.copyWith(
      updatedAt: DateTime.now(),
      retryCount: item.retryCount + 1,
      status: SyncStatus.pending,
    );
    _persist();
  }

  @override
  void resolveConflict(String id) {
    final item = _entities[id];
    if (item == null) throw StateError('Sync queue item $id does not exist.');
    if (item.status != SyncStatus.conflict) {
      throw StateError('Only conflict items can be reviewed.');
    }
    _entities[id] = item.copyWith(
      updatedAt: DateTime.now(),
      retryCount: item.retryCount + 1,
      status: SyncStatus.pending,
    );
    _persist();
  }

  @override
  void dismiss(String id) {
    final item = _entities[id];
    if (item == null) throw StateError('Sync queue item $id does not exist.');
    if (item.status != SyncStatus.synced && item.status != SyncStatus.failed) {
      throw StateError('Only synced or failed items can be dismissed.');
    }
    _entities.remove(id);
    _persist();
  }

  @override
  void createTombstone(String entityType, String entityId) {
    final now = DateTime.now();
    final tombstone = SyncTombstone(
      id: 'tombstone-$entityType-$entityId',
      createdAt: now,
      updatedAt: now,
      entityType: entityType,
      entityId: entityId,
    );
    if (_tombstones.any((existing) => existing.id == tombstone.id)) return;
    _tombstones.add(tombstone);
    enqueue(
      entityType: entityType,
      entityId: entityId,
      operation: SyncOperation.delete,
      payload: {'deleted': true, 'tombstoneId': tombstone.id},
      idempotencyKey: 'delete:$entityType:$entityId',
    );
    _persist();
  }

  @override
  List<SyncTombstone> getTombstones() => List.unmodifiable(_tombstones);

  @override
  SyncCursor getCursor() => _cursor;

  @override
  void setCursor(String? cursor) {
    _cursor = SyncCursor(
      syncCursor: cursor,
      schemaVersion: _cursor.schemaVersion,
      updatedAt: DateTime.now(),
    );
    _persist();
  }

  Map<String, Object?> toSnapshot() => {
    'items': [
      for (final item in _entities.values)
        {
          'id': item.id,
          'createdAt': item.createdAt.toIso8601String(),
          'updatedAt': item.updatedAt.toIso8601String(),
          'entityType': item.entityType,
          'entityId': item.entityId,
          'operation': item.operation.name,
          'payload': item.payload,
          'idempotencyKey': item.idempotencyKey,
          'retryCount': item.retryCount,
          'status': item.status.name,
          'createdBy': item.createdBy,
          'updatedBy': item.updatedBy,
        },
    ],
    'tombstones': [
      for (final tombstone in _tombstones)
        {
          'id': tombstone.id,
          'createdAt': tombstone.createdAt.toIso8601String(),
          'updatedAt': tombstone.updatedAt.toIso8601String(),
          'entityType': tombstone.entityType,
          'entityId': tombstone.entityId,
        },
    ],
    'cursor': _cursor.syncCursor,
    'schemaVersion': _cursor.schemaVersion,
    'cursorUpdatedAt': _cursor.updatedAt.toIso8601String(),
    'idempotencyKeys': _idByIdempotencyKey,
  };

  void _restore(Map<String, Object?> snapshot) {
    final keys = (snapshot['idempotencyKeys'] as Map).cast<String, Object?>();
    _idByIdempotencyKey.addAll(
      keys.map((key, value) => MapEntry(key, value as String)),
    );
    for (final encoded in snapshot['items'] as List<Object?>) {
      final record = (encoded as Map).cast<String, Object?>();
      final payload = (record['payload'] as Map).cast<String, Object?>();
      final item = SyncQueueItem(
        id: record['id'] as String,
        createdAt: DateTime.parse(record['createdAt'] as String),
        updatedAt: DateTime.parse(record['updatedAt'] as String),
        entityType: record['entityType'] as String,
        entityId: record['entityId'] as String,
        operation: SyncOperation.values.byName(record['operation'] as String),
        payload: payload,
        idempotencyKey: record['idempotencyKey'] as String,
        retryCount: record['retryCount'] as int,
        status: SyncStatus.values.byName(record['status'] as String),
        createdBy: record['createdBy'] as String?,
        updatedBy: record['updatedBy'] as String?,
      );
      _entities[item.id] = item;
      _idByIdempotencyKey.putIfAbsent(item.idempotencyKey, () => item.id);
    }
    for (final encoded in snapshot['tombstones'] as List<Object?>) {
      final record = (encoded as Map).cast<String, Object?>();
      _tombstones.add(
        SyncTombstone(
          id: record['id'] as String,
          createdAt: DateTime.parse(record['createdAt'] as String),
          updatedAt: DateTime.parse(record['updatedAt'] as String),
          entityType: record['entityType'] as String,
          entityId: record['entityId'] as String,
        ),
      );
    }
    _cursor = SyncCursor(
      syncCursor: snapshot['cursor'] as String?,
      schemaVersion: snapshot['schemaVersion'] as int,
      updatedAt: DateTime.parse(snapshot['cursorUpdatedAt'] as String),
    );
  }

  void _persist() {
    onChanged?.call(toSnapshot());
  }

  void _seedDemoQueue() {
    final now = DateTime.now();
    final statuses = [
      ...List.filled(12, SyncStatus.pending),
      ...List.filled(8, SyncStatus.synced),
      ...List.filled(2, SyncStatus.failed),
      ...List.filled(2, SyncStatus.conflict),
    ];
    for (var index = 0; index < statuses.length; index++) {
      final itemId = 'demo-sync-$index';
      final item = SyncQueueItem(
        id: itemId,
        createdAt: now.subtract(Duration(minutes: index * 7)),
        updatedAt: now.subtract(Duration(minutes: index * 7)),
        entityType: index == 20
            ? 'Treatment'
            : index == 21
            ? 'Weight'
            : index.isEven
            ? 'Event'
            : 'Task',
        entityId: 'demo-entity-$index',
        operation: index % 3 == 0 ? SyncOperation.create : SyncOperation.update,
        payload: {'demo': true},
        idempotencyKey: 'demo-idempotency-$index',
        retryCount: statuses[index] == SyncStatus.failed ? 1 : 0,
        status: statuses[index],
      );
      _idByIdempotencyKey[item.idempotencyKey] = item.id;
      _entities[item.id] = item;
    }
  }
}
