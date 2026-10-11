enum SyncOperation { create, update, delete }

enum SyncStatus { pending, syncing, synced, conflict, failed }

abstract class Entity {
  const Entity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy;
  final String? updatedBy;
}

class Farm extends Entity {
  const Farm({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    super.createdBy,
    super.updatedBy,
  });

  final String name;
}

class User extends Entity {
  const User({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.displayName,
    required this.email,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String displayName;
  final String email;
}

class Sheep extends Entity {
  const Sheep({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.tagNumber,
    this.eidRfid,
    this.breedId,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String tagNumber;
  final String? eidRfid;
  final String? breedId;
}

class Group extends Entity {
  Group({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.name,
    Iterable<String> sheepIds = const [],
    super.createdBy,
    super.updatedBy,
  }) : sheepIds = List.unmodifiable(sheepIds);

  final String farmId;
  final String name;
  final List<String> sheepIds;
}

class Task extends Entity {
  const Task({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.title,
    this.dueAt,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String title;
  final DateTime? dueAt;
}

class Treatment extends Entity {
  const Treatment({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.sheepId,
    required this.medicationId,
    required this.administeredAt,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String sheepId;
  final String medicationId;
  final DateTime administeredAt;
}

class Medication extends Entity {
  const Medication({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.name,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String name;
}

class Event extends Entity {
  const Event({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.farmId,
    required this.entityId,
    required this.entityType,
    required this.occurredAt,
    super.createdBy,
    super.updatedBy,
  });

  final String farmId;
  final String entityId;
  final String entityType;
  final DateTime occurredAt;
}

class SyncQueueItem extends Entity {
  SyncQueueItem({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required Map<String, Object?> payload,
    required this.idempotencyKey,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
    super.createdBy,
    super.updatedBy,
  }) : payload = Map.unmodifiable(payload);

  final String entityType;
  final String entityId;
  final SyncOperation operation;
  final Map<String, Object?> payload;
  final int retryCount;
  final String idempotencyKey;
  final SyncStatus status;

  SyncQueueItem copyWith({
    DateTime? updatedAt,
    int? retryCount,
    SyncStatus? status,
  }) => SyncQueueItem(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    entityType: entityType,
    entityId: entityId,
    operation: operation,
    payload: payload,
    retryCount: retryCount ?? this.retryCount,
    idempotencyKey: idempotencyKey,
    status: status ?? this.status,
    createdBy: createdBy,
    updatedBy: updatedBy,
  );
}

class SyncTombstone extends Entity {
  const SyncTombstone({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.entityType,
    required this.entityId,
  });

  final String entityType;
  final String entityId;
}

class SyncCursor {
  const SyncCursor({
    required this.syncCursor,
    required this.schemaVersion,
    required this.updatedAt,
  });

  final String? syncCursor;
  final int schemaVersion;
  final DateTime updatedAt;
}
