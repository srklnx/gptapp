import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/care_records.dart';
import '../domain/care_repositories.dart';
import '../domain/record_animal_action.dart';
import '../domain/record_treatment.dart';
import '../domain/record_weight.dart';
import '../domain/create_follow_up_task.dart';
import '../domain/withdrawal_calculator.dart';
import 'in_memory_care_repository.dart';
import '../../sheep/domain/sheep_record.dart';
import '../../tasks/domain/bulk_action.dart';
import '../../tasks/domain/complete_farm_task.dart';
import '../../tasks/domain/farm_task.dart';
import '../../sync/data/sync_providers.dart';
import '../../../core/models/entities.dart' show SyncOperation;
import '../../heat_stress/domain/heat_stress.dart';
import '../../sheep/data/sheep_providers.dart';

final careRepositoryProvider = Provider<CareRepository>(
  (ref) => InMemoryCareRepository(),
);

class CareState {
  CareState({
    required Iterable<MedicationRecord> medications,
    required Iterable<TreatmentRecord> treatments,
    required Iterable<FarmEvent> events,
    required Iterable<FollowUpTask> followUpTasks,
    required Iterable<FarmTask> farmTasks,
    required Iterable<FarmProtocol> protocols,
    required this.asOf,
  }) : medications = List.unmodifiable(medications),
       treatments = List.unmodifiable(treatments),
       events = List.unmodifiable(events),
       followUpTasks = List.unmodifiable(followUpTasks),
       farmTasks = List.unmodifiable(farmTasks),
       protocols = List.unmodifiable(protocols);

  final List<MedicationRecord> medications;
  final List<TreatmentRecord> treatments;
  final List<FarmEvent> events;
  final List<FollowUpTask> followUpTasks;
  final List<FarmTask> farmTasks;
  final List<FarmProtocol> protocols;
  final DateTime asOf;

  WithdrawalSummary withdrawalFor(String sheepId) =>
      WithdrawalCalculator.calculate(
        treatments.where((treatment) => treatment.sheepId == sheepId),
        now: asOf,
      );

  WithdrawalSummary withdrawalForTreatment(TreatmentRecord treatment) =>
      WithdrawalCalculator.calculate([treatment], now: asOf);

  WithdrawalClearanceDates clearanceDatesFor(
    MedicationRecord medication,
    DateTime administeredAt,
  ) => WithdrawalCalculator.clearanceDatesFor(medication, administeredAt);

  SheepHealthStatus statusFor(SheepRecord sheep) =>
      withdrawalFor(sheep.id).hasAnyActiveWithdrawal
      ? SheepHealthStatus.withdrawal
      : sheep.status;

  int? withdrawalDaysFor(String sheepId) =>
      withdrawalFor(sheepId).daysUntilMeatClearance(asOf) ??
      withdrawalFor(sheepId).daysUntilMilkClearance(asOf);

  List<TreatmentRecord> treatmentsFor(String sheepId) => List.unmodifiable(
    treatments.where((treatment) => treatment.sheepId == sheepId),
  );

  List<TreatmentRecord> activeTreatmentsFor(String sheepId) =>
      List.unmodifiable(
        treatmentsFor(sheepId).where(
          (treatment) => WithdrawalCalculator.calculate([
            treatment,
          ], now: asOf).hasAnyActiveWithdrawal,
        ),
      );

  List<FarmEvent> eventsFor(String sheepId) {
    final matching = events.where((event) => event.sheepId == sheepId).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return List.unmodifiable(matching);
  }

  MedicationRecord? medicationFor(String id) {
    for (final medication in medications) {
      if (medication.id == id) return medication;
    }
    return null;
  }

  FarmProtocol? protocolFor(String? id) {
    if (id == null) return null;
    for (final protocol in protocols) {
      if (protocol.id == id) return protocol;
    }
    return null;
  }

  Set<String> get sheepInWithdrawal => treatments
      .map((treatment) => treatment.sheepId)
      .where((sheepId) => withdrawalFor(sheepId).hasAnyActiveWithdrawal)
      .toSet();
}

class CareController extends Notifier<CareState> {
  late CareRepository _repository;
  var _idCounter = 0;
  Timer? _expiryTimer;

  @override
  CareState build() {
    _repository = ref.watch(careRepositoryProvider);
    ref.onDispose(() => _expiryTimer?.cancel());
    final snapshot = _readState();
    _scheduleClearanceRefresh(snapshot);
    return snapshot;
  }

