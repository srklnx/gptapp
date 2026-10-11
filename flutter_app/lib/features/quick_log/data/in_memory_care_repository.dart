import '../domain/care_records.dart';
import '../domain/care_repositories.dart';
import '../../sheep/data/mock_sheep_directory_repository.dart';
import '../../tasks/domain/farm_task.dart';

class InMemoryCareRepository implements CareRepository {
  InMemoryCareRepository({Map<String, Object?>? initialData, this.persist})
    : _medications = initialData == null
          ? _seedMedications()
          : _decodeList(initialData, 'medications', _medicationFromJson),
      _treatmentRecords = initialData == null
          ? _seedTreatments()
          : _decodeList(initialData, 'treatments', _treatmentFromJson),
      _events = initialData == null
          ? _seedEvents()
          : _decodeList(initialData, 'events', _eventFromJson),
      _tasks = initialData == null
          ? []
          : _decodeList(initialData, 'followUpTasks', _followUpFromJson),
      _farmTasks = initialData == null
          ? _seedFarmTasks()
          : _decodeList(initialData, 'farmTasks', _farmTaskFromJson),
      _protocols = initialData == null
          ? _seedProtocols()
          : _decodeList(initialData, 'protocols', _protocolFromJson) {
    if (initialData != null) {
      _deletedEventIds.addAll(
        (initialData['deletedEventIds'] as List<Object?>).cast<String>(),
      );
      _deletedFarmTaskIds.addAll(
        (initialData['deletedFarmTaskIds'] as List<Object?>).cast<String>(),
      );
    }
  }

  final void Function(Map<String, Object?> snapshot)? persist;
  final List<MedicationRecord> _medications;
  final List<TreatmentRecord> _treatmentRecords;
  final List<FarmEvent> _events;
  final List<FollowUpTask> _tasks;
  final List<FarmTask> _farmTasks;
  final List<FarmProtocol> _protocols;
  final Set<String> _deletedEventIds = {};
  final Set<String> _deletedFarmTaskIds = {};

  @override
  List<MedicationRecord> getMedications() => List.unmodifiable(_medications);

  @override
  List<TreatmentRecord> getTreatments({String? sheepId}) => List.unmodifiable(
    sheepId == null
        ? _treatmentRecords
        : _treatmentRecords.where((record) => record.sheepId == sheepId),
  );

  @override
  void saveTreatment(TreatmentRecord treatment) {
    _treatmentRecords.add(treatment);
    _persist();
  }

  @override
  List<FarmEvent> getEvents({String? sheepId}) => List.unmodifiable(
    _events.where(
      (event) =>
          !_deletedEventIds.contains(event.id) &&
          (sheepId == null || event.sheepId == sheepId),
    ),
  );

  @override
  void saveEvent(FarmEvent event) {
    _events.add(event);
    _deletedEventIds.remove(event.id);
    _persist();
  }

  @override
  void removeEvents(Iterable<String> ids) {
    _deletedEventIds.addAll(ids);
    _persist();
  }

  @override
  List<FollowUpTask> getFollowUpTasks({String? sheepId}) => List.unmodifiable(
    sheepId == null ? _tasks : _tasks.where((task) => task.sheepId == sheepId),
  );

  @override
  void saveFollowUpTask(FollowUpTask task) {
    _tasks.add(task);
    _persist();
  }

  @override
  List<FarmTask> getFarmTasks() => List.unmodifiable(
    _farmTasks.where((task) => !_deletedFarmTaskIds.contains(task.id)),
  );

  @override
  void saveFarmTask(FarmTask task) {
    final index = _farmTasks.indexWhere((record) => record.id == task.id);
    if (index == -1) {
      _farmTasks.add(task);
    } else {
      _farmTasks[index] = task;
    }
    _deletedFarmTaskIds.remove(task.id);
    _persist();
  }

  @override
  void removeFarmTask(String id) {
    _deletedFarmTaskIds.add(id);
    _persist();
  }

