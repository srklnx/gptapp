import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/entities.dart' show SyncOperation;
import '../../health/domain/famacha.dart';
import '../../quick_log/data/care_providers.dart';
import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/withdrawal_calculator.dart';
import '../../sync/data/sync_providers.dart';
import '../domain/parasite_records.dart';
import '../domain/parasite_service.dart';

class InMemoryParasiteRepository {
  InMemoryParasiteRepository({Map<String, Object?>? initialData, this.persist})
    : _famacha = initialData == null
          ? <FamachaRecord>[]
          : _decodeFamacha(initialData),
      _fecalTests = initialData == null
          ? <FecalTestRecord>[]
          : _decodeFecalTests(initialData),
      _dewormings = initialData == null
          ? <DewormingRecord>[]
          : _decodeDewormings(initialData),
      _assessments = initialData == null
          ? <ParasiteAssessment>[]
          : _decodeAssessments(initialData);

  final void Function(Map<String, Object?> snapshot)? persist;
  final List<FamachaRecord> _famacha;
  final List<FecalTestRecord> _fecalTests;
  final List<DewormingRecord> _dewormings;
  final List<ParasiteAssessment> _assessments;

  List<FamachaRecord> famacha({String? sheepId}) => List.unmodifiable(
    sheepId == null ? _famacha : _famacha.where((r) => r.sheepId == sheepId),
  );

  List<FecalTestRecord> fecalTests({String? sheepId}) => List.unmodifiable(
    sheepId == null
        ? _fecalTests
        : _fecalTests.where((r) => r.sheepId == sheepId),
  );

  List<DewormingRecord> dewormings({String? sheepId}) => List.unmodifiable(
    sheepId == null
        ? _dewormings
        : _dewormings.where((r) => r.sheepId == sheepId),
  );

  List<ParasiteAssessment> assessments({String? sheepId}) => List.unmodifiable(
    sheepId == null
        ? _assessments
        : _assessments.where((r) => r.sheepId == sheepId),
  );

  void saveFamacha(FamachaRecord record) {
    _famacha.add(record);
    _persist();
  }

  void saveFecalTest(FecalTestRecord record) {
    _fecalTests.add(record);
    _persist();
  }

  void saveDeworming(DewormingRecord record) {
    _dewormings.add(record);
    _persist();
  }

  void updateDeworming(DewormingRecord record) {
    final index = _dewormings.indexWhere((r) => r.id == record.id);
    if (index >= 0) _dewormings[index] = record;
    _persist();
  }

  void saveAssessment(ParasiteAssessment assessment) {
    _assessments.add(assessment);
    _persist();
  }

  Map<String, Object?> toSnapshot() => {
    'famacha': _famacha.map(_famachaToJson).toList(),
    'fecalTests': _fecalTests.map(_fecalToJson).toList(),
    'dewormings': _dewormings.map(_dewormingToJson).toList(),
    'assessments': _assessments.map(_assessmentToJson).toList(),
  };

  void _persist() => persist?.call(toSnapshot());
}

Map<String, Object?> _famachaToJson(FamachaRecord item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'score': item.score,
  'date': item.date.toIso8601String(),
  'observer': item.observer,
  'notes': item.notes,
  'weightKg': item.weightKg,
  'bcs': item.bcs,
  'eventId': item.eventId,
};

List<FamachaRecord> _decodeFamacha(Map<String, Object?> snapshot) =>
    (snapshot['famacha'] as List<Object?>).map((encoded) {
      final map = (encoded as Map).cast<String, Object?>();
      return FamachaRecord(
        id: map['id'] as String,
        sheepId: map['sheepId'] as String,
        score: map['score'] as int,
        date: DateTime.parse(map['date'] as String),
        observer: map['observer'] as String,
        notes: map['notes'] as String? ?? '',
        weightKg: (map['weightKg'] as num?)?.toDouble(),
        bcs: (map['bcs'] as num?)?.toDouble(),
        eventId: map['eventId'] as String?,
      );
    }).toList();