  TreatmentRecord recordTreatment({
    required String sheepId,
    required MedicationRecord medication,
    required double dose,
    required DateTime administeredAt,
    required String administeredBy,
    String notes = '',
    String? observationId,
    String? eventId,
    String treatmentReason = '',
  }) {
    final followUpIdsBefore = _repository
        .getFollowUpTasks(sheepId: sheepId)
        .map((task) => task.id)
        .toSet();
    final result = RecordTreatment(repository: _repository, createId: _newId)(
      sheepId: sheepId,
      medication: medication,
      dose: dose,
      administeredAt: administeredAt,
      administeredBy: administeredBy,
      notes: notes,
      observationId: observationId,
      eventId: eventId,
      treatmentReason: treatmentReason,
    );
    ref
        .read(syncCenterProvider.notifier)
        .enqueue(
          entityType: 'Treatment',
          entityId: result.id,
          operation: SyncOperation.create,
          idempotencyKey: 'treatment:${result.id}:create',
          payload: {
            'sheepId': result.sheepId,
            'medicationId': result.medicationId,
            'dose': result.dose,
            'doseUnit': result.doseUnit,
            'route': result.route.name,
            'administeredAt': result.administeredAt.toIso8601String(),
            'withdrawalDays': result.withdrawalDays,
            'milkWithdrawalDays': result.milkWithdrawalDays,
            'clearanceDate': result.clearanceDate.toIso8601String(),
            'milkClearanceDate': result.milkClearanceDate.toIso8601String(),
            'notes': result.notes,
          },
        );
    final treatmentEvent = _repository
        .getEvents()
        .whereType<TreatmentEvent>()
        .firstWhere((event) => event.treatmentId == result.id);
    _enqueueEvent(treatmentEvent);
    for (final task
        in _repository
            .getFollowUpTasks(sheepId: result.sheepId)
            .where((task) => !followUpIdsBefore.contains(task.id))) {
      ref
          .read(syncCenterProvider.notifier)
          .enqueue(
            entityType: 'Task',
            entityId: task.id,
            operation: SyncOperation.create,
            idempotencyKey: 'task:${task.id}:create',
            payload: {
              'sheepId': task.sheepId,
              'title': task.title,
              'dueAt': task.dueAt.toIso8601String(),
            },
          );
    }
    _refresh();
    return result;
  }

  FarmEvent recordAction({
    required String sheepId,
    required String action,
    required DateTime occurredAt,
    required String recordedBy,
    double? value,
    String notes = '',
  }) {
    final result =
        RecordAnimalAction(repository: _repository, createId: _newId)(
          sheepId: sheepId,
          action: action,
          occurredAt: occurredAt,
          recordedBy: recordedBy,
          value: value,
          notes: notes,
        );
    _enqueueEvent(result);
    _refresh();
    return result;
  }

  WeightRecordResult recordWeight({
    required String sheepId,
    required double weightKg,
    required DateTime occurredAt,
    required String recordedBy,
    String unit = 'kg',
    String? method,
    String notes = '',
    double? bcs,
  }) {
    final result = RecordWeightUseCase(
      repository: _repository,
      createId: _newId,
    )(
      sheepId: sheepId,
      weightKg: weightKg,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      unit: unit,
      method: method,
      notes: notes,
      bcs: bcs,
    );
    _enqueueEvent(result.weight);
    if (result.bcs != null) _enqueueEvent(result.bcs!);
    _refresh();
    return result;
  }

  FarmTask createFollowUpTask({
    required Iterable<String> sheepIds,
    required String title,
    required DateTime dueAt,
    TaskPriority priority = TaskPriority.normal,
    String? assignedTo,
    String notes = '',
    String? observationId,
  }) {
    final result = CreateFollowUpTaskUseCase(
      repository: _repository,
      createId: _newId,
    )(
      sheepIds: sheepIds,
      title: title,
      dueAt: dueAt,
      priority: priority,
      assignedTo: assignedTo,
      notes: notes,
      observationId: observationId,
    );
    _enqueueFarmTask(result, 'create');
    _refresh();
    return result;
  }

  void recordIdentityChange({
    required String sheepId,
    required String field,
    required String oldValue,
    required String newValue,
    required DateTime occurredAt,
    required String recordedBy,
  }) {
    final event = IdentityChangeEvent(
      id: _newId(),
      sheepId: sheepId,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      field: field,
      oldValue: oldValue,
      newValue: newValue,
    );
    _repository.saveEvent(event);
    _enqueueEvent(event);
    _refresh();
  }

  void recordHealthObservationEvent({
    required String sheepId,
    required String observationId,
    required Iterable<String> symptomIds,
    required String severity,
    required String summary,
    required DateTime occurredAt,
    required String recordedBy,
    String notes = '',
  }) {
    final event = HealthObservationEvent(
      id: _newId(),
      sheepId: sheepId,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      observationId: observationId,
      symptomIds: symptomIds,
      severity: severity,
      summary: summary,
      notes: notes,
    );
    _repository.saveEvent(event);
    _enqueueEvent(event);
    _refresh();
  }

