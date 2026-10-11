import '../../../l10n/generated/app_localizations.dart';
import '../../health/domain/condition.dart';
import '../../health/domain/health_observation.dart';
import '../../quick_log/domain/care_records.dart';
import '../../tasks/domain/farm_task.dart';

/// Maps stable domain ids to localized, user-visible labels.
abstract final class HealthLabels {
  static String symptom(AppLocalizations s, String id) => switch (id) {
    'not_eating' => s.symptomNotEating,
    'reduced_appetite' => s.symptomReducedAppetite,
    'diarrhea' => s.symptomDiarrhea,
    'constipation' => s.symptomConstipation,
    'bloating' => s.symptomBloating,
    'abnormal_stool' => s.symptomAbnormalStool,
    'drinking_less' => s.symptomDrinkingLess,
    'not_drinking' => s.symptomNotDrinking,
    'coughing' => s.symptomCoughing,
    'difficulty_breathing' => s.symptomDifficultyBreathing,
    'nasal_discharge' => s.symptomNasalDischarge,
    'eye_redness' => s.symptomEyeRedness,
    'eye_discharge' => s.symptomEyeDischarge,
    'eye_cloudiness' => s.symptomEyeCloudiness,
    'eye_swelling' => s.symptomEyeSwelling,
    'keeps_eye_closed' => s.symptomKeepsEyeClosed,
    'possible_eye_injury' => s.symptomPossibleEyeInjury,
    'lameness' => s.symptomLameness,
    'swollen_joint' => s.symptomSwollenJoint,
    'hoof_problem' => s.symptomHoofProblem,
    'itching' => s.symptomItching,
    'hair_loss' => s.symptomHairLoss,
    'skin_lesion' => s.symptomSkinLesion,
    'weakness' => s.symptomWeakness,
    'lethargy' => s.symptomLethargy,
    'fever' => s.symptomFever,
    'weight_loss' => s.symptomWeightLoss,
    'pale_eyelids' => s.symptomPaleEyelids,
    'abnormal_urine' => s.symptomAbnormalUrine,
    'other' => s.symptomOther,
    'rapid_breathing' => s.symptomRapidBreathing,
    'tearing' => s.symptomTearing,
    'hoof_swelling' => s.symptomHoofSwelling,
    'hoof_bad_odor' => s.symptomHoofBadOdor,
    'abdominal_pain' => s.symptomAbdominalPain,
    'bottle_jaw' => s.symptomBottleJaw,
    'recumbent' => s.symptomRecumbent,
    'neurologic_signs' => s.symptomNeurologicSigns,
    'sudden_illness' => s.symptomSuddenIllness,
    'sudden_death' => s.symptomSuddenDeath,
    'crusts' => s.symptomCrusts,
    'visible_parasites' => s.symptomVisibleParasites,
    _ => id,
  };

  static String category(AppLocalizations s, SymptomCategory category) =>
      switch (category) {
        SymptomCategory.eating => s.symptomCategoryEating,
        SymptomCategory.breathing => s.symptomCategoryBreathing,
        SymptomCategory.eyes => s.symptomCategoryEyes,
        SymptomCategory.movement => s.symptomCategoryMovement,
        SymptomCategory.skin => s.symptomCategorySkin,
        SymptomCategory.general => s.symptomCategoryGeneral,
        SymptomCategory.other => s.symptomCategoryOther,
      };

  static String question(AppLocalizations s, String id) => switch (id) {
    'appetite_duration' => s.qAppetiteDuration,
    'drinking' => s.qDrinking,
    'appetite_other_signs' => s.qAppetiteOtherSigns,
    'diarrhea_duration' => s.qDiarrheaDuration,
    'stool_appearance' => s.qStoolAppearance,
    'diarrhea_other_signs' => s.qDiarrheaOtherSigns,
    'eye_what_see' => s.qEyeWhatSee,
    'eye_one_or_both' => s.qEyeOneOrBoth,
    'eye_rubbing' => s.qEyeRubbing,
    'eye_injury' => s.qEyeInjury,
    'lameness_severity' => s.qLamenessSeverity,
    'lameness_leg' => s.qLamenessLeg,
    'hoof_appearance' => s.qHoofAppearance,
    _ => id,
  };

