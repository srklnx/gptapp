import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'in_memory_repositories.dart';
import 'repository_contracts.dart';

final sheepRepositoryProvider = Provider<SheepRepository>(
  (ref) => InMemorySheepRepository(),
);
final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => InMemoryGroupRepository(),
);
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => InMemoryTaskRepository(),
);
final treatmentRepositoryProvider = Provider<TreatmentRepository>(
  (ref) => InMemoryTreatmentRepository(),
);
final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => InMemoryEventRepository(),
);
final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => InMemorySyncRepository(),
);
