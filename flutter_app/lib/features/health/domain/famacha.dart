import 'package:flutter/foundation.dart';

/// FAMACHA-compatible eyelid-color score (1–5). The app never claims this
/// alone diagnoses anemia.
@immutable
class FamachaRecord {
  const FamachaRecord({
    required this.id,
    required this.sheepId,
    required this.score,
    required this.date,
    required this.observer,
    this.notes = '',
    this.weightKg,
    this.bcs,
    this.eventId,
  });

  final String id;
  final String sheepId;
  final int score;
  final DateTime date;
  final String observer;
  final String notes;
  final double? weightKg;
  final double? bcs;
  final String? eventId;

  static bool isValid(int score) => score >= 1 && score <= 5;
}

/// A photo attached to a health observation (architecture prepared; camera
/// integration is optional for now).
@immutable
class HealthAttachment {
  const HealthAttachment({
    required this.id,
    required this.healthObservationId,
    required this.localPath,
    required this.type,
    required this.createdAt,
    this.uploaded = false,
  });

  final String id;
  final String healthObservationId;
  final String localPath;
  final String type;
  final DateTime createdAt;
  final bool uploaded;
}

/// Version metadata for the downloadable health-guidance knowledge base.
@immutable
class HealthKnowledgeVersion {
  const HealthKnowledgeVersion({
    required this.version,
    required this.publishedAt,
    required this.source,
    required this.region,
    required this.lastVerifiedAt,
  });

  final String version;
  final DateTime publishedAt;
  final String source;
  final String region;
  final DateTime lastVerifiedAt;
}
