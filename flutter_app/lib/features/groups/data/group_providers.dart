import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quick_log/data/care_providers.dart';
import '../../sheep/data/sheep_providers.dart';
import '../../sheep/domain/sheep_record.dart';
import '../../tasks/domain/farm_task.dart';
import '../domain/group_record.dart';

String groupIdForName(String name) => name
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
    .replaceAll(RegExp(r'^-|-$'), '');

final flockGroupsProvider = Provider<List<FlockGroup>>((ref) {
  final sheep = ref.watch(sheepRecordsProvider);
  final care = ref.watch(careProvider);
  final groups = <String, List<SheepRecord>>{};
  for (final animal in sheep) {
    groups.putIfAbsent(animal.groupName, () => []).add(animal);
  }
  final result = groups.entries.map((entry) {
    final groupId = groupIdForName(entry.key);
    FarmTask? activeTask;
    for (final task in care.farmTasks) {
      if (task.targetGroupId == groupId &&
          (task.status == FarmTaskStatus.pending ||
              task.status == FarmTaskStatus.inProgress)) {
        activeTask = task;
        break;
      }
    }
    final animals = entry.value;
    final groupStatus =
        animals.any(
          (animal) => care.statusFor(animal) == SheepHealthStatus.urgent,
        )
        ? GroupStatus.urgent
        : animals.any(
            (animal) =>
                care.statusFor(animal) == SheepHealthStatus.attention ||
                care.statusFor(animal) == SheepHealthStatus.withdrawal,
          )
        ? GroupStatus.attention
        : GroupStatus.normal;
    return FlockGroup(
      id: groupId,
      name: entry.key,
      location: animals.first.location,
      sheep: animals,
      currentTask: activeTask?.title,
      status: groupStatus,
    );
  }).toList()..sort((a, b) => a.name.compareTo(b.name));
  return List.unmodifiable(result);
});

final flockGroupByIdProvider = Provider.family<FlockGroup?, String>((ref, id) {
  for (final group in ref.watch(flockGroupsProvider)) {
    if (group.id == id) return group;
  }
  return null;
});

final savedViewSheepProvider = Provider.family<List<SheepRecord>, SavedView>((
  ref,
  view,
) {
  final care = ref.watch(careProvider);
  return evaluateSavedView(
    ref.watch(sheepRecordsProvider),
    view,
    sheepInWithdrawal: care.sheepInWithdrawal,
    now: care.asOf,
  );
});
