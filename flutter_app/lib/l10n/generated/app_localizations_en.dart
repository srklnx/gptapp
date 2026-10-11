// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HerdHub Sheep';

  @override
  String get home => 'Home';

  @override
  String get flock => 'Flock';

  @override
  String get tasks => 'Tasks';

  @override
  String get breeding => 'Breeding';

  @override
  String get more => 'More';

  @override
  String get quickLog => 'Quick Log';

  @override
  String get settings => 'Settings';

  @override
  String get sync => 'Sync';

  @override
  String placeholderTitle(String page) {
    return '$page foundation';
  }

  @override
  String get placeholderBody =>
      'This screen is intentionally a Stage 0 placeholder.';

  @override
  String get theme => 'Appearance';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get sunMode => 'Sun Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get selectTheme => 'Select appearance';

  @override
  String get quickLogComingSoon =>
      'Quick Log workflow will be added in a later stage.';

  @override
  String get whatToRecord => 'What do you want to record?';

  @override
  String get healthActions => 'Health';

  @override
  String get conditionActions => 'Condition';

  @override
  String get breedingActions => 'Breeding';

  @override
  String get otherActions => 'Other';

  @override
  String get treatmentAction => 'Treatment';

  @override
  String get vaccinationAction => 'Vaccination';

  @override
  String get dewormingAction => 'Deworming';

  @override
  String get dippingAction => 'Dipping / Parasite';

  @override
  String get hoofTrimAction => 'Hoof trim';

  @override
  String get shearingAction => 'Shearing';

  @override
  String get weightAction => 'Weight';

  @override
  String get bcsAction => 'BCS';

  @override
  String get heatCheckAction => 'Heat check';

  @override
  String get feedWaterAction => 'Feed / Water';

  @override
  String get matingAction => 'Mating';

  @override
  String get pregnancyAction => 'Pregnancy';

  @override
  String get lambingAction => 'Lambing';

  @override
  String get photoAction => 'Photo';

  @override
  String get voiceNoteAction => 'Voice note';

  @override
  String get noteAction => 'Note';

  @override
  String get selectSheep => 'Sheep';

  @override
  String get selectMedication => 'Medication';

  @override
  String get dose => 'Dose';

  @override
  String get route => 'Route';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes';

  @override
  String get saveTreatment => 'Save treatment';

  @override
  String get treatmentRecorded => 'Treatment recorded';

  @override
  String get followUpCreated => 'Follow-up task created';

  @override
  String get treatmentWithdrawalNotice =>
      'Withdrawal is calculated automatically from this treatment.';

  @override
  String get meatWithdrawal => 'Meat withdrawal';

  @override
  String get milkWithdrawal => 'Milk withdrawal';

  @override
  String days(int count) {
    return '$count days';
  }

  @override
  String recordAction(String action) {
    return 'Record $action';
  }

  @override
  String get saveRecord => 'Save record';

  @override
  String get recorded => 'Recorded';

  @override
  String get value => 'Value';

  @override
  String get invalidValue => 'Enter a valid value.';

  @override
  String get invalidDose => 'Enter a dose greater than zero.';

  @override
  String get bcsValueHelp => 'Enter a score from 0 to 5.';

  @override
  String get routeOral => 'Oral';

  @override
  String get routeInjection => 'Injection';

  @override
  String get routeTopical => 'Topical';

  @override
  String get routeIntramuscular => 'Intramuscular';

  @override
  String get routeSubcutaneous => 'Subcutaneous';

  @override
  String recordTreatmentFor(String tag) {
    return 'Treatment for #$tag';
  }

  @override
  String get activeTreatment => 'Active treatment';

  @override
  String get clearance => 'Clearance';

  @override
  String get noActiveTreatment => 'No active withdrawal';

  @override
  String get treatmentFollowUp => 'Treatment follow-up';

  @override
  String get groups => 'Groups';

  @override
  String get savedViewsTitle => 'Saved views';

  @override
  String groupCount(int count) {
    return '$count sheep';
  }

  @override
  String get groupLocation => 'Location';

  @override
  String get groupCurrentTask => 'Current task';

  @override
  String get groupStatus => 'Status';

  @override
  String get groupStatusNormal => 'On track';

  @override
  String get groupStatusAttention => 'Needs attention';

  @override
  String get groupStatusUrgent => 'Urgent';

  @override
  String get openGroups => 'Manage groups';

  @override
  String get viewGroup => 'Open group';

  @override
  String get bulkAction => 'Bulk action';

  @override
  String get chooseBulkAction => 'Choose an action';

  @override
  String sheepSelected(int count) {
    return '$count sheep selected';
  }

  @override
  String vaccinateCount(int count) {
    return 'Vaccinate $count Sheep';
  }

  @override
  String completeActionCount(String action, int count) {
    return 'Record $action for $count sheep';
  }

  @override
  String bulkActionSaved(int count) {
    return '$count records saved';
  }

  @override
  String get undo => 'Undo';

  @override
  String get bulkActionUndone => 'Bulk action undone';

  @override
  String get bulkActionFailed => 'Could not safely undo this bulk action.';

  @override
  String get taskToday => 'Today';

  @override
  String get taskUpcoming => 'Upcoming';

  @override
  String get taskCompleted => 'Completed';

  @override
  String get taskPending => 'Pending';

  @override
  String get taskInProgress => 'In progress';

  @override
  String get taskSkipped => 'Skipped';

  @override
  String get taskCancelled => 'Cancelled';

  @override
  String get taskStart => 'Start';

  @override
  String get taskComplete => 'Complete';

  @override
  String get taskSkip => 'Skip';

  @override
  String get taskEmpty => 'No tasks in this list.';

  @override
  String nextTaskDue(String date) {
    return 'Next task due $date';
  }

  @override
  String get upcomingSavedViewWithdrawal => 'Withdrawal active';

  @override
  String get upcomingSavedViewLowBcs => 'Low BCS';

  @override
  String get upcomingSavedViewVaccination => 'Due for vaccination';

  @override
  String get upcomingSavedViewEid => 'Eid candidates';

  @override
  String get bulkVaccination => 'Vaccination';

  @override
  String get bulkDeworming => 'Deworming';

  @override
  String get bulkWeight => 'Record weight';

  @override
  String get bulkBcs => 'BCS check';

  @override
  String get taskUpdated => 'Task updated';

  @override
  String get groupNotFound => 'Group not found';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get openSync => 'Open Sync Center';

  @override
  String get openBreeding => 'Open Breeding';

  @override
  String get farmName => 'Al Noor Farm';

  @override
  String get flockName => 'North Flock';

  @override
  String get sheepCount => '486 sheep';

  @override
  String get heatRiskHigh => 'HEAT RISK · HIGH';

  @override
  String get offlinePending => 'Offline · Changes saved locally';

  @override
  String get pendingCount => '12 pending';

  @override
  String get needsAttention => 'Needs attention';

  @override
  String get urgentCount => 'Urgent';

  @override
  String get dueTodayCount => 'Due today';

  @override
  String get dueWeekCount => 'Due this week';

  @override
  String get vaccinationDue => 'Vaccination due';

  @override
  String get withdrawalActive => 'Withdrawal active';

  @override
  String get lowBcs => 'Low BCS';

  @override
  String get heatCheck => 'Heat check';

  @override
  String get pregnantEwes => 'Pregnant Ewes';

  @override
  String get priorityHigh => 'High';

  @override
  String get taskCheckWater => 'Check Water';

  @override
  String get taskWeighLambs => 'Weigh Lambs';

  @override
  String get taskBcsCheck => 'BCS Check';

  @override
  String get northPasture => 'North Pasture';

  @override
  String get groupB => 'Group B';

  @override
  String get ewesTwelve => '12 ewes';

  @override
  String get flockSnapshot => 'Flock snapshot';

  @override
  String get total => 'Total';

  @override
  String get ewes => 'Ewes';

  @override
  String get rams => 'Rams';

  @override
  String get lambs => 'Lambs';

  @override
  String get pregnantCount => 'Pregnant';

  @override
  String get humidity => 'humidity';

  @override
  String get recommended => 'Recommended';

  @override
  String get moveToShade => 'Move to shade';

  @override
  String get checkWater => 'Check water';

  @override
  String get avoidHandling => 'Avoid unnecessary handling';

  @override
  String get searchSheep => 'Search tag, group, breed';

  @override
  String get scanTag => 'Scan Tag';

  @override
  String get addSheep => 'Add Sheep';

  @override
  String get addSheepTitle => 'Add sheep';

  @override
  String get duplicateTagError => 'This tag is already in the flock.';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidWeight => 'Enter a valid weight greater than zero.';

  @override
  String get invalidBcs => 'Enter a BCS from 1 to 5.';

  @override
  String get selectBreed => 'Select breed';

  @override
  String get defaultGroup => 'North Flock';

  @override
  String get defaultLocation => 'North Pasture';

  @override
  String get saveSheep => 'Save sheep';

  @override
  String get all => 'All';

  @override
  String get sick => 'Sick';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get dueToday => 'Due Today';

  @override
  String get savedViews => 'Saved views';

  @override
  String get dueVaccination => 'Due for Vaccination';

  @override
  String get dueDeworming => 'Due for Deworming';

  @override
  String get withdrawalView => 'Withdrawal Active';

  @override
  String get pregnantView => 'Pregnant';

  @override
  String get eidCandidates => 'Eid Candidates';

  @override
  String get allSheep => 'All sheep';

  @override
  String get nextRoutine => 'Next';

  @override
  String get weight => 'Weight';

  @override
  String get bcs => 'BCS';

  @override
  String get attention => 'Attention';

  @override
  String get healthy => 'Healthy';

  @override
  String get urgent => 'Urgent';

  @override
  String get sexEwe => 'Ewe';

  @override
  String get sexRam => 'Ram';

  @override
  String get sexLamb => 'Lamb';

  @override
  String get overview => 'Overview';

  @override
  String get health => 'Health';

  @override
  String get identity => 'Identity';

  @override
  String get currentStatus => 'Current status';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get tag => 'Tag';

  @override
  String get breed => 'Breed';

  @override
  String get sex => 'Sex';

  @override
  String get birthDate => 'Birth date';

  @override
  String get group => 'Group';

  @override
  String get location => 'Location';

  @override
  String get healthRoutines => 'Health routines';

  @override
  String get activeTreatments => 'Active treatments';

  @override
  String get breedingStatus => 'Breeding status';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get matingDate => 'Mating date';

  @override
  String get ramLabel => 'Ram';

  @override
  String get expectedLambing => 'Expected lambing';

  @override
  String get weightTrend => 'Weight trend';

  @override
  String get timeline => 'Timeline';

  @override
  String get clearForSale => 'CLEAR FOR SALE';

  @override
  String get notClearForSale => 'NOT CLEAR FOR SALE';

  @override
  String withdrawalDays(int count) {
    return '$count days remaining';
  }

  @override
  String clearanceDate(String date) {
    return 'Clearance · $date';
  }

  @override
  String get noSheepFound => 'No sheep found';

  @override
  String get tryAnotherSearch => 'Try a different search or filter.';

  @override
  String get farmTaskVaccinate => 'Vaccinate Pregnant Ewes';

  @override
  String get farmTaskCheckWater => 'Check Water · North Pasture';

  @override
  String get farmTaskWeighLambs => 'Weigh Lambs · Group B';

  @override
  String get farmTaskBcs => 'BCS Check · 12 ewes';

  @override
  String get activityBcs => 'BCS recorded · 2.5';

  @override
  String get activityTreatment => 'Treatment · Albendazole';

  @override
  String eventTreatmentTitle(String medication) {
    return 'Treatment · $medication';
  }

  @override
  String eventBcsRecorded(String score) {
    return 'BCS recorded · $score';
  }

  @override
  String milkClearanceActive(int days) {
    return 'Milk withdrawal · $days days remaining';
  }

  @override
  String get activityWeight => 'Weight recorded · 62.4 kg';

  @override
  String get activityMating => 'Mating · Karakul #R12';

  @override
  String get activityVaccination => 'Vaccination · Clostridial';

  @override
  String get lastDate => 'Last';

  @override
  String get nextDate => 'Next';

  @override
  String get routineVaccination => 'Vaccination';

  @override
  String get routineDeworming => 'Deworming';

  @override
  String get routineDipping => 'Dipping';

  @override
  String get routineHoof => 'Hoof trimming';

  @override
  String get routineShearing => 'Shearing';

  @override
  String get routineSupplements => 'Supplements';

  @override
  String get profileNotFound => 'Sheep not found';

  @override
  String get profileNotFoundDetails =>
      'This sheep may have been removed from the flock.';

  @override
  String get backToFlock => 'Back to Flock';

  @override
  String get dueInThreeDays => 'in 3 days';

  @override
  String get weightRecorded => 'Weight recorded';

  @override
  String get breedAwassi => 'Awassi';

  @override
  String get breedNajdi => 'Najdi';

  @override
  String get breedNaimi => 'Naimi';

  @override
  String get breedSuffolk => 'Suffolk';

  @override
  String get groupsCount => 'sheep';

  @override
  String get attentionDueVaccination => '4 sheep · vaccination due';

  @override
  String get attentionWithdrawal => '3 sheep · withdrawal active';

  @override
  String withdrawalAlertCount(int count) {
    return '$count sheep · withdrawal active';
  }

  @override
  String get attentionLowBcs => '2 sheep · low body condition';

  @override
  String get attentionHeat => '3 sheep · heat check required';

  @override
  String get seeAll => 'See all';

  @override
  String get pregnancy => 'Pregnancy';

  @override
  String get noWithdrawal => 'No active withdrawal';

  @override
  String get recordWeight => 'Record weight';

  @override
  String get expected => 'Expected';

  @override
  String get lambingHistory => 'Lambing history';

  @override
  String get healthyTwins => 'Twins · healthy';

  @override
  String get todaysTasks => 'Today\'s tasks';

  @override
  String get humidityReading => '28% humidity · 14:20';

  @override
  String get routineDueInDays => 'in 3 days';

  @override
  String treatmentAdministered(
    String date,
    String dose,
    String unit,
    String route,
  ) {
    return 'Administered · $date · $dose $unit $route';
  }

  @override
  String withdrawalClearance(String date) {
    return 'Clearance · $date';
  }

  @override
  String get farmRole => 'Farm manager';

  @override
  String get dewormingInDays => 'due in 12 days';

  @override
  String get hoofTrimInWeeks => 'due in 2 weeks';

  @override
  String get routineNotDue => 'No routine due';

  @override
  String get bcsCheckDue => 'BCS check due';

  @override
  String get weightCheckDue => 'Weight check · 12 Oct';

  @override
  String get withdrawalDueDays => 'Withdrawal · 5 days remaining';

  @override
  String get confirmedPregnancy => 'Confirmed pregnancy';

  @override
  String get numeralSystemTitle => 'Numerals';

  @override
  String get westernNumerals => 'Western numerals (123)';

  @override
  String get arabicIndicNumerals => 'Arabic-Indic numerals (١٢٣)';

  @override
  String get calendarSystemTitle => 'Calendar';

  @override
  String get gregorianCalendar => 'Gregorian';

  @override
  String get hijriCalendar => 'Hijri (calculated)';

  @override
  String ramKarakul(String tag) {
    return 'Karakul #$tag';
  }

  @override
  String pregnancyDayProgress(String day, String total) {
    return 'Pregnancy · day $day of $total';
  }

  @override
  String get recordedByName => 'Recorded by Ahmed';

  @override
  String get southPasture => 'South Pasture';

  @override
  String get dryEwes => 'Dry Ewes';

  @override
  String get eastPaddock => 'East Paddock';

  @override
  String get lambingBarn => 'Lambing Barn';

  @override
  String get lambsGroupB => 'Lambs · Group B';

  @override
  String get eventLabel => 'Event';

  @override
  String get sheepEntity => 'Sheep';

  @override
  String get farmInitials => 'AN';

  @override
  String get userAhmed => 'Ahmed';

  @override
  String get userSara => 'Sara';

  @override
  String get connectionMode => 'Connection mode';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get syncOnlineDescription => 'Online · Ready to sync';

  @override
  String get offlineSavedDescription => 'Offline · Changes saved locally';

  @override
  String pendingCountValue(int count) {
    return '$count pending';
  }

  @override
  String get syncNow => 'Sync Now';

  @override
  String get pendingStatus => 'Pending';

  @override
  String get syncingStatus => 'Syncing';

  @override
  String get syncedStatus => 'Synced';

  @override
  String get failedStatus => 'Failed';

  @override
  String get conflictStatus => 'Conflict';

  @override
  String get syncQueueEmpty => 'No changes in this view.';

  @override
  String get schemaVersion => 'Data schema';

  @override
  String retryCount(int count) {
    return 'Retry $count';
  }

  @override
  String get retry => 'Retry';

  @override
  String get review => 'Review';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get createOperation => 'Create';

  @override
  String get updateOperation => 'Update';

  @override
  String get deleteOperation => 'Delete';

  @override
  String get conflictReview => 'Review sync conflict';

  @override
  String criticalConflictDescription(String entity) {
    return 'A $entity record changed on another device. Review the local record before retrying; critical farm records are never overwritten automatically.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get keepLocalAndRetry => 'Keep local and retry';

  @override
  String get conflictQueuedForReview =>
      'Local record kept for review and queued to sync.';

  @override
  String get savedLocallyWaiting => 'Saved locally · Waiting to sync';

  @override
  String get heatStressTitle => 'Heat stress';

  @override
  String get heatFactors => 'Conditions';

  @override
  String get temperature => 'Temperature';

  @override
  String get thiIndex => 'THI index';

  @override
  String get recheckInThirty => 'Recheck the flock in 30 minutes';

  @override
  String get recordHeatCheck => 'Record heat check';

  @override
  String get recentHeatChecks => 'Recent heat checks';

  @override
  String get noHeatChecks => 'No heat checks recorded yet.';

  @override
  String get symptoms => 'Observed signs';

  @override
  String get panting => 'Panting';

  @override
  String get lethargy => 'Lethargy';

  @override
  String get excessiveSalivation => 'Excessive salivation';

  @override
  String get waterAvailable => 'Water available';

  @override
  String get shadeAvailable => 'Shade available';

  @override
  String get actionsTaken => 'Actions taken';

  @override
  String get heatRiskGuidance =>
      'Use this configurable reading as decision support, not a veterinary diagnosis.';

  @override
  String get heatRiskSafe => 'SAFE';

  @override
  String get heatRiskAlert => 'ALERT';

  @override
  String get heatRiskDanger => 'DANGER';

  @override
  String get heatRiskEmergency => 'EMERGENCY';

  @override
  String get breedingDashboard => 'Breeding';

  @override
  String get breedingDescription =>
      'Keep mating, pregnancy and lambing records together.';

  @override
  String get recordMating => 'Record mating';

  @override
  String get upcomingLambings => 'Upcoming lambings';

  @override
  String get noUpcomingLambings => 'No confirmed upcoming lambings.';

  @override
  String get pregnancyConfirmed => 'Pregnancy confirmed';

  @override
  String siredBy(String tag) {
    return 'Ram #$tag';
  }

  @override
  String get recentMatings => 'Recent matings';

  @override
  String get noRecentMatings => 'No mating records yet.';

  @override
  String get ramNotRecorded => 'Ram not recorded';

  @override
  String get pregnantSheep => 'Pregnant sheep';

  @override
  String lambCount(int count) {
    return '$count lambs';
  }

  @override
  String get ramTag => 'Ram tag';

  @override
  String get eidMode => 'Eid mode';

  @override
  String get eidCountdown => 'Eid al-Adha countdown';

  @override
  String daysToEid(String count) {
    return '$count days remaining';
  }

  @override
  String estimatedEidDate(String date) {
    return 'Estimated date · $date';
  }

  @override
  String get eidDateDisclaimer =>
      'The date is an estimate and may vary by local moon sighting.';

  @override
  String readyCandidates(String ready, String total) {
    return '$ready of $total clear for sale';
  }

  @override
  String get eidStatusReady => 'Meets configured criteria';

  @override
  String get eidStatusUnderweight => 'Below configured weight minimum';

  @override
  String get eidStatusLowBcs => 'BCS below configured range';

  @override
  String get eidStatusHighBcs => 'BCS above configured range';

  @override
  String get eidStatusHealth => 'Health status needs review';

  @override
  String get eidStatusWithdrawal => 'Withdrawal period is active';

  @override
  String get eidHealthClear => 'No recorded health concern';

  @override
  String get eidHealthConcern => 'Health concern';

  @override
  String eidCriteriaSummary(String weight, String bcs) {
    return 'Configured minimums: $weight kg and BCS $bcs.';
  }

  @override
  String get openHeatStress => 'Open heat stress';

  @override
  String get openEid => 'Open Eid mode';

  @override
  String get recordPregnancy => 'Record pregnancy';

  @override
  String get recordLambing => 'Record lambing';

  @override
  String get pregnancyStatus => 'Pregnancy status';

  @override
  String get pregnancyOpen => 'Not pregnant';

  @override
  String get pregnancyAborted => 'Pregnancy loss';

  @override
  String get lambCountLabel => 'Number of lambs';

  @override
  String get noEwesAvailable =>
      'No ewes are available to record this breeding action.';

  @override
  String get ramRequired => 'Enter the ram tag before saving the mating.';

  @override
  String get syncInProgress => 'Sync in progress';

  @override
  String get editSheep => 'Edit sheep';

  @override
  String get edit => 'Edit';

  @override
  String get identificationSection => 'Identification';

  @override
  String get animalInfoSection => 'Animal information';

  @override
  String get managementSection => 'Management';

  @override
  String get tagNumber => 'Tag number';

  @override
  String get sheepName => 'Name';

  @override
  String get rfidEid => 'RFID / Electronic ID';

  @override
  String get color => 'Color';

  @override
  String get markings => 'Markings';

  @override
  String get primaryGroup => 'Primary group';

  @override
  String get source => 'Source / origin';

  @override
  String get purchaseDate => 'Purchase date';

  @override
  String get purchasePrice => 'Purchase price';

  @override
  String get birthDateUnknown => 'Birth date unknown';

  @override
  String get estimatedAge => 'Estimated age';

  @override
  String get photo => 'Photo';

  @override
  String get photoPlaceholder =>
      'Camera capture is not available yet; this keeps the field ready.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get duplicateTagMessage =>
      'This tag number is already assigned to another sheep.';

  @override
  String get breedCrossbred => 'Crossbred';

  @override
  String get breedMixed => 'Mixed';

  @override
  String get breedUnknown => 'Unknown';

  @override
  String get breedOther => 'Other';

  @override
  String get breedLocal => 'Local';

  @override
  String get breedAssaf => 'Assaf';

  @override
  String get breedDorper => 'Dorper';

  @override
  String get breedMerino => 'Merino';

  @override
  String get breedNajdiCross => 'Najdi Cross';

  @override
  String get customBreed => 'Custom breed';

  @override
  String get recordBcs => 'Record BCS';

  @override
  String recordWeightFor(String tag) {
    return 'Weight for #$tag';
  }

  @override
  String get weightUnit => 'Unit';

  @override
  String get method => 'Method';

  @override
  String get methodScale => 'Scale';

  @override
  String get methodEstimated => 'Estimated';

  @override
  String get kgUnit => 'kg';

  @override
  String get lbUnit => 'lb';

  @override
  String get saveWeight => 'Save weight';

  @override
  String get bcsInvalid => 'BCS must be between 1 and 5 in 0.5 steps.';

  @override
  String get weightInvalid => 'Enter a weight greater than zero.';

  @override
  String get healthObservation => 'Health Observation';

  @override
  String get whatDidYouObserve => 'What did you observe?';

  @override
  String get whoIsThisFor => 'Who is this for?';

  @override
  String get thisSheep => 'This sheep';

  @override
  String get groupScope => 'Group';

  @override
  String get entireFlock => 'Entire flock';

  @override
  String get selectSymptoms => 'Select symptoms';

  @override
  String get symptomCategoryEating => 'Eating & Digestion';

  @override
  String get symptomCategoryBreathing => 'Breathing';

  @override
  String get symptomCategoryEyes => 'Eyes';

  @override
  String get symptomCategoryMovement => 'Movement';

  @override
  String get symptomCategorySkin => 'Skin';

  @override
  String get symptomCategoryGeneral => 'General';

  @override
  String get symptomCategoryOther => 'Other';

  @override
  String get severity => 'Severity';

  @override
  String get severityMild => 'Mild';

  @override
  String get severityModerate => 'Moderate';

  @override
  String get severitySevere => 'Severe';

  @override
  String get urgentAttention => 'Urgent Attention';

  @override
  String get urgentAttentionBody =>
      'This observation may require prompt veterinary assessment.';

  @override
  String get observationSummary => 'Observation summary';

  @override
  String get observedSigns => 'Observed signs';

  @override
  String get durationLabel => 'Duration';

  @override
  String get drinking => 'Drinking';

  @override
  String get suggestedChecks => 'Suggested next checks';

  @override
  String get possibleAreas => 'Possible areas to investigate';

  @override
  String get recommendedNextAction => 'Recommended next action';

  @override
  String get saveObservation => 'Save Observation';

  @override
  String get createFollowUp => 'Create Follow-up Task';

  @override
  String get recordTreatment => 'Record Treatment';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get followUpQuestions => 'Follow-up questions';

  @override
  String get symptomNotEating => 'Not eating';

  @override
  String get symptomReducedAppetite => 'Reduced appetite';

  @override
  String get symptomDiarrhea => 'Diarrhea';

  @override
  String get symptomConstipation => 'Constipation';

  @override
  String get symptomBloating => 'Bloating';

  @override
  String get symptomAbnormalStool => 'Abnormal stool';

  @override
  String get symptomDrinkingLess => 'Drinking less';

  @override
  String get symptomNotDrinking => 'Not drinking';

  @override
  String get symptomCoughing => 'Coughing';

  @override
  String get symptomDifficultyBreathing => 'Difficulty breathing';

  @override
  String get symptomNasalDischarge => 'Nasal discharge';

  @override
  String get symptomEyeRedness => 'Eye redness';

  @override
  String get symptomEyeDischarge => 'Eye discharge';

  @override
  String get symptomEyeCloudiness => 'Cloudy eye';

  @override
  String get symptomEyeSwelling => 'Swollen eye';

  @override
  String get symptomKeepsEyeClosed => 'Keeps eye closed';

  @override
  String get symptomPossibleEyeInjury => 'Possible eye injury';

  @override
  String get symptomLameness => 'Lameness';

  @override
  String get symptomSwollenJoint => 'Swollen leg/joint';

  @override
  String get symptomHoofProblem => 'Hoof problem';

  @override
  String get symptomItching => 'Itching';

  @override
  String get symptomHairLoss => 'Hair loss';

  @override
  String get symptomSkinLesion => 'Skin lesion';

  @override
  String get symptomWeakness => 'Weakness';

  @override
  String get symptomLethargy => 'Lethargy';

  @override
  String get symptomFever => 'Fever / feels hot';

  @override
  String get symptomWeightLoss => 'Weight loss';

  @override
  String get symptomPaleEyelids => 'Pale eyelids / gums';

  @override
  String get symptomAbnormalUrine => 'Abnormal urine';

  @override
  String get symptomOther => 'Other';

  @override
  String get qAppetiteDuration => 'How long?';

  @override
  String get qDrinking => 'Is the sheep drinking?';

  @override
  String get qAppetiteOtherSigns => 'Any other signs?';

  @override
  String get qDiarrheaDuration => 'How long?';

  @override
  String get qStoolAppearance => 'Stool appearance';

  @override
  String get qDiarrheaOtherSigns => 'Other signs?';

  @override
  String get qEyeWhatSee => 'What do you see?';

  @override
  String get qEyeOneOrBoth => 'One or both eyes?';

  @override
  String get qEyeRubbing => 'Is the sheep rubbing the eye?';

  @override
  String get qEyeInjury => 'Is there an obvious injury?';

  @override
  String get qLamenessSeverity => 'Severity';

  @override
  String get qLamenessLeg => 'Which leg?';

  @override
  String get qHoofAppearance => 'Hoof appearance';

  @override
  String get optLess12h => 'Less than 12 hours';

  @override
  String get opt12_24h => '12–24 hours';

  @override
  String get opt1_2Days => '1–2 days';

  @override
  String get optMore2Days => 'More than 2 days';

  @override
  String get optUnknown => 'Unknown';

  @override
  String get optNormally => 'Normally';

  @override
  String get optLessThanNormal => 'Less than normal';

  @override
  String get optNotDrinking => 'Not drinking';

  @override
  String get optTeethGrinding => 'Teeth grinding';

  @override
  String get optLess1Day => 'Less than 1 day';

  @override
  String get opt3_5Days => '3–5 days';

  @override
  String get optMore5Days => 'More than 5 days';

  @override
  String get optLoose => 'Loose';

  @override
  String get optWatery => 'Watery';

  @override
  String get optVeryWatery => 'Very watery';

  @override
  String get optMucus => 'Mucus present';

  @override
  String get optBlood => 'Blood present';

  @override
  String get optRedness => 'Redness';

  @override
  String get optCloudiness => 'Cloudiness';

  @override
  String get optDischarge => 'Discharge';

  @override
  String get optSwelling => 'Swelling';

  @override
  String get optKeepsClosed => 'Keeps eye closed';

  @override
  String get optTearing => 'Excessive tearing';

  @override
  String get optPossibleInjury => 'Possible injury';

  @override
  String get optDifficultySeeing => 'Difficulty seeing';

  @override
  String get optLeft => 'Left';

  @override
  String get optRight => 'Right';

  @override
  String get optBoth => 'Both';

  @override
  String get optYes => 'Yes';

  @override
  String get optNo => 'No';

  @override
  String get optNotSure => 'Not sure';

  @override
  String get optSlight => 'Slight';

  @override
  String get optModerate => 'Moderate';

  @override
  String get optSevere => 'Severe';

  @override
  String get optUnableToWalk => 'Unable to walk';

  @override
  String get optFrontLeft => 'Front left';

  @override
  String get optFrontRight => 'Front right';

  @override
  String get optRearLeft => 'Rear left';

  @override
  String get optRearRight => 'Rear right';

  @override
  String get optNormal => 'Normal';

  @override
  String get optOvergrown => 'Overgrown';

  @override
  String get optDamaged => 'Damaged';

  @override
  String get optSwollen => 'Swollen';

  @override
  String get optBadOdor => 'Bad odor';

  @override
  String get checkTemperature => 'Check temperature';

  @override
  String get checkHydration => 'Check hydration';

  @override
  String get checkEyelidColor => 'Check eyelid/gum color';

  @override
  String get checkFeces => 'Check feces';

  @override
  String get checkFeedChanges => 'Check recent feed changes';

  @override
  String get checkOtherSheep => 'Check whether other sheep are affected';

  @override
  String get monitorWater => 'Monitor water intake';

  @override
  String get examineEyeLight => 'Examine the eye in good light';

  @override
  String get checkForeignMaterial => 'Check for foreign material or injury';

  @override
  String get monitorVision => 'Monitor whether vision appears affected';

  @override
  String get inspectHoof => 'Inspect hoof';

  @override
  String get areaDigestiveProblem => 'Digestive problem';

  @override
  String get areaFeedRelated => 'Feed-related issue';

  @override
  String get areaParasiteBurden => 'Parasite burden';

  @override
  String get areaInfection => 'Infection';

  @override
  String get areaDentalMouth => 'Dental/mouth problem';

  @override
  String get areaPainInjury => 'Pain or injury';

  @override
  String get areaUnderlying => 'Other underlying condition';

  @override
  String get areaEyeIrritation => 'Irritation';

  @override
  String get areaEyeInjury => 'Injury';

  @override
  String get areaEyeInfection => 'Infectious eye problem';

  @override
  String get areaEyeForeignMaterial => 'Foreign material';

  @override
  String get areaHoofProblem => 'Hoof problem';

  @override
  String get areaJointProblem => 'Joint problem';

  @override
  String get actionMonitorClosely =>
      'Monitor closely and consider veterinary assessment if symptoms persist or worsen.';

  @override
  String get actionInspectEye => 'Inspect eye';

  @override
  String get actionInspectHoof => 'Inspect hoof';

  @override
  String get actionSeparateFlock => 'Separate from flock if appropriate';

  @override
  String get redFlagSevereBreathing => 'Severe breathing difficulty';

  @override
  String get redFlagSevereBloating => 'Severe bloating';

  @override
  String get redFlagSevereWeakness => 'Severe weakness';

  @override
  String get redFlagNotDrinking => 'Not drinking';

  @override
  String get redFlagUnableToStand => 'Unable to stand';

  @override
  String get redFlagSevereEyeInjury => 'Eye injury requires assessment';

  @override
  String get medicationLibrary => 'Medication Library';

  @override
  String get searchMedication => 'Search medication...';

  @override
  String get medicationCategory => 'Category';

  @override
  String get categoryAntibiotic => 'Antibiotic';

  @override
  String get categoryAntiparasitic => 'Antiparasitic';

  @override
  String get categoryAntiInflammatory => 'Anti-inflammatory';

  @override
  String get categoryPainRelief => 'Pain relief';

  @override
  String get categoryVitaminMineral => 'Vitamin / Mineral';

  @override
  String get categoryElectrolyte => 'Electrolyte';

  @override
  String get categoryEyeTreatment => 'Eye treatment';

  @override
  String get categoryTopicalTreatment => 'Topical treatment';

  @override
  String get categoryHoofTreatment => 'Hoof treatment';

  @override
  String get categoryOther => 'Other';

  @override
  String get activeIngredient => 'Active ingredient';

  @override
  String get availableRoutes => 'Available routes';

  @override
  String get select => 'Select';

  @override
  String get medicationInformation => 'Medication information';

  @override
  String get treatmentOptionsDisclaimer =>
      'Treatment options to discuss with your veterinarian';

  @override
  String get filter => 'Filter';

  @override
  String get doseUnit => 'Unit';

  @override
  String get unitMl => 'mL';

  @override
  String get unitMg => 'mg';

  @override
  String get unitG => 'g';

  @override
  String get unitTablet => 'tablet';

  @override
  String get unitBolus => 'bolus';

  @override
  String get unitOther => 'other';

  @override
  String get routeEye => 'Eye';

  @override
  String get routeOther => 'Other';

  @override
  String get administeredBy => 'Administered by';

  @override
  String get dateTime => 'Date/time';

  @override
  String get clear => 'Clear';

  @override
  String get meatClearance => 'Meat clearance';

  @override
  String get milkClearance => 'Milk clearance';

  @override
  String meatWithdrawalUntil(String date) {
    return 'Meat withdrawal until $date';
  }

  @override
  String milkWithdrawalUntil(String date) {
    return 'Milk withdrawal until $date';
  }

  @override
  String get followUp => 'Follow-up';

  @override
  String get followUpTitle => 'Task title';

  @override
  String get dueDate => 'Due date';

  @override
  String get priority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get assignedTo => 'Assigned to';

  @override
  String get saveFollowUp => 'Save follow-up';

  @override
  String get followUpSaved => 'Follow-up task created';

  @override
  String get activeWithdrawals => 'Active Withdrawals';

  @override
  String sheepNeedAttention(int count) {
    return '$count sheep need attention';
  }

  @override
  String get healthConcerns => 'Health concerns';

  @override
  String get underWithdrawal => 'Under withdrawal';

  @override
  String get followUpDueToday => 'Follow-up due today';

  @override
  String get recentHealthObservation => 'Recent health observation';

  @override
  String get eventHealthObservation => 'Health Observation';

  @override
  String get eventIdentityChanged => 'Identity updated';

  @override
  String identityChangeDetail(String field, String old, String newValue) {
    return '$field · $old → $newValue';
  }

  @override
  String get today => 'TODAY';

  @override
  String get symptomRapidBreathing => 'Rapid breathing';

  @override
  String get symptomTearing => 'Tearing';

  @override
  String get symptomHoofSwelling => 'Swollen hoof';

  @override
  String get symptomHoofBadOdor => 'Bad odor (hoof)';

  @override
  String get symptomAbdominalPain => 'Abdominal pain';

  @override
  String get symptomBottleJaw => 'Bottle jaw';

  @override
  String get symptomRecumbent => 'Unable to stand / recumbent';

  @override
  String get symptomNeurologicSigns => 'Neurologic signs';

  @override
  String get symptomSuddenIllness => 'Sudden severe illness';

  @override
  String get symptomSuddenDeath => 'Sudden death';

  @override
  String get symptomCrusts => 'Crusts';

  @override
  String get symptomVisibleParasites => 'Visible parasites';

  @override
  String get conditionHaemonchosis => 'Haemonchosis';

  @override
  String get conditionGastrointestinalParasitism =>
      'Gastrointestinal parasitism';

  @override
  String get conditionCoccidiosis => 'Coccidiosis';

  @override
  String get conditionGrainOverload => 'Grain overload / lactic acidosis';

  @override
  String get conditionEnterotoxemia => 'Enterotoxemia';

  @override
  String get conditionBacterialPneumonia => 'Bacterial pneumonia';

  @override
  String get conditionRespiratoryDisease => 'Respiratory disease';

  @override
  String get conditionPinkeye => 'Pinkeye';

  @override
  String get conditionFootrot => 'Footrot';

  @override
  String get conditionPregnancyToxemia => 'Pregnancy toxemia';

  @override
  String get conditionHypocalcemia => 'Hypocalcemia';

  @override
  String get conditionExternalParasites => 'External parasites';

  @override
  String get conditionDehydration => 'Dehydration';

  @override
  String get conditionFeverInfection => 'Fever / infection';

  @override
  String get conditionGeneralEnteritis => 'General enteritis';

  @override
  String get conditionSalmonellosis => 'Salmonellosis';

  @override
  String get categoryDigestive => 'Digestive';

  @override
  String get categoryRespiratory => 'Respiratory';

  @override
  String get categoryEye => 'Eye';

  @override
  String get categoryHoof => 'Hoof / Musculoskeletal';

  @override
  String get categoryMetabolic => 'Metabolic';

  @override
  String get categoryParasite => 'Parasites';

  @override
  String get categorySkin => 'Skin';

  @override
  String get categoryGeneral => 'General / Infectious';

  @override
  String get categoryReproductive => 'Reproductive';

  @override
  String get compatibilityStronglyCompatible => 'Strongly compatible pattern';

  @override
  String get compatibilityCompatible => 'Compatible pattern';

  @override
  String get compatibilityPossible => 'Possible';

  @override
  String get compatibilityLessLikely => 'Less likely';

  @override
  String get compatibilityInsufficient => 'Insufficient information';

  @override
  String get riskRoutine => 'Routine';

  @override
  String get riskNeedsAttention => 'Needs attention';

  @override
  String get riskUrgent => 'Urgent';

  @override
  String get redFlagNeurologicSigns => 'Neurologic signs';

  @override
  String get redFlagSuddenDeath => 'Sudden death';

  @override
  String get redFlagSevereDehydration => 'Severe dehydration';

  @override
  String get checkFamacha => 'FAMACHA score';

  @override
  String get checkFecalEggCount => 'Fecal egg count';

  @override
  String get checkBodyCondition => 'Body condition';

  @override
  String get checkDewormingHistory => 'Recent deworming history';

  @override
  String get checkAge => 'Age';

  @override
  String get checkFecalExam => 'Fecal examination';

  @override
  String get checkBloodMucus => 'Blood/mucus in feces';

  @override
  String get checkGestationStage => 'Gestation stage';

  @override
  String get checkLitterSize => 'Litter size';

  @override
  String get checkKetoneBhb => 'Ketones / BHB';

  @override
  String get checkBloodGlucose => 'Blood glucose';

  @override
  String get checkRespiratoryRate => 'Respiratory rate';

  @override
  String get checkRumen => 'Rumen / bloat';

  @override
  String get checkVaccinationStatus => 'Vaccination status';

  @override
  String get checkAffectedAgeGroup => 'Affected age group';

  @override
  String get checkNumberAffected => 'Number affected';

  @override
  String get checkCorneal => 'Corneal cloudiness';

  @override
  String get checkOneBothEyes => 'One or both eyes';

  @override
  String get checkUlcerInjury => 'Ulcer / injury';

  @override
  String get checkPainSquinting => 'Pain / squinting';

  @override
  String get checkVision => 'Vision';

  @override
  String get checkHoofOdor => 'Hoof odor';

  @override
  String get checkVisibleParasites => 'Visible parasites';

  @override
  String get checkAffectedAreas => 'Affected areas';

  @override
  String get checkNasalDischarge => 'Nasal discharge';

  @override
  String get checkDrinking => 'Drinking';

  @override
  String get checkRecentFeedChange => 'Recent feed change';

  @override
  String get actionIsolate => 'Isolate sheep';

  @override
  String get actionCleanWater => 'Provide clean water';

  @override
  String get actionAssessNow => 'Assess immediately';

  @override
  String get actionRemoveFeed => 'Remove access to suspected feed';

  @override
  String get actionContactVet => 'Contact veterinarian';

  @override
  String get actionRecordTemperature => 'Record body temperature';

  @override
  String get actionInspectEyes => 'Inspect eyes';

  @override
  String get actionCheckMucousMembrane => 'Check mucous membrane color';

  @override
  String get actionMoveCleanDry => 'Move to cleaner/drier conditions';

  @override
  String get actionSupportNutrition => 'Support nutrition';

  @override
  String get actionMonitorFlock => 'Monitor other sheep';

  @override
  String get actionReviewVaccination => 'Review vaccination status';

  @override
  String get treatmentSupportiveCare => 'Supportive care';

  @override
  String get treatmentAntiparasitic => 'Antiparasitic';

  @override
  String get treatmentAnticoccidial => 'Anticoccidial';

  @override
  String get treatmentAntimicrobial => 'Antimicrobial';

  @override
  String get treatmentAntiInflammatory => 'Anti-inflammatory';

  @override
  String get treatmentElectrolyte => 'Electrolyte / fluid support';

  @override
  String get treatmentNutritional => 'Nutritional support';

  @override
  String get treatmentTopical => 'Topical treatment';

  @override
  String get treatmentFootbath => 'Footbath / hoof management';

  @override
  String get treatmentIsolation => 'Isolation';

  @override
  String get treatmentSurgical => 'Surgical / veterinary intervention';

  @override
  String get treatmentMonitoring => 'Monitoring';

  @override
  String get treatmentPreventiveVaccination => 'Preventive vaccination';

  @override
  String get treatmentOther => 'Other';

  @override
  String get protocolSupportiveCare => 'Supportive care';

  @override
  String get protocolParasiteControl => 'Parasite-control protocol';

  @override
  String get protocolAnticoccidialTherapy => 'Anticoccidial therapy';

  @override
  String get protocolAntimicrobialWhenIndicated =>
      'Antimicrobial (when indicated)';

  @override
  String get protocolOphthalmic => 'Ophthalmic treatment';

  @override
  String get protocolFootbathHoof => 'Footbath / hoof management';

  @override
  String get protocolMetabolic => 'Veterinary-directed metabolic treatment';

  @override
  String get protocolIsolation => 'Isolation';

  @override
  String get protocolMonitoring => 'Monitoring';

  @override
  String get protocolTopical => 'Topical treatment';

  @override
  String get protocolPreventiveVaccination => 'Preventive vaccination';

  @override
  String get protocolElectrolyte => 'Electrolyte / fluid support';

  @override
  String get riskRecentFeedChange => 'Recent feed change';

  @override
  String get riskRecentGrainAccess => 'Recent grain access';

  @override
  String get riskMultipleAffected => 'Multiple sheep affected';

  @override
  String get riskCrowded => 'Crowding';

  @override
  String get riskPastureExposure => 'Pasture exposure';

  @override
  String get riskWetConditions => 'Wet conditions';

  @override
  String get riskRecentTransport => 'Recent transport';

  @override
  String get riskRecentStress => 'Recent stress';

  @override
  String get riskPregnant => 'Pregnant';

  @override
  String get riskLateGestation => 'Late gestation';

  @override
  String get riskLowBcs => 'Low body condition';

  @override
  String get riskLactating => 'Lactating';

  @override
  String get ageGroupNeonatal => 'Neonatal lamb';

  @override
  String get ageGroupYoungLamb => 'Young lamb';

  @override
  String get ageGroupGrowingLamb => 'Growing lamb';

  @override
  String get ageGroupAdult => 'Adult';

  @override
  String get ageGroupSenior => 'Senior';

  @override
  String get conditionsToConsider => 'Conditions to consider';

  @override
  String get whyThisAppears => 'Why it appears';

  @override
  String get checkNext => 'Check next';

  @override
  String get treatmentApproach => 'Treatment approach';

  @override
  String get viewProtocol => 'View protocol';

  @override
  String get viewMedications => 'View medications';

  @override
  String get healthAssessment => 'Health Assessment';

  @override
  String get clinicalDifferential => 'Clinical differential';

  @override
  String get advancedHealthView => 'Advanced Health View';

  @override
  String get possibleFlockProblem => 'Possible Flock-Level Problem';

  @override
  String get flockProblemBody => 'Multiple sheep have similar observations.';

  @override
  String get medicationRequiresVerification =>
      'Medication requires veterinary/product verification.';

  @override
  String get labelStatusApprovedForSheep => 'Approved for sheep';

  @override
  String get labelStatusApprovedForIndication => 'Approved for this indication';

  @override
  String get labelStatusVeterinaryDirected =>
      'Veterinary-directed / extra-label';

  @override
  String get labelStatusVerificationRequired => 'Verification required';

  @override
  String get labelStatusUnknown => 'Unknown';

  @override
  String get reasonForTreatment => 'Why are you treating?';

  @override
  String get treatmentReasonHealthObservation => 'Health Observation';

  @override
  String get treatmentReasonConfirmedDiagnosis => 'Confirmed Diagnosis';

  @override
  String get treatmentReasonPreventive => 'Preventive protocol';

  @override
  String get treatmentReasonVaccination => 'Vaccination';

  @override
  String get treatmentReasonRoutineParasite => 'Routine parasite control';

  @override
  String get treatmentReasonOther => 'Other';

  @override
  String get confirmTreatment => 'Confirm Treatment';

  @override
  String get confirmAndRecord => 'Confirm & Record';

  @override
  String get healthGuidanceDatabase => 'Health guidance database';

  @override
  String get lastVerified => 'Last verified';

  @override
  String knowledgeVersion(String version) {
    return 'Version $version';
  }

  @override
  String get famacha => 'FAMACHA';

  @override
  String get eyelidColor => 'Eyelid color';

  @override
  String get gestationStage => 'Gestation stage';

  @override
  String get litterSize => 'Litter size';

  @override
  String get whyExpandable => 'Why am I seeing this?';

  @override
  String get whatMoreLikely => 'What would make it more likely?';

  @override
  String get whatLessLikely => 'What would make it less likely?';

  @override
  String get antibioticNotIndicated =>
      'Antibiotic treatment is not automatically indicated from these signs alone.';

  @override
  String get urgentVeterinaryAssessment => 'Urgent veterinary assessment';

  @override
  String get doNotDewormRoutinely =>
      'Do not automatically deworm based on diarrhea alone.';

  @override
  String get healthCenter => 'Health Center';

  @override
  String get changeSheep => 'Change sheep';

  @override
  String get healthCheck => 'Health Check';

  @override
  String get stable => 'Stable';

  @override
  String get underTreatment => 'Under treatment';

  @override
  String get weightBcs => 'Weight / BCS';

  @override
  String get deworming => 'Deworming';

  @override
  String get healthCases => 'Health Cases';

  @override
  String get preventiveCare => 'Preventive care';

  @override
  String get measurements => 'Measurements';

  @override
  String get history => 'History';

  @override
  String get lastHealthCheck => 'Last health check';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get caseStatus => 'Status';

  @override
  String get caseSeverity => 'Severity';

  @override
  String get caseStarted => 'Started';

  @override
  String get caseSummary => 'Case summary';

  @override
  String get caseObservations => 'Observations';

  @override
  String get caseAssessment => 'Assessment';

  @override
  String get caseChecks => 'Checks';

  @override
  String get noActiveHealthCases => 'No active health cases';

  @override
  String get noHealthCasesDetail =>
      'This sheep currently has no open health cases.';

  @override
  String get caseOpen => 'Open';

  @override
  String get caseMonitoring => 'Monitoring';

  @override
  String get caseTreatment => 'Treatment';

  @override
  String get caseAwaitingVet => 'Awaiting Veterinary Review';

  @override
  String get caseImproving => 'Improving';

  @override
  String get caseResolved => 'Resolved';

  @override
  String get caseChronic => 'Chronic';

  @override
  String get caseClosed => 'Closed';

  @override
  String get parasiteManagement => 'Parasite Management';

  @override
  String get currentParasiteStatus => 'Current parasite status';

  @override
  String get lastFamacha => 'Last FAMACHA';

  @override
  String get lastFecalTest => 'Last fecal test';

  @override
  String get lastDeworming => 'Last deworming';

  @override
  String get currentWithdrawal => 'Current withdrawal';

  @override
  String get nextAction => 'Next action';

  @override
  String get deworm => 'Deworm';

  @override
  String get fecalTest => 'Fecal Test';

  @override
  String get parasiteObservation => 'Parasite Observation';

  @override
  String get viewHistory => 'View history';

  @override
  String get whyDeworming => 'Why are you deworming?';

  @override
  String get dewormingReasonTreatment =>
      'Treatment — signs consistent with parasite disease';

  @override
  String get dewormingReasonPositiveTest => 'Positive fecal test';

  @override
  String get dewormingReasonFamacha => 'FAMACHA / anemia assessment';

  @override
  String get dewormingReasonRoutine => 'Routine protocol';

  @override
  String get dewormingReasonGroup => 'Group treatment';

  @override
  String get dewormingReasonVet => 'Veterinary recommendation';

  @override
  String get dewormingReasonOther => 'Other';

  @override
  String get parasiteAssessment => 'Parasite Assessment';

  @override
  String get bottleJaw => 'Bottle jaw';

  @override
  String get recentFecalTest => 'Recent fecal test';

  @override
  String get previousProduct => 'Previous product';

  @override
  String get otherSheepAffected => 'Other sheep affected?';

  @override
  String get reviewRecommended => 'Review recommended';

  @override
  String get findings => 'Findings';

  @override
  String get pattern => 'Pattern';

  @override
  String get importantNextCheck => 'Important next check';

  @override
  String get viewParasiteProtocol => 'View Parasite Treatment Protocol';

  @override
  String get famachaTrend => 'FAMACHA trend';

  @override
  String get famachaWorsening => 'FAMACHA score increased — needs attention';

  @override
  String get recordFamacha => 'Record FAMACHA';

  @override
  String get recordFecalTest => 'Record Fecal Test';

  @override
  String get fecalTestType => 'Test type';

  @override
  String get fecalEggCount => 'Fecal egg count';

  @override
  String get resultLevel => 'Result';

  @override
  String get parasitesDetected => 'Parasites detected';

  @override
  String get laboratory => 'Laboratory';

  @override
  String get testTypeFecalEggCount => 'Fecal egg count';

  @override
  String get testTypeMcMaster => 'McMaster';

  @override
  String get testTypeOocyst => 'Oocyst count';

  @override
  String get testTypeGeneral => 'General fecal examination';

  @override
  String get testTypeOther => 'Other';

  @override
  String get fecalNegative => 'Negative';

  @override
  String get fecalLow => 'Low';

  @override
  String get fecalModerate => 'Moderate';

  @override
  String get fecalHigh => 'High';

  @override
  String get fecalSpecific => 'Specific parasite detected';

  @override
  String get fecalPending => 'Pending';

  @override
  String get parasiteHistory => 'Parasite History';

  @override
  String get dewormingHistory => 'Deworming History';

  @override
  String get noDewormingRecorded => 'No deworming recorded';

  @override
  String get noDewormingDetail =>
      'Start tracking parasite treatments to build a complete parasite history.';

  @override
  String get noFamachaRecorded => 'No FAMACHA recorded';

  @override
  String get noFamachaDetail =>
      'Record a FAMACHA score to begin parasite monitoring.';

  @override
  String get noFecalTests => 'No fecal tests recorded';

  @override
  String get recordDeworming => 'Record Deworming';

  @override
  String get dewormingRecorded => 'Deworming recorded';

  @override
  String get treatmentResponse => 'Treatment response';

  @override
  String get responseImproved => 'Improved';

  @override
  String get responseUnchanged => 'No change';

  @override
  String get responseWorse => 'Worse';

  @override
  String get responseUnknown => 'Unknown';

  @override
  String get concentration => 'Concentration';

  @override
  String get weightAtTreatment => 'Weight at treatment';

  @override
  String get calculatedDose => 'Calculated dose';

  @override
  String get basedOn => 'Based on';

  @override
  String get protocolMgPerKg => 'Protocol (mg/kg)';

  @override
  String get productMgPerMl => 'Product (mg/mL)';

  @override
  String get underdoseWarning =>
      'Entered dose is below the configured protocol.';

  @override
  String get overdoseWarning => 'Dose requires verification.';

  @override
  String get parasiteRisk => 'Parasite risk';

  @override
  String get riskLow => 'Low';

  @override
  String get riskMonitor => 'Monitor';

  @override
  String get riskNeedsAssessment => 'Needs assessment';

  @override
  String get riskHighConcern => 'High concern';

  @override
  String get demoMedication => 'DEMO — VERIFY PRODUCT';

  @override
  String get possibleReducedEffectiveness =>
      'Possible reduced treatment effectiveness — veterinary/parasitology review recommended.';

  @override
  String get parasiteReviewRecommended =>
      'Review FAMACHA trend and consider fecal testing / veterinary assessment according to the farm parasite-control protocol.';
}
