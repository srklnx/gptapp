import '../domain/sheep_directory_repository.dart';
import '../domain/sheep_record.dart';

class MockSheepDirectoryRepository implements SheepDirectoryRepository {
  MockSheepDirectoryRepository() : _sheep = _build();

  final List<SheepRecord> _sheep;

  @override
  List<SheepRecord> getAll() => List.unmodifiable(_sheep);

  @override
  SheepRecord? getById(String id) {
    for (final sheep in _sheep) {
      if (sheep.id == id) return sheep;
    }
    return null;
  }

  @override
  void add(SheepRecord sheep) {
    if (_sheep.any((record) => record.tagNumber == sheep.tagNumber)) {
      throw StateError('A sheep with this tag already exists.');
    }
    _sheep.add(sheep);
  }

  @override
  void update(SheepRecord sheep) {
    final index = _sheep.indexWhere((record) => record.id == sheep.id);
    if (index == -1) {
      throw StateError('Sheep not found.');
    }
    _sheep[index] = sheep;
  }

  @override
  SheepRecord? findByTagNumber(String tagNumber) {
    for (final sheep in _sheep) {
      if (sheep.tagNumber == tagNumber) return sheep;
    }
    return null;
  }

  static List<SheepRecord> _build() {
    final records = <SheepRecord>[
      SheepRecord(
        id: '184',
        tagNumber: '184',
        breed: 'Awassi',
        sex: SheepSex.ewe,
        weightKg: 62.4,
        bcs: 2.5,
        status: SheepHealthStatus.attention,
        nextRoutine: 'Vaccination · 3 days',
        groupName: 'Pregnant Ewes',
        birthDate: DateTime(2023, 3, 14),
        location: 'North Pasture',
        pregnant: true,
        activities: [
          SheepActivity(DateTime(2026, 9, 30), 'BCS recorded · 2.5', 'Ahmed'),
          SheepActivity(
            DateTime(2026, 9, 20),
            'Weight recorded · 62.4 kg',
            'Ahmed',
          ),
          SheepActivity(DateTime(2026, 9, 8), 'Mating · Karakul #R12', 'Ahmed'),
          SheepActivity(
            DateTime(2026, 8, 12),
            'Vaccination · Clostridial',
            'Sara',
          ),
        ],
      ),
      SheepRecord(
        id: '209',
        tagNumber: '209',
        breed: 'Awassi',
        sex: SheepSex.ewe,
        weightKg: 68.1,
        bcs: 3.0,
        status: SheepHealthStatus.attention,
        nextRoutine: 'Deworming · 12 days',
        groupName: 'Pregnant Ewes',
        birthDate: DateTime(2022, 11, 2),
        location: 'North Pasture',
        pregnant: true,
        activities: const [],
      ),
      SheepRecord(
        id: '311',
        tagNumber: '311',
        breed: 'Najdi',
        sex: SheepSex.ram,
        weightKg: 83.2,
        bcs: 3.5,
        status: SheepHealthStatus.healthy,
        nextRoutine: 'Weight check · 12 Oct',
        groupName: 'Rams',
        birthDate: DateTime(2021, 1, 20),
        location: 'East Paddock',
        activities: const [],
      ),
      SheepRecord(
        id: '472',
        tagNumber: '472',
        breed: 'Awassi',
        sex: SheepSex.lamb,
        weightKg: 29.7,
        bcs: 2.0,
        status: SheepHealthStatus.attention,
        nextRoutine: 'BCS check due',
        groupName: 'Lambs · Group B',
        birthDate: DateTime(2026, 3, 9),
        location: 'Lambing Barn',
        activities: const [],
      ),
    ];
    const breeds = ['Awassi', 'Najdi', 'Naimi', 'Suffolk'];
    const groups = [
      'Pregnant Ewes',
      'Dry Ewes',
      'Lambs · Group B',
      'Rams',
      'North Flock',
    ];
    const routines = [
      'Deworming · 12 days',
      'Hoof trim · 2 weeks',
      'Healthy · no routine due',
      'Vaccination · 3 days',
      'Weight check · 12 Oct',
    ];
    for (var i = 5; i <= 30; i++) {
      final isLamb = i % 5 == 0;
      final isRam = !isLamb && i % 6 == 0;
      final sex = isLamb
          ? SheepSex.lamb
          : isRam
          ? SheepSex.ram
          : SheepSex.ewe;
      final status = switch (i % 9) {
        0 => SheepHealthStatus.urgent,
        1 || 4 => SheepHealthStatus.attention,
        2 => SheepHealthStatus.healthy,
        _ => SheepHealthStatus.healthy,
      };
      records.add(
        SheepRecord(
          id: '${100 + i}',
          tagNumber: '${100 + i}',
          breed: breeds[i % breeds.length],
          sex: sex,
          weightKg: isLamb ? 25 + (i % 12) * 1.8 : 48 + (i % 19) * 1.7,
          bcs: [2.0, 2.5, 3.0, 3.5][i % 4],
          status: status,
          nextRoutine: routines[i % routines.length],
          groupName: groups[i % groups.length],
          birthDate: isLamb
              ? DateTime(2026, 2 + i % 5, 4 + i % 20)
              : DateTime(2021 + i % 5, 1 + i % 11, 3 + i % 24),
          location: i.isEven ? 'North Pasture' : 'South Pasture',
          pregnant: sex == SheepSex.ewe && i % 3 == 0,
          activities: const [],
        ),
      );
    }
    return records;
  }
}
