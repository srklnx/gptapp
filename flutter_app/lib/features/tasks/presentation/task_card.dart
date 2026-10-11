import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../groups/data/group_providers.dart';
import '../../quick_log/data/care_providers.dart';
import '../domain/farm_task.dart';

class FarmTaskCard extends ConsumerWidget {
  const FarmTaskCard({required this.task, this.showActions = true, super.key});

  final FarmTask task;
  final bool showActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final care = ref.read(careProvider.notifier);
    final farmTasks = ref.watch(
      careProvider.select((careState) => careState.farmTasks),
    );
    String? groupName;
    for (final group in ref.watch(flockGroupsProvider)) {
      if (group.id == task.targetGroupId) {
        groupName = group.name;
        break;
      }
    }
    final terminal =
        task.status == FarmTaskStatus.completed ||
        task.status == FarmTaskStatus.skipped ||
        task.status == FarmTaskStatus.cancelled;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _localizedTaskTitle(strings, task.title),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                _TaskStatusLabel(status: task.status),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              LocaleFormatters.textForContext(
                context,
                strings.groupCount(task.sheepIds.length),
              ),
            ),
            if (groupName != null)
              Text(_localizedGroupName(strings, groupName)),
            Text(LocaleFormatters.dateForContext(context, task.dueAt)),
            if (showActions && !terminal) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  if (task.status == FarmTaskStatus.pending)
                    OutlinedButton(
                      key: Key('start-task-${task.id}'),
                      onPressed: () => care.updateTaskStatus(
                        task,
                        FarmTaskStatus.inProgress,
                      ),
                      child: Text(strings.taskStart),
                    ),
                  FilledButton(
                    key: Key('complete-task-${task.id}'),
                    onPressed: () => care.completeTask(
                      task: task,
                      completedAt: DateTime.now(),
                      completedBy: 'Ahmed',
                    ),
                    child: Text(strings.taskComplete),
                  ),
                  TextButton(
                    key: Key('skip-task-${task.id}'),
                    onPressed: () =>
                        care.updateTaskStatus(task, FarmTaskStatus.skipped),
                    child: Text(strings.taskSkip),
                  ),
                ],
              ),
            ],
            if (task.status == FarmTaskStatus.completed &&
                task.protocolId != null &&
                farmTasks.any(
                  (next) =>
                      next.protocolId == task.protocolId &&
                      next.dueAt.isAfter(task.dueAt) &&
                      next.status == FarmTaskStatus.pending,
                ))
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  strings.nextTaskDue(
                    LocaleFormatters.dateForContext(
                      context,
                      farmTasks
                          .where(
                            (next) =>
                                next.protocolId == task.protocolId &&
                                next.dueAt.isAfter(task.dueAt) &&
                                next.status == FarmTaskStatus.pending,
                          )
                          .reduce((a, b) => a.dueAt.isBefore(b.dueAt) ? a : b)
                          .dueAt,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _localizedTaskTitle(AppLocalizations strings, String title) =>
      switch (title) {
        'Vaccinate Pregnant Ewes' => strings.farmTaskVaccinate,
        'Check Water' => strings.taskCheckWater,
        'Weigh Lambs' => strings.taskWeighLambs,
        'BCS Check' => strings.taskBcsCheck,
        'Recheck heat stress' => strings.recheckInThirty,
        _ => title,
      };

  String _localizedGroupName(AppLocalizations strings, String name) =>
      switch (name) {
        'Pregnant Ewes' => strings.pregnantEwes,
        'North Pasture' => strings.northPasture,
        'Group B' => strings.groupB,
        'Rams' => strings.rams,
        'Lambs' => strings.lambs,
        _ => name,
      };
}

class _TaskStatusLabel extends StatelessWidget {
  const _TaskStatusLabel({required this.status});
  final FarmTaskStatus status;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final label = switch (status) {
      FarmTaskStatus.pending => strings.taskPending,
      FarmTaskStatus.inProgress => strings.taskInProgress,
      FarmTaskStatus.completed => strings.taskCompleted,
      FarmTaskStatus.skipped => strings.taskSkipped,
      FarmTaskStatus.cancelled => strings.taskCancelled,
    };
    return Chip(label: Text(label), visualDensity: VisualDensity.compact);
  }
}