  static String option(AppLocalizations s, String id) => switch (id) {
    'less_12h' => s.optLess12h,
    '12_24h' => s.opt12_24h,
    '1_2_days' => s.opt1_2Days,
    'more_2_days' => s.optMore2Days,
    'unknown' => s.optUnknown,
    'normally' => s.optNormally,
    'less_than_normal' => s.optLessThanNormal,
    'not_drinking' => s.optNotDrinking,
    'teeth_grinding' => s.optTeethGrinding,
    'less_1_day' => s.optLess1Day,
    '3_5_days' => s.opt3_5Days,
    'more_5_days' => s.optMore5Days,
    'loose' => s.optLoose,
    'watery' => s.optWatery,
    'very_watery' => s.optVeryWatery,
    'mucus' => s.optMucus,
    'blood' => s.optBlood,
    'redness' => s.optRedness,
    'cloudiness' => s.optCloudiness,
    'discharge' => s.optDischarge,
    'swelling' => s.optSwelling,
    'keeps_closed' => s.optKeepsClosed,
    'tearing' => s.optTearing,
    'possible_injury' => s.optPossibleInjury,
    'difficulty_seeing' => s.optDifficultySeeing,
    'left' => s.optLeft,
    'right' => s.optRight,
    'both' => s.optBoth,
    'yes' => s.optYes,
    'no' => s.optNo,
    'not_sure' => s.optNotSure,
    'slight' => s.optSlight,
    'moderate' => s.optModerate,
    'severe' => s.optSevere,
    'unable_to_walk' => s.optUnableToWalk,
    'front_left' => s.optFrontLeft,
    'front_right' => s.optFrontRight,
    'rear_left' => s.optRearLeft,
    'rear_right' => s.optRearRight,
    'normal' => s.optNormal,
    'overgrown' => s.optOvergrown,
    'damaged' => s.optDamaged,
    'swollen' => s.optSwollen,
    'bad_odor' => s.optBadOdor,
    _ => id,
  };

  static String check(AppLocalizations s, String id) => switch (id) {
    'check_temperature' => s.checkTemperature,
    'check_hydration' => s.checkHydration,
    'check_eyelid_color' => s.checkEyelidColor,
    'check_feces' => s.checkFeces,
    'check_feed_changes' => s.checkFeedChanges,
    'check_other_sheep' => s.checkOtherSheep,
    'monitor_water' => s.monitorWater,
    'examine_eye_light' => s.examineEyeLight,
    'check_foreign_material' => s.checkForeignMaterial,
    'monitor_vision' => s.monitorVision,
    'inspect_hoof' => s.inspectHoof,
    'famacha_score' => s.checkFamacha,
    'fecal_egg_count' => s.checkFecalEggCount,
    'body_condition' => s.checkBodyCondition,
    'deworming_history' => s.checkDewormingHistory,
    'age_check' => s.checkAge,
    'fecal_exam' => s.checkFecalExam,
    'blood_mucus' => s.checkBloodMucus,
    'gestation_stage' => s.checkGestationStage,
    'litter_size' => s.checkLitterSize,
    'ketone_bhb' => s.checkKetoneBhb,
    'blood_glucose' => s.checkBloodGlucose,
    'respiratory_rate' => s.checkRespiratoryRate,
    'rumen_check' => s.checkRumen,
    'vaccination_status' => s.checkVaccinationStatus,
    'affected_age_group' => s.checkAffectedAgeGroup,
    'number_affected' => s.checkNumberAffected,
    'corneal_check' => s.checkCorneal,
    'one_both_eyes' => s.checkOneBothEyes,
    'ulcer_injury' => s.checkUlcerInjury,
    'pain_squinting' => s.checkPainSquinting,
    'vision_check' => s.checkVision,
    'hoof_odor_check' => s.checkHoofOdor,
    'visible_parasites_check' => s.checkVisibleParasites,
    'affected_areas' => s.checkAffectedAreas,
    'nasal_discharge_check' => s.checkNasalDischarge,
    'drinking_check' => s.checkDrinking,
    'recent_feed_change' => s.checkRecentFeedChange,
    _ => id,
  };

  static String area(AppLocalizations s, String id) => switch (id) {
    'digestive_problem' => s.areaDigestiveProblem,
    'feed_related' => s.areaFeedRelated,
    'parasite_burden' => s.areaParasiteBurden,
    'infection' => s.areaInfection,
    'dental_mouth' => s.areaDentalMouth,
    'pain_injury' => s.areaPainInjury,
    'underlying' => s.areaUnderlying,
    'eye_irritation' => s.areaEyeIrritation,
    'eye_injury' => s.areaEyeInjury,
    'eye_infection' => s.areaEyeInfection,
    'eye_foreign_material' => s.areaEyeForeignMaterial,
    'hoof_problem' => s.areaHoofProblem,
    'joint_problem' => s.areaJointProblem,
    _ => id,
  };

