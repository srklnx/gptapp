import 'package:flutter/foundation.dart';

enum HealthCaseStatus { open, monitoring, treatment, awaitingVetReview, improving, resolved, chronic, closed }

/// Groups related observations/treatments for one or more sheep into a
/// longitudinal health case.
@immutable
class HealthCase {
  const HealthCase({
    required this.id,
    required this.sheepIds,
    required this.startedAt,
    this.symptoms = const [],
    this.suspectedConditions = const [],
    this.severity,
    this.status = HealthCaseStatus.open,
    this.outbreakFlag = false,
    this.diagnosis,
    this.diagnosisConfirmed = false,
    this.confirmedBy,
    this.treatmentIds = const [],
    this.followUpTaskIds = const [],
    this.closedAt,
  });

  final String id;
  final List<String> sheepIds;
  final DateTime startedAt;
  final List<String> symptoms;
  final List<String> suspectedConditions;
  final String? severity;
  final HealthCaseStatus status;
  final bool outbreakFlag;
  final String? diagnosis;
  final bool diagnosisConfirmed;
  final String? confirmedBy;
  final List<String> treatmentIds;
  final List<String> followUpTaskIds;
  final DateTime? closedAt;
}

/// A veterinarian-confirmed diagnosis, kept separate from symptom-based
/// assessment.
@immutable
class VeterinaryDiagnosis {
  const VeterinaryDiagnosis({
    required this.id,
    required this.sheepId,
    required this.diagnosis,
    required this.veterinarian,
    required this.date,
    this.diagnosticMethod = '',
    this.laboratoryResult = '',
    this.notes = '',
  });

  final String id;
  final String sheepId;
  final String diagnosis;
  final String veterinarian;
  final DateTime date;
  final String diagnosticMethod;
  final String laboratoryResult;
  final String notes;
}
