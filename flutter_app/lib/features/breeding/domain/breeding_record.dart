enum PregnancyStatus { unknown, open, confirmed, lambed, aborted }

class LambingRecord {
  const LambingRecord({
    required this.date,
    required this.lambCount,
    this.notes = '',
  });

  final DateTime date;
  final int lambCount;
  final String notes;
}

class BreedingRecord {
  BreedingRecord({
    required this.id,
    required this.sheepId,
    required this.pregnancyStatus,
    required this.createdAt,
    required this.updatedAt,
    this.matingDate,
    this.ramTag,
    this.expectedLambingDate,
    Iterable<LambingRecord> lambingHistory = const [],
  }) : lambingHistory = List.unmodifiable(lambingHistory);

  final String id;
  final String sheepId;
  final DateTime? matingDate;
  final String? ramTag;
  final DateTime? expectedLambingDate;
  final PregnancyStatus pregnancyStatus;
  final List<LambingRecord> lambingHistory;
  final DateTime createdAt;
  final DateTime updatedAt;

  BreedingRecord copyWith({
    DateTime? matingDate,
    String? ramTag,
    DateTime? expectedLambingDate,
    PregnancyStatus? pregnancyStatus,
    Iterable<LambingRecord>? lambingHistory,
    DateTime? updatedAt,
  }) => BreedingRecord(
    id: id,
    sheepId: sheepId,
    matingDate: matingDate ?? this.matingDate,
    ramTag: ramTag ?? this.ramTag,
    expectedLambingDate: expectedLambingDate ?? this.expectedLambingDate,
    pregnancyStatus: pregnancyStatus ?? this.pregnancyStatus,
    lambingHistory: lambingHistory ?? this.lambingHistory,
    createdAt: createdAt,
    updatedAt: updatedAt ?? DateTime.now(),
  );
}