  @override
  List<FarmProtocol> getProtocols() => List.unmodifiable(_protocols);

  Map<String, Object?> toSnapshot() => {
    'medications': _medications.map(_medicationToJson).toList(),
    'treatments': _treatmentRecords.map(_treatmentToJson).toList(),
    'events': _events.map(_eventToJson).toList(),
    'followUpTasks': _tasks.map(_followUpToJson).toList(),
    'farmTasks': _farmTasks.map(_farmTaskToJson).toList(),
    'protocols': _protocols.map(_protocolToJson).toList(),
    'deletedEventIds': _deletedEventIds.toList(),
    'deletedFarmTaskIds': _deletedFarmTaskIds.toList(),
  };

  void _persist() => persist?.call(toSnapshot());

  static List<FarmTask> _seedFarmTasks() {
    final sheep = MockSheepDirectoryRepository().getAll();
    final pregnant = sheep
        .where((animal) => animal.groupName == 'Pregnant Ewes')
        .map((animal) => animal.id)
        .toList();
    if (pregnant.isEmpty) return [];
    final now = DateTime.now();
    const protocolId = 'pregnant-ewes-vaccination';
    return [
      FarmTask(
        id: 'task-pregnant-vaccination',
        title: 'Vaccinate Pregnant Ewes',
        action: 'Vaccination',
        targetGroupId: 'pregnant-ewes',
        sheepIds: pregnant,
        dueAt: DateTime(now.year, now.month, now.day),
        createdAt: DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(const Duration(days: 180)),
        protocolId: protocolId,
      ),
    ];
  }

  static List<FarmProtocol> _seedProtocols() => const [
    FarmProtocol(
      id: 'pregnant-ewes-vaccination',
      name: 'Vaccinate Pregnant Ewes',
      routineType: 'Vaccination',
      targetGroupId: 'pregnant-ewes',
      intervalDays: 180,
      enabled: true,
      season: 'Breeding',
    ),
  ];

  static List<MedicationRecord> _seedMedications() => [
    MedicationRecord(
      id: 'albendazole',
      name: 'Albendazole',
      activeIngredient: 'Albendazole',
      species: const ['Sheep'],
      route: TreatmentRoute.oral,
      routeOptions: const [TreatmentRoute.oral],
      doseUnit: 'ml',
      meatWithdrawalDays: 5,
      milkWithdrawalDays: 0,
      followUpAfterDays: 7,
      category: MedicationCategory.antiparasitic,
      formulation: 'Oral suspension',
      concentration: '2.5%',
      notes: 'Use according to the farm veterinary protocol.',
    ),
    MedicationRecord(
      id: 'oxytetracycline',
      name: 'Oxytetracycline',
      activeIngredient: 'Oxytetracycline',
      species: const ['Sheep'],
      route: TreatmentRoute.intramuscular,
      routeOptions: const [
        TreatmentRoute.intramuscular,
        TreatmentRoute.subcutaneous,
      ],
      doseUnit: 'ml',
      meatWithdrawalDays: 28,
      milkWithdrawalDays: 7,
      followUpAfterDays: 3,
      category: MedicationCategory.antibiotic,
      formulation: 'Injectable',
      concentration: '200 mg/mL',
    ),
    MedicationRecord(
      id: 'meloxicam',
      name: 'Meloxicam',
      activeIngredient: 'Meloxicam',
      species: const ['Sheep'],
      route: TreatmentRoute.subcutaneous,
      routeOptions: const [TreatmentRoute.subcutaneous],
      doseUnit: 'ml',
      meatWithdrawalDays: 15,
      milkWithdrawalDays: 5,
      category: MedicationCategory.antiInflammatory,
      formulation: 'Injectable',
      concentration: '20 mg/mL',
    ),
    MedicationRecord(
      id: 'oxytetracycline-eye',
      name: 'Oxytetracycline eye ointment',
      activeIngredient: 'Oxytetracycline',
      species: const ['Sheep'],
      route: TreatmentRoute.eye,
      routeOptions: const [TreatmentRoute.eye],
      doseUnit: 'other',
      meatWithdrawalDays: 0,
      milkWithdrawalDays: 0,
      category: MedicationCategory.eyeTreatment,
      formulation: 'Ophthalmic ointment',
    ),
    MedicationRecord(
      id: 'electrolyte',
      name: 'Oral rehydration electrolytes',
      activeIngredient: 'Electrolytes',
      species: const ['Sheep'],
      route: TreatmentRoute.oral,
      routeOptions: const [TreatmentRoute.oral],
      doseUnit: 'g',
      meatWithdrawalDays: 0,
      milkWithdrawalDays: 0,
      category: MedicationCategory.electrolyte,
      formulation: 'Powder',
    ),
    MedicationRecord(
      id: 'vitamin-mineral',
      name: 'Vitamin / mineral drench',
      activeIngredient: 'Vitamins & minerals',
      species: const ['Sheep'],
      route: TreatmentRoute.oral,
      routeOptions: const [TreatmentRoute.oral],
      doseUnit: 'ml',
      meatWithdrawalDays: 0,
      milkWithdrawalDays: 0,
      category: MedicationCategory.vitaminMineral,
      formulation: 'Oral drench',
    ),
  ];