  static String action(AppLocalizations s, String id) => switch (id) {
    'monitor_closely' => s.actionMonitorClosely,
    'inspect_eye' => s.actionInspectEye,
    'inspect_hoof' => s.actionInspectHoof,
    'separate_flock' => s.actionSeparateFlock,
    'isolate' => s.actionIsolate,
    'clean_water' => s.actionCleanWater,
    'assess_now' => s.actionAssessNow,
    'remove_feed_access' => s.actionRemoveFeed,
    'contact_vet' => s.actionContactVet,
    'record_temperature' => s.actionRecordTemperature,
    'inspect_eyes' => s.actionInspectEyes,
    'check_mucous_membrane' => s.actionCheckMucousMembrane,
    'move_clean_dry' => s.actionMoveCleanDry,
    'support_nutrition' => s.actionSupportNutrition,
    'monitor_flock' => s.actionMonitorFlock,
    'review_vaccination' => s.actionReviewVaccination,
    _ => id,
  };

  static String redFlag(AppLocalizations s, String id) => switch (id) {
    'severe_breathing' => s.redFlagSevereBreathing,
    'severe_bloating' => s.redFlagSevereBloating,
    'severe_weakness' => s.redFlagSevereWeakness,
    'not_drinking' => s.redFlagNotDrinking,
    'unable_to_stand' => s.redFlagUnableToStand,
    'severe_eye_injury' => s.redFlagSevereEyeInjury,
    'neurologic_signs' => s.redFlagNeurologicSigns,
    'sudden_death' => s.redFlagSuddenDeath,
    'severe_dehydration' => s.redFlagSevereDehydration,
    _ => id,
  };

  static String severity(AppLocalizations s, HealthSeverity severity) =>
      switch (severity) {
        HealthSeverity.mild => s.severityMild,
        HealthSeverity.moderate => s.severityModerate,
        HealthSeverity.severe => s.severitySevere,
      };

  static String medicationCategory(AppLocalizations s, MedicationCategory c) =>
      switch (c) {
        MedicationCategory.antibiotic => s.categoryAntibiotic,
        MedicationCategory.antiparasitic => s.categoryAntiparasitic,
        MedicationCategory.antiInflammatory => s.categoryAntiInflammatory,
        MedicationCategory.painRelief => s.categoryPainRelief,
        MedicationCategory.vitaminMineral => s.categoryVitaminMineral,
        MedicationCategory.electrolyte => s.categoryElectrolyte,
        MedicationCategory.eyeTreatment => s.categoryEyeTreatment,
        MedicationCategory.topicalTreatment => s.categoryTopicalTreatment,
        MedicationCategory.hoofTreatment => s.categoryHoofTreatment,
        MedicationCategory.other => s.categoryOther,
      };

  static String route(AppLocalizations s, TreatmentRoute route) => switch (route) {
    TreatmentRoute.oral => s.routeOral,
    TreatmentRoute.injection => s.routeInjection,
    TreatmentRoute.topical => s.routeTopical,
    TreatmentRoute.intramuscular => s.routeIntramuscular,
    TreatmentRoute.subcutaneous => s.routeSubcutaneous,
    TreatmentRoute.eye => s.routeEye,
    TreatmentRoute.other => s.routeOther,
  };

  static String priority(AppLocalizations s, TaskPriority priority) =>
      switch (priority) {
        TaskPriority.low => s.priorityLow,
        TaskPriority.normal => s.priorityNormal,
        TaskPriority.high => s.priorityHigh,
      };

  static String identityField(AppLocalizations s, String field) =>
      switch (field) {
        'tag' => s.tagNumber,
        'breed' => s.breed,
        'group' => s.group,
        _ => field,
      };

