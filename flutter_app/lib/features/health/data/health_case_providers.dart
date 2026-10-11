import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/entities.dart' show SyncOperation;
import '../../quick_log/data/care_providers.dart';
import '../../sync/data/sync_providers.dart';
import '../domain/health_case.dart';

class InMemoryHealthCaseRepository {
  InMemoryHealthCaseRepository({Map<String, Object?>? initialData, this.persist})
    : _cases = initialData == null ? <HealthCase>[] : _decode(initialData);

  final void Function(Map<String, Object?> snapshot)? persist;
  final List<HealthCase> _cases;

  List<HealthCase> getAll() => List.unmodifiable(_cases);

  List<HealthCase> forSheep(String sheepId) => List.unmodifiable(
    _cases.where((c) => c.sheepIds.contains(sheepId)),
  );

  void save(HealthCase healthCase) {
    _cases.add(healthCase);
    _persist();
  }

  void update(HealthCase healthCase) {
    final index = _cases.indexWhere((c) => c.id == healthCase.id);
    if (index >= 0) _cases[index] = healthCase;
    _persist();
  }

  HealthCase? byId(String id) {
    for (final healthCase in _cases) {
      if (healthCase.id == id) return healthCase;
    }
    return null;
  }

  Map<String, Object?> toSnapshot() => {'cases': _cases.map(_toJson).toList()};

  void _persist() => persist?.call(toSnapshot());

  static Map<String, Object?> _toJson(HealthCase item) => {
    'id': item.id,
    'sheepIds': item.sheepIds,
    'startedAt': item.startedAt.toIso8601String(),
    'symptoms': item.symptoms,
    'suspectedConditions': item.suspectedConditions,
    'severity': item.severity,
    'status': item.status.name,
    'outbreakFlag': item.outbreakFlag,
    'diagnosis': item.diagnosis,
    'diagnosisConfirmed': item.diagnosisConfirmed,
    'confirmedBy': item.confirmedBy,
    'treatmentIds': item.treatmentIds,
    'followUpTaskIds': item.followUpTaskIds,
    'closedAt': item.closedAt?.toIso8601String(),
  };

  static List<HealthCase> _decode(Map<String, Object?> snapshot) =>
      (snapshot['cases'] as List<Object?>).map((encoded) {
        final map = (encoded as Map).cast<String, Object?>();
        return HealthCase(
          id: map['id'] as String,
          sheepIds: (map['sheepIds'] as List<Object?>).cast<String>(),
          startedAt: DateTime.parse(map['startedAt'] as String),
          symptoms: (map['symptoms'] as List<Object?>).cast<String>(),
          suspectedConditions: (map['suspectedConditions'] as List<Object?>)
              .cast<String>(),
          severity: map['severity'] as String?,
          status: HealthCaseStatus.values.byName(map['status'] as String),
          outbreakFlag: map['outbreakFlag'] as bool? ?? false,
          diagnosis: map['diagnosis'] as String?,
          diagnosisConfirmed: map['diagnosisConfirmed'] as bool? ?? false,
          confirmedBy: map['confirmedBy'] as String?,
          treatmentIds: (map['treatmentIds'] as List<Object?>).cast<String>(),
          followUpTaskIds: (map['followUpTaskIds'] as List<Object?>)
              .cast<String>(),
          closedAt: map['closedAt'] == null
              ? null
              : DateTime.parse(map['closedAt'] as String),
        );
      }).toList();
}

class HealthCaseState {
  HealthCaseState({required Iterable<HealthCase> cases})
    : cases = List.unmodifiable(cases);

  final List<HealthCase> cases;

  List<HealthCase> forSheep(String sheepId) =>
      List.unmodifiable(cases.where((c) => c.sheepIds.contains(sheepId)));
}

final healthCaseRepositoryProvider = Provider<InMemoryHealthCaseRepository>(
  (ref) => InMemoryHealthCaseRepository(),
);

class HealthCaseController extends Notifier<HealthCaseState> {
  late InMemoryHealthCaseRepository _repository;
  var _idCounter = 0;

  @override
  HealthCaseState build() {
    _repository = ref.watch(healthCaseRepositoryProvider);
    return HealthCaseState(cases: _repository.getAll());
  }

  HealthCase createCase({
    required Iterable<String> sheepIds,
    required DateTime startedAt,
    Iterable<String> symptoms = const [],
    Iterable<String> suspectedConditions = const [],
    String? severity,
    HealthCaseStatus status = HealthCaseStatus.open,
    bool outbreakFlag = false,
  }) {
    final uniqueSheepIds = sheepIds.toSet().toList(growable: false);
    if (uniqueSheepIds.isEmpty) {
      throw ArgumentError.value(sheepIds, 'sheepIds', 'Cannot be empty');
    }
    final healthCase = HealthCase(
      id: 'case-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}',
      sheepIds: uniqueSheepIds,
      startedAt: startedAt,
      symptoms: List.unmodifiable(symptoms),
      suspectedConditions: List.unmodifiable(suspectedConditions),
      severity: severity,
      status: status,
      outbreakFlag: outbreakFlag,
    );
    _repository.save(healthCase);
    _emit(sheepIds: uniqueSheepIds, action: 'Health case', occurredAt: startedAt);
    ref.read(syncCenterProvider.notifier).enqueue(
      entityType: 'HealthCase',
      entityId: healthCase.id,
      operation: SyncOperation.create,
      idempotencyKey: 'healthcase:${healthCase.id}:create',
      payload: {'sheepIds': uniqueSheepIds, 'status': status.name},
    );
    state = HealthCaseState(cases: _repository.getAll());
    return healthCase;
  }

  void updateStatus(String caseId, HealthCaseStatus status) {
    final current = _repository.byId(caseId);
    if (current == null) return;
    final updated = HealthCase(
      id: current.id,
      sheepIds: current.sheepIds,
      startedAt: current.startedAt,
      symptoms: current.symptoms,
      suspectedConditions: current.suspectedConditions,
      severity: current.severity,
      status: status,
      outbreakFlag: current.outbreakFlag,
      diagnosis: current.diagnosis,
      diagnosisConfirmed: current.diagnosisConfirmed,
      confirmedBy: current.confirmedBy,
      treatmentIds: current.treatmentIds,
      followUpTaskIds: current.followUpTaskIds,
      closedAt: status == HealthCaseStatus.closed ||
              status == HealthCaseStatus.resolved
          ? DateTime.now()
          : current.closedAt,
    );
    _repository.update(updated);
    _emit(
      sheepIds: updated.sheepIds,
      action: 'Health case updated',
      occurredAt: DateTime.now(),
    );
    state = HealthCaseState(cases: _repository.getAll());
  }

  void _emit({
    required Iterable<String> sheepIds,
    required String action,
    required DateTime occurredAt,
  }) {
    for (final sheepId in sheepIds) {
      ref.read(careProvider.notifier).recordAction(
        sheepId: sheepId,
        action: action,
        occurredAt: occurredAt,
        recordedBy: 'Ahmed',
      );
    }
  }
}

final healthCaseProvider = NotifierProvider<HealthCaseController, HealthCaseState>(
  HealthCaseController.new,
);
