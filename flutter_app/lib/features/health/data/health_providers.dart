import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quick_log/data/care_providers.dart';
import '../domain/health_case.dart';
import '../domain/health_observation.dart';
import 'health_case_providers.dart';

/// In-memory, persistable store for health observations.
class InMemoryHealthObservationRepository {
  InMemoryHealthObservationRepository({
    Map<String, Object?>? initialData,
    this.persist,
  }) : _observations = initialData == null
           ? <HealthObservation>[]
           : _decode(initialData);

  final void Function(Map<String, Object?> snapshot)? persist;
  final List<HealthObservation> _observations;

  List<HealthObservation> getAll() => List.unmodifiable(_observations);

  List<HealthObservation> forSheep(String sheepId) => List.unmodifiable(
    _observations.where((observation) => observation.sheepIds.contains(sheepId)),
  );

  void save(HealthObservation observation) {
    _observations.add(observation);
    _persist();
  }

  Map<String, Object?> toSnapshot() => {
    'observations': _observations.map(_toJson).toList(),
  };

  void _persist() => persist?.call(toSnapshot());

  static Map<String, Object?> _toJson(HealthObservation item) => {
    'id': item.id,
    'targetScope': item.targetScope.name,
    'sheepIds': item.sheepIds,
    'symptomIds': item.symptomIds,
    'answers': item.answers.map(
      (key, value) => MapEntry(key, value),
    ),
    'severity': item.severity.name,
    'occurredAt': item.occurredAt.toIso8601String(),
    'recordedBy': item.recordedBy,
    'notes': item.notes,
  };

  static List<HealthObservation> _decode(Map<String, Object?> snapshot) =>
      (snapshot['observations'] as List<Object?>).map((encoded) {
        final map = (encoded as Map).cast<String, Object?>();
        final answers = <String, List<String>>{};
        for (final entry in (map['answers'] as Map).entries) {
          answers[entry.key as String] =
              (entry.value as List<Object?>).cast<String>();
        }
        return HealthObservation(
          id: map['id'] as String,
          targetScope: HealthTargetScope.values.byName(
            map['targetScope'] as String,
          ),
          sheepIds: (map['sheepIds'] as List<Object?>).cast<String>(),
          symptomIds: (map['symptomIds'] as List<Object?>).cast<String>(),
          answers: answers,
          severity: HealthSeverity.values.byName(map['severity'] as String),
          occurredAt: DateTime.parse(map['occurredAt'] as String),
          recordedBy: map['recordedBy'] as String,
          notes: map['notes'] as String,
        );
      }).toList();
}

class HealthState {
  HealthState({required Iterable<HealthObservation> observations})
    : observations = List.unmodifiable(observations);

  final List<HealthObservation> observations;

  List<HealthObservation> forSheep(String sheepId) =>
      List.unmodifiable(observations.where((o) => o.sheepIds.contains(sheepId)));
}

final healthRepositoryProvider =
    Provider<InMemoryHealthObservationRepository>(
      (ref) => InMemoryHealthObservationRepository(),
    );

class HealthController extends Notifier<HealthState> {
  late InMemoryHealthObservationRepository _repository;
  var _idCounter = 0;

  @override
  HealthState build() {
    _repository = ref.watch(healthRepositoryProvider);
    return HealthState(observations: _repository.getAll());
  }

  /// Records a health observation and emits timeline events for each sheep.
  HealthObservation recordObservation({
    required HealthTargetScope targetScope,
    required Iterable<String> sheepIds,
    required Iterable<String> symptomIds,
    required Map<String, List<String>> answers,
    required HealthSeverity severity,
    required DateTime occurredAt,
    required String recordedBy,
    String notes = '',
  }) {
    final uniqueSheepIds = sheepIds.toSet().toList(growable: false);
    if (uniqueSheepIds.isEmpty) {
      throw ArgumentError.value(sheepIds, 'sheepIds', 'Cannot be empty');
    }
    final observationId = _newId();
    final observation = HealthObservation(
      id: observationId,
      targetScope: targetScope,
      sheepIds: uniqueSheepIds,
      symptomIds: symptomIds.toSet().toList(growable: false),
      answers: Map.unmodifiable(answers),
      severity: severity,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      notes: notes,
    );
    _repository.save(observation);

    final care = ref.read(careProvider.notifier);
    final summary = observation.symptomIds.join(' + ');
    for (final sheepId in uniqueSheepIds) {
      care.recordHealthObservationEvent(
        sheepId: sheepId,
        observationId: observationId,
        symptomIds: observation.symptomIds,
        severity: severity.name,
        summary: summary,
        occurredAt: occurredAt,
        recordedBy: recordedBy,
        notes: notes,
      );
    }

    // Open a health case for the observation so the health section is usable.
    ref.read(healthCaseProvider.notifier).createCase(
      sheepIds: uniqueSheepIds,
      startedAt: occurredAt,
      symptoms: observation.symptomIds,
      severity: severity.name,
      status: HealthCaseStatus.open,
    );

    state = HealthState(observations: _repository.getAll());
    return observation;
  }

  String _newId() =>
      'obs-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';
}

final healthProvider = NotifierProvider<HealthController, HealthState>(
  HealthController.new,
);