Map<String, Object?> _fecalToJson(FecalTestRecord item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'date': item.date.toIso8601String(),
  'testType': item.testType.name,
  'fecalEggCount': item.fecalEggCount,
  'parasitesDetected': item.parasitesDetected,
  'resultLevel': item.resultLevel.name,
  'laboratory': item.laboratory,
  'notes': item.notes,
};

List<FecalTestRecord> _decodeFecalTests(Map<String, Object?> snapshot) =>
    (snapshot['fecalTests'] as List<Object?>).map((encoded) {
      final map = (encoded as Map).cast<String, Object?>();
      return FecalTestRecord(
        id: map['id'] as String,
        sheepId: map['sheepId'] as String,
        date: DateTime.parse(map['date'] as String),
        testType: FecalTestType.values.byName(map['testType'] as String),
        fecalEggCount: map['fecalEggCount'] as int?,
        parasitesDetected: (map['parasitesDetected'] as List<Object?>)
            .cast<String>(),
        resultLevel: FecalResultLevel.values.byName(map['resultLevel'] as String),
        laboratory: map['laboratory'] as String? ?? '',
        notes: map['notes'] as String? ?? '',
      );
    }).toList();

Map<String, Object?> _dewormingToJson(DewormingRecord item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'reason': item.reason.name,
  'medicationId': item.medicationId,
  'productId': item.productId,
  'activeIngredient': item.activeIngredient,
  'concentration': item.concentration,
  'dose': item.dose,
  'doseUnit': item.doseUnit,
  'route': item.route,
  'administeredAt': item.administeredAt.toIso8601String(),
  'administeredBy': item.administeredBy,
  'weightAtTreatment': item.weightAtTreatment,
  'withdrawalDays': item.withdrawalDays,
  'clearanceDate': item.clearanceDate.toIso8601String(),
  'veterinaryDirected': item.veterinaryDirected,
  'protocolId': item.protocolId,
  'notes': item.notes,
  'followUpDate': item.followUpDate?.toIso8601String(),
  'responseStatus': item.responseStatus?.name,
  'eventId': item.eventId,
};

List<DewormingRecord> _decodeDewormings(Map<String, Object?> snapshot) =>
    (snapshot['dewormings'] as List<Object?>).map((encoded) {
      final map = (encoded as Map).cast<String, Object?>();
      return DewormingRecord(
        id: map['id'] as String,
        sheepId: map['sheepId'] as String,
        reason: DewormingReason.values.byName(map['reason'] as String),
        medicationId: map['medicationId'] as String,
        productId: map['productId'] as String?,
        activeIngredient: map['activeIngredient'] as String,
        concentration: map['concentration'] as String?,
        dose: (map['dose'] as num).toDouble(),
        doseUnit: map['doseUnit'] as String,
        route: map['route'] as String,
        administeredAt: DateTime.parse(map['administeredAt'] as String),
        administeredBy: map['administeredBy'] as String,
        weightAtTreatment: (map['weightAtTreatment'] as num?)?.toDouble(),
        withdrawalDays: map['withdrawalDays'] as int,
        clearanceDate: DateTime.parse(map['clearanceDate'] as String),
        veterinaryDirected: map['veterinaryDirected'] as bool? ?? false,
        protocolId: map['protocolId'] as String?,
        notes: map['notes'] as String? ?? '',
        followUpDate: map['followUpDate'] == null
            ? null
            : DateTime.parse(map['followUpDate'] as String),
        responseStatus: map['responseStatus'] == null
            ? null
            : TreatmentResponse.values.byName(map['responseStatus'] as String),
        eventId: map['eventId'] as String?,
      );
    }).toList();

Map<String, Object?> _assessmentToJson(ParasiteAssessment item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'date': item.date.toIso8601String(),
  'observer': item.observer,
  'famachaScore': item.famachaScore,
  'bcs': item.bcs,
  'weightKg': item.weightKg,
  'bottleJaw': item.bottleJaw,
  'diarrhea': item.diarrhea,
  'weightLoss': item.weightLoss,
  'paleEyelids': item.paleEyelids,
  'recentFecalTest': item.recentFecalTest,
  'lastDewormingDate': item.lastDewormingDate?.toIso8601String(),
  'previousProduct': item.previousProduct,
  'otherSheepAffected': item.otherSheepAffected,
  'notes': item.notes,
};

