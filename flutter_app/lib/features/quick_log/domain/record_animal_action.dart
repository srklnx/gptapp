import 'care_records.dart';
import 'care_repositories.dart';

class RecordAnimalAction {
  const RecordAnimalAction({required this.repository, required this.createId});

  final CareRepository repository;
  final String Function() createId;

  FarmEvent call({
    required String sheepId,
    required String action,
    required DateTime occurredAt,
    required String recordedBy,
    double? value,
    String notes = '',
  }) {
    final FarmEvent event = switch (action) {
      'Weight' when value != null => WeightEvent(
        id: createId(),
        sheepId: sheepId,
        occurredAt: occurredAt,
        recordedBy: recordedBy,
        weightKg: value,
      ),
      'BCS' when value != null => BcsEvent(
        id: createId(),
        sheepId: sheepId,
        occurredAt: occurredAt,
        recordedBy: recordedBy,
        score: value,
      ),
      _ => AnimalActionEvent(
        id: createId(),
        sheepId: sheepId,
        occurredAt: occurredAt,
        recordedBy: recordedBy,
        action: action,
        notes: notes,
      ),
    };
    repository.saveEvent(event);
    return event;
  }
}
