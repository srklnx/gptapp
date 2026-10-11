import '../../../l10n/generated/app_localizations.dart';
import '../domain/parasite_records.dart';
import '../domain/parasite_service.dart';

abstract final class ParasiteLabels {
  static String reason(AppLocalizations s, DewormingReason r) => switch (r) {
    DewormingReason.treatment => s.dewormingReasonTreatment,
    DewormingReason.positiveTest => s.dewormingReasonPositiveTest,
    DewormingReason.famachaAnemia => s.dewormingReasonFamacha,
    DewormingReason.routineProtocol => s.dewormingReasonRoutine,
    DewormingReason.groupTreatment => s.dewormingReasonGroup,
    DewormingReason.veterinaryRecommendation => s.dewormingReasonVet,
    DewormingReason.other => s.dewormingReasonOther,
  };

  static String testType(AppLocalizations s, FecalTestType t) => switch (t) {
    FecalTestType.fecalEggCount => s.testTypeFecalEggCount,
    FecalTestType.mcmaster => s.testTypeMcMaster,
    FecalTestType.oocystCount => s.testTypeOocyst,
    FecalTestType.general => s.testTypeGeneral,
    FecalTestType.other => s.testTypeOther,
  };

  static String resultLevel(AppLocalizations s, FecalResultLevel l) =>
      switch (l) {
        FecalResultLevel.negative => s.fecalNegative,
        FecalResultLevel.low => s.fecalLow,
        FecalResultLevel.moderate => s.fecalModerate,
        FecalResultLevel.high => s.fecalHigh,
        FecalResultLevel.specificParasite => s.fecalSpecific,
        FecalResultLevel.pending => s.fecalPending,
      };

  static String response(AppLocalizations s, TreatmentResponse r) =>
      switch (r) {
        TreatmentResponse.improved => s.responseImproved,
        TreatmentResponse.unchanged => s.responseUnchanged,
        TreatmentResponse.worse => s.responseWorse,
        TreatmentResponse.unknown => s.responseUnknown,
      };

  static String risk(AppLocalizations s, ParasiteRiskLevel l) => switch (l) {
    ParasiteRiskLevel.low => s.riskLow,
    ParasiteRiskLevel.monitor => s.riskMonitor,
    ParasiteRiskLevel.needsAssessment => s.riskNeedsAssessment,
    ParasiteRiskLevel.highConcern => s.riskHighConcern,
  };

  static String trend(AppLocalizations s, FamachaTrend t) => switch (t) {
    FamachaTrend.improving => s.responseImproved,
    FamachaTrend.stable => s.stable,
    FamachaTrend.worsening => s.famachaWorsening,
    FamachaTrend.insufficient => s.riskNeedsAssessment,
  };
}