List<ParasiteAssessment> _decodeAssessments(Map<String, Object?> snapshot) =>
    (snapshot['assessments'] as List<Object?>).map((encoded) {
      final map = (encoded as Map).cast<String, Object?>();
      return ParasiteAssessment(
        id: map['id'] as String,
        sheepId: map['sheepId'] as String,
        date: DateTime.parse(map['date'] as String),
        observer: map['observer'] as String,
        famachaScore: map['famachaScore'] as int?,
        bcs: (map['bcs'] as num?)?.toDouble(),
        weightKg: (map['weightKg'] as num?)?.toDouble(),
        bottleJaw: map['bottleJaw'] as bool?,
        diarrhea: map['diarrhea'] as bool?,
        weightLoss: map['weightLoss'] as bool?,
        paleEyelids: map['paleEyelids'] as bool?,
        recentFecalTest: map['recentFecalTest'] as bool?,
        lastDewormingDate: map['lastDewormingDate'] == null
            ? null
            : DateTime.parse(map['lastDewormingDate'] as String),
        previousProduct: map['previousProduct'] as String?,
        otherSheepAffected: map['otherSheepAffected'] as bool?,
        notes: map['notes'] as String? ?? '',
      );
    }).toList();

class ParasiteState {
  ParasiteState({
    required Iterable<FamachaRecord> famacha,
    required Iterable<FecalTestRecord> fecalTests,
    required Iterable<DewormingRecord> dewormings,
    required Iterable<ParasiteAssessment> assessments,
  }) : famacha = List.unmodifiable(famacha),
       fecalTests = List.unmodifiable(fecalTests),
       dewormings = List.unmodifiable(dewormings),
       assessments = List.unmodifiable(assessments);

  final List<FamachaRecord> famacha;
  final List<FecalTestRecord> fecalTests;
  final List<DewormingRecord> dewormings;
  final List<ParasiteAssessment> assessments;

  List<FamachaRecord> famachaFor(String sheepId) => List.unmodifiable(
    famacha.where((r) => r.sheepId == sheepId),
  );

  List<DewormingRecord> dewormingsFor(String sheepId) => List.unmodifiable(
    dewormings.where((r) => r.sheepId == sheepId),
  );
}

final parasiteRepositoryProvider = Provider<InMemoryParasiteRepository>(
  (ref) => InMemoryParasiteRepository(),
);

class ParasiteController extends Notifier<ParasiteState> {
  late InMemoryParasiteRepository _repository;
  var _idCounter = 0;

  @override
  ParasiteState build() {
    _repository = ref.watch(parasiteRepositoryProvider);
    return _read();
  }

  ParasiteState _read() => ParasiteState(
    famacha: _repository.famacha(),
    fecalTests: _repository.fecalTests(),
    dewormings: _repository.dewormings(),
    assessments: _repository.assessments(),
  );