  static List<TreatmentRecord> _seedTreatments() => [
    TreatmentRecord(
      id: 'treatment-184-seed',
      sheepId: '184',
      medicationId: 'albendazole',
      dose: 10,
      doseUnit: 'ml',
      route: TreatmentRoute.oral,
      administeredAt: DateTime(2026, 9, 30, 9, 10),
      administeredBy: 'Sara',
      withdrawalDays: 5,
      milkWithdrawalDays: 0,
      clearanceDate: DateTime(2026, 10, 5, 9, 10),
      milkClearanceDate: DateTime(2026, 9, 30, 9, 10),
    ),
  ];

  static List<FarmEvent> _seedEvents() => [
    BcsEvent(
      id: 'event-184-bcs',
      sheepId: '184',
      occurredAt: DateTime(2026, 9, 30, 8),
      recordedBy: 'Ahmed',
      score: 2.5,
    ),
    TreatmentEvent(
      id: 'event-184-treatment',
      sheepId: '184',
      occurredAt: DateTime(2026, 9, 30, 9, 10),
      recordedBy: 'Sara',
      treatmentId: 'treatment-184-seed',
      medicationName: 'Albendazole',
      dose: 10,
      doseUnit: 'ml',
    ),
    WeightEvent(
      id: 'event-184-weight',
      sheepId: '184',
      occurredAt: DateTime(2026, 9, 20),
      recordedBy: 'Ahmed',
      weightKg: 62.4,
    ),
    AnimalActionEvent(
      id: 'event-184-mating',
      sheepId: '184',
      occurredAt: DateTime(2026, 9, 8),
      recordedBy: 'Ahmed',
      action: 'Mating · Karakul #R12',
    ),
    AnimalActionEvent(
      id: 'event-184-vaccination',
      sheepId: '184',
      occurredAt: DateTime(2026, 8, 12),
      recordedBy: 'Sara',
      action: 'Vaccination · Clostridial',
    ),
  ];
}

List<T> _decodeList<T>(
  Map<String, Object?> snapshot,
  String key,
  T Function(Map<String, Object?>) decode,
) => (snapshot[key] as List<Object?>)
    .map((record) => decode(_recordMap(record)))
    .toList();

Map<String, Object?> _recordMap(Object? value) =>
    (value as Map).cast<String, Object?>();

DateTime _date(Object? value) => DateTime.parse(value as String);

