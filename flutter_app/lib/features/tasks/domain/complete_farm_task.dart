import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/care_repositories.dart';
import 'farm_task.dart';

class CompleteFarmTaskResult {
  const CompleteFarmTaskResult({
    required this.completedTask,
    required this.createdEvents,
    this.nextTask,
  });

  final FarmTask completedTask;
  final List<FarmEvent> createdEvents;
  final FarmTask? nextTask;
}

class CompleteFarmTask {
  const CompleteFarmTask({
    required this.taskRepository,
    required this.eventRepository,
    required this.createId,
  });

  final FarmTaskRepository taskRepository;
  final CareEventRepository eventRepository;
  final String Function() createId;

  CompleteFarmTaskResult call({
    required FarmTask task,
    required DateTime completedAt,
    required String completedBy,
    required FarmProtocol? protocol,
  }) {
    if (task.status == FarmTaskStatus.completed ||
        task.status == FarmTaskStatus.cancelled ||
        task.status == FarmTaskStatus.skipped) {
      throw StateError('Only pending or in-progress tasks can be completed.');
    }
    final completed = task.copyWith(
      status: FarmTaskStatus.completed,
      completedAt: completedAt,
    );
    taskRepository.saveFarmTask(completed);
    final events = <FarmEvent>[
      for (final sheepId in task.sheepIds.toSet())
        AnimalActionEvent(
          id: createId(),
          sheepId: sheepId,
          occurredAt: completedAt,
          recordedBy: completedBy,
          action: task.action,
        ),
    ];
    for (final event in events) {
      eventRepository.saveEvent(event);
    }
    FarmTask? nextTask;
    if (protocol case FarmProtocol(enabled: true, intervalDays: final days)) {
      final dueAt = TaskRecurrence.nextDueDate(
        lastCompletion: completedAt,
        intervalDays: days,
      );
      if (dueAt != null) {
        nextTask = FarmTask(
          id: createId(),
          title: protocol.name,
          action: protocol.routineType,
          targetGroupId: protocol.targetGroupId,
          sheepIds: task.sheepIds,
          dueAt: dueAt,
          createdAt: completedAt,
          protocolId: protocol.id,
        );
        taskRepository.saveFarmTask(nextTask);
      }
    }
    return CompleteFarmTaskResult(
      completedTask: completed,
      createdEvents: List.unmodifiable(events),
      nextTask: nextTask,
    );
  }
}