  static String condition(AppLocalizations s, String id) => switch (id) {
    'haemonchosis' => s.conditionHaemonchosis,
    'gastrointestinal_parasitism' => s.conditionGastrointestinalParasitism,
    'coccidiosis' => s.conditionCoccidiosis,
    'grain_overload' => s.conditionGrainOverload,
    'enterotoxemia' => s.conditionEnterotoxemia,
    'bacterial_pneumonia' => s.conditionBacterialPneumonia,
    'respiratory_disease' => s.conditionRespiratoryDisease,
    'pinkeye' => s.conditionPinkeye,
    'footrot' => s.conditionFootrot,
    'pregnancy_toxemia' => s.conditionPregnancyToxemia,
    'hypocalcemia' => s.conditionHypocalcemia,
    'external_parasites' => s.conditionExternalParasites,
    'dehydration' => s.conditionDehydration,
    'fever_infection_syndrome' => s.conditionFeverInfection,
    'general_enteritis' => s.conditionGeneralEnteritis,
    'salmonellosis' => s.conditionSalmonellosis,
    _ => id,
  };

  static String conditionCategory(AppLocalizations s, ConditionCategory c) =>
      switch (c) {
        ConditionCategory.digestive => s.categoryDigestive,
        ConditionCategory.respiratory => s.categoryRespiratory,
        ConditionCategory.eye => s.categoryEye,
        ConditionCategory.hoof => s.categoryHoof,
        ConditionCategory.metabolic => s.categoryMetabolic,
        ConditionCategory.parasite => s.categoryParasite,
        ConditionCategory.skin => s.categorySkin,
        ConditionCategory.general => s.categoryGeneral,
        ConditionCategory.reproductive => s.categoryReproductive,
      };

  static String protocolName(AppLocalizations s, String id) => switch (id) {
    'supportive_care' => s.protocolSupportiveCare,
    'parasite_control' => s.protocolParasiteControl,
    'anticoccidial_therapy' => s.protocolAnticoccidialTherapy,
    'antimicrobial_when_indicated' => s.protocolAntimicrobialWhenIndicated,
    'ophthalmic_treatment' => s.protocolOphthalmic,
    'footbath_hoof_management' => s.protocolFootbathHoof,
    'veterinary_metabolic' => s.protocolMetabolic,
    'isolation' => s.protocolIsolation,
    'monitoring' => s.protocolMonitoring,
    'topical_treatment' => s.protocolTopical,
    'preventive_vaccination' => s.protocolPreventiveVaccination,
    'electrolyte_fluid_support' => s.protocolElectrolyte,
    _ => id,
  };

  static String compatibility(AppLocalizations s, CompatibilityLevel level) =>
      switch (level) {
        CompatibilityLevel.stronglyCompatible => s.compatibilityStronglyCompatible,
        CompatibilityLevel.compatible => s.compatibilityCompatible,
        CompatibilityLevel.possible => s.compatibilityPossible,
        CompatibilityLevel.lessLikely => s.compatibilityLessLikely,
        CompatibilityLevel.insufficient => s.compatibilityInsufficient,
      };

  static String riskLevel(AppLocalizations s, HealthRiskLevel level) =>
      switch (level) {
        HealthRiskLevel.routine => s.riskRoutine,
        HealthRiskLevel.needsAttention => s.riskNeedsAttention,
        HealthRiskLevel.urgent => s.riskUrgent,
      };

  static String riskFactor(AppLocalizations s, String key) => switch (key) {
    'recent_feed_change' => s.riskRecentFeedChange,
    'recent_grain_access' => s.riskRecentGrainAccess,
    'multiple_affected' => s.riskMultipleAffected,
    'crowded' => s.riskCrowded,
    'pasture_exposure' => s.riskPastureExposure,
    'wet_conditions' => s.riskWetConditions,
    'recent_transport' => s.riskRecentTransport,
    'recent_stress' => s.riskRecentStress,
    'pregnant' => s.riskPregnant,
    'late_gestation' => s.riskLateGestation,
    'low_bcs' => s.riskLowBcs,
    'lactating' => s.riskLactating,
    'neonatal' => s.ageGroupNeonatal,
    'young_lamb' => s.ageGroupYoungLamb,
    'growing_lamb' => s.ageGroupGrowingLamb,
    'adult' => s.ageGroupAdult,
    'senior' => s.ageGroupSenior,
    _ => key,
  };

  static String labelStatus(AppLocalizations s, LabelStatus status) =>
      switch (status) {
        LabelStatus.approvedForSheep => s.labelStatusApprovedForSheep,
        LabelStatus.approvedForIndication => s.labelStatusApprovedForIndication,
        LabelStatus.veterinaryDirected => s.labelStatusVeterinaryDirected,
        LabelStatus.verificationRequired => s.labelStatusVerificationRequired,
        LabelStatus.unknown => s.labelStatusUnknown,
      };
}
