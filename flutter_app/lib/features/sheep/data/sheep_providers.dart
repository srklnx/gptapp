import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/repository_exception.dart';
import '../../../core/models/entities.dart' show SyncOperation;
import '../../quick_log/data/care_providers.dart';
import '../../sync/data/sync_providers.dart';
import '../domain/sheep_directory_repository.dart';
import '../domain/sheep_record.dart';
import '../domain/update_sheep.dart';
import 'mock_sheep_directory_repository.dart';

final sheepDirectoryRepositoryProvider = Provider<SheepDirectoryRepository>(
  (ref) => MockSheepDirectoryRepository(),
);

final sheepDirectoryControllerProvider =
    NotifierProvider<SheepDirectoryController, List<SheepRecord>>(
      SheepDirectoryController.new,
    );

final sheepRecordsProvider = Provider<List<SheepRecord>>(
  (ref) => ref.watch(sheepDirectoryControllerProvider),
);

final sheepByIdProvider = Provider.family<SheepRecord?, String>((ref, id) {
  for (final sheep in ref.watch(sheepDirectoryControllerProvider)) {
    if (sheep.id == id) return sheep;
  }
  return null;
});

class SheepDirectoryController extends Notifier<List<SheepRecord>> {
  late SheepDirectoryRepository _repository;
  var _idCounter = 0;

  @override
  List<SheepRecord> build() {
    _repository = ref.watch(sheepDirectoryRepositoryProvider);
    return _repository.getAll();
  }

  void add(SheepRecord sheep) {
    _repository.add(sheep);
    state = _repository.getAll();
  }

  void update(SheepRecord sheep) {
    final existing = _repository.findByTagNumber(sheep.tagNumber);
    if (existing != null && existing.id != sheep.id) {
      throw DuplicateSheepTagException(sheep.id, sheep.tagNumber);
    }
    _repository.update(sheep);
    state = _repository.getAll();
  }

  /// Applies an identity edit through [UpdateSheepUseCase] and records audit
  /// events for important changes.
  SheepRecord updateSheep({
    required SheepRecord current,
    required String tagNumber,
    required String? name,
    required String? eidRfid,
    required SheepSex sex,
    required String breed,
    required DateTime? birthDate,
    required bool birthDateUnknown,
    required String? color,
    required String? markings,
    required String groupName,
    required String? source,
    required DateTime? purchaseDate,
    required double? purchasePrice,
    required String notes,
    required DateTime occurredAt,
    required String recordedBy,
  }) {
    final eventRepository = ref.read(careRepositoryProvider);
    final result = UpdateSheepUseCase(
      repository: _repository,
      eventRepository: eventRepository,
      createId: _newId,
    )(
      current: current,
      tagNumber: tagNumber,
      name: name,
      eidRfid: eidRfid,
      sex: sex,
      breed: breed,
      birthDate: birthDate,
      birthDateUnknown: birthDateUnknown,
      color: color,
      markings: markings,
      groupName: groupName,
      source: source,
      purchaseDate: purchaseDate,
      purchasePrice: purchasePrice,
      notes: notes,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
    );
    final sync = ref.read(syncCenterProvider.notifier);
    sync.enqueue(
      entityType: 'Sheep',
      entityId: result.sheep.id,
      operation: SyncOperation.update,
      idempotencyKey:
          'sheep:${result.sheep.id}:update:${occurredAt.microsecondsSinceEpoch}',
      payload: {
        'tagNumber': result.sheep.tagNumber,
        'name': result.sheep.name,
        'eidRfid': result.sheep.eidRfid,
        'breed': result.sheep.breed,
        'groupName': result.sheep.groupName,
      },
    );
    final care = ref.read(careProvider.notifier);
    for (final event in result.auditEvents) {
      care.enqueueExistingEvent(event);
    }
    state = _repository.getAll();
    return result.sheep;
  }

  String _newId() =>
      'sheep-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
}
