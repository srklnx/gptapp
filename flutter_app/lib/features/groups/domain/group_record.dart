import '../../sheep/domain/sheep_record.dart';

class FlockGroup {
  FlockGroup({
    required this.id,
    required this.name,
    required this.location,
    required Iterable<SheepRecord> sheep,
    this.currentTask,
    this.status = GroupStatus.normal,
  }) : sheep = List.unmodifiable(sheep);

  final String id;
  final String name;
  final String location;
  final List<SheepRecord> sheep;
  final String? currentTask;
  final GroupStatus status;

  int get sheepCount => sheep.length;
  List<String> get sheepIds =>
      List.unmodifiable(sheep.map((record) => record.id));
}

enum GroupStatus { normal, attention, urgent }

enum SavedView { withdrawalActive, lowBcs, dueVaccination, eidCandidates }

List<SheepRecord> evaluateSavedView(
  Iterable<SheepRecord> sheep,
  SavedView view, {
  required Set<String> sheepInWithdrawal,
  required DateTime now,
}) {
  final filtered = sheep.where((animal) {
    return switch (view) {
      SavedView.withdrawalActive => sheepInWithdrawal.contains(animal.id),
      SavedView.lowBcs => animal.bcs <= 2.0,
      SavedView.dueVaccination => animal.nextRoutine.toLowerCase().contains(
        'vaccination',
      ),
      SavedView.eidCandidates =>
        animal.weightKg >= 45 &&
            animal.bcs >= 2.5 &&
            animal.status == SheepHealthStatus.healthy &&
            !sheepInWithdrawal.contains(animal.id) &&
            animal.birthDate.isBefore(now),
    };
  });
  return List.unmodifiable(filtered);
}