  /// Enqueues an event that was already persisted (e.g. an identity audit
  /// event created by [UpdateSheepUseCase]) without saving it a second time.
  void enqueueExistingEvent(FarmEvent event) {
    _enqueueEvent(event);
  }

  BulkActionResult performBulkAction({
    required String groupId,
    required Iterable<String> sheepIds,
    required String action,
    FarmTask? task,
    required DateTime occurredAt,
    required String recordedBy,
  }) {
    final result =
        PerformBulkAction(
          taskRepository: _repository,
          eventRepository: _repository,
          createId: _newId,
        )(
          groupId: groupId,
          sheepIds: sheepIds,
          action: action,
          task: task,
          protocol: task == null ? null : state.protocolFor(task.protocolId),
          occurredAt: occurredAt,
          recordedBy: recordedBy,
        );
    for (final event in result.events) {
      _enqueueEvent(event);
    }
    if (result.task != null) _enqueueFarmTask(result.task!, 'update');
    if (result.nextTask != null) _enqueueFarmTask(result.nextTask!, 'create');
    _refresh();
    return result;
  }

  CompleteFarmTaskResult completeTask({
    required FarmTask task,
    required DateTime completedAt,
    required String completedBy,
  }) {
    final result =
        CompleteFarmTask(
          taskRepository: _repository,
          eventRepository: _repository,
          createId: _newId,
        )(
          task: task,
          completedAt: completedAt,
          completedBy: completedBy,
          protocol: state.protocolFor(task.protocolId),
        );
    for (final event in result.createdEvents) {
      _enqueueEvent(event);
    }
    _enqueueFarmTask(result.completedTask, 'update');
    if (result.nextTask != null) _enqueueFarmTask(result.nextTask!, 'create');
    _refresh();
    return result;
  }

  void updateTaskStatus(FarmTask task, FarmTaskStatus status) {
    _repository.saveFarmTask(
      task.copyWith(
        status: status,
        completedAt: status == FarmTaskStatus.completed
            ? DateTime.now()
            : task.completedAt,
      ),
    );
    _enqueueFarmTask(
      task.copyWith(
        status: status,
        completedAt: status == FarmTaskStatus.completed
            ? DateTime.now()
            : task.completedAt,
      ),
      'update',
    );
    _refresh();
  }

  void undoBulkAction(BulkUndoReceipt receipt) {
    revertBulkAction(
      receipt: receipt,
      taskRepository: _repository,
      eventRepository: _repository,
    );
    for (final eventId in receipt.createdEventIds) {
      syncRepositoryTombstone('Event', eventId);
    }
    if (receipt.completedTaskBefore case final previousTask?) {
      _enqueueFarmTask(previousTask, 'update');
    }
    if (receipt.createdNextTaskId case final nextTaskId?) {
      syncRepositoryTombstone('Task', nextTaskId);
    }
    _refresh();
  }

