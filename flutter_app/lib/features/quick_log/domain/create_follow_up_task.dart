import '../../tasks/domain/farm_task.dart';
import 'care_repositories.dart';

/// Creates a follow-up task that shows in the Tasks screen and Home.
class CreateFollowUpTaskUseCase {
  const CreateFollowUpTaskUseCase({
    required this.repository,
    required this.createId,
  });

  final FarmTaskRepository repository;
  final String Function() createId;

  FarmTask call({
    required Iterable<String> sheepIds,
    required String title,
    required DateTime dueAt,
    DateTime? createdAt,
    TaskPriority priority = TaskPriority.normal,
    String? assignedTo,
    String notes = '',
    String? observationId,
  }) {
    final uniqueSheepIds = sheepIds.toSet().toList(growable: false);
    if (uniqueSheepIds.isEmpty) {
      throw ArgumentError.value(sheepIds, 'sheepIds', 'Cannot be empty');
    }
    final task = FarmTask(
      id: createId(),
      title: title,
      action: 'Follow-up',
      targetGroupId: observationId ?? uniqueSheepIds.first,
      sheepIds: uniqueSheepIds,
      dueAt: dueAt,
      createdAt: createdAt ?? DateTime.now(),
      priority: priority,
      assignedTo: assignedTo,
      notes: notes,
    );
    repository.saveFarmTask(task);
    return task;
  }
}
