import '../../../core/errors/repository_exception.dart';
import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/care_repositories.dart';
import '../domain/sheep_record.dart';
import '../domain/sheep_directory_repository.dart';

/// Result of an identity update, including the audit events that were created.
class UpdateSheepResult {
  const UpdateSheepResult({required this.sheep, required this.auditEvents});

  final SheepRecord sheep;
  final List<IdentityChangeEvent> auditEvents;
}

/// Updates a sheep's identity through a use case and records an audit event
/// when an important identity field changes.
///
/// Widgets must not call the directory repository directly; they go through
/// this use case (via the SheepDirectoryController).
class UpdateSheepUseCase {
  const UpdateSheepUseCase({
    required this.repository,
    required this.eventRepository,
    required this.createId,
  });

  final SheepDirectoryRepository repository;
  final CareEventRepository eventRepository;
  final String Function() createId;

  UpdateSheepResult call({
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
    final updated = current.copyWith(
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
    );

    if (updated.tagNumber != current.tagNumber) {
      final existing = repository.findByTagNumber(updated.tagNumber);
      if (existing != null && existing.id != current.id) {
        throw DuplicateSheepTagException(current.id, updated.tagNumber);
      }
    }

    repository.update(updated);

    final auditEvents = <IdentityChangeEvent>[];
    _audit(current, updated, 'tag', occurredAt, recordedBy, auditEvents);
    _audit(current, updated, 'breed', occurredAt, recordedBy, auditEvents);
    _audit(current, updated, 'group', occurredAt, recordedBy, auditEvents);

    return UpdateSheepResult(sheep: updated, auditEvents: auditEvents);
  }

  void _audit(
    SheepRecord before,
    SheepRecord after,
    String field,
    DateTime occurredAt,
    String recordedBy,
    List<IdentityChangeEvent> auditEvents,
  ) {
    final oldValue = _value(before, field);
    final newValue = _value(after, field);
    if (oldValue == newValue) return;
    final event = IdentityChangeEvent(
      id: createId(),
      sheepId: after.id,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      field: field,
      oldValue: oldValue,
      newValue: newValue,
    );
    eventRepository.saveEvent(event);
    auditEvents.add(event);
  }

  static String _value(SheepRecord sheep, String field) => switch (field) {
    'tag' => sheep.tagNumber,
    'breed' => sheep.breed,
    'group' => sheep.groupName,
    _ => '',
  };
}