  String _newId() =>
      'care-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  void _refresh() {
    state = _readState();
    _scheduleClearanceRefresh(state);
  }

  void _enqueueEvent(FarmEvent event) {
    final sync = ref.read(syncCenterProvider.notifier);
    final entityType = switch (event) {
      TreatmentEvent() => 'Event',
      WeightEvent() => 'Weight',
      BcsEvent() => 'BCS',
      AnimalActionEvent(action: final action)
          when RegExp(
            r'mating|pregnancy|lambing',
            caseSensitive: false,
          ).hasMatch(action) =>
        'Breeding',
      AnimalActionEvent() => 'Event',
      IdentityChangeEvent() => 'Sheep',
      HealthObservationEvent() => 'HealthObservation',
      HeatCheckEvent() => 'HeatCheck',
    };
    sync.enqueue(
      entityType: entityType,
      entityId: event.id,
      operation: SyncOperation.create,
      idempotencyKey: 'event:${event.id}:create',
      payload: switch (event) {
        TreatmentEvent() => {
          'sheepId': event.sheepId,
          'treatmentId': event.treatmentId,
          'medicationName': event.medicationName,
          'dose': event.dose,
          'doseUnit': event.doseUnit,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        WeightEvent() => {
          'sheepId': event.sheepId,
          'weightKg': event.weightKg,
          'unit': event.unit,
          'method': event.method,
          'notes': event.notes,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        BcsEvent() => {
          'sheepId': event.sheepId,
          'score': event.score,
          'notes': event.notes,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        AnimalActionEvent() => {
          'sheepId': event.sheepId,
          'action': event.action,
          'notes': event.notes,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        IdentityChangeEvent() => {
          'sheepId': event.sheepId,
          'field': event.field,
          'oldValue': event.oldValue,
          'newValue': event.newValue,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        HealthObservationEvent() => {
          'sheepId': event.sheepId,
          'observationId': event.observationId,
          'symptomIds': event.symptomIds,
          'severity': event.severity,
          'summary': event.summary,
          'notes': event.notes,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
        HeatCheckEvent() => {
          'sheepId': event.sheepId,
          'temperatureC': event.temperatureC,
          'humidityPercent': event.humidityPercent,
          'thi': event.thi,
          'riskLevel': event.riskLevel,
          'symptoms': event.symptoms,
          'waterAvailable': event.waterAvailable,
          'shadeAvailable': event.shadeAvailable,
          'actionsTaken': event.actionsTaken,
          'notes': event.notes,
          'occurredAt': event.occurredAt.toIso8601String(),
        },
      },
    );
  }

  HeatCheckEvent recordHeatCheck({
    required String sheepId,
    required double temperatureC,
    required double humidityPercent,
    required Iterable<String> symptoms,
    required bool waterAvailable,
    required bool shadeAvailable,
    required Iterable<String> actionsTaken,
    required DateTime occurredAt,
    required String recordedBy,
    String notes = '',
    HeatStressThresholds thresholds = const HeatStressThresholds(),
  }) {
    final assessment = HeatStressService.assess(
      temperatureC: temperatureC,
      relativeHumidity: humidityPercent,
      thresholds: thresholds,
    );
    final event = HeatCheckEvent(
      id: _newId(),
      sheepId: sheepId,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      temperatureC: temperatureC,
      humidityPercent: humidityPercent,
      thi: assessment.thi,
      riskLevel: assessment.level.name,
      symptoms: symptoms,
      waterAvailable: waterAvailable,
      shadeAvailable: shadeAvailable,
      actionsTaken: actionsTaken,
      notes: notes,
    );
    _repository.saveEvent(event);
    _enqueueEvent(event);
    if (assessment.level == HeatRiskLevel.danger ||
        assessment.level == HeatRiskLevel.emergency) {
      final sheepIds = sheepId == 'flock'
          ? ref.read(sheepRecordsProvider).map((animal) => animal.id).toList()
          : [sheepId];
      final task = FarmTask(
        id: _newId(),
        title: 'Recheck heat stress',
        action: 'Heat check',
        targetGroupId: sheepId == 'flock' ? 'north-flock' : sheepId,
        sheepIds: sheepIds,
        dueAt: occurredAt.add(const Duration(minutes: 30)),
        createdAt: occurredAt,
      );
      _repository.saveFarmTask(task);
      _enqueueFarmTask(task, 'create');
    }
    _refresh();
    return event;
  }

  void _enqueueFarmTask(FarmTask task, String operation) {
    ref
        .read(syncCenterProvider.notifier)
        .enqueue(
          entityType: 'Task',
          entityId: task.id,
          operation: operation == 'create'
              ? SyncOperation.create
              : SyncOperation.update,
          idempotencyKey:
              'task:${task.id}:$operation:${DateTime.now().microsecondsSinceEpoch}',
          payload: {
            'title': task.title,
            'action': task.action,
            'sheepIds': task.sheepIds,
            'dueAt': task.dueAt.toIso8601String(),
            'status': task.status.name,
            'completedAt': task.completedAt?.toIso8601String(),
          },
        );
  }

  void syncRepositoryTombstone(String entityType, String entityId) {
    final repository = ref.read(syncRepositoryProvider);
    repository.createTombstone(entityType, entityId);
    ref.read(syncCenterProvider.notifier).refreshQueue();
  }

  void _scheduleClearanceRefresh(CareState snapshot) {
    _expiryTimer?.cancel();
    final now = snapshot.asOf;
    final clearances =
        snapshot.treatments
            .expand(
              (treatment) => [
                treatment.clearanceDate,
                treatment.milkClearanceDate,
              ],
            )
            .where((date) => date.isAfter(now))
            .toList()
          ..sort();
    if (clearances.isEmpty) return;
    _expiryTimer = Timer(clearances.first.difference(now), _refresh);
  }

  CareState _readState() => CareState(
    medications: _repository.getMedications(),
    treatments: _repository.getTreatments(),
    events: _repository.getEvents(),
    followUpTasks: _repository.getFollowUpTasks(),
    farmTasks: _repository.getFarmTasks(),
    protocols: _repository.getProtocols(),
    asOf: DateTime.now(),
  );
}

final careProvider = NotifierProvider<CareController, CareState>(
  CareController.new,
);
