import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../domain/farm_task.dart';
import 'task_card.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final tasks = ref.watch(
      careProvider.select((careState) => careState.farmTasks),
    );
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final todayTasks = tasks.where(
      (task) =>
          (task.status == FarmTaskStatus.pending ||
              task.status == FarmTaskStatus.inProgress) &&
          task.dueAt.isBefore(tomorrow),
    );
    final upcoming = tasks.where(
      (task) =>
          (task.status == FarmTaskStatus.pending ||
              task.status == FarmTaskStatus.inProgress) &&
          !task.dueAt.isBefore(tomorrow),
    );
    final completed = tasks.where(
      (task) =>
          task.status == FarmTaskStatus.completed ||
          task.status == FarmTaskStatus.skipped ||
          task.status == FarmTaskStatus.cancelled,
    );
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).cardColor,
            child: TabBar(
              tabs: [
                Tab(text: strings.taskToday),
                Tab(text: strings.taskUpcoming),
                Tab(text: strings.taskCompleted),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _TaskList(key: const Key('tasks-today'), tasks: todayTasks),
                _TaskList(key: const Key('tasks-upcoming'), tasks: upcoming),
                _TaskList(key: const Key('tasks-completed'), tasks: completed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({required this.tasks, super.key});
  final Iterable<FarmTask> tasks;

  @override
  Widget build(BuildContext context) {
    final taskList = tasks.toList()..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final strings = AppLocalizations.of(context);
    if (taskList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(strings.taskEmpty),
        ),
      );
    }
    return ListView.builder(
      key: const Key('task-list'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        return FarmTaskCard(
          task: task,
          showActions:
              task.status != FarmTaskStatus.completed &&
              task.status != FarmTaskStatus.skipped &&
              task.status != FarmTaskStatus.cancelled,
        );
      },
    );
  }
}
