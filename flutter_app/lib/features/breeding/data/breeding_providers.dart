import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/entities.dart' show SyncOperation;
import '../../sheep/data/mock_sheep_directory_repository.dart';
import '../../sync/data/sync_providers.dart';
import '../../quick_log/data/care_providers.dart';
import '../domain/breeding_record.dart';

final breedingRepositoryProvider = Provider<InMemoryBreedingRepository>(
  (ref) => InMemoryBreedingRepository(),
);

class InMemoryBreedingRepository {
  InMemoryBreedingRepository({Map<String, Object?>? initialData, this.persist})
    : _records = initialData == null
          ? _seedRecords()
          : _decodeRecords(initialData);

  final void Function(Map<String, Object?> snapshot)? persist;
  final List<BreedingRecord> _records;

  List<BreedingRecord> getRecords() =>
      List.unmodifiable(_records..sort(_byExpectedDate));

  BreedingRecord? bySheepId(String sheepId) {
    for (final record in _records) {
      if (record.sheepId == sheepId) return record;
    }
    return null;
  }

  void save(BreedingRecord record) {
    final index = _records.indexWhere((existing) => existing.id == record.id);
    if (index < 0) {
      _records.add(record);
    } else {
      _records[index] = record;
    }
    _persist();
  }

  Map<String, Object?> toSnapshot() => {
    'records': [
      for (final record in _records)
        {
          'id': record.id,
          'sheepId': record.sheepId,
          'matingDate': record.matingDate?.toIso8601String(),
          'ramTag': record.ramTag,
          'expectedLambingDate': record.expectedLambingDate?.toIso8601String(),
          'pregnancyStatus': record.pregnancyStatus.name,
          'lambingHistory': [
            for (final lambing in record.lambingHistory)
              {
                'date': lambing.date.toIso8601String(),
                'lambCount': lambing.lambCount,
                'notes': lambing.notes,
              },
          ],
          'createdAt': record.createdAt.toIso8601String(),
          'updatedAt': record.updatedAt.toIso8601String(),
        },
    ],
  };

  void _persist() => persist?.call(toSnapshot());

  static int _byExpectedDate(BreedingRecord a, BreedingRecord b) {
    final aDate = a.expectedLambingDate ?? DateTime(9999);
    final bDate = b.expectedLambingDate ?? DateTime(9999);
    return aDate.compareTo(bDate);
  }

  static List<BreedingRecord> _seedRecords() {
    final now = DateTime.now();
    return MockSheepDirectoryRepository()
        .getAll()
        .where((sheep) => sheep.pregnant)
        .map((sheep) {
          final matingDate = sheep.id == '184'
              ? DateTime(2026, 9, 8)
              : DateTime(2026, 9, 15);
          return BreedingRecord(
            id: 'breeding-${sheep.id}',
            sheepId: sheep.id,
            matingDate: matingDate,
            ramTag: sheep.id == '184' ? 'R12' : 'R08',
            expectedLambingDate: matingDate.add(const Duration(days: 147)),
            pregnancyStatus: PregnancyStatus.confirmed,
            createdAt: matingDate,
            updatedAt: now,
          );
        })
        .toList();
  }

  static List<BreedingRecord> _decodeRecords(Map<String, Object?> snapshot) =>
      (snapshot['records'] as List<Object?>).map((encoded) {
        final map = (encoded as Map).cast<String, Object?>();
        DateTime? date(String key) =>
            map[key] == null ? null : DateTime.parse(map[key]! as String);
        return BreedingRecord(
          id: map['id'] as String,
          sheepId: map['sheepId'] as String,
          matingDate: date('matingDate'),
          ramTag: map['ramTag'] as String?,
          expectedLambingDate: date('expectedLambingDate'),
          pregnancyStatus: PregnancyStatus.values.byName(
            map['pregnancyStatus'] as String,
          ),
          lambingHistory: (map['lambingHistory'] as List<Object?>).map((
            encodedLambing,
          ) {
            final lambing = (encodedLambing as Map).cast<String, Object?>();
            return LambingRecord(
              date: DateTime.parse(lambing['date'] as String),
              lambCount: lambing['lambCount'] as int,
              notes: lambing['notes'] as String,
            );
          }),
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
      }).toList();
}

class BreedingController extends Notifier<List<BreedingRecord>> {
  late InMemoryBreedingRepository _repository;
  var _idCounter = 0;