Map<String, Object?> _medicationToJson(MedicationRecord item) => {
  'id': item.id,
  'name': item.name,
  'activeIngredient': item.activeIngredient,
  'species': item.species,
  'route': item.route.name,
  'routeOptions': item.routeOptions.map((route) => route.name).toList(),
  'doseUnit': item.doseUnit,
  'meatWithdrawalDays': item.meatWithdrawalDays,
  'milkWithdrawalDays': item.milkWithdrawalDays,
  'notes': item.notes,
  'followUpAfterDays': item.followUpAfterDays,
  'category': item.category.name,
  'formulation': item.formulation,
  'concentration': item.concentration,
  'reference': item.reference,
  'active': item.active,
  'brandName': item.brandName,
  'productionClass': item.productionClass,
  'indication': item.indication,
  'contraindications': item.contraindications,
  'minimumAge': item.minimumAge,
  'pregnancyRestrictions': item.pregnancyRestrictions,
  'dosageReference': item.dosageReference,
  'labelStatus': item.labelStatus.name,
  'region': item.region,
  'country': item.country,
  'source': item.source,
  'lastVerifiedAt': item.lastVerifiedAt?.toIso8601String(),
};

MedicationRecord _medicationFromJson(Map<String, Object?> item) =>
    MedicationRecord(
      id: item['id'] as String,
      name: item['name'] as String,
      activeIngredient: item['activeIngredient'] as String,
      species: (item['species'] as List<Object?>).cast<String>(),
      route: TreatmentRoute.values.byName(item['route'] as String),
      routeOptions:
          (item['routeOptions'] as List<Object?>)
              .map((value) => TreatmentRoute.values.byName(value as String))
              .toList(),
      doseUnit: item['doseUnit'] as String,
      meatWithdrawalDays: item['meatWithdrawalDays'] as int,
      milkWithdrawalDays: item['milkWithdrawalDays'] as int,
      notes: item['notes'] as String,
      followUpAfterDays: item['followUpAfterDays'] as int?,
      category: MedicationCategory.values.byName(item['category'] as String),
      formulation: item['formulation'] as String?,
      concentration: item['concentration'] as String?,
      reference: item['reference'] as String?,
      active: item['active'] as bool,
      brandName: item['brandName'] as String?,
      productionClass: item['productionClass'] as String?,
      indication: item['indication'] as String?,
      contraindications:
          (item['contraindications'] as List<Object?>?)?.cast<String>() ??
          const [],
      minimumAge: item['minimumAge'] as int?,
      pregnancyRestrictions: item['pregnancyRestrictions'] as String?,
      dosageReference: item['dosageReference'] as String?,
      labelStatus: item['labelStatus'] == null
          ? LabelStatus.verificationRequired
          : LabelStatus.values.byName(item['labelStatus'] as String),
      region: item['region'] as String?,
      country: item['country'] as String?,
      source: item['source'] as String?,
      lastVerifiedAt: item['lastVerifiedAt'] == null
          ? null
          : _date(item['lastVerifiedAt']),
    );

Map<String, Object?> _treatmentToJson(TreatmentRecord item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'medicationId': item.medicationId,
  'dose': item.dose,
  'doseUnit': item.doseUnit,
  'route': item.route.name,
  'administeredAt': item.administeredAt.toIso8601String(),
  'administeredBy': item.administeredBy,
  'withdrawalDays': item.withdrawalDays,
  'milkWithdrawalDays': item.milkWithdrawalDays,
  'clearanceDate': item.clearanceDate.toIso8601String(),
  'milkClearanceDate': item.milkClearanceDate.toIso8601String(),
  'notes': item.notes,
  'medicationNameSnapshot': item.medicationNameSnapshot,
  'activeIngredientSnapshot': item.activeIngredientSnapshot,
  'observationId': item.observationId,
  'eventId': item.eventId,
  'createdAt': item.createdAt?.toIso8601String(),
  'updatedAt': item.updatedAt?.toIso8601String(),
  'treatmentReason': item.treatmentReason,
};

