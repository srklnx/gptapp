enum SheepSex { ewe, ram, lamb }

enum SheepHealthStatus { healthy, attention, urgent, withdrawal }

class SheepRecord {
  const SheepRecord({
    required this.id,
    required this.tagNumber,
    required this.breed,
    required this.sex,
    required this.weightKg,
    required this.bcs,
    required this.status,
    required this.nextRoutine,
    required this.groupName,
    required this.birthDate,
    required this.location,
    required this.activities,
    this.pregnant = false,
    this.name,
    this.eidRfid,
    this.color,
    this.markings,
    this.source,
    this.purchaseDate,
    this.purchasePrice,
    this.notes = '',
    this.photoAssetPath,
    this.birthDateUnknown = false,
  });

  final String id;
  final String tagNumber;
  final String breed;
  final SheepSex sex;
  final double weightKg;
  final double bcs;
  final SheepHealthStatus status;
  final String nextRoutine;
  final String groupName;
  final DateTime birthDate;
  final String location;
  final List<SheepActivity> activities;
  final bool pregnant;

  // Identity fields (optional where the spec allows).
  final String? name;
  final String? eidRfid;
  final String? color;
  final String? markings;
  final String? source;
  final DateTime? purchaseDate;
  final double? purchasePrice;
  final String notes;
  final String? photoAssetPath;
  final bool birthDateUnknown;

  SheepRecord copyWith({
    String? tagNumber,
    String? breed,
    SheepSex? sex,
    double? weightKg,
    double? bcs,
    SheepHealthStatus? status,
    String? nextRoutine,
    String? groupName,
    DateTime? birthDate,
    String? location,
    bool? pregnant,
    String? name,
    String? eidRfid,
    String? color,
    String? markings,
    String? source,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? notes,
    String? photoAssetPath,
    bool? birthDateUnknown,
  }) => SheepRecord(
    id: id,
    tagNumber: tagNumber ?? this.tagNumber,
    breed: breed ?? this.breed,
    sex: sex ?? this.sex,
    weightKg: weightKg ?? this.weightKg,
    bcs: bcs ?? this.bcs,
    status: status ?? this.status,
    nextRoutine: nextRoutine ?? this.nextRoutine,
    groupName: groupName ?? this.groupName,
    birthDate: birthDate ?? this.birthDate,
    location: location ?? this.location,
    activities: activities,
    pregnant: pregnant ?? this.pregnant,
    name: name ?? this.name,
    eidRfid: eidRfid ?? this.eidRfid,
    color: color ?? this.color,
    markings: markings ?? this.markings,
    source: source ?? this.source,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    notes: notes ?? this.notes,
    photoAssetPath: photoAssetPath ?? this.photoAssetPath,
    birthDateUnknown: birthDateUnknown ?? this.birthDateUnknown,
  );
}

class SheepActivity {
  const SheepActivity(this.date, this.title, this.details);

  final DateTime date;
  final String title;
  final String details;
}
