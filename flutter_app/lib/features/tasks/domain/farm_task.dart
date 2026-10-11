enum FarmTaskStatus { pending, inProgress, completed, skipped, cancelled }

enum TaskPriority { low, normal, high }

class FarmTask {
  FarmTask({
    required this.id,
    required this.title,
    required this.action,
    required this.targetGroupId,
    required Iterable<String> sheepIds,
    required this.dueAt,
    required this.createdAt,
    this.protocolId,
    this.status = FarmTaskStatus.pending,
    this.completedAt,
    this.priority = TaskPriority.normal,
    this.assignedTo,
    this.notes = '',
  }) : sheepIds = List.unmodifiable(sheepIds);

  final String id;
  final String title;
  final String action;
  final String targetGroupId;
  final List<String> sheepIds;
  final DateTime dueAt;
  final DateTime createdAt;
  final String? protocolId;
  final FarmTaskStatus status;
  final DateTime? completedAt;
  final TaskPriority priority;
  final String? assignedTo;
  final String notes;

  FarmTask copyWith({
    FarmTaskStatus? status,
    DateTime? completedAt,
    DateTime? dueAt,
    Iterable<String>? sheepIds,
  }) => FarmTask(
    id: id,
    title: title,
    action: action,
    targetGroupId: targetGroupId,
    sheepIds: sheepIds ?? this.sheepIds,
    dueAt: dueAt ?? this.dueAt,
    createdAt: createdAt,
    protocolId: protocolId,
    status: status ?? this.status,
    completedAt: completedAt ?? this.completedAt,
    priority: priority,
    assignedTo: assignedTo,
    notes: notes,
  );
}

class FarmProtocol {
  const FarmProtocol({
    required this.id,
    required this.name,
    required this.routineType,
    required this.targetGroupId,
    required this.intervalDays,
    required this.enabled,
    this.season,
  });

  final String id;
  final String name;
  final String routineType;
  final String targetGroupId;
  final int intervalDays;
  final bool enabled;
  final String? season;
}

abstract final class TaskRecurrence {
  static DateTime? nextDueDate({
    required DateTime lastCompletion,
    required int intervalDays,
  }) {
    if (intervalDays <= 0) {
      throw ArgumentError.value(
        intervalDays,
        'intervalDays',
        'Must be positive',
      );
    }
    return lastCompletion.add(Duration(days: intervalDays));
  }
}