TreatmentRecord _treatmentFromJson(Map<String, Object?> item) =>
    TreatmentRecord(
      id: item['id'] as String,
      sheepId: item['sheepId'] as String,
      medicationId: item['medicationId'] as String,
      dose: (item['dose'] as num).toDouble(),
      doseUnit: item['doseUnit'] as String,
      route: TreatmentRoute.values.byName(item['route'] as String),
      administeredAt: _date(item['administeredAt']),
      administeredBy: item['administeredBy'] as String,
      withdrawalDays: item['withdrawalDays'] as int,
      milkWithdrawalDays: item['milkWithdrawalDays'] as int,
      clearanceDate: _date(item['clearanceDate']),
      milkClearanceDate: _date(item['milkClearanceDate']),
      notes: item['notes'] as String,
      medicationNameSnapshot: item['medicationNameSnapshot'] as String?,
      activeIngredientSnapshot: item['activeIngredientSnapshot'] as String?,
      observationId: item['observationId'] as String?,
      eventId: item['eventId'] as String?,
      createdAt: item['createdAt'] == null ? null : _date(item['createdAt']),
      updatedAt: item['updatedAt'] == null ? null : _date(item['updatedAt']),
      treatmentReason: item['treatmentReason'] as String? ?? '',
    );

Map<String, Object?> _eventToJson(FarmEvent event) => switch (event) {
  TreatmentEvent() => {
    'type': 'treatment',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'treatmentId': event.treatmentId,
    'medicationName': event.medicationName,
    'dose': event.dose,
    'doseUnit': event.doseUnit,
  },
  WeightEvent() => {
    'type': 'weight',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'weightKg': event.weightKg,
    'unit': event.unit,
    'method': event.method,
    'notes': event.notes,
  },
  BcsEvent() => {
    'type': 'bcs',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'score': event.score,
    'notes': event.notes,
  },
  AnimalActionEvent() => {
    'type': 'action',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'action': event.action,
    'notes': event.notes,
  },
  IdentityChangeEvent() => {
    'type': 'identityChange',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'field': event.field,
    'oldValue': event.oldValue,
    'newValue': event.newValue,
  },
  HealthObservationEvent() => {
    'type': 'healthObservation',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'observationId': event.observationId,
    'symptomIds': event.symptomIds,
    'severity': event.severity,
    'summary': event.summary,
    'notes': event.notes,
  },
  HeatCheckEvent() => {
    'type': 'heatCheck',
    'id': event.id,
    'sheepId': event.sheepId,
    'occurredAt': event.occurredAt.toIso8601String(),
    'recordedBy': event.recordedBy,
    'temperatureC': event.temperatureC,
    'humidityPercent': event.humidityPercent,
    'thi': event.thi,
    'riskLevel': event.riskLevel,
    'symptoms': event.symptoms,
    'waterAvailable': event.waterAvailable,
    'shadeAvailable': event.shadeAvailable,
    'actionsTaken': event.actionsTaken,
    'notes': event.notes,
  },
};

