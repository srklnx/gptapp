import '../../sheep/domain/sheep_record.dart';

enum FlockFilter {
  all,
  ewes,
  rams,
  lambs,
  pregnant,
  sick,
  withdrawal,
  dueToday,
  dueVaccination,
  dueDeworming,
  lowBcs,
  eidCandidates,
}

List<SheepRecord> filterSheep(
  Iterable<SheepRecord> records, {
  required String query,
  required FlockFilter filter,
  Set<String> sheepInWithdrawal = const {},
}) {
  final normalized = query.trim().toLowerCase();
  return List.unmodifiable(
    records.where((sheep) {
      final matchesQuery =
          normalized.isEmpty ||
          sheep.tagNumber.toLowerCase().contains(normalized) ||
          sheep.breed.toLowerCase().contains(normalized) ||
          sheep.groupName.toLowerCase().contains(normalized) ||
          (sheep.name?.toLowerCase().contains(normalized) ?? false) ||
          (sheep.eidRfid?.toLowerCase().contains(normalized) ?? false);
      if (!matchesQuery) return false;
      return switch (filter) {
        FlockFilter.all => true,
        FlockFilter.ewes => sheep.sex == SheepSex.ewe,
        FlockFilter.rams => sheep.sex == SheepSex.ram,
        FlockFilter.lambs => sheep.sex == SheepSex.lamb,
        FlockFilter.pregnant => sheep.pregnant,
        FlockFilter.sick =>
          sheep.status == SheepHealthStatus.urgent ||
              sheep.status == SheepHealthStatus.attention,
        FlockFilter.withdrawal => sheepInWithdrawal.contains(sheep.id),
        FlockFilter.dueToday => sheep.nextRoutine.toLowerCase().contains('due'),
        FlockFilter.dueVaccination => sheep.nextRoutine.toLowerCase().contains(
          'vaccination',
        ),
        FlockFilter.dueDeworming => sheep.nextRoutine.toLowerCase().contains(
          'deworming',
        ),
        FlockFilter.lowBcs => sheep.bcs <= 2.0,
        FlockFilter.eidCandidates =>
          sheep.weightKg >= 45 &&
              sheep.bcs >= 2.5 &&
              sheep.status == SheepHealthStatus.healthy &&
              !sheepInWithdrawal.contains(sheep.id),
      };
    }),
  );
}