  String _newId() =>
      'para-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  FamachaRecord recordFamacha({
    required String sheepId,
    required int score,
    required DateTime date,
    required String observer,
    double? weightKg,
    double? bcs,
    String notes = '',
  }) {
    if (!FamachaRecord.isValid(score)) {
      throw ArgumentError.value(score, 'score', 'Must be 1-5');
    }
    final record = FamachaRecord(
      id: _newId(),
      sheepId: sheepId,
      score: score,
      date: date,
      observer: observer,
      weightKg: weightKg,
      bcs: bcs,
      notes: notes,
    );
    _repository.saveFamacha(record);
    _emitEvent(sheepId, 'FAMACHA', date, observer, notes: '${record.score}');
    _enqueue('Famacha', record.id, {'sheepId': sheepId, 'score': score});
    state = _read();
    return record;
  }

  FecalTestRecord recordFecalTest({
    required String sheepId,
    required DateTime date,
    required FecalTestType testType,
    int? fecalEggCount,
    Iterable<String> parasitesDetected = const [],
    FecalResultLevel resultLevel = FecalResultLevel.pending,
    String laboratory = '',
    String notes = '',
  }) {
    if (!ParasiteValidation.isValidFecalEggCount(fecalEggCount)) {
      throw ArgumentError.value(fecalEggCount, 'fecalEggCount', 'Cannot be negative');
    }
    final record = FecalTestRecord(
      id: _newId(),
      sheepId: sheepId,
      date: date,
      testType: testType,
      fecalEggCount: fecalEggCount,
      parasitesDetected: List.unmodifiable(parasitesDetected),
      resultLevel: resultLevel,
      laboratory: laboratory,
      notes: notes,
    );
    _repository.saveFecalTest(record);
    _emitEvent(sheepId, 'Fecal test', date, 'Ahmed', notes: resultLevel.name);
    _enqueue('FecalTest', record.id, {'sheepId': sheepId});
    state = _read();
    return record;
  }

  DewormingRecord recordDeworming({
    required String sheepId,
    required DewormingReason reason,
    required MedicationRecord medication,
    required double dose,
    required DateTime administeredAt,
    required String administeredBy,
    double? weightAtTreatment,
    bool veterinaryDirected = false,
    String? protocolId,
    String notes = '',
    DateTime? followUpDate,
  }) {
    if (!dose.isFinite || dose <= 0) {
      throw ArgumentError.value(dose, 'dose', 'Must be positive');
    }
    final clearance = WithdrawalCalculator.clearanceDatesFor(
      medication,
      administeredAt,
    );
    final record = DewormingRecord(
      id: _newId(),
      sheepId: sheepId,
      reason: reason,
      medicationId: medication.id,
      activeIngredient: medication.activeIngredient,
      concentration: medication.concentration,
      dose: dose,
      doseUnit: medication.doseUnit,
      route: medication.route.name,
      administeredAt: administeredAt,
      administeredBy: administeredBy,
      weightAtTreatment: weightAtTreatment,
      withdrawalDays: medication.meatWithdrawalDays,
      clearanceDate: clearance.meat,
      veterinaryDirected: veterinaryDirected,
      protocolId: protocolId,
      notes: notes,
      followUpDate: followUpDate,
    );
    _repository.saveDeworming(record);
    _emitEvent(
      sheepId,
      'Deworming',
      administeredAt,
      administeredBy,
      notes: medication.name,
    );
    _enqueue('Deworming', record.id, {
      'sheepId': sheepId,
      'medicationId': medication.id,
      'reason': reason.name,
      'withdrawalDays': medication.meatWithdrawalDays,
    });
    if (followUpDate != null) {
      ref.read(careProvider.notifier).createFollowUpTask(
        sheepIds: [sheepId],
        title: 'Recheck parasite status',
        dueAt: followUpDate,
        observationId: record.id,
      );
    }
    state = _read();
    return record;
  }

  void recordResponse({
    required String dewormingId,
    required TreatmentResponse response,
  }) {
    DewormingRecord? target;
    for (final record in _repository.dewormings()) {
      if (record.id == dewormingId) target = record;
    }
    if (target != null) {
      _repository.updateDeworming(target.copyWith(responseStatus: response));
      _emitEvent(
        target.sheepId,
        'Treatment response',
        DateTime.now(),
        'Ahmed',
        notes: response.name,
      );
      _enqueue('DewormingResponse', dewormingId, {'response': response.name});
    }
    state = _read();
  }

  void _emitEvent(
    String sheepId,
    String action,
    DateTime occurredAt,
    String recordedBy, {
    String notes = '',
  }) {
    ref.read(careProvider.notifier).recordAction(
      sheepId: sheepId,
      action: action,
      occurredAt: occurredAt,
      recordedBy: recordedBy,
      notes: notes,
    );
  }

  void _enqueue(String entityType, String entityId, Map<String, Object?> payload) {
    ref.read(syncCenterProvider.notifier).enqueue(
      entityType: entityType,
      entityId: entityId,
      operation: SyncOperation.create,
      idempotencyKey: '$entityType:$entityId:create',
      payload: payload,
    );
  }
}

final parasiteProvider = NotifierProvider<ParasiteController, ParasiteState>(
  ParasiteController.new,
);
