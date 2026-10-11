import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:herd_hub_sheep/app/app.dart';
import 'package:herd_hub_sheep/features/groups/domain/group_record.dart';
import 'package:herd_hub_sheep/features/quick_log/data/care_providers.dart';
import 'package:herd_hub_sheep/features/quick_log/data/in_memory_care_repository.dart';
import 'package:herd_hub_sheep/features/sheep/domain/sheep_record.dart';
import 'package:herd_hub_sheep/features/tasks/domain/bulk_action.dart';
import 'package:herd_hub_sheep/features/tasks/domain/complete_farm_task.dart';
import 'package:herd_hub_sheep/features/tasks/domain/farm_task.dart';

Future<void> pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(const ProviderScope(child: HerdHubApp()));
  await tester.pumpAndSettle();
}

Finder _verticalScrollables(Finder ancestor) => find.descendant(
  of: ancestor,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is Scrollable && widget.axisDirection == AxisDirection.down,
  ),
);

void main() {
  test('recurring task is due interval days after completion', () {
    final completedAt = DateTime(2026, 9, 30, 14);

    expect(
      TaskRecurrence.nextDueDate(
        lastCompletion: completedAt,
        intervalDays: 180,
      ),
      DateTime(2027, 3, 29, 14),
    );
  });

  test(
    'completing recurring task creates an event per sheep and next task',
    () {
      final repository = InMemoryCareRepository();
      final task = repository.getFarmTasks().singleWhere(
        (record) => record.id == 'task-pregnant-vaccination',
      );
      final protocol = repository.getProtocols().single;
      var counter = 0;

      final result =
          CompleteFarmTask(
            taskRepository: repository,
            eventRepository: repository,
            createId: () => 'complete-${counter++}',
          )(
            task: task,
            completedAt: DateTime(2026, 10, 1),
            completedBy: 'Ahmed',
            protocol: protocol,
          );

      expect(result.completedTask.status, FarmTaskStatus.completed);
      expect(result.createdEvents.length, task.sheepIds.length);
      expect(
        result.createdEvents.map((event) => event.sheepId).toSet(),
        task.sheepIds.toSet(),
      );
      expect(result.nextTask!.dueAt, DateTime(2027, 3, 30));
      expect(repository.getFarmTasks(), contains(result.nextTask));
    },
  );

  test('bulk action records distinct events and undo restores task safely', () {
    final repository = InMemoryCareRepository();
    final task = repository.getFarmTasks().singleWhere(
      (record) => record.id == 'task-pregnant-vaccination',
    );
    final protocol = repository.getProtocols().single;
    var counter = 0;
    final result =
        PerformBulkAction(
          taskRepository: repository,
          eventRepository: repository,
          createId: () => 'bulk-${counter++}',
        )(
          groupId: task.targetGroupId,
          sheepIds: task.sheepIds,
          action: task.action,
          task: task,
          protocol: protocol,
          occurredAt: DateTime(2026, 10, 1),
          recordedBy: 'Ahmed',
        );

    expect(result.events.length, task.sheepIds.length);
    expect(
      result.events.map((event) => event.sheepId).toSet(),
      task.sheepIds.toSet(),
    );
    expect(result.task!.status, FarmTaskStatus.completed);
    expect(result.nextTask, isNotNull);

    revertBulkAction(
      receipt: result.undoReceipt,
      taskRepository: repository,
      eventRepository: repository,
    );
    expect(
      repository.getEvents().where(
        (event) => result.undoReceipt.createdEventIds.contains(event.id),
      ),
      isEmpty,
    );
    expect(
      repository
          .getFarmTasks()
          .singleWhere((item) => item.id == task.id)
          .status,
      FarmTaskStatus.pending,
    );
    expect(
      repository.getFarmTasks().any((item) => item.id == result.nextTask!.id),
      isFalse,
    );
  });

  test('saved view uses current care state, not physical group membership', () {
    final sheep = [
      _sheep('1', weight: 60, bcs: 3, routine: 'Vaccination · 3 days'),
      _sheep('2', weight: 30, bcs: 1.5, routine: 'No routine due'),
    ];

    final result = evaluateSavedView(
      sheep,
      SavedView.dueVaccination,
      sheepInWithdrawal: const {},
      now: DateTime(2026, 9, 30),
    );

    expect(result.map((animal) => animal.id), ['1']);
  });

  testWidgets('Groups screen opens a group and undo reverses bulk action', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-flock')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open-groups')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('groups-list')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('group-card-pregnant-ewes')),
      220,
      scrollable: _verticalScrollables(find.byKey(const Key('groups-list')))
          .first,
    );
    await tester.ensureVisible(
      find.byKey(const Key('group-card-pregnant-ewes')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('group-card-pregnant-ewes')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('group-detail-pregnant-ewes')), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byKey(const Key('group-detail-pregnant-ewes'))),
    );
    final taskBefore = container
        .read(careProvider)
        .farmTasks
        .singleWhere((task) => task.id == 'task-pregnant-vaccination');
    final eventIdsBefore = container
        .read(careProvider)
        .events
        .map((event) => event.id)
        .toSet();
    await tester.tap(find.byKey(const Key('open-bulk-action')));
    await tester.pumpAndSettle();
    expect(
      find.text('Vaccinate ${taskBefore.sheepIds.length} Sheep'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('confirm-bulk-action')));
    await tester.pumpAndSettle();
    expect(
      find.text('${taskBefore.sheepIds.length} records saved'),
      findsOneWidget,
    );
    final after = container.read(careProvider);
    expect(
      after.events.where((event) => !eventIdsBefore.contains(event.id)).length,
      taskBefore.sheepIds.length,
    );
    expect(
      after.farmTasks.singleWhere((task) => task.id == taskBefore.id).status,
      FarmTaskStatus.completed,
    );

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(
      container
          .read(careProvider)
          .farmTasks
          .singleWhere((task) => task.id == taskBefore.id)
          .status,
      FarmTaskStatus.pending,
    );
    expect(
      container.read(careProvider).events.map((event) => event.id).toSet(),
      eventIdsBefore,
    );
  });

  testWidgets('Tasks screen has Today, Upcoming and Completed tabs', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.byKey(const Key('nav-tasks')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tasks-today')), findsOneWidget);
    expect(find.text('Vaccinate Pregnant Ewes'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.byKey(const Key('tasks-today'))),
    );
    final eventCountBefore = container.read(careProvider).events.length;
    await tester.tap(
      find.byKey(const Key('complete-task-task-pregnant-vaccination')),
    );
    await tester.pumpAndSettle();
    expect(
      container.read(careProvider).events.length - eventCountBefore,
      container
          .read(careProvider)
          .farmTasks
          .singleWhere((task) => task.id == 'task-pregnant-vaccination')
          .sheepIds
          .length,
    );
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tasks-upcoming')), findsOneWidget);
    expect(find.text('Vaccinate Pregnant Ewes'), findsOneWidget);
    await tester.tap(find.text('Completed'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('tasks-completed')), findsOneWidget);
    expect(find.text('Vaccinate Pregnant Ewes'), findsOneWidget);
  });
}

SheepRecord _sheep(
  String id, {
  required double weight,
  required double bcs,
  required String routine,
}) => SheepRecord(
  id: id,
  tagNumber: id,
  breed: 'Awassi',
  sex: SheepSex.ewe,
  weightKg: weight,
  bcs: bcs,
  status: SheepHealthStatus.healthy,
  nextRoutine: routine,
  groupName: 'Dry Ewes',
  birthDate: DateTime(2022, 1, 1),
  location: 'North Pasture',
  activities: const [],
);