  @override
  List<BreedingRecord> build() {
    _repository = ref.watch(breedingRepositoryProvider);
    return _repository.getRecords();
  }

  BreedingRecord recordMating({
    required String sheepId,
    required DateTime matingDate,
    required String ramTag,
    int gestationDays = 147,
  }) {
    if (ramTag.trim().isEmpty || gestationDays <= 0) {
      throw ArgumentError(
        'Ram identification and positive gestation are required.',
      );
    }
    final now = DateTime.now();
    final current = _repository.bySheepId(sheepId);
    final record = current == null
        ? BreedingRecord(
            id: 'breeding-${now.microsecondsSinceEpoch}-${_idCounter++}',
            sheepId: sheepId,
            matingDate: matingDate,
            ramTag: ramTag.trim(),
            expectedLambingDate: matingDate.add(Duration(days: gestationDays)),
            pregnancyStatus: PregnancyStatus.unknown,
            createdAt: now,
            updatedAt: now,
          )
        : current.copyWith(
            matingDate: matingDate,
            ramTag: ramTag.trim(),
            expectedLambingDate: matingDate.add(Duration(days: gestationDays)),
            pregnancyStatus: PregnancyStatus.unknown,
            updatedAt: now,
          );
    _save(record, 'mating');
    return record;
  }

  BreedingRecord updatePregnancy(String sheepId, PregnancyStatus status) {
    final now = DateTime.now();
    final current = _repository.bySheepId(sheepId);
    final record = current == null
        ? BreedingRecord(
            id: 'breeding-${now.microsecondsSinceEpoch}-${_idCounter++}',
            sheepId: sheepId,
            pregnancyStatus: status,
            createdAt: now,
            updatedAt: now,
          )
        : current.copyWith(pregnancyStatus: status, updatedAt: now);
    _save(record, 'pregnancy');
    return record;
  }

  BreedingRecord recordLambing({
    required String sheepId,
    required DateTime date,
    required int lambCount,
    String notes = '',
  }) {
    if (lambCount < 1) {
      throw ArgumentError.value(lambCount, 'lambCount', 'Must be positive.');
    }
    final now = DateTime.now();
    final current = _repository.bySheepId(sheepId);
    final base =
        current ??
        BreedingRecord(
          id: 'breeding-${now.microsecondsSinceEpoch}-${_idCounter++}',
          sheepId: sheepId,
          pregnancyStatus: PregnancyStatus.lambed,
          createdAt: now,
          updatedAt: now,
        );
    final record = base.copyWith(
      pregnancyStatus: PregnancyStatus.lambed,
      lambingHistory: [
        ...base.lambingHistory,
        LambingRecord(date: date, lambCount: lambCount, notes: notes),
      ],
      updatedAt: now,
    );
    _save(record, 'lambing');
    return record;
  }

  void _save(BreedingRecord record, String mutation) {
    _repository.save(record);
    ref
        .read(careProvider.notifier)
        .recordAction(
          sheepId: record.sheepId,
          action: switch (mutation) {
            'mating' => 'Mating',
            'pregnancy' => 'Pregnancy ${record.pregnancyStatus.name}',
            'lambing' => 'Lambing',
            _ => mutation,
          },
          occurredAt: record.updatedAt,
          recordedBy: 'Ahmed',
        );
    ref
        .read(syncCenterProvider.notifier)
        .enqueue(
          entityType: 'Breeding',
          entityId: record.id,
          operation: SyncOperation.update,
          idempotencyKey:
              'breeding:${record.id}:${record.updatedAt.microsecondsSinceEpoch}:$mutation',
          payload: {
            'sheepId': record.sheepId,
            'matingDate': record.matingDate?.toIso8601String(),
            'ramTag': record.ramTag,
            'expectedLambingDate': record.expectedLambingDate
                ?.toIso8601String(),
            'pregnancyStatus': record.pregnancyStatus.name,
            'lambingHistory': [
              for (final lambing in record.lambingHistory)
                {
                  'date': lambing.date.toIso8601String(),
                  'lambCount': lambing.lambCount,
                  'notes': lambing.notes,
                },
            ],
          },
        );
    state = _repository.getRecords();
  }
}

final breedingProvider =
    NotifierProvider<BreedingController, List<BreedingRecord>>(
      BreedingController.new,
    );