FarmEvent _eventFromJson(Map<String, Object?> item) {
  final common = (
    id: item['id'] as String,
    sheepId: item['sheepId'] as String,
    occurredAt: _date(item['occurredAt']),
    recordedBy: item['recordedBy'] as String,
  );
  return switch (item['type']) {
    'treatment' => TreatmentEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      treatmentId: item['treatmentId'] as String,
      medicationName: item['medicationName'] as String,
      dose: (item['dose'] as num).toDouble(),
      doseUnit: item['doseUnit'] as String,
    ),
    'weight' => WeightEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      weightKg: (item['weightKg'] as num).toDouble(),
      unit: item['unit'] as String? ?? 'kg',
      method: item['method'] as String?,
      notes: item['notes'] as String? ?? '',
    ),
    'bcs' => BcsEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      score: (item['score'] as num).toDouble(),
      notes: item['notes'] as String? ?? '',
    ),
    'action' => AnimalActionEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      action: item['action'] as String,
      notes: item['notes'] as String,
    ),
    'identityChange' => IdentityChangeEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      field: item['field'] as String,
      oldValue: item['oldValue'] as String,
      newValue: item['newValue'] as String,
    ),
    'healthObservation' => HealthObservationEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      observationId: item['observationId'] as String,
      symptomIds: (item['symptomIds'] as List<Object?>).cast<String>(),
      severity: item['severity'] as String,
      summary: item['summary'] as String,
      notes: item['notes'] as String? ?? '',
    ),
    'heatCheck' => HeatCheckEvent(
      id: common.id,
      sheepId: common.sheepId,
      occurredAt: common.occurredAt,
      recordedBy: common.recordedBy,
      temperatureC: (item['temperatureC'] as num).toDouble(),
      humidityPercent: (item['humidityPercent'] as num).toDouble(),
      thi: (item['thi'] as num).toDouble(),
      riskLevel: item['riskLevel'] as String,
      symptoms: (item['symptoms'] as List<Object?>).cast<String>(),
      waterAvailable: item['waterAvailable'] as bool,
      shadeAvailable: item['shadeAvailable'] as bool,
      actionsTaken: (item['actionsTaken'] as List<Object?>).cast<String>(),
      notes: item['notes'] as String,
    ),
    _ => throw FormatException('Unknown farm event type: ${item['type']}.'),
  };
}

Map<String, Object?> _followUpToJson(FollowUpTask item) => {
  'id': item.id,
  'sheepId': item.sheepId,
  'title': item.title,
  'dueAt': item.dueAt.toIso8601String(),
  'createdAt': item.createdAt.toIso8601String(),
};

FollowUpTask _followUpFromJson(Map<String, Object?> item) => FollowUpTask(
  id: item['id'] as String,
  sheepId: item['sheepId'] as String,
  title: item['title'] as String,
  dueAt: _date(item['dueAt']),
  createdAt: _date(item['createdAt']),
);

Map<String, Object?> _farmTaskToJson(FarmTask item) => {
  'id': item.id,
  'title': item.title,
  'action': item.action,
  'targetGroupId': item.targetGroupId,
  'sheepIds': item.sheepIds,
  'dueAt': item.dueAt.toIso8601String(),
  'createdAt': item.createdAt.toIso8601String(),
  'protocolId': item.protocolId,
  'status': item.status.name,
  'completedAt': item.completedAt?.toIso8601String(),
  'priority': item.priority.name,
  'assignedTo': item.assignedTo,
  'notes': item.notes,
};

FarmTask _farmTaskFromJson(Map<String, Object?> item) => FarmTask(
  id: item['id'] as String,
  title: item['title'] as String,
  action: item['action'] as String,
  targetGroupId: item['targetGroupId'] as String,
  sheepIds: (item['sheepIds'] as List<Object?>).cast<String>(),
  dueAt: _date(item['dueAt']),
  createdAt: _date(item['createdAt']),
  protocolId: item['protocolId'] as String?,
  status: FarmTaskStatus.values.byName(item['status'] as String),
  completedAt: item['completedAt'] == null ? null : _date(item['completedAt']),
  priority: item['priority'] == null
      ? TaskPriority.normal
      : TaskPriority.values.byName(item['priority'] as String),
  assignedTo: item['assignedTo'] as String?,
  notes: item['notes'] as String? ?? '',
);

Map<String, Object?> _protocolToJson(FarmProtocol item) => {
  'id': item.id,
  'name': item.name,
  'routineType': item.routineType,
  'targetGroupId': item.targetGroupId,
  'intervalDays': item.intervalDays,
  'enabled': item.enabled,
  'season': item.season,
};

FarmProtocol _protocolFromJson(Map<String, Object?> item) => FarmProtocol(
  id: item['id'] as String,
  name: item['name'] as String,
  routineType: item['routineType'] as String,
  targetGroupId: item['targetGroupId'] as String,
  intervalDays: item['intervalDays'] as int,
  enabled: item['enabled'] as bool,
  season: item['season'] as String?,
);
