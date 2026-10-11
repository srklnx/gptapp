import 'package:flutter/foundation.dart';

enum DewormingReason {
  treatment,
  positiveTest,
  famachaAnemia,
  routineProtocol,
  groupTreatment,
  veterinaryRecommendation,
  other,
}

enum AnthelminticClass {
  benzimidazole,
  macrocyclicLactone,
  imidazothiazole,
  other,
  unknown,
}

enum FecalTestType { fecalEggCount, mcmaster, oocystCount, general, other }

enum FecalResultLevel { negative, low, moderate, high, specificParasite, pending }

enum TreatmentResponse { improved, unchanged, worse, unknown }

enum ParasiteRiskLevel { low, monitor, needsAssessment, highConcern }

/// Structured parasite assessment collected before a deworming decision.
@immutable
class ParasiteAssessment {
  const ParasiteAssessment({
    required this.id,
    required this.sheepId,
    required this.date,
    required this.observer,
    this.famachaScore,
    this.bcs,
    this.weightKg,
    this.bottleJaw,
    this.diarrhea,
    this.weightLoss,
    this.paleEyelids,
    this.recentFecalTest,
    this.lastDewormingDate,
    this.previousProduct,
    this.otherSheepAffected,
    this.notes = '',
  });

  final String id;
  final String sheepId;
  final DateTime date;
  final String observer;
  final int? famachaScore;
  final double? bcs;
  final double? weightKg;
  final bool? bottleJaw;
  final bool? diarrhea;
  final bool? weightLoss;
  final bool? paleEyelids;
  final bool? recentFecalTest;
  final DateTime? lastDewormingDate;
  final String? previousProduct;
  final bool? otherSheepAffected;
  final String notes;
}

/// A fecal laboratory test result.
@immutable
class FecalTestRecord {
  const FecalTestRecord({
    required this.id,
    required this.sheepId,
    required this.date,
    required this.testType,
    this.fecalEggCount,
    this.parasitesDetected = const [],
    this.resultLevel = FecalResultLevel.pending,
    this.laboratory = '',
    this.notes = '',
  });

  final String id;
  final String sheepId;
  final DateTime date;
  final FecalTestType testType;
  final int? fecalEggCount;
  final List<String> parasitesDetected;
  final FecalResultLevel resultLevel;
  final String laboratory;
  final String notes;
}

/// A recorded deworming treatment with a medication snapshot and response
/// tracking. Historical records are immutable and never recalculated from the
/// current medication library.
@immutable
class DewormingRecord {
  const DewormingRecord({
    required this.id,
    required this.sheepId,
    required this.reason,
    required this.medicationId,
    required this.activeIngredient,
    required this.dose,
    required this.doseUnit,
    required this.route,
    required this.administeredAt,
    required this.administeredBy,
    required this.withdrawalDays,
    required this.clearanceDate,
    this.productId,
    this.concentration,
    this.weightAtTreatment,
    this.veterinaryDirected = false,
    this.protocolId,
    this.notes = '',
    this.followUpDate,
    this.responseStatus,
    this.eventId,
  });

  final String id;
  final String sheepId;
  final DewormingReason reason;
  final String medicationId;
  final String? productId;
  final String activeIngredient;
  final String? concentration;
  final double dose;
  final String doseUnit;
  final String route;
  final DateTime administeredAt;
  final String administeredBy;
  final double? weightAtTreatment;
  final int withdrawalDays;
  final DateTime clearanceDate;
  final bool veterinaryDirected;
  final String? protocolId;
  final String notes;
  final DateTime? followUpDate;
  final TreatmentResponse? responseStatus;
  final String? eventId;

  DewormingRecord copyWith({
    TreatmentResponse? responseStatus,
  }) => DewormingRecord(
    id: id,
    sheepId: sheepId,
    reason: reason,
    medicationId: medicationId,
    productId: productId,
    activeIngredient: activeIngredient,
    concentration: concentration,
    dose: dose,
    doseUnit: doseUnit,
    route: route,
    administeredAt: administeredAt,
    administeredBy: administeredBy,
    weightAtTreatment: weightAtTreatment,
    withdrawalDays: withdrawalDays,
    clearanceDate: clearanceDate,
    veterinaryDirected: veterinaryDirected,
    protocolId: protocolId,
    notes: notes,
    followUpDate: followUpDate,
    responseStatus: responseStatus,
    eventId: eventId,
  );
}

/// A derived (never manually stored) parasite risk assessment.
@immutable
class ParasiteRiskAssessment {
  const ParasiteRiskAssessment({
    required this.riskLevel,
    required this.reasons,
  });

  final ParasiteRiskLevel riskLevel;
  final List<String> reasons;

  bool get needsAction =>
      riskLevel == ParasiteRiskLevel.needsAssessment ||
      riskLevel == ParasiteRiskLevel.highConcern;
}
