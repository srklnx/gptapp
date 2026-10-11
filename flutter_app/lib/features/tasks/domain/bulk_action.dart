import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/care_repositories.dart';
import 'complete_farm_task.dart';
import 'farm_task.dart';

class BulkUndoReceipt {
  const BulkUndoReceipt({
    required this.id,
    required this.createdEventIds,
    required this.completedTaskBefore,
    required this.createdNextTaskId,
  });

  final String id;
  final List<String> createdEventIds;
  final FarmTask? completedTaskBefore;
  final String? createdNextTaskId;
}

class BulkActionResult {
  const BulkActionResult({
    required this.events,
    required this.task,
    required this.nextTask,
    required this.undoReceipt,
  });

  final List<FarmEvent> events;
  final FarmTask? task;
  final FarmTask? nextTask;
  final BulkUndoReceipt undoReceipt;
}

class PerformBulkAction {
  const PerformBulkAction({
    required this.taskRepository,
    required this.eventRepository,
    required this.createId,
  });

  final FarmTaskRepository taskRepository;
  final CareEventRepository eventRepository;
  final String Function() createId;

  BulkActionResult call({
    required String groupId,
    required Iterable<String> sheepIds,
    required String action,
    required DateTime occurredAt,
    required String recordedBy,
    FarmTask? task,
    FarmProtocol? protocol,
  }) {
    final uniqueSheepIds = sheepIds.toSet().toList(growable: false);
    if (uniqueSheepIds.isEmpty) {
      throw ArgumentError.value(sheepIds, 'sheepIds', 'Cannot be empty');
    }
    if (task != null &&
        (task.targetGroupId != groupId ||
            task.action != action ||
            !task.sheepIds.toSet().containsAll(uniqueSheepIds) ||
            !uniqueSheepIds.toSet().containsAll(task.sheepIds))) {
      throw ArgumentError('Task does not match the selected group action.');
    }

    final events = <FarmEvent>[];
    FarmTask? completedTask;
    FarmTask? nextTask;
    if (task != null) {
      final completion =
          CompleteFarmTask(
            taskRepository: taskRepository,
            eventRepository: eventRepository,
            createId: createId,
          )(
            task: task,
            completedAt: occurredAt,
            completedBy: recordedBy,
            protocol: protocol,
          );
      completedTask = completion.completedTask;
      nextTask = completion.nextTask;
      events.addAll(completion.createdEvents);
    } else {
      for (final sheepId in uniqueSheepIds) {
        final event = AnimalActionEvent(
          id: createId(),
          sheepId: sheepId,
          occurredAt: occurredAt,
          recordedBy: recordedBy,
          action: action,
        );
        eventRepository.saveEvent(event);
        events.add(event);
      }
    }

    final receipt = BulkUndoReceipt(
      id: createId(),
      createdEventIds: List.unmodifiable(events.map((event) => event.id)),
      completedTaskBefore: task,
      createdNextTaskId: nextTask?.id,
    );
    return BulkActionResult(
      events: List.unmodifiable(events),
      task: completedTask,
      nextTask: nextTask,
      undoReceipt: receipt,
    );
  }
}

void revertBulkAction({
  required BulkUndoReceipt receipt,
  required FarmTaskRepository taskRepository,
  required CareEventRepository eventRepository,
}) {
  final events = eventRepository.getEvents();
  final existingEventIds = events.map((event) => event.id).toSet();
  if (!receipt.createdEventIds.every(existingEventIds.contains)) {
    throw StateError('Bulk action can no longer be undone safely.');
  }
  final previousTask = receipt.completedTaskBefore;
  if (previousTask != null) {
    FarmTask? current;
    for (final task in taskRepository.getFarmTasks()) {
      if (task.id == previousTask.id) {
        current = task;
        break;
      }
    }
    if (current == null || current.status != FarmTaskStatus.completed) {
      throw StateError('Task changed since the bulk action; undo is unsafe.');
    }
  }
  final nextTaskId = receipt.createdNextTaskId;
  if (nextTaskId != null) {
    FarmTask? nextTask;
    for (final task in taskRepository.getFarmTasks()) {
      if (task.id == nextTaskId) {
        nextTask = task;
        break;
      }
    }
    if (nextTask == null || nextTask.status != FarmTaskStatus.pending) {
      throw StateError(
        'Recurring task changed since the bulk action; undo is unsafe.',
      );
    }
  }

  eventRepository.removeEvents(receipt.createdEventIds);
  if (previousTask != null) taskRepository.saveFarmTask(previousTask);
  if (nextTaskId != null) taskRepository.removeFarmTask(nextTaskId);
}
