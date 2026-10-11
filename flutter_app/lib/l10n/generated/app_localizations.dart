import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HerdHub Sheep'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @flock.
  ///
  /// In en, this message translates to:
  /// **'Flock'**
  String get flock;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @breeding.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get breeding;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @quickLog.
  ///
  /// In en, this message translates to:
  /// **'Quick Log'**
  String get quickLog;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @placeholderTitle.
  ///
  /// In en, this message translates to:
  /// **'{page} foundation'**
  String placeholderTitle(String page);

  /// No description provided for @placeholderBody.
  ///
  /// In en, this message translates to:
  /// **'This screen is intentionally a Stage 0 placeholder.'**
  String get placeholderBody;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get theme;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @sunMode.
  ///
  /// In en, this message translates to:
  /// **'Sun Mode'**
  String get sunMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select appearance'**
  String get selectTheme;

  /// No description provided for @quickLogComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Quick Log workflow will be added in a later stage.'**
  String get quickLogComingSoon;

  /// No description provided for @whatToRecord.
  ///
  /// In en, this message translates to:
  /// **'What do you want to record?'**
  String get whatToRecord;

  /// No description provided for @healthActions.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get healthActions;

  /// No description provided for @conditionActions.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get conditionActions;

  /// No description provided for @breedingActions.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get breedingActions;

  /// No description provided for @otherActions.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherActions;

  /// No description provided for @treatmentAction.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatmentAction;

  /// No description provided for @vaccinationAction.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccinationAction;

  /// No description provided for @dewormingAction.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get dewormingAction;

  /// No description provided for @dippingAction.
  ///
  /// In en, this message translates to:
  /// **'Dipping / Parasite'**
  String get dippingAction;

  /// No description provided for @hoofTrimAction.
  ///
  /// In en, this message translates to:
  /// **'Hoof trim'**
  String get hoofTrimAction;

  /// No description provided for @shearingAction.
  ///
  /// In en, this message translates to:
  /// **'Shearing'**
  String get shearingAction;

  /// No description provided for @weightAction.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightAction;

  /// No description provided for @bcsAction.
  ///
  /// In en, this message translates to:
  /// **'BCS'**
  String get bcsAction;

  /// No description provided for @heatCheckAction.
  ///
  /// In en, this message translates to:
  /// **'Heat check'**
  String get heatCheckAction;

  /// No description provided for @feedWaterAction.
  ///
  /// In en, this message translates to:
  /// **'Feed / Water'**
  String get feedWaterAction;

  /// No description provided for @matingAction.
  ///
  /// In en, this message translates to:
  /// **'Mating'**
  String get matingAction;

  /// No description provided for @pregnancyAction.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get pregnancyAction;

  /// No description provided for @lambingAction.
  ///
  /// In en, this message translates to:
  /// **'Lambing'**
  String get lambingAction;

  /// No description provided for @photoAction.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoAction;

  /// No description provided for @voiceNoteAction.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get voiceNoteAction;

  /// No description provided for @noteAction.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteAction;

  /// No description provided for @selectSheep.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get selectSheep;

  /// No description provided for @selectMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get selectMedication;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @saveTreatment.
  ///
  /// In en, this message translates to:
  /// **'Save treatment'**
  String get saveTreatment;

  /// No description provided for @treatmentRecorded.
  ///
  /// In en, this message translates to:
  /// **'Treatment recorded'**
  String get treatmentRecorded;

  /// No description provided for @followUpCreated.
  ///
  /// In en, this message translates to:
  /// **'Follow-up task created'**
  String get followUpCreated;

  /// No description provided for @treatmentWithdrawalNotice.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal is calculated automatically from this treatment.'**
  String get treatmentWithdrawalNotice;

  /// No description provided for @meatWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Meat withdrawal'**
  String get meatWithdrawal;

  /// No description provided for @milkWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Milk withdrawal'**
  String get milkWithdrawal;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String days(int count);

  /// No description provided for @recordAction.
  ///
  /// In en, this message translates to:
  /// **'Record {action}'**
  String recordAction(String action);

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get saveRecord;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid value.'**
  String get invalidValue;

  /// No description provided for @invalidDose.
  ///
  /// In en, this message translates to:
  /// **'Enter a dose greater than zero.'**
  String get invalidDose;

  /// No description provided for @bcsValueHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter a score from 0 to 5.'**
  String get bcsValueHelp;

  /// No description provided for @routeOral.
  ///
  /// In en, this message translates to:
  /// **'Oral'**
  String get routeOral;

  /// No description provided for @routeInjection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get routeInjection;

  /// No description provided for @routeTopical.
  ///
  /// In en, this message translates to:
  /// **'Topical'**
  String get routeTopical;

  /// No description provided for @routeIntramuscular.
  ///
  /// In en, this message translates to:
  /// **'Intramuscular'**
  String get routeIntramuscular;

  /// No description provided for @routeSubcutaneous.
  ///
  /// In en, this message translates to:
  /// **'Subcutaneous'**
  String get routeSubcutaneous;

  /// No description provided for @recordTreatmentFor.
  ///
  /// In en, this message translates to:
  /// **'Treatment for #{tag}'**
  String recordTreatmentFor(String tag);

  /// No description provided for @activeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Active treatment'**
  String get activeTreatment;

  /// No description provided for @clearance.
  ///
  /// In en, this message translates to:
  /// **'Clearance'**
  String get clearance;

  /// No description provided for @noActiveTreatment.
  ///
  /// In en, this message translates to:
  /// **'No active withdrawal'**
  String get noActiveTreatment;

  /// No description provided for @treatmentFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Treatment follow-up'**
  String get treatmentFollowUp;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @savedViewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved views'**
  String get savedViewsTitle;

  /// No description provided for @groupCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sheep'**
  String groupCount(int count);

  /// No description provided for @groupLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get groupLocation;

  /// No description provided for @groupCurrentTask.
  ///
  /// In en, this message translates to:
  /// **'Current task'**
  String get groupCurrentTask;

  /// No description provided for @groupStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get groupStatus;

  /// No description provided for @groupStatusNormal.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get groupStatusNormal;

  /// No description provided for @groupStatusAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get groupStatusAttention;

  /// No description provided for @groupStatusUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get groupStatusUrgent;

  /// No description provided for @openGroups.
  ///
  /// In en, this message translates to:
  /// **'Manage groups'**
  String get openGroups;

  /// No description provided for @viewGroup.
  ///
  /// In en, this message translates to:
  /// **'Open group'**
  String get viewGroup;

  /// No description provided for @bulkAction.
  ///
  /// In en, this message translates to:
  /// **'Bulk action'**
  String get bulkAction;

  /// No description provided for @chooseBulkAction.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get chooseBulkAction;

  /// No description provided for @sheepSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} sheep selected'**
  String sheepSelected(int count);

  /// No description provided for @vaccinateCount.
  ///
  /// In en, this message translates to:
  /// **'Vaccinate {count} Sheep'**
  String vaccinateCount(int count);

  /// No description provided for @completeActionCount.
  ///
  /// In en, this message translates to:
  /// **'Record {action} for {count} sheep'**
  String completeActionCount(String action, int count);

  /// No description provided for @bulkActionSaved.
  ///
  /// In en, this message translates to:
  /// **'{count} records saved'**
  String bulkActionSaved(int count);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @bulkActionUndone.
  ///
  /// In en, this message translates to:
  /// **'Bulk action undone'**
  String get bulkActionUndone;

  /// No description provided for @bulkActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not safely undo this bulk action.'**
  String get bulkActionFailed;

  /// No description provided for @taskToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get taskToday;

  /// No description provided for @taskUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get taskUpcoming;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get taskCompleted;

  /// No description provided for @taskPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get taskPending;

  /// No description provided for @taskInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get taskInProgress;

  /// No description provided for @taskSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get taskSkipped;

  /// No description provided for @taskCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get taskCancelled;

  /// No description provided for @taskStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get taskStart;

  /// No description provided for @taskComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get taskComplete;

  /// No description provided for @taskSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get taskSkip;

  /// No description provided for @taskEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this list.'**
  String get taskEmpty;

  /// No description provided for @nextTaskDue.
  ///
  /// In en, this message translates to:
  /// **'Next task due {date}'**
  String nextTaskDue(String date);

  /// No description provided for @upcomingSavedViewWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal active'**
  String get upcomingSavedViewWithdrawal;

  /// No description provided for @upcomingSavedViewLowBcs.
  ///
  /// In en, this message translates to:
  /// **'Low BCS'**
  String get upcomingSavedViewLowBcs;

  /// No description provided for @upcomingSavedViewVaccination.
  ///
  /// In en, this message translates to:
  /// **'Due for vaccination'**
  String get upcomingSavedViewVaccination;

  /// No description provided for @upcomingSavedViewEid.
  ///
  /// In en, this message translates to:
  /// **'Eid candidates'**
  String get upcomingSavedViewEid;

  /// No description provided for @bulkVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get bulkVaccination;

  /// No description provided for @bulkDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get bulkDeworming;

  /// No description provided for @bulkWeight.
  ///
  /// In en, this message translates to:
  /// **'Record weight'**
  String get bulkWeight;

  /// No description provided for @bulkBcs.
  ///
  /// In en, this message translates to:
  /// **'BCS check'**
  String get bulkBcs;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated'**
  String get taskUpdated;

  /// No description provided for @groupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Group not found'**
  String get groupNotFound;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @openSync.
  ///
  /// In en, this message translates to:
  /// **'Open Sync Center'**
  String get openSync;

  /// No description provided for @openBreeding.
  ///
  /// In en, this message translates to:
  /// **'Open Breeding'**
  String get openBreeding;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Al Noor Farm'**
  String get farmName;

  /// No description provided for @flockName.
  ///
  /// In en, this message translates to:
  /// **'North Flock'**
  String get flockName;

  /// No description provided for @sheepCount.
  ///
  /// In en, this message translates to:
  /// **'486 sheep'**
  String get sheepCount;

  /// No description provided for @heatRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'HEAT RISK · HIGH'**
  String get heatRiskHigh;

  /// No description provided for @offlinePending.
  ///
  /// In en, this message translates to:
  /// **'Offline · Changes saved locally'**
  String get offlinePending;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'12 pending'**
  String get pendingCount;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @urgentCount.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgentCount;

  /// No description provided for @dueTodayCount.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueTodayCount;

  /// No description provided for @dueWeekCount.
  ///
  /// In en, this message translates to:
  /// **'Due this week'**
  String get dueWeekCount;

  /// No description provided for @vaccinationDue.
  ///
  /// In en, this message translates to:
  /// **'Vaccination due'**
  String get vaccinationDue;

  /// No description provided for @withdrawalActive.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal active'**
  String get withdrawalActive;

  /// No description provided for @lowBcs.
  ///
  /// In en, this message translates to:
  /// **'Low BCS'**
  String get lowBcs;

  /// No description provided for @heatCheck.
  ///
  /// In en, this message translates to:
  /// **'Heat check'**
  String get heatCheck;

  /// No description provided for @pregnantEwes.
  ///
  /// In en, this message translates to:
  /// **'Pregnant Ewes'**
  String get pregnantEwes;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @taskCheckWater.
  ///
  /// In en, this message translates to:
  /// **'Check Water'**
  String get taskCheckWater;

  /// No description provided for @taskWeighLambs.
  ///
  /// In en, this message translates to:
  /// **'Weigh Lambs'**
  String get taskWeighLambs;

  /// No description provided for @taskBcsCheck.
  ///
  /// In en, this message translates to:
  /// **'BCS Check'**
  String get taskBcsCheck;

  /// No description provided for @northPasture.
  ///
  /// In en, this message translates to:
  /// **'North Pasture'**
  String get northPasture;

  /// No description provided for @groupB.
  ///
  /// In en, this message translates to:
  /// **'Group B'**
  String get groupB;

  /// No description provided for @ewesTwelve.
  ///
  /// In en, this message translates to:
  /// **'12 ewes'**
  String get ewesTwelve;

  /// No description provided for @flockSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Flock snapshot'**
  String get flockSnapshot;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @ewes.
  ///
  /// In en, this message translates to:
  /// **'Ewes'**
  String get ewes;

  /// No description provided for @rams.
  ///
  /// In en, this message translates to:
  /// **'Rams'**
  String get rams;

  /// No description provided for @lambs.
  ///
  /// In en, this message translates to:
  /// **'Lambs'**
  String get lambs;

  /// No description provided for @pregnantCount.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnantCount;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'humidity'**
  String get humidity;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @moveToShade.
  ///
  /// In en, this message translates to:
  /// **'Move to shade'**
  String get moveToShade;

  /// No description provided for @checkWater.
  ///
  /// In en, this message translates to:
  /// **'Check water'**
  String get checkWater;

  /// No description provided for @avoidHandling.
  ///
  /// In en, this message translates to:
  /// **'Avoid unnecessary handling'**
  String get avoidHandling;

  /// No description provided for @searchSheep.
  ///
  /// In en, this message translates to:
  /// **'Search tag, group, breed'**
  String get searchSheep;

  /// No description provided for @scanTag.
  ///
  /// In en, this message translates to:
  /// **'Scan Tag'**
  String get scanTag;

  /// No description provided for @addSheep.
  ///
  /// In en, this message translates to:
  /// **'Add Sheep'**
  String get addSheep;

  /// No description provided for @addSheepTitle.
  ///
  /// In en, this message translates to:
  /// **'Add sheep'**
  String get addSheepTitle;

  /// No description provided for @duplicateTagError.
  ///
  /// In en, this message translates to:
  /// **'This tag is already in the flock.'**
  String get duplicateTagError;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight greater than zero.'**
  String get invalidWeight;

  /// No description provided for @invalidBcs.
  ///
  /// In en, this message translates to:
  /// **'Enter a BCS from 1 to 5.'**
  String get invalidBcs;

  /// No description provided for @selectBreed.
  ///
  /// In en, this message translates to:
  /// **'Select breed'**
  String get selectBreed;

  /// No description provided for @defaultGroup.
  ///
  /// In en, this message translates to:
  /// **'North Flock'**
  String get defaultGroup;

  /// No description provided for @defaultLocation.
  ///
  /// In en, this message translates to:
  /// **'North Pasture'**
  String get defaultLocation;

  /// No description provided for @saveSheep.
  ///
  /// In en, this message translates to:
  /// **'Save sheep'**
  String get saveSheep;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @sick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get sick;

  /// No description provided for @withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// No description provided for @savedViews.
  ///
  /// In en, this message translates to:
  /// **'Saved views'**
  String get savedViews;

  /// No description provided for @dueVaccination.
  ///
  /// In en, this message translates to:
  /// **'Due for Vaccination'**
  String get dueVaccination;

  /// No description provided for @dueDeworming.
  ///
  /// In en, this message translates to:
  /// **'Due for Deworming'**
  String get dueDeworming;

  /// No description provided for @withdrawalView.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Active'**
  String get withdrawalView;

  /// No description provided for @pregnantView.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get pregnantView;

  /// No description provided for @eidCandidates.
  ///
  /// In en, this message translates to:
  /// **'Eid Candidates'**
  String get eidCandidates;

  /// No description provided for @allSheep.
  ///
  /// In en, this message translates to:
  /// **'All sheep'**
  String get allSheep;

  /// No description provided for @nextRoutine.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextRoutine;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @bcs.
  ///
  /// In en, this message translates to:
  /// **'BCS'**
  String get bcs;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @sexEwe.
  ///
  /// In en, this message translates to:
  /// **'Ewe'**
  String get sexEwe;

  /// No description provided for @sexRam.
  ///
  /// In en, this message translates to:
  /// **'Ram'**
  String get sexRam;

  /// No description provided for @sexLamb.
  ///
  /// In en, this message translates to:
  /// **'Lamb'**
  String get sexLamb;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @identity.
  ///
  /// In en, this message translates to:
  /// **'Identity'**
  String get identity;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get currentStatus;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @sex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get sex;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth date'**
  String get birthDate;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @healthRoutines.
  ///
  /// In en, this message translates to:
  /// **'Health routines'**
  String get healthRoutines;

  /// No description provided for @activeTreatments.
  ///
  /// In en, this message translates to:
  /// **'Active treatments'**
  String get activeTreatments;

  /// No description provided for @breedingStatus.
  ///
  /// In en, this message translates to:
  /// **'Breeding status'**
  String get breedingStatus;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @matingDate.
  ///
  /// In en, this message translates to:
  /// **'Mating date'**
  String get matingDate;

  /// No description provided for @ramLabel.
  ///
  /// In en, this message translates to:
  /// **'Ram'**
  String get ramLabel;

  /// No description provided for @expectedLambing.
  ///
  /// In en, this message translates to:
  /// **'Expected lambing'**
  String get expectedLambing;

  /// No description provided for @weightTrend.
  ///
  /// In en, this message translates to:
  /// **'Weight trend'**
  String get weightTrend;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @clearForSale.
  ///
  /// In en, this message translates to:
  /// **'CLEAR FOR SALE'**
  String get clearForSale;

  /// No description provided for @notClearForSale.
  ///
  /// In en, this message translates to:
  /// **'NOT CLEAR FOR SALE'**
  String get notClearForSale;

  /// No description provided for @withdrawalDays.
  ///
  /// In en, this message translates to:
  /// **'{count} days remaining'**
  String withdrawalDays(int count);

  /// No description provided for @clearanceDate.
  ///
  /// In en, this message translates to:
  /// **'Clearance · {date}'**
  String clearanceDate(String date);

  /// No description provided for @noSheepFound.
  ///
  /// In en, this message translates to:
  /// **'No sheep found'**
  String get noSheepFound;

  /// No description provided for @tryAnotherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter.'**
  String get tryAnotherSearch;

  /// No description provided for @farmTaskVaccinate.
  ///
  /// In en, this message translates to:
  /// **'Vaccinate Pregnant Ewes'**
  String get farmTaskVaccinate;

  /// No description provided for @farmTaskCheckWater.
  ///
  /// In en, this message translates to:
  /// **'Check Water · North Pasture'**
  String get farmTaskCheckWater;

  /// No description provided for @farmTaskWeighLambs.
  ///
  /// In en, this message translates to:
  /// **'Weigh Lambs · Group B'**
  String get farmTaskWeighLambs;

  /// No description provided for @farmTaskBcs.
  ///
  /// In en, this message translates to:
  /// **'BCS Check · 12 ewes'**
  String get farmTaskBcs;

  /// No description provided for @activityBcs.
  ///
  /// In en, this message translates to:
  /// **'BCS recorded · 2.5'**
  String get activityBcs;

  /// No description provided for @activityTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment · Albendazole'**
  String get activityTreatment;

  /// No description provided for @eventTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment · {medication}'**
  String eventTreatmentTitle(String medication);

  /// No description provided for @eventBcsRecorded.
  ///
  /// In en, this message translates to:
  /// **'BCS recorded · {score}'**
  String eventBcsRecorded(String score);

  /// No description provided for @milkClearanceActive.
  ///
  /// In en, this message translates to:
  /// **'Milk withdrawal · {days} days remaining'**
  String milkClearanceActive(int days);

  /// No description provided for @activityWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight recorded · 62.4 kg'**
  String get activityWeight;

  /// No description provided for @activityMating.
  ///
  /// In en, this message translates to:
  /// **'Mating · Karakul #R12'**
  String get activityMating;

  /// No description provided for @activityVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination · Clostridial'**
  String get activityVaccination;

  /// No description provided for @lastDate.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get lastDate;

  /// No description provided for @nextDate.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextDate;

  /// No description provided for @routineVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get routineVaccination;

  /// No description provided for @routineDeworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get routineDeworming;

  /// No description provided for @routineDipping.
  ///
  /// In en, this message translates to:
  /// **'Dipping'**
  String get routineDipping;

  /// No description provided for @routineHoof.
  ///
  /// In en, this message translates to:
  /// **'Hoof trimming'**
  String get routineHoof;

  /// No description provided for @routineShearing.
  ///
  /// In en, this message translates to:
  /// **'Shearing'**
  String get routineShearing;

  /// No description provided for @routineSupplements.
  ///
  /// In en, this message translates to:
  /// **'Supplements'**
  String get routineSupplements;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Sheep not found'**
  String get profileNotFound;

  /// No description provided for @profileNotFoundDetails.
  ///
  /// In en, this message translates to:
  /// **'This sheep may have been removed from the flock.'**
  String get profileNotFoundDetails;

  /// No description provided for @backToFlock.
  ///
  /// In en, this message translates to:
  /// **'Back to Flock'**
  String get backToFlock;

  /// No description provided for @dueInThreeDays.
  ///
  /// In en, this message translates to:
  /// **'in 3 days'**
  String get dueInThreeDays;

  /// No description provided for @weightRecorded.
  ///
  /// In en, this message translates to:
  /// **'Weight recorded'**
  String get weightRecorded;

  /// No description provided for @breedAwassi.
  ///
  /// In en, this message translates to:
  /// **'Awassi'**
  String get breedAwassi;

  /// No description provided for @breedNajdi.
  ///
  /// In en, this message translates to:
  /// **'Najdi'**
  String get breedNajdi;

  /// No description provided for @breedNaimi.
  ///
  /// In en, this message translates to:
  /// **'Naimi'**
  String get breedNaimi;

  /// No description provided for @breedSuffolk.
  ///
  /// In en, this message translates to:
  /// **'Suffolk'**
  String get breedSuffolk;

  /// No description provided for @groupsCount.
  ///
  /// In en, this message translates to:
  /// **'sheep'**
  String get groupsCount;

  /// No description provided for @attentionDueVaccination.
  ///
  /// In en, this message translates to:
  /// **'4 sheep · vaccination due'**
  String get attentionDueVaccination;

  /// No description provided for @attentionWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'3 sheep · withdrawal active'**
  String get attentionWithdrawal;

  /// No description provided for @withdrawalAlertCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sheep · withdrawal active'**
  String withdrawalAlertCount(int count);

  /// No description provided for @attentionLowBcs.
  ///
  /// In en, this message translates to:
  /// **'2 sheep · low body condition'**
  String get attentionLowBcs;

  /// No description provided for @attentionHeat.
  ///
  /// In en, this message translates to:
  /// **'3 sheep · heat check required'**
  String get attentionHeat;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get pregnancy;

  /// No description provided for @noWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'No active withdrawal'**
  String get noWithdrawal;

  /// No description provided for @recordWeight.
  ///
  /// In en, this message translates to:
  /// **'Record weight'**
  String get recordWeight;

  /// No description provided for @expected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get expected;

  /// No description provided for @lambingHistory.
  ///
  /// In en, this message translates to:
  /// **'Lambing history'**
  String get lambingHistory;

  /// No description provided for @healthyTwins.
  ///
  /// In en, this message translates to:
  /// **'Twins · healthy'**
  String get healthyTwins;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todaysTasks;

  /// No description provided for @humidityReading.
  ///
  /// In en, this message translates to:
  /// **'28% humidity · 14:20'**
  String get humidityReading;

  /// No description provided for @routineDueInDays.
  ///
  /// In en, this message translates to:
  /// **'in 3 days'**
  String get routineDueInDays;

  /// No description provided for @treatmentAdministered.
  ///
  /// In en, this message translates to:
  /// **'Administered · {date} · {dose} {unit} {route}'**
  String treatmentAdministered(
    String date,
    String dose,
    String unit,
    String route,
  );

  /// No description provided for @withdrawalClearance.
  ///
  /// In en, this message translates to:
  /// **'Clearance · {date}'**
  String withdrawalClearance(String date);

  /// No description provided for @farmRole.
  ///
  /// In en, this message translates to:
  /// **'Farm manager'**
  String get farmRole;

  /// No description provided for @dewormingInDays.
  ///
  /// In en, this message translates to:
  /// **'due in 12 days'**
  String get dewormingInDays;

  /// No description provided for @hoofTrimInWeeks.
  ///
  /// In en, this message translates to:
  /// **'due in 2 weeks'**
  String get hoofTrimInWeeks;

  /// No description provided for @routineNotDue.
  ///
  /// In en, this message translates to:
  /// **'No routine due'**
  String get routineNotDue;

  /// No description provided for @bcsCheckDue.
  ///
  /// In en, this message translates to:
  /// **'BCS check due'**
  String get bcsCheckDue;

  /// No description provided for @weightCheckDue.
  ///
  /// In en, this message translates to:
  /// **'Weight check · 12 Oct'**
  String get weightCheckDue;

  /// No description provided for @withdrawalDueDays.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal · 5 days remaining'**
  String get withdrawalDueDays;

  /// No description provided for @confirmedPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Confirmed pregnancy'**
  String get confirmedPregnancy;

  /// No description provided for @numeralSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Numerals'**
  String get numeralSystemTitle;

  /// No description provided for @westernNumerals.
  ///
  /// In en, this message translates to:
  /// **'Western numerals (123)'**
  String get westernNumerals;

  /// No description provided for @arabicIndicNumerals.
  ///
  /// In en, this message translates to:
  /// **'Arabic-Indic numerals (١٢٣)'**
  String get arabicIndicNumerals;

  /// No description provided for @calendarSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarSystemTitle;

  /// No description provided for @gregorianCalendar.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get gregorianCalendar;

  /// No description provided for @hijriCalendar.
  ///
  /// In en, this message translates to:
  /// **'Hijri (calculated)'**
  String get hijriCalendar;

  /// No description provided for @ramKarakul.
  ///
  /// In en, this message translates to:
  /// **'Karakul #{tag}'**
  String ramKarakul(String tag);

  /// No description provided for @pregnancyDayProgress.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy · day {day} of {total}'**
  String pregnancyDayProgress(String day, String total);

  /// No description provided for @recordedByName.
  ///
  /// In en, this message translates to:
  /// **'Recorded by Ahmed'**
  String get recordedByName;

  /// No description provided for @southPasture.
  ///
  /// In en, this message translates to:
  /// **'South Pasture'**
  String get southPasture;

  /// No description provided for @dryEwes.
  ///
  /// In en, this message translates to:
  /// **'Dry Ewes'**
  String get dryEwes;

  /// No description provided for @eastPaddock.
  ///
  /// In en, this message translates to:
  /// **'East Paddock'**
  String get eastPaddock;

  /// No description provided for @lambingBarn.
  ///
  /// In en, this message translates to:
  /// **'Lambing Barn'**
  String get lambingBarn;

  /// No description provided for @lambsGroupB.
  ///
  /// In en, this message translates to:
  /// **'Lambs · Group B'**
  String get lambsGroupB;

  /// No description provided for @eventLabel.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get eventLabel;

  /// No description provided for @sheepEntity.
  ///
  /// In en, this message translates to:
  /// **'Sheep'**
  String get sheepEntity;

  /// No description provided for @farmInitials.
  ///
  /// In en, this message translates to:
  /// **'AN'**
  String get farmInitials;

  /// No description provided for @userAhmed.
  ///
  /// In en, this message translates to:
  /// **'Ahmed'**
  String get userAhmed;

  /// No description provided for @userSara.
  ///
  /// In en, this message translates to:
  /// **'Sara'**
  String get userSara;

  /// No description provided for @connectionMode.
  ///
  /// In en, this message translates to:
  /// **'Connection mode'**
  String get connectionMode;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @syncOnlineDescription.
  ///
  /// In en, this message translates to:
  /// **'Online · Ready to sync'**
  String get syncOnlineDescription;

  /// No description provided for @offlineSavedDescription.
  ///
  /// In en, this message translates to:
  /// **'Offline · Changes saved locally'**
  String get offlineSavedDescription;

  /// No description provided for @pendingCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCountValue(int count);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @syncingStatus.
  ///
  /// In en, this message translates to:
  /// **'Syncing'**
  String get syncingStatus;

  /// No description provided for @syncedStatus.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncedStatus;

  /// No description provided for @failedStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedStatus;

  /// No description provided for @conflictStatus.
  ///
  /// In en, this message translates to:
  /// **'Conflict'**
  String get conflictStatus;

  /// No description provided for @syncQueueEmpty.
  ///
  /// In en, this message translates to:
  /// **'No changes in this view.'**
  String get syncQueueEmpty;

  /// No description provided for @schemaVersion.
  ///
  /// In en, this message translates to:
  /// **'Data schema'**
  String get schemaVersion;

  /// No description provided for @retryCount.
  ///
  /// In en, this message translates to:
  /// **'Retry {count}'**
  String retryCount(int count);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @createOperation.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createOperation;

  /// No description provided for @updateOperation.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateOperation;

  /// No description provided for @deleteOperation.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteOperation;

  /// No description provided for @conflictReview.
  ///
  /// In en, this message translates to:
  /// **'Review sync conflict'**
  String get conflictReview;

  /// No description provided for @criticalConflictDescription.
  ///
  /// In en, this message translates to:
  /// **'A {entity} record changed on another device. Review the local record before retrying; critical farm records are never overwritten automatically.'**
  String criticalConflictDescription(String entity);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @keepLocalAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Keep local and retry'**
  String get keepLocalAndRetry;

  /// No description provided for @conflictQueuedForReview.
  ///
  /// In en, this message translates to:
  /// **'Local record kept for review and queued to sync.'**
  String get conflictQueuedForReview;

  /// No description provided for @savedLocallyWaiting.
  ///
  /// In en, this message translates to:
  /// **'Saved locally · Waiting to sync'**
  String get savedLocallyWaiting;

  /// No description provided for @heatStressTitle.
  ///
  /// In en, this message translates to:
  /// **'Heat stress'**
  String get heatStressTitle;

  /// No description provided for @heatFactors.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get heatFactors;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @thiIndex.
  ///
  /// In en, this message translates to:
  /// **'THI index'**
  String get thiIndex;

  /// No description provided for @recheckInThirty.
  ///
  /// In en, this message translates to:
  /// **'Recheck the flock in 30 minutes'**
  String get recheckInThirty;

  /// No description provided for @recordHeatCheck.
  ///
  /// In en, this message translates to:
  /// **'Record heat check'**
  String get recordHeatCheck;

  /// No description provided for @recentHeatChecks.
  ///
  /// In en, this message translates to:
  /// **'Recent heat checks'**
  String get recentHeatChecks;

  /// No description provided for @noHeatChecks.
  ///
  /// In en, this message translates to:
  /// **'No heat checks recorded yet.'**
  String get noHeatChecks;

  /// No description provided for @symptoms.
  ///
  /// In en, this message translates to:
  /// **'Observed signs'**
  String get symptoms;

  /// No description provided for @panting.
  ///
  /// In en, this message translates to:
  /// **'Panting'**
  String get panting;

  /// No description provided for @lethargy.
  ///
  /// In en, this message translates to:
  /// **'Lethargy'**
  String get lethargy;

  /// No description provided for @excessiveSalivation.
  ///
  /// In en, this message translates to:
  /// **'Excessive salivation'**
  String get excessiveSalivation;

  /// No description provided for @waterAvailable.
  ///
  /// In en, this message translates to:
  /// **'Water available'**
  String get waterAvailable;

  /// No description provided for @shadeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Shade available'**
  String get shadeAvailable;

  /// No description provided for @actionsTaken.
  ///
  /// In en, this message translates to:
  /// **'Actions taken'**
  String get actionsTaken;

  /// No description provided for @heatRiskGuidance.
  ///
  /// In en, this message translates to:
  /// **'Use this configurable reading as decision support, not a veterinary diagnosis.'**
  String get heatRiskGuidance;

  /// No description provided for @heatRiskSafe.
  ///
  /// In en, this message translates to:
  /// **'SAFE'**
  String get heatRiskSafe;

  /// No description provided for @heatRiskAlert.
  ///
  /// In en, this message translates to:
  /// **'ALERT'**
  String get heatRiskAlert;

  /// No description provided for @heatRiskDanger.
  ///
  /// In en, this message translates to:
  /// **'DANGER'**
  String get heatRiskDanger;

  /// No description provided for @heatRiskEmergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get heatRiskEmergency;

  /// No description provided for @breedingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Breeding'**
  String get breedingDashboard;

  /// No description provided for @breedingDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep mating, pregnancy and lambing records together.'**
  String get breedingDescription;

  /// No description provided for @recordMating.
  ///
  /// In en, this message translates to:
  /// **'Record mating'**
  String get recordMating;

  /// No description provided for @upcomingLambings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming lambings'**
  String get upcomingLambings;

  /// No description provided for @noUpcomingLambings.
  ///
  /// In en, this message translates to:
  /// **'No confirmed upcoming lambings.'**
  String get noUpcomingLambings;

  /// No description provided for @pregnancyConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy confirmed'**
  String get pregnancyConfirmed;

  /// No description provided for @siredBy.
  ///
  /// In en, this message translates to:
  /// **'Ram #{tag}'**
  String siredBy(String tag);

  /// No description provided for @recentMatings.
  ///
  /// In en, this message translates to:
  /// **'Recent matings'**
  String get recentMatings;

  /// No description provided for @noRecentMatings.
  ///
  /// In en, this message translates to:
  /// **'No mating records yet.'**
  String get noRecentMatings;

  /// No description provided for @ramNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Ram not recorded'**
  String get ramNotRecorded;

  /// No description provided for @pregnantSheep.
  ///
  /// In en, this message translates to:
  /// **'Pregnant sheep'**
  String get pregnantSheep;

  /// No description provided for @lambCount.
  ///
  /// In en, this message translates to:
  /// **'{count} lambs'**
  String lambCount(int count);

  /// No description provided for @ramTag.
  ///
  /// In en, this message translates to:
  /// **'Ram tag'**
  String get ramTag;

  /// No description provided for @eidMode.
  ///
  /// In en, this message translates to:
  /// **'Eid mode'**
  String get eidMode;

  /// No description provided for @eidCountdown.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha countdown'**
  String get eidCountdown;

  /// No description provided for @daysToEid.
  ///
  /// In en, this message translates to:
  /// **'{count} days remaining'**
  String daysToEid(String count);

  /// No description provided for @estimatedEidDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated date · {date}'**
  String estimatedEidDate(String date);

  /// No description provided for @eidDateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'The date is an estimate and may vary by local moon sighting.'**
  String get eidDateDisclaimer;

  /// No description provided for @readyCandidates.
  ///
  /// In en, this message translates to:
  /// **'{ready} of {total} clear for sale'**
  String readyCandidates(String ready, String total);

  /// No description provided for @eidStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Meets configured criteria'**
  String get eidStatusReady;

  /// No description provided for @eidStatusUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Below configured weight minimum'**
  String get eidStatusUnderweight;

  /// No description provided for @eidStatusLowBcs.
  ///
  /// In en, this message translates to:
  /// **'BCS below configured range'**
  String get eidStatusLowBcs;

  /// No description provided for @eidStatusHighBcs.
  ///
  /// In en, this message translates to:
  /// **'BCS above configured range'**
  String get eidStatusHighBcs;

  /// No description provided for @eidStatusHealth.
  ///
  /// In en, this message translates to:
  /// **'Health status needs review'**
  String get eidStatusHealth;

  /// No description provided for @eidStatusWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal period is active'**
  String get eidStatusWithdrawal;

  /// No description provided for @eidHealthClear.
  ///
  /// In en, this message translates to:
  /// **'No recorded health concern'**
  String get eidHealthClear;

  /// No description provided for @eidHealthConcern.
  ///
  /// In en, this message translates to:
  /// **'Health concern'**
  String get eidHealthConcern;

  /// No description provided for @eidCriteriaSummary.
  ///
  /// In en, this message translates to:
  /// **'Configured minimums: {weight} kg and BCS {bcs}.'**
  String eidCriteriaSummary(String weight, String bcs);

  /// No description provided for @openHeatStress.
  ///
  /// In en, this message translates to:
  /// **'Open heat stress'**
  String get openHeatStress;

  /// No description provided for @openEid.
  ///
  /// In en, this message translates to:
  /// **'Open Eid mode'**
  String get openEid;

  /// No description provided for @recordPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Record pregnancy'**
  String get recordPregnancy;

  /// No description provided for @recordLambing.
  ///
  /// In en, this message translates to:
  /// **'Record lambing'**
  String get recordLambing;

  /// No description provided for @pregnancyStatus.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy status'**
  String get pregnancyStatus;

  /// No description provided for @pregnancyOpen.
  ///
  /// In en, this message translates to:
  /// **'Not pregnant'**
  String get pregnancyOpen;

  /// No description provided for @pregnancyAborted.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy loss'**
  String get pregnancyAborted;

  /// No description provided for @lambCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of lambs'**
  String get lambCountLabel;

  /// No description provided for @noEwesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No ewes are available to record this breeding action.'**
  String get noEwesAvailable;

  /// No description provided for @ramRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the ram tag before saving the mating.'**
  String get ramRequired;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Sync in progress'**
  String get syncInProgress;

  /// No description provided for @editSheep.
  ///
  /// In en, this message translates to:
  /// **'Edit sheep'**
  String get editSheep;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @identificationSection.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identificationSection;

  /// No description provided for @animalInfoSection.
  ///
  /// In en, this message translates to:
  /// **'Animal information'**
  String get animalInfoSection;

  /// No description provided for @managementSection.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get managementSection;

  /// No description provided for @tagNumber.
  ///
  /// In en, this message translates to:
  /// **'Tag number'**
  String get tagNumber;

  /// No description provided for @sheepName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sheepName;

  /// No description provided for @rfidEid.
  ///
  /// In en, this message translates to:
  /// **'RFID / Electronic ID'**
  String get rfidEid;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @markings.
  ///
  /// In en, this message translates to:
  /// **'Markings'**
  String get markings;

  /// No description provided for @primaryGroup.
  ///
  /// In en, this message translates to:
  /// **'Primary group'**
  String get primaryGroup;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source / origin'**
  String get source;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get purchaseDate;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get purchasePrice;

  /// No description provided for @birthDateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Birth date unknown'**
  String get birthDateUnknown;

  /// No description provided for @estimatedAge.
  ///
  /// In en, this message translates to:
  /// **'Estimated age'**
  String get estimatedAge;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @photoPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Camera capture is not available yet; this keeps the field ready.'**
  String get photoPlaceholder;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @duplicateTagMessage.
  ///
  /// In en, this message translates to:
  /// **'This tag number is already assigned to another sheep.'**
  String get duplicateTagMessage;

  /// No description provided for @breedCrossbred.
  ///
  /// In en, this message translates to:
  /// **'Crossbred'**
  String get breedCrossbred;

  /// No description provided for @breedMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get breedMixed;

  /// No description provided for @breedUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get breedUnknown;

  /// No description provided for @breedOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get breedOther;

  /// No description provided for @breedLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get breedLocal;

  /// No description provided for @breedAssaf.
  ///
  /// In en, this message translates to:
  /// **'Assaf'**
  String get breedAssaf;

  /// No description provided for @breedDorper.
  ///
  /// In en, this message translates to:
  /// **'Dorper'**
  String get breedDorper;

  /// No description provided for @breedMerino.
  ///
  /// In en, this message translates to:
  /// **'Merino'**
  String get breedMerino;

  /// No description provided for @breedNajdiCross.
  ///
  /// In en, this message translates to:
  /// **'Najdi Cross'**
  String get breedNajdiCross;

  /// No description provided for @customBreed.
  ///
  /// In en, this message translates to:
  /// **'Custom breed'**
  String get customBreed;

  /// No description provided for @recordBcs.
  ///
  /// In en, this message translates to:
  /// **'Record BCS'**
  String get recordBcs;

  /// No description provided for @recordWeightFor.
  ///
  /// In en, this message translates to:
  /// **'Weight for #{tag}'**
  String recordWeightFor(String tag);

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get weightUnit;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @methodScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get methodScale;

  /// No description provided for @methodEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get methodEstimated;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @lbUnit.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get lbUnit;

  /// No description provided for @saveWeight.
  ///
  /// In en, this message translates to:
  /// **'Save weight'**
  String get saveWeight;

  /// No description provided for @bcsInvalid.
  ///
  /// In en, this message translates to:
  /// **'BCS must be between 1 and 5 in 0.5 steps.'**
  String get bcsInvalid;

  /// No description provided for @weightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight greater than zero.'**
  String get weightInvalid;

  /// No description provided for @healthObservation.
  ///
  /// In en, this message translates to:
  /// **'Health Observation'**
  String get healthObservation;

  /// No description provided for @whatDidYouObserve.
  ///
  /// In en, this message translates to:
  /// **'What did you observe?'**
  String get whatDidYouObserve;

  /// No description provided for @whoIsThisFor.
  ///
  /// In en, this message translates to:
  /// **'Who is this for?'**
  String get whoIsThisFor;

  /// No description provided for @thisSheep.
  ///
  /// In en, this message translates to:
  /// **'This sheep'**
  String get thisSheep;

  /// No description provided for @groupScope.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupScope;

  /// No description provided for @entireFlock.
  ///
  /// In en, this message translates to:
  /// **'Entire flock'**
  String get entireFlock;

  /// No description provided for @selectSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Select symptoms'**
  String get selectSymptoms;

  /// No description provided for @symptomCategoryEating.
  ///
  /// In en, this message translates to:
  /// **'Eating & Digestion'**
  String get symptomCategoryEating;

  /// No description provided for @symptomCategoryBreathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get symptomCategoryBreathing;

  /// No description provided for @symptomCategoryEyes.
  ///
  /// In en, this message translates to:
  /// **'Eyes'**
  String get symptomCategoryEyes;

  /// No description provided for @symptomCategoryMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get symptomCategoryMovement;

  /// No description provided for @symptomCategorySkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get symptomCategorySkin;

  /// No description provided for @symptomCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get symptomCategoryGeneral;

  /// No description provided for @symptomCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get symptomCategoryOther;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @severityMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get severityMild;

  /// No description provided for @severityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get severityModerate;

  /// No description provided for @severitySevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severitySevere;

  /// No description provided for @urgentAttention.
  ///
  /// In en, this message translates to:
  /// **'Urgent Attention'**
  String get urgentAttention;

  /// No description provided for @urgentAttentionBody.
  ///
  /// In en, this message translates to:
  /// **'This observation may require prompt veterinary assessment.'**
  String get urgentAttentionBody;

  /// No description provided for @observationSummary.
  ///
  /// In en, this message translates to:
  /// **'Observation summary'**
  String get observationSummary;

  /// No description provided for @observedSigns.
  ///
  /// In en, this message translates to:
  /// **'Observed signs'**
  String get observedSigns;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @drinking.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get drinking;

  /// No description provided for @suggestedChecks.
  ///
  /// In en, this message translates to:
  /// **'Suggested next checks'**
  String get suggestedChecks;

  /// No description provided for @possibleAreas.
  ///
  /// In en, this message translates to:
  /// **'Possible areas to investigate'**
  String get possibleAreas;

  /// No description provided for @recommendedNextAction.
  ///
  /// In en, this message translates to:
  /// **'Recommended next action'**
  String get recommendedNextAction;

  /// No description provided for @saveObservation.
  ///
  /// In en, this message translates to:
  /// **'Save Observation'**
  String get saveObservation;

  /// No description provided for @createFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Create Follow-up Task'**
  String get createFollowUp;

  /// No description provided for @recordTreatment.
  ///
  /// In en, this message translates to:
  /// **'Record Treatment'**
  String get recordTreatment;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @followUpQuestions.
  ///
  /// In en, this message translates to:
  /// **'Follow-up questions'**
  String get followUpQuestions;

  /// No description provided for @symptomNotEating.
  ///
  /// In en, this message translates to:
  /// **'Not eating'**
  String get symptomNotEating;

  /// No description provided for @symptomReducedAppetite.
  ///
  /// In en, this message translates to:
  /// **'Reduced appetite'**
  String get symptomReducedAppetite;

  /// No description provided for @symptomDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhea'**
  String get symptomDiarrhea;

  /// No description provided for @symptomConstipation.
  ///
  /// In en, this message translates to:
  /// **'Constipation'**
  String get symptomConstipation;

  /// No description provided for @symptomBloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get symptomBloating;

  /// No description provided for @symptomAbnormalStool.
  ///
  /// In en, this message translates to:
  /// **'Abnormal stool'**
  String get symptomAbnormalStool;

  /// No description provided for @symptomDrinkingLess.
  ///
  /// In en, this message translates to:
  /// **'Drinking less'**
  String get symptomDrinkingLess;

  /// No description provided for @symptomNotDrinking.
  ///
  /// In en, this message translates to:
  /// **'Not drinking'**
  String get symptomNotDrinking;

  /// No description provided for @symptomCoughing.
  ///
  /// In en, this message translates to:
  /// **'Coughing'**
  String get symptomCoughing;

  /// No description provided for @symptomDifficultyBreathing.
  ///
  /// In en, this message translates to:
  /// **'Difficulty breathing'**
  String get symptomDifficultyBreathing;

  /// No description provided for @symptomNasalDischarge.
  ///
  /// In en, this message translates to:
  /// **'Nasal discharge'**
  String get symptomNasalDischarge;

  /// No description provided for @symptomEyeRedness.
  ///
  /// In en, this message translates to:
  /// **'Eye redness'**
  String get symptomEyeRedness;

  /// No description provided for @symptomEyeDischarge.
  ///
  /// In en, this message translates to:
  /// **'Eye discharge'**
  String get symptomEyeDischarge;

  /// No description provided for @symptomEyeCloudiness.
  ///
  /// In en, this message translates to:
  /// **'Cloudy eye'**
  String get symptomEyeCloudiness;

  /// No description provided for @symptomEyeSwelling.
  ///
  /// In en, this message translates to:
  /// **'Swollen eye'**
  String get symptomEyeSwelling;

  /// No description provided for @symptomKeepsEyeClosed.
  ///
  /// In en, this message translates to:
  /// **'Keeps eye closed'**
  String get symptomKeepsEyeClosed;

  /// No description provided for @symptomPossibleEyeInjury.
  ///
  /// In en, this message translates to:
  /// **'Possible eye injury'**
  String get symptomPossibleEyeInjury;

  /// No description provided for @symptomLameness.
  ///
  /// In en, this message translates to:
  /// **'Lameness'**
  String get symptomLameness;

  /// No description provided for @symptomSwollenJoint.
  ///
  /// In en, this message translates to:
  /// **'Swollen leg/joint'**
  String get symptomSwollenJoint;

  /// No description provided for @symptomHoofProblem.
  ///
  /// In en, this message translates to:
  /// **'Hoof problem'**
  String get symptomHoofProblem;

  /// No description provided for @symptomItching.
  ///
  /// In en, this message translates to:
  /// **'Itching'**
  String get symptomItching;

  /// No description provided for @symptomHairLoss.
  ///
  /// In en, this message translates to:
  /// **'Hair loss'**
  String get symptomHairLoss;

  /// No description provided for @symptomSkinLesion.
  ///
  /// In en, this message translates to:
  /// **'Skin lesion'**
  String get symptomSkinLesion;

  /// No description provided for @symptomWeakness.
  ///
  /// In en, this message translates to:
  /// **'Weakness'**
  String get symptomWeakness;

  /// No description provided for @symptomLethargy.
  ///
  /// In en, this message translates to:
  /// **'Lethargy'**
  String get symptomLethargy;

  /// No description provided for @symptomFever.
  ///
  /// In en, this message translates to:
  /// **'Fever / feels hot'**
  String get symptomFever;

  /// No description provided for @symptomWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Weight loss'**
  String get symptomWeightLoss;

  /// No description provided for @symptomPaleEyelids.
  ///
  /// In en, this message translates to:
  /// **'Pale eyelids / gums'**
  String get symptomPaleEyelids;

  /// No description provided for @symptomAbnormalUrine.
  ///
  /// In en, this message translates to:
  /// **'Abnormal urine'**
  String get symptomAbnormalUrine;

  /// No description provided for @symptomOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get symptomOther;

  /// No description provided for @qAppetiteDuration.
  ///
  /// In en, this message translates to:
  /// **'How long?'**
  String get qAppetiteDuration;

  /// No description provided for @qDrinking.
  ///
  /// In en, this message translates to:
  /// **'Is the sheep drinking?'**
  String get qDrinking;

  /// No description provided for @qAppetiteOtherSigns.
  ///
  /// In en, this message translates to:
  /// **'Any other signs?'**
  String get qAppetiteOtherSigns;

  /// No description provided for @qDiarrheaDuration.
  ///
  /// In en, this message translates to:
  /// **'How long?'**
  String get qDiarrheaDuration;

  /// No description provided for @qStoolAppearance.
  ///
  /// In en, this message translates to:
  /// **'Stool appearance'**
  String get qStoolAppearance;

  /// No description provided for @qDiarrheaOtherSigns.
  ///
  /// In en, this message translates to:
  /// **'Other signs?'**
  String get qDiarrheaOtherSigns;

  /// No description provided for @qEyeWhatSee.
  ///
  /// In en, this message translates to:
  /// **'What do you see?'**
  String get qEyeWhatSee;

  /// No description provided for @qEyeOneOrBoth.
  ///
  /// In en, this message translates to:
  /// **'One or both eyes?'**
  String get qEyeOneOrBoth;

  /// No description provided for @qEyeRubbing.
  ///
  /// In en, this message translates to:
  /// **'Is the sheep rubbing the eye?'**
  String get qEyeRubbing;

  /// No description provided for @qEyeInjury.
  ///
  /// In en, this message translates to:
  /// **'Is there an obvious injury?'**
  String get qEyeInjury;

  /// No description provided for @qLamenessSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get qLamenessSeverity;

  /// No description provided for @qLamenessLeg.
  ///
  /// In en, this message translates to:
  /// **'Which leg?'**
  String get qLamenessLeg;

  /// No description provided for @qHoofAppearance.
  ///
  /// In en, this message translates to:
  /// **'Hoof appearance'**
  String get qHoofAppearance;

  /// No description provided for @optLess12h.
  ///
  /// In en, this message translates to:
  /// **'Less than 12 hours'**
  String get optLess12h;

  /// No description provided for @opt12_24h.
  ///
  /// In en, this message translates to:
  /// **'12–24 hours'**
  String get opt12_24h;

  /// No description provided for @opt1_2Days.
  ///
  /// In en, this message translates to:
  /// **'1–2 days'**
  String get opt1_2Days;

  /// No description provided for @optMore2Days.
  ///
  /// In en, this message translates to:
  /// **'More than 2 days'**
  String get optMore2Days;

  /// No description provided for @optUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get optUnknown;

  /// No description provided for @optNormally.
  ///
  /// In en, this message translates to:
  /// **'Normally'**
  String get optNormally;

  /// No description provided for @optLessThanNormal.
  ///
  /// In en, this message translates to:
  /// **'Less than normal'**
  String get optLessThanNormal;

  /// No description provided for @optNotDrinking.
  ///
  /// In en, this message translates to:
  /// **'Not drinking'**
  String get optNotDrinking;

  /// No description provided for @optTeethGrinding.
  ///
  /// In en, this message translates to:
  /// **'Teeth grinding'**
  String get optTeethGrinding;

  /// No description provided for @optLess1Day.
  ///
  /// In en, this message translates to:
  /// **'Less than 1 day'**
  String get optLess1Day;

  /// No description provided for @opt3_5Days.
  ///
  /// In en, this message translates to:
  /// **'3–5 days'**
  String get opt3_5Days;

  /// No description provided for @optMore5Days.
  ///
  /// In en, this message translates to:
  /// **'More than 5 days'**
  String get optMore5Days;

  /// No description provided for @optLoose.
  ///
  /// In en, this message translates to:
  /// **'Loose'**
  String get optLoose;

  /// No description provided for @optWatery.
  ///
  /// In en, this message translates to:
  /// **'Watery'**
  String get optWatery;

  /// No description provided for @optVeryWatery.
  ///
  /// In en, this message translates to:
  /// **'Very watery'**
  String get optVeryWatery;

  /// No description provided for @optMucus.
  ///
  /// In en, this message translates to:
  /// **'Mucus present'**
  String get optMucus;

  /// No description provided for @optBlood.
  ///
  /// In en, this message translates to:
  /// **'Blood present'**
  String get optBlood;

  /// No description provided for @optRedness.
  ///
  /// In en, this message translates to:
  /// **'Redness'**
  String get optRedness;

  /// No description provided for @optCloudiness.
  ///
  /// In en, this message translates to:
  /// **'Cloudiness'**
  String get optCloudiness;

  /// No description provided for @optDischarge.
  ///
  /// In en, this message translates to:
  /// **'Discharge'**
  String get optDischarge;

  /// No description provided for @optSwelling.
  ///
  /// In en, this message translates to:
  /// **'Swelling'**
  String get optSwelling;

  /// No description provided for @optKeepsClosed.
  ///
  /// In en, this message translates to:
  /// **'Keeps eye closed'**
  String get optKeepsClosed;

  /// No description provided for @optTearing.
  ///
  /// In en, this message translates to:
  /// **'Excessive tearing'**
  String get optTearing;

  /// No description provided for @optPossibleInjury.
  ///
  /// In en, this message translates to:
  /// **'Possible injury'**
  String get optPossibleInjury;

  /// No description provided for @optDifficultySeeing.
  ///
  /// In en, this message translates to:
  /// **'Difficulty seeing'**
  String get optDifficultySeeing;

  /// No description provided for @optLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get optLeft;

  /// No description provided for @optRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get optRight;

  /// No description provided for @optBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get optBoth;

  /// No description provided for @optYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optYes;

  /// No description provided for @optNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optNo;

  /// No description provided for @optNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get optNotSure;

  /// No description provided for @optSlight.
  ///
  /// In en, this message translates to:
  /// **'Slight'**
  String get optSlight;

  /// No description provided for @optModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get optModerate;

  /// No description provided for @optSevere.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get optSevere;

  /// No description provided for @optUnableToWalk.
  ///
  /// In en, this message translates to:
  /// **'Unable to walk'**
  String get optUnableToWalk;

  /// No description provided for @optFrontLeft.
  ///
  /// In en, this message translates to:
  /// **'Front left'**
  String get optFrontLeft;

  /// No description provided for @optFrontRight.
  ///
  /// In en, this message translates to:
  /// **'Front right'**
  String get optFrontRight;

  /// No description provided for @optRearLeft.
  ///
  /// In en, this message translates to:
  /// **'Rear left'**
  String get optRearLeft;

  /// No description provided for @optRearRight.
  ///
  /// In en, this message translates to:
  /// **'Rear right'**
  String get optRearRight;

  /// No description provided for @optNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get optNormal;

  /// No description provided for @optOvergrown.
  ///
  /// In en, this message translates to:
  /// **'Overgrown'**
  String get optOvergrown;

  /// No description provided for @optDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get optDamaged;

  /// No description provided for @optSwollen.
  ///
  /// In en, this message translates to:
  /// **'Swollen'**
  String get optSwollen;

  /// No description provided for @optBadOdor.
  ///
  /// In en, this message translates to:
  /// **'Bad odor'**
  String get optBadOdor;

  /// No description provided for @checkTemperature.
  ///
  /// In en, this message translates to:
  /// **'Check temperature'**
  String get checkTemperature;

  /// No description provided for @checkHydration.
  ///
  /// In en, this message translates to:
  /// **'Check hydration'**
  String get checkHydration;

  /// No description provided for @checkEyelidColor.
  ///
  /// In en, this message translates to:
  /// **'Check eyelid/gum color'**
  String get checkEyelidColor;

  /// No description provided for @checkFeces.
  ///
  /// In en, this message translates to:
  /// **'Check feces'**
  String get checkFeces;

  /// No description provided for @checkFeedChanges.
  ///
  /// In en, this message translates to:
  /// **'Check recent feed changes'**
  String get checkFeedChanges;

  /// No description provided for @checkOtherSheep.
  ///
  /// In en, this message translates to:
  /// **'Check whether other sheep are affected'**
  String get checkOtherSheep;

  /// No description provided for @monitorWater.
  ///
  /// In en, this message translates to:
  /// **'Monitor water intake'**
  String get monitorWater;

  /// No description provided for @examineEyeLight.
  ///
  /// In en, this message translates to:
  /// **'Examine the eye in good light'**
  String get examineEyeLight;

  /// No description provided for @checkForeignMaterial.
  ///
  /// In en, this message translates to:
  /// **'Check for foreign material or injury'**
  String get checkForeignMaterial;

  /// No description provided for @monitorVision.
  ///
  /// In en, this message translates to:
  /// **'Monitor whether vision appears affected'**
  String get monitorVision;

  /// No description provided for @inspectHoof.
  ///
  /// In en, this message translates to:
  /// **'Inspect hoof'**
  String get inspectHoof;

  /// No description provided for @areaDigestiveProblem.
  ///
  /// In en, this message translates to:
  /// **'Digestive problem'**
  String get areaDigestiveProblem;

  /// No description provided for @areaFeedRelated.
  ///
  /// In en, this message translates to:
  /// **'Feed-related issue'**
  String get areaFeedRelated;

  /// No description provided for @areaParasiteBurden.
  ///
  /// In en, this message translates to:
  /// **'Parasite burden'**
  String get areaParasiteBurden;

  /// No description provided for @areaInfection.
  ///
  /// In en, this message translates to:
  /// **'Infection'**
  String get areaInfection;

  /// No description provided for @areaDentalMouth.
  ///
  /// In en, this message translates to:
  /// **'Dental/mouth problem'**
  String get areaDentalMouth;

  /// No description provided for @areaPainInjury.
  ///
  /// In en, this message translates to:
  /// **'Pain or injury'**
  String get areaPainInjury;

  /// No description provided for @areaUnderlying.
  ///
  /// In en, this message translates to:
  /// **'Other underlying condition'**
  String get areaUnderlying;

  /// No description provided for @areaEyeIrritation.
  ///
  /// In en, this message translates to:
  /// **'Irritation'**
  String get areaEyeIrritation;

  /// No description provided for @areaEyeInjury.
  ///
  /// In en, this message translates to:
  /// **'Injury'**
  String get areaEyeInjury;

  /// No description provided for @areaEyeInfection.
  ///
  /// In en, this message translates to:
  /// **'Infectious eye problem'**
  String get areaEyeInfection;

  /// No description provided for @areaEyeForeignMaterial.
  ///
  /// In en, this message translates to:
  /// **'Foreign material'**
  String get areaEyeForeignMaterial;

  /// No description provided for @areaHoofProblem.
  ///
  /// In en, this message translates to:
  /// **'Hoof problem'**
  String get areaHoofProblem;

  /// No description provided for @areaJointProblem.
  ///
  /// In en, this message translates to:
  /// **'Joint problem'**
  String get areaJointProblem;

  /// No description provided for @actionMonitorClosely.
  ///
  /// In en, this message translates to:
  /// **'Monitor closely and consider veterinary assessment if symptoms persist or worsen.'**
  String get actionMonitorClosely;

  /// No description provided for @actionInspectEye.
  ///
  /// In en, this message translates to:
  /// **'Inspect eye'**
  String get actionInspectEye;

  /// No description provided for @actionInspectHoof.
  ///
  /// In en, this message translates to:
  /// **'Inspect hoof'**
  String get actionInspectHoof;

  /// No description provided for @actionSeparateFlock.
  ///
  /// In en, this message translates to:
  /// **'Separate from flock if appropriate'**
  String get actionSeparateFlock;

  /// No description provided for @redFlagSevereBreathing.
  ///
  /// In en, this message translates to:
  /// **'Severe breathing difficulty'**
  String get redFlagSevereBreathing;

  /// No description provided for @redFlagSevereBloating.
  ///
  /// In en, this message translates to:
  /// **'Severe bloating'**
  String get redFlagSevereBloating;

  /// No description provided for @redFlagSevereWeakness.
  ///
  /// In en, this message translates to:
  /// **'Severe weakness'**
  String get redFlagSevereWeakness;

  /// No description provided for @redFlagNotDrinking.
  ///
  /// In en, this message translates to:
  /// **'Not drinking'**
  String get redFlagNotDrinking;

  /// No description provided for @redFlagUnableToStand.
  ///
  /// In en, this message translates to:
  /// **'Unable to stand'**
  String get redFlagUnableToStand;

  /// No description provided for @redFlagSevereEyeInjury.
  ///
  /// In en, this message translates to:
  /// **'Eye injury requires assessment'**
  String get redFlagSevereEyeInjury;

  /// No description provided for @medicationLibrary.
  ///
  /// In en, this message translates to:
  /// **'Medication Library'**
  String get medicationLibrary;

  /// No description provided for @searchMedication.
  ///
  /// In en, this message translates to:
  /// **'Search medication...'**
  String get searchMedication;

  /// No description provided for @medicationCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get medicationCategory;

  /// No description provided for @categoryAntibiotic.
  ///
  /// In en, this message translates to:
  /// **'Antibiotic'**
  String get categoryAntibiotic;

  /// No description provided for @categoryAntiparasitic.
  ///
  /// In en, this message translates to:
  /// **'Antiparasitic'**
  String get categoryAntiparasitic;

  /// No description provided for @categoryAntiInflammatory.
  ///
  /// In en, this message translates to:
  /// **'Anti-inflammatory'**
  String get categoryAntiInflammatory;

  /// No description provided for @categoryPainRelief.
  ///
  /// In en, this message translates to:
  /// **'Pain relief'**
  String get categoryPainRelief;

  /// No description provided for @categoryVitaminMineral.
  ///
  /// In en, this message translates to:
  /// **'Vitamin / Mineral'**
  String get categoryVitaminMineral;

  /// No description provided for @categoryElectrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte'**
  String get categoryElectrolyte;

  /// No description provided for @categoryEyeTreatment.
  ///
  /// In en, this message translates to:
  /// **'Eye treatment'**
  String get categoryEyeTreatment;

  /// No description provided for @categoryTopicalTreatment.
  ///
  /// In en, this message translates to:
  /// **'Topical treatment'**
  String get categoryTopicalTreatment;

  /// No description provided for @categoryHoofTreatment.
  ///
  /// In en, this message translates to:
  /// **'Hoof treatment'**
  String get categoryHoofTreatment;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @activeIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active ingredient'**
  String get activeIngredient;

  /// No description provided for @availableRoutes.
  ///
  /// In en, this message translates to:
  /// **'Available routes'**
  String get availableRoutes;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @medicationInformation.
  ///
  /// In en, this message translates to:
  /// **'Medication information'**
  String get medicationInformation;

  /// No description provided for @treatmentOptionsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Treatment options to discuss with your veterinarian'**
  String get treatmentOptionsDisclaimer;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @doseUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get doseUnit;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'mL'**
  String get unitMl;

  /// No description provided for @unitMg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get unitMg;

  /// No description provided for @unitG.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitG;

  /// No description provided for @unitTablet.
  ///
  /// In en, this message translates to:
  /// **'tablet'**
  String get unitTablet;

  /// No description provided for @unitBolus.
  ///
  /// In en, this message translates to:
  /// **'bolus'**
  String get unitBolus;

  /// No description provided for @unitOther.
  ///
  /// In en, this message translates to:
  /// **'other'**
  String get unitOther;

  /// No description provided for @routeEye.
  ///
  /// In en, this message translates to:
  /// **'Eye'**
  String get routeEye;

  /// No description provided for @routeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get routeOther;

  /// No description provided for @administeredBy.
  ///
  /// In en, this message translates to:
  /// **'Administered by'**
  String get administeredBy;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date/time'**
  String get dateTime;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @meatClearance.
  ///
  /// In en, this message translates to:
  /// **'Meat clearance'**
  String get meatClearance;

  /// No description provided for @milkClearance.
  ///
  /// In en, this message translates to:
  /// **'Milk clearance'**
  String get milkClearance;

  /// No description provided for @meatWithdrawalUntil.
  ///
  /// In en, this message translates to:
  /// **'Meat withdrawal until {date}'**
  String meatWithdrawalUntil(String date);

  /// No description provided for @milkWithdrawalUntil.
  ///
  /// In en, this message translates to:
  /// **'Milk withdrawal until {date}'**
  String milkWithdrawalUntil(String date);

  /// No description provided for @followUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get followUp;

  /// No description provided for @followUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get followUpTitle;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priorityNormal;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @saveFollowUp.
  ///
  /// In en, this message translates to:
  /// **'Save follow-up'**
  String get saveFollowUp;

  /// No description provided for @followUpSaved.
  ///
  /// In en, this message translates to:
  /// **'Follow-up task created'**
  String get followUpSaved;

  /// No description provided for @activeWithdrawals.
  ///
  /// In en, this message translates to:
  /// **'Active Withdrawals'**
  String get activeWithdrawals;

  /// No description provided for @sheepNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'{count} sheep need attention'**
  String sheepNeedAttention(int count);

  /// No description provided for @healthConcerns.
  ///
  /// In en, this message translates to:
  /// **'Health concerns'**
  String get healthConcerns;

  /// No description provided for @underWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Under withdrawal'**
  String get underWithdrawal;

  /// No description provided for @followUpDueToday.
  ///
  /// In en, this message translates to:
  /// **'Follow-up due today'**
  String get followUpDueToday;

  /// No description provided for @recentHealthObservation.
  ///
  /// In en, this message translates to:
  /// **'Recent health observation'**
  String get recentHealthObservation;

  /// No description provided for @eventHealthObservation.
  ///
  /// In en, this message translates to:
  /// **'Health Observation'**
  String get eventHealthObservation;

  /// No description provided for @eventIdentityChanged.
  ///
  /// In en, this message translates to:
  /// **'Identity updated'**
  String get eventIdentityChanged;

  /// No description provided for @identityChangeDetail.
  ///
  /// In en, this message translates to:
  /// **'{field} · {old} → {newValue}'**
  String identityChangeDetail(String field, String old, String newValue);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @symptomRapidBreathing.
  ///
  /// In en, this message translates to:
  /// **'Rapid breathing'**
  String get symptomRapidBreathing;

  /// No description provided for @symptomTearing.
  ///
  /// In en, this message translates to:
  /// **'Tearing'**
  String get symptomTearing;

  /// No description provided for @symptomHoofSwelling.
  ///
  /// In en, this message translates to:
  /// **'Swollen hoof'**
  String get symptomHoofSwelling;

  /// No description provided for @symptomHoofBadOdor.
  ///
  /// In en, this message translates to:
  /// **'Bad odor (hoof)'**
  String get symptomHoofBadOdor;

  /// No description provided for @symptomAbdominalPain.
  ///
  /// In en, this message translates to:
  /// **'Abdominal pain'**
  String get symptomAbdominalPain;

  /// No description provided for @symptomBottleJaw.
  ///
  /// In en, this message translates to:
  /// **'Bottle jaw'**
  String get symptomBottleJaw;

  /// No description provided for @symptomRecumbent.
  ///
  /// In en, this message translates to:
  /// **'Unable to stand / recumbent'**
  String get symptomRecumbent;

  /// No description provided for @symptomNeurologicSigns.
  ///
  /// In en, this message translates to:
  /// **'Neurologic signs'**
  String get symptomNeurologicSigns;

  /// No description provided for @symptomSuddenIllness.
  ///
  /// In en, this message translates to:
  /// **'Sudden severe illness'**
  String get symptomSuddenIllness;

  /// No description provided for @symptomSuddenDeath.
  ///
  /// In en, this message translates to:
  /// **'Sudden death'**
  String get symptomSuddenDeath;

  /// No description provided for @symptomCrusts.
  ///
  /// In en, this message translates to:
  /// **'Crusts'**
  String get symptomCrusts;

  /// No description provided for @symptomVisibleParasites.
  ///
  /// In en, this message translates to:
  /// **'Visible parasites'**
  String get symptomVisibleParasites;

  /// No description provided for @conditionHaemonchosis.
  ///
  /// In en, this message translates to:
  /// **'Haemonchosis'**
  String get conditionHaemonchosis;

  /// No description provided for @conditionGastrointestinalParasitism.
  ///
  /// In en, this message translates to:
  /// **'Gastrointestinal parasitism'**
  String get conditionGastrointestinalParasitism;

  /// No description provided for @conditionCoccidiosis.
  ///
  /// In en, this message translates to:
  /// **'Coccidiosis'**
  String get conditionCoccidiosis;

  /// No description provided for @conditionGrainOverload.
  ///
  /// In en, this message translates to:
  /// **'Grain overload / lactic acidosis'**
  String get conditionGrainOverload;

  /// No description provided for @conditionEnterotoxemia.
  ///
  /// In en, this message translates to:
  /// **'Enterotoxemia'**
  String get conditionEnterotoxemia;

  /// No description provided for @conditionBacterialPneumonia.
  ///
  /// In en, this message translates to:
  /// **'Bacterial pneumonia'**
  String get conditionBacterialPneumonia;

  /// No description provided for @conditionRespiratoryDisease.
  ///
  /// In en, this message translates to:
  /// **'Respiratory disease'**
  String get conditionRespiratoryDisease;

  /// No description provided for @conditionPinkeye.
  ///
  /// In en, this message translates to:
  /// **'Pinkeye'**
  String get conditionPinkeye;

  /// No description provided for @conditionFootrot.
  ///
  /// In en, this message translates to:
  /// **'Footrot'**
  String get conditionFootrot;

  /// No description provided for @conditionPregnancyToxemia.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy toxemia'**
  String get conditionPregnancyToxemia;

  /// No description provided for @conditionHypocalcemia.
  ///
  /// In en, this message translates to:
  /// **'Hypocalcemia'**
  String get conditionHypocalcemia;

  /// No description provided for @conditionExternalParasites.
  ///
  /// In en, this message translates to:
  /// **'External parasites'**
  String get conditionExternalParasites;

  /// No description provided for @conditionDehydration.
  ///
  /// In en, this message translates to:
  /// **'Dehydration'**
  String get conditionDehydration;

  /// No description provided for @conditionFeverInfection.
  ///
  /// In en, this message translates to:
  /// **'Fever / infection'**
  String get conditionFeverInfection;

  /// No description provided for @conditionGeneralEnteritis.
  ///
  /// In en, this message translates to:
  /// **'General enteritis'**
  String get conditionGeneralEnteritis;

  /// No description provided for @conditionSalmonellosis.
  ///
  /// In en, this message translates to:
  /// **'Salmonellosis'**
  String get conditionSalmonellosis;

  /// No description provided for @categoryDigestive.
  ///
  /// In en, this message translates to:
  /// **'Digestive'**
  String get categoryDigestive;

  /// No description provided for @categoryRespiratory.
  ///
  /// In en, this message translates to:
  /// **'Respiratory'**
  String get categoryRespiratory;

  /// No description provided for @categoryEye.
  ///
  /// In en, this message translates to:
  /// **'Eye'**
  String get categoryEye;

  /// No description provided for @categoryHoof.
  ///
  /// In en, this message translates to:
  /// **'Hoof / Musculoskeletal'**
  String get categoryHoof;

  /// No description provided for @categoryMetabolic.
  ///
  /// In en, this message translates to:
  /// **'Metabolic'**
  String get categoryMetabolic;

  /// No description provided for @categoryParasite.
  ///
  /// In en, this message translates to:
  /// **'Parasites'**
  String get categoryParasite;

  /// No description provided for @categorySkin.
  ///
  /// In en, this message translates to:
  /// **'Skin'**
  String get categorySkin;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General / Infectious'**
  String get categoryGeneral;

  /// No description provided for @categoryReproductive.
  ///
  /// In en, this message translates to:
  /// **'Reproductive'**
  String get categoryReproductive;

  /// No description provided for @compatibilityStronglyCompatible.
  ///
  /// In en, this message translates to:
  /// **'Strongly compatible pattern'**
  String get compatibilityStronglyCompatible;

  /// No description provided for @compatibilityCompatible.
  ///
  /// In en, this message translates to:
  /// **'Compatible pattern'**
  String get compatibilityCompatible;

  /// No description provided for @compatibilityPossible.
  ///
  /// In en, this message translates to:
  /// **'Possible'**
  String get compatibilityPossible;

  /// No description provided for @compatibilityLessLikely.
  ///
  /// In en, this message translates to:
  /// **'Less likely'**
  String get compatibilityLessLikely;

  /// No description provided for @compatibilityInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient information'**
  String get compatibilityInsufficient;

  /// No description provided for @riskRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine'**
  String get riskRoutine;

  /// No description provided for @riskNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get riskNeedsAttention;

  /// No description provided for @riskUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get riskUrgent;

  /// No description provided for @redFlagNeurologicSigns.
  ///
  /// In en, this message translates to:
  /// **'Neurologic signs'**
  String get redFlagNeurologicSigns;

  /// No description provided for @redFlagSuddenDeath.
  ///
  /// In en, this message translates to:
  /// **'Sudden death'**
  String get redFlagSuddenDeath;

  /// No description provided for @redFlagSevereDehydration.
  ///
  /// In en, this message translates to:
  /// **'Severe dehydration'**
  String get redFlagSevereDehydration;

  /// No description provided for @checkFamacha.
  ///
  /// In en, this message translates to:
  /// **'FAMACHA score'**
  String get checkFamacha;

  /// No description provided for @checkFecalEggCount.
  ///
  /// In en, this message translates to:
  /// **'Fecal egg count'**
  String get checkFecalEggCount;

  /// No description provided for @checkBodyCondition.
  ///
  /// In en, this message translates to:
  /// **'Body condition'**
  String get checkBodyCondition;

  /// No description provided for @checkDewormingHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent deworming history'**
  String get checkDewormingHistory;

  /// No description provided for @checkAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get checkAge;

  /// No description provided for @checkFecalExam.
  ///
  /// In en, this message translates to:
  /// **'Fecal examination'**
  String get checkFecalExam;

  /// No description provided for @checkBloodMucus.
  ///
  /// In en, this message translates to:
  /// **'Blood/mucus in feces'**
  String get checkBloodMucus;

  /// No description provided for @checkGestationStage.
  ///
  /// In en, this message translates to:
  /// **'Gestation stage'**
  String get checkGestationStage;

  /// No description provided for @checkLitterSize.
  ///
  /// In en, this message translates to:
  /// **'Litter size'**
  String get checkLitterSize;

  /// No description provided for @checkKetoneBhb.
  ///
  /// In en, this message translates to:
  /// **'Ketones / BHB'**
  String get checkKetoneBhb;

  /// No description provided for @checkBloodGlucose.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose'**
  String get checkBloodGlucose;

  /// No description provided for @checkRespiratoryRate.
  ///
  /// In en, this message translates to:
  /// **'Respiratory rate'**
  String get checkRespiratoryRate;

  /// No description provided for @checkRumen.
  ///
  /// In en, this message translates to:
  /// **'Rumen / bloat'**
  String get checkRumen;

  /// No description provided for @checkVaccinationStatus.
  ///
  /// In en, this message translates to:
  /// **'Vaccination status'**
  String get checkVaccinationStatus;

  /// No description provided for @checkAffectedAgeGroup.
  ///
  /// In en, this message translates to:
  /// **'Affected age group'**
  String get checkAffectedAgeGroup;

  /// No description provided for @checkNumberAffected.
  ///
  /// In en, this message translates to:
  /// **'Number affected'**
  String get checkNumberAffected;

  /// No description provided for @checkCorneal.
  ///
  /// In en, this message translates to:
  /// **'Corneal cloudiness'**
  String get checkCorneal;

  /// No description provided for @checkOneBothEyes.
  ///
  /// In en, this message translates to:
  /// **'One or both eyes'**
  String get checkOneBothEyes;

  /// No description provided for @checkUlcerInjury.
  ///
  /// In en, this message translates to:
  /// **'Ulcer / injury'**
  String get checkUlcerInjury;

  /// No description provided for @checkPainSquinting.
  ///
  /// In en, this message translates to:
  /// **'Pain / squinting'**
  String get checkPainSquinting;

  /// No description provided for @checkVision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get checkVision;

  /// No description provided for @checkHoofOdor.
  ///
  /// In en, this message translates to:
  /// **'Hoof odor'**
  String get checkHoofOdor;

  /// No description provided for @checkVisibleParasites.
  ///
  /// In en, this message translates to:
  /// **'Visible parasites'**
  String get checkVisibleParasites;

  /// No description provided for @checkAffectedAreas.
  ///
  /// In en, this message translates to:
  /// **'Affected areas'**
  String get checkAffectedAreas;

  /// No description provided for @checkNasalDischarge.
  ///
  /// In en, this message translates to:
  /// **'Nasal discharge'**
  String get checkNasalDischarge;

  /// No description provided for @checkDrinking.
  ///
  /// In en, this message translates to:
  /// **'Drinking'**
  String get checkDrinking;

  /// No description provided for @checkRecentFeedChange.
  ///
  /// In en, this message translates to:
  /// **'Recent feed change'**
  String get checkRecentFeedChange;

  /// No description provided for @actionIsolate.
  ///
  /// In en, this message translates to:
  /// **'Isolate sheep'**
  String get actionIsolate;

  /// No description provided for @actionCleanWater.
  ///
  /// In en, this message translates to:
  /// **'Provide clean water'**
  String get actionCleanWater;

  /// No description provided for @actionAssessNow.
  ///
  /// In en, this message translates to:
  /// **'Assess immediately'**
  String get actionAssessNow;

  /// No description provided for @actionRemoveFeed.
  ///
  /// In en, this message translates to:
  /// **'Remove access to suspected feed'**
  String get actionRemoveFeed;

  /// No description provided for @actionContactVet.
  ///
  /// In en, this message translates to:
  /// **'Contact veterinarian'**
  String get actionContactVet;

  /// No description provided for @actionRecordTemperature.
  ///
  /// In en, this message translates to:
  /// **'Record body temperature'**
  String get actionRecordTemperature;

  /// No description provided for @actionInspectEyes.
  ///
  /// In en, this message translates to:
  /// **'Inspect eyes'**
  String get actionInspectEyes;

  /// No description provided for @actionCheckMucousMembrane.
  ///
  /// In en, this message translates to:
  /// **'Check mucous membrane color'**
  String get actionCheckMucousMembrane;

  /// No description provided for @actionMoveCleanDry.
  ///
  /// In en, this message translates to:
  /// **'Move to cleaner/drier conditions'**
  String get actionMoveCleanDry;

  /// No description provided for @actionSupportNutrition.
  ///
  /// In en, this message translates to:
  /// **'Support nutrition'**
  String get actionSupportNutrition;

  /// No description provided for @actionMonitorFlock.
  ///
  /// In en, this message translates to:
  /// **'Monitor other sheep'**
  String get actionMonitorFlock;

  /// No description provided for @actionReviewVaccination.
  ///
  /// In en, this message translates to:
  /// **'Review vaccination status'**
  String get actionReviewVaccination;

  /// No description provided for @treatmentSupportiveCare.
  ///
  /// In en, this message translates to:
  /// **'Supportive care'**
  String get treatmentSupportiveCare;

  /// No description provided for @treatmentAntiparasitic.
  ///
  /// In en, this message translates to:
  /// **'Antiparasitic'**
  String get treatmentAntiparasitic;

  /// No description provided for @treatmentAnticoccidial.
  ///
  /// In en, this message translates to:
  /// **'Anticoccidial'**
  String get treatmentAnticoccidial;

  /// No description provided for @treatmentAntimicrobial.
  ///
  /// In en, this message translates to:
  /// **'Antimicrobial'**
  String get treatmentAntimicrobial;

  /// No description provided for @treatmentAntiInflammatory.
  ///
  /// In en, this message translates to:
  /// **'Anti-inflammatory'**
  String get treatmentAntiInflammatory;

  /// No description provided for @treatmentElectrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte / fluid support'**
  String get treatmentElectrolyte;

  /// No description provided for @treatmentNutritional.
  ///
  /// In en, this message translates to:
  /// **'Nutritional support'**
  String get treatmentNutritional;

  /// No description provided for @treatmentTopical.
  ///
  /// In en, this message translates to:
  /// **'Topical treatment'**
  String get treatmentTopical;

  /// No description provided for @treatmentFootbath.
  ///
  /// In en, this message translates to:
  /// **'Footbath / hoof management'**
  String get treatmentFootbath;

  /// No description provided for @treatmentIsolation.
  ///
  /// In en, this message translates to:
  /// **'Isolation'**
  String get treatmentIsolation;

  /// No description provided for @treatmentSurgical.
  ///
  /// In en, this message translates to:
  /// **'Surgical / veterinary intervention'**
  String get treatmentSurgical;

  /// No description provided for @treatmentMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get treatmentMonitoring;

  /// No description provided for @treatmentPreventiveVaccination.
  ///
  /// In en, this message translates to:
  /// **'Preventive vaccination'**
  String get treatmentPreventiveVaccination;

  /// No description provided for @treatmentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get treatmentOther;

  /// No description provided for @protocolSupportiveCare.
  ///
  /// In en, this message translates to:
  /// **'Supportive care'**
  String get protocolSupportiveCare;

  /// No description provided for @protocolParasiteControl.
  ///
  /// In en, this message translates to:
  /// **'Parasite-control protocol'**
  String get protocolParasiteControl;

  /// No description provided for @protocolAnticoccidialTherapy.
  ///
  /// In en, this message translates to:
  /// **'Anticoccidial therapy'**
  String get protocolAnticoccidialTherapy;

  /// No description provided for @protocolAntimicrobialWhenIndicated.
  ///
  /// In en, this message translates to:
  /// **'Antimicrobial (when indicated)'**
  String get protocolAntimicrobialWhenIndicated;

  /// No description provided for @protocolOphthalmic.
  ///
  /// In en, this message translates to:
  /// **'Ophthalmic treatment'**
  String get protocolOphthalmic;

  /// No description provided for @protocolFootbathHoof.
  ///
  /// In en, this message translates to:
  /// **'Footbath / hoof management'**
  String get protocolFootbathHoof;

  /// No description provided for @protocolMetabolic.
  ///
  /// In en, this message translates to:
  /// **'Veterinary-directed metabolic treatment'**
  String get protocolMetabolic;

  /// No description provided for @protocolIsolation.
  ///
  /// In en, this message translates to:
  /// **'Isolation'**
  String get protocolIsolation;

  /// No description provided for @protocolMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get protocolMonitoring;

  /// No description provided for @protocolTopical.
  ///
  /// In en, this message translates to:
  /// **'Topical treatment'**
  String get protocolTopical;

  /// No description provided for @protocolPreventiveVaccination.
  ///
  /// In en, this message translates to:
  /// **'Preventive vaccination'**
  String get protocolPreventiveVaccination;

  /// No description provided for @protocolElectrolyte.
  ///
  /// In en, this message translates to:
  /// **'Electrolyte / fluid support'**
  String get protocolElectrolyte;

  /// No description provided for @riskRecentFeedChange.
  ///
  /// In en, this message translates to:
  /// **'Recent feed change'**
  String get riskRecentFeedChange;

  /// No description provided for @riskRecentGrainAccess.
  ///
  /// In en, this message translates to:
  /// **'Recent grain access'**
  String get riskRecentGrainAccess;

  /// No description provided for @riskMultipleAffected.
  ///
  /// In en, this message translates to:
  /// **'Multiple sheep affected'**
  String get riskMultipleAffected;

  /// No description provided for @riskCrowded.
  ///
  /// In en, this message translates to:
  /// **'Crowding'**
  String get riskCrowded;

  /// No description provided for @riskPastureExposure.
  ///
  /// In en, this message translates to:
  /// **'Pasture exposure'**
  String get riskPastureExposure;

  /// No description provided for @riskWetConditions.
  ///
  /// In en, this message translates to:
  /// **'Wet conditions'**
  String get riskWetConditions;

  /// No description provided for @riskRecentTransport.
  ///
  /// In en, this message translates to:
  /// **'Recent transport'**
  String get riskRecentTransport;

  /// No description provided for @riskRecentStress.
  ///
  /// In en, this message translates to:
  /// **'Recent stress'**
  String get riskRecentStress;

  /// No description provided for @riskPregnant.
  ///
  /// In en, this message translates to:
  /// **'Pregnant'**
  String get riskPregnant;

  /// No description provided for @riskLateGestation.
  ///
  /// In en, this message translates to:
  /// **'Late gestation'**
  String get riskLateGestation;

  /// No description provided for @riskLowBcs.
  ///
  /// In en, this message translates to:
  /// **'Low body condition'**
  String get riskLowBcs;

  /// No description provided for @riskLactating.
  ///
  /// In en, this message translates to:
  /// **'Lactating'**
  String get riskLactating;

  /// No description provided for @ageGroupNeonatal.
  ///
  /// In en, this message translates to:
  /// **'Neonatal lamb'**
  String get ageGroupNeonatal;

  /// No description provided for @ageGroupYoungLamb.
  ///
  /// In en, this message translates to:
  /// **'Young lamb'**
  String get ageGroupYoungLamb;

  /// No description provided for @ageGroupGrowingLamb.
  ///
  /// In en, this message translates to:
  /// **'Growing lamb'**
  String get ageGroupGrowingLamb;

  /// No description provided for @ageGroupAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get ageGroupAdult;

  /// No description provided for @ageGroupSenior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get ageGroupSenior;

  /// No description provided for @conditionsToConsider.
  ///
  /// In en, this message translates to:
  /// **'Conditions to consider'**
  String get conditionsToConsider;

  /// No description provided for @whyThisAppears.
  ///
  /// In en, this message translates to:
  /// **'Why it appears'**
  String get whyThisAppears;

  /// No description provided for @checkNext.
  ///
  /// In en, this message translates to:
  /// **'Check next'**
  String get checkNext;

  /// No description provided for @treatmentApproach.
  ///
  /// In en, this message translates to:
  /// **'Treatment approach'**
  String get treatmentApproach;

  /// No description provided for @viewProtocol.
  ///
  /// In en, this message translates to:
  /// **'View protocol'**
  String get viewProtocol;

  /// No description provided for @viewMedications.
  ///
  /// In en, this message translates to:
  /// **'View medications'**
  String get viewMedications;

  /// No description provided for @healthAssessment.
  ///
  /// In en, this message translates to:
  /// **'Health Assessment'**
  String get healthAssessment;

  /// No description provided for @clinicalDifferential.
  ///
  /// In en, this message translates to:
  /// **'Clinical differential'**
  String get clinicalDifferential;

  /// No description provided for @advancedHealthView.
  ///
  /// In en, this message translates to:
  /// **'Advanced Health View'**
  String get advancedHealthView;

  /// No description provided for @possibleFlockProblem.
  ///
  /// In en, this message translates to:
  /// **'Possible Flock-Level Problem'**
  String get possibleFlockProblem;

  /// No description provided for @flockProblemBody.
  ///
  /// In en, this message translates to:
  /// **'Multiple sheep have similar observations.'**
  String get flockProblemBody;

  /// No description provided for @medicationRequiresVerification.
  ///
  /// In en, this message translates to:
  /// **'Medication requires veterinary/product verification.'**
  String get medicationRequiresVerification;

  /// No description provided for @labelStatusApprovedForSheep.
  ///
  /// In en, this message translates to:
  /// **'Approved for sheep'**
  String get labelStatusApprovedForSheep;

  /// No description provided for @labelStatusApprovedForIndication.
  ///
  /// In en, this message translates to:
  /// **'Approved for this indication'**
  String get labelStatusApprovedForIndication;

  /// No description provided for @labelStatusVeterinaryDirected.
  ///
  /// In en, this message translates to:
  /// **'Veterinary-directed / extra-label'**
  String get labelStatusVeterinaryDirected;

  /// No description provided for @labelStatusVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification required'**
  String get labelStatusVerificationRequired;

  /// No description provided for @labelStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get labelStatusUnknown;

  /// No description provided for @reasonForTreatment.
  ///
  /// In en, this message translates to:
  /// **'Why are you treating?'**
  String get reasonForTreatment;

  /// No description provided for @treatmentReasonHealthObservation.
  ///
  /// In en, this message translates to:
  /// **'Health Observation'**
  String get treatmentReasonHealthObservation;

  /// No description provided for @treatmentReasonConfirmedDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'Confirmed Diagnosis'**
  String get treatmentReasonConfirmedDiagnosis;

  /// No description provided for @treatmentReasonPreventive.
  ///
  /// In en, this message translates to:
  /// **'Preventive protocol'**
  String get treatmentReasonPreventive;

  /// No description provided for @treatmentReasonVaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get treatmentReasonVaccination;

  /// No description provided for @treatmentReasonRoutineParasite.
  ///
  /// In en, this message translates to:
  /// **'Routine parasite control'**
  String get treatmentReasonRoutineParasite;

  /// No description provided for @treatmentReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get treatmentReasonOther;

  /// No description provided for @confirmTreatment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Treatment'**
  String get confirmTreatment;

  /// No description provided for @confirmAndRecord.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Record'**
  String get confirmAndRecord;

  /// No description provided for @healthGuidanceDatabase.
  ///
  /// In en, this message translates to:
  /// **'Health guidance database'**
  String get healthGuidanceDatabase;

  /// No description provided for @lastVerified.
  ///
  /// In en, this message translates to:
  /// **'Last verified'**
  String get lastVerified;

  /// No description provided for @knowledgeVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String knowledgeVersion(String version);

  /// No description provided for @famacha.
  ///
  /// In en, this message translates to:
  /// **'FAMACHA'**
  String get famacha;

  /// No description provided for @eyelidColor.
  ///
  /// In en, this message translates to:
  /// **'Eyelid color'**
  String get eyelidColor;

  /// No description provided for @gestationStage.
  ///
  /// In en, this message translates to:
  /// **'Gestation stage'**
  String get gestationStage;

  /// No description provided for @litterSize.
  ///
  /// In en, this message translates to:
  /// **'Litter size'**
  String get litterSize;

  /// No description provided for @whyExpandable.
  ///
  /// In en, this message translates to:
  /// **'Why am I seeing this?'**
  String get whyExpandable;

  /// No description provided for @whatMoreLikely.
  ///
  /// In en, this message translates to:
  /// **'What would make it more likely?'**
  String get whatMoreLikely;

  /// No description provided for @whatLessLikely.
  ///
  /// In en, this message translates to:
  /// **'What would make it less likely?'**
  String get whatLessLikely;

  /// No description provided for @antibioticNotIndicated.
  ///
  /// In en, this message translates to:
  /// **'Antibiotic treatment is not automatically indicated from these signs alone.'**
  String get antibioticNotIndicated;

  /// No description provided for @urgentVeterinaryAssessment.
  ///
  /// In en, this message translates to:
  /// **'Urgent veterinary assessment'**
  String get urgentVeterinaryAssessment;

  /// No description provided for @doNotDewormRoutinely.
  ///
  /// In en, this message translates to:
  /// **'Do not automatically deworm based on diarrhea alone.'**
  String get doNotDewormRoutinely;

  /// No description provided for @healthCenter.
  ///
  /// In en, this message translates to:
  /// **'Health Center'**
  String get healthCenter;

  /// No description provided for @changeSheep.
  ///
  /// In en, this message translates to:
  /// **'Change sheep'**
  String get changeSheep;

  /// No description provided for @healthCheck.
  ///
  /// In en, this message translates to:
  /// **'Health Check'**
  String get healthCheck;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @underTreatment.
  ///
  /// In en, this message translates to:
  /// **'Under treatment'**
  String get underTreatment;

  /// No description provided for @weightBcs.
  ///
  /// In en, this message translates to:
  /// **'Weight / BCS'**
  String get weightBcs;

  /// No description provided for @deworming.
  ///
  /// In en, this message translates to:
  /// **'Deworming'**
  String get deworming;

  /// No description provided for @healthCases.
  ///
  /// In en, this message translates to:
  /// **'Health Cases'**
  String get healthCases;

  /// No description provided for @preventiveCare.
  ///
  /// In en, this message translates to:
  /// **'Preventive care'**
  String get preventiveCare;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'Measurements'**
  String get measurements;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @lastHealthCheck.
  ///
  /// In en, this message translates to:
  /// **'Last health check'**
  String get lastHealthCheck;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @caseStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get caseStatus;

  /// No description provided for @caseSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get caseSeverity;

  /// No description provided for @caseStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get caseStarted;

  /// No description provided for @caseSummary.
  ///
  /// In en, this message translates to:
  /// **'Case summary'**
  String get caseSummary;

  /// No description provided for @caseObservations.
  ///
  /// In en, this message translates to:
  /// **'Observations'**
  String get caseObservations;

  /// No description provided for @caseAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get caseAssessment;

  /// No description provided for @caseChecks.
  ///
  /// In en, this message translates to:
  /// **'Checks'**
  String get caseChecks;

  /// No description provided for @noActiveHealthCases.
  ///
  /// In en, this message translates to:
  /// **'No active health cases'**
  String get noActiveHealthCases;

  /// No description provided for @noHealthCasesDetail.
  ///
  /// In en, this message translates to:
  /// **'This sheep currently has no open health cases.'**
  String get noHealthCasesDetail;

  /// No description provided for @caseOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get caseOpen;

  /// No description provided for @caseMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Monitoring'**
  String get caseMonitoring;

  /// No description provided for @caseTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get caseTreatment;

  /// No description provided for @caseAwaitingVet.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Veterinary Review'**
  String get caseAwaitingVet;

  /// No description provided for @caseImproving.
  ///
  /// In en, this message translates to:
  /// **'Improving'**
  String get caseImproving;

  /// No description provided for @caseResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get caseResolved;

  /// No description provided for @caseChronic.
  ///
  /// In en, this message translates to:
  /// **'Chronic'**
  String get caseChronic;

  /// No description provided for @caseClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get caseClosed;

  /// No description provided for @parasiteManagement.
  ///
  /// In en, this message translates to:
  /// **'Parasite Management'**
  String get parasiteManagement;

  /// No description provided for @currentParasiteStatus.
  ///
  /// In en, this message translates to:
  /// **'Current parasite status'**
  String get currentParasiteStatus;

  /// No description provided for @lastFamacha.
  ///
  /// In en, this message translates to:
  /// **'Last FAMACHA'**
  String get lastFamacha;

  /// No description provided for @lastFecalTest.
  ///
  /// In en, this message translates to:
  /// **'Last fecal test'**
  String get lastFecalTest;

  /// No description provided for @lastDeworming.
  ///
  /// In en, this message translates to:
  /// **'Last deworming'**
  String get lastDeworming;

  /// No description provided for @currentWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Current withdrawal'**
  String get currentWithdrawal;

  /// No description provided for @nextAction.
  ///
  /// In en, this message translates to:
  /// **'Next action'**
  String get nextAction;

  /// No description provided for @deworm.
  ///
  /// In en, this message translates to:
  /// **'Deworm'**
  String get deworm;

  /// No description provided for @fecalTest.
  ///
  /// In en, this message translates to:
  /// **'Fecal Test'**
  String get fecalTest;

  /// No description provided for @parasiteObservation.
  ///
  /// In en, this message translates to:
  /// **'Parasite Observation'**
  String get parasiteObservation;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View history'**
  String get viewHistory;

  /// No description provided for @whyDeworming.
  ///
  /// In en, this message translates to:
  /// **'Why are you deworming?'**
  String get whyDeworming;

  /// No description provided for @dewormingReasonTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment — signs consistent with parasite disease'**
  String get dewormingReasonTreatment;

  /// No description provided for @dewormingReasonPositiveTest.
  ///
  /// In en, this message translates to:
  /// **'Positive fecal test'**
  String get dewormingReasonPositiveTest;

  /// No description provided for @dewormingReasonFamacha.
  ///
  /// In en, this message translates to:
  /// **'FAMACHA / anemia assessment'**
  String get dewormingReasonFamacha;

  /// No description provided for @dewormingReasonRoutine.
  ///
  /// In en, this message translates to:
  /// **'Routine protocol'**
  String get dewormingReasonRoutine;

  /// No description provided for @dewormingReasonGroup.
  ///
  /// In en, this message translates to:
  /// **'Group treatment'**
  String get dewormingReasonGroup;

  /// No description provided for @dewormingReasonVet.
  ///
  /// In en, this message translates to:
  /// **'Veterinary recommendation'**
  String get dewormingReasonVet;

  /// No description provided for @dewormingReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dewormingReasonOther;

  /// No description provided for @parasiteAssessment.
  ///
  /// In en, this message translates to:
  /// **'Parasite Assessment'**
  String get parasiteAssessment;

  /// No description provided for @bottleJaw.
  ///
  /// In en, this message translates to:
  /// **'Bottle jaw'**
  String get bottleJaw;

  /// No description provided for @recentFecalTest.
  ///
  /// In en, this message translates to:
  /// **'Recent fecal test'**
  String get recentFecalTest;

  /// No description provided for @previousProduct.
  ///
  /// In en, this message translates to:
  /// **'Previous product'**
  String get previousProduct;

  /// No description provided for @otherSheepAffected.
  ///
  /// In en, this message translates to:
  /// **'Other sheep affected?'**
  String get otherSheepAffected;

  /// No description provided for @reviewRecommended.
  ///
  /// In en, this message translates to:
  /// **'Review recommended'**
  String get reviewRecommended;

  /// No description provided for @findings.
  ///
  /// In en, this message translates to:
  /// **'Findings'**
  String get findings;

  /// No description provided for @pattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// No description provided for @importantNextCheck.
  ///
  /// In en, this message translates to:
  /// **'Important next check'**
  String get importantNextCheck;

  /// No description provided for @viewParasiteProtocol.
  ///
  /// In en, this message translates to:
  /// **'View Parasite Treatment Protocol'**
  String get viewParasiteProtocol;

  /// No description provided for @famachaTrend.
  ///
  /// In en, this message translates to:
  /// **'FAMACHA trend'**
  String get famachaTrend;

  /// No description provided for @famachaWorsening.
  ///
  /// In en, this message translates to:
  /// **'FAMACHA score increased — needs attention'**
  String get famachaWorsening;

  /// No description provided for @recordFamacha.
  ///
  /// In en, this message translates to:
  /// **'Record FAMACHA'**
  String get recordFamacha;

  /// No description provided for @recordFecalTest.
  ///
  /// In en, this message translates to:
  /// **'Record Fecal Test'**
  String get recordFecalTest;

  /// No description provided for @fecalTestType.
  ///
  /// In en, this message translates to:
  /// **'Test type'**
  String get fecalTestType;

  /// No description provided for @fecalEggCount.
  ///
  /// In en, this message translates to:
  /// **'Fecal egg count'**
  String get fecalEggCount;

  /// No description provided for @resultLevel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultLevel;

  /// No description provided for @parasitesDetected.
  ///
  /// In en, this message translates to:
  /// **'Parasites detected'**
  String get parasitesDetected;

  /// No description provided for @laboratory.
  ///
  /// In en, this message translates to:
  /// **'Laboratory'**
  String get laboratory;

  /// No description provided for @testTypeFecalEggCount.
  ///
  /// In en, this message translates to:
  /// **'Fecal egg count'**
  String get testTypeFecalEggCount;

  /// No description provided for @testTypeMcMaster.
  ///
  /// In en, this message translates to:
  /// **'McMaster'**
  String get testTypeMcMaster;

  /// No description provided for @testTypeOocyst.
  ///
  /// In en, this message translates to:
  /// **'Oocyst count'**
  String get testTypeOocyst;

  /// No description provided for @testTypeGeneral.
  ///
  /// In en, this message translates to:
  /// **'General fecal examination'**
  String get testTypeGeneral;

  /// No description provided for @testTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get testTypeOther;

  /// No description provided for @fecalNegative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get fecalNegative;

  /// No description provided for @fecalLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get fecalLow;

  /// No description provided for @fecalModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get fecalModerate;

  /// No description provided for @fecalHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get fecalHigh;

  /// No description provided for @fecalSpecific.
  ///
  /// In en, this message translates to:
  /// **'Specific parasite detected'**
  String get fecalSpecific;

  /// No description provided for @fecalPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get fecalPending;

  /// No description provided for @parasiteHistory.
  ///
  /// In en, this message translates to:
  /// **'Parasite History'**
  String get parasiteHistory;

  /// No description provided for @dewormingHistory.
  ///
  /// In en, this message translates to:
  /// **'Deworming History'**
  String get dewormingHistory;

  /// No description provided for @noDewormingRecorded.
  ///
  /// In en, this message translates to:
  /// **'No deworming recorded'**
  String get noDewormingRecorded;

  /// No description provided for @noDewormingDetail.
  ///
  /// In en, this message translates to:
  /// **'Start tracking parasite treatments to build a complete parasite history.'**
  String get noDewormingDetail;

  /// No description provided for @noFamachaRecorded.
  ///
  /// In en, this message translates to:
  /// **'No FAMACHA recorded'**
  String get noFamachaRecorded;

  /// No description provided for @noFamachaDetail.
  ///
  /// In en, this message translates to:
  /// **'Record a FAMACHA score to begin parasite monitoring.'**
  String get noFamachaDetail;

  /// No description provided for @noFecalTests.
  ///
  /// In en, this message translates to:
  /// **'No fecal tests recorded'**
  String get noFecalTests;

  /// No description provided for @recordDeworming.
  ///
  /// In en, this message translates to:
  /// **'Record Deworming'**
  String get recordDeworming;

  /// No description provided for @dewormingRecorded.
  ///
  /// In en, this message translates to:
  /// **'Deworming recorded'**
  String get dewormingRecorded;

  /// No description provided for @treatmentResponse.
  ///
  /// In en, this message translates to:
  /// **'Treatment response'**
  String get treatmentResponse;

  /// No description provided for @responseImproved.
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get responseImproved;

  /// No description provided for @responseUnchanged.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get responseUnchanged;

  /// No description provided for @responseWorse.
  ///
  /// In en, this message translates to:
  /// **'Worse'**
  String get responseWorse;

  /// No description provided for @responseUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get responseUnknown;

  /// No description provided for @concentration.
  ///
  /// In en, this message translates to:
  /// **'Concentration'**
  String get concentration;

  /// No description provided for @weightAtTreatment.
  ///
  /// In en, this message translates to:
  /// **'Weight at treatment'**
  String get weightAtTreatment;

  /// No description provided for @calculatedDose.
  ///
  /// In en, this message translates to:
  /// **'Calculated dose'**
  String get calculatedDose;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @protocolMgPerKg.
  ///
  /// In en, this message translates to:
  /// **'Protocol (mg/kg)'**
  String get protocolMgPerKg;

  /// No description provided for @productMgPerMl.
  ///
  /// In en, this message translates to:
  /// **'Product (mg/mL)'**
  String get productMgPerMl;

  /// No description provided for @underdoseWarning.
  ///
  /// In en, this message translates to:
  /// **'Entered dose is below the configured protocol.'**
  String get underdoseWarning;

  /// No description provided for @overdoseWarning.
  ///
  /// In en, this message translates to:
  /// **'Dose requires verification.'**
  String get overdoseWarning;

  /// No description provided for @parasiteRisk.
  ///
  /// In en, this message translates to:
  /// **'Parasite risk'**
  String get parasiteRisk;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get riskLow;

  /// No description provided for @riskMonitor.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get riskMonitor;

  /// No description provided for @riskNeedsAssessment.
  ///
  /// In en, this message translates to:
  /// **'Needs assessment'**
  String get riskNeedsAssessment;

  /// No description provided for @riskHighConcern.
  ///
  /// In en, this message translates to:
  /// **'High concern'**
  String get riskHighConcern;

  /// No description provided for @demoMedication.
  ///
  /// In en, this message translates to:
  /// **'DEMO — VERIFY PRODUCT'**
  String get demoMedication;

  /// No description provided for @possibleReducedEffectiveness.
  ///
  /// In en, this message translates to:
  /// **'Possible reduced treatment effectiveness — veterinary/parasitology review recommended.'**
  String get possibleReducedEffectiveness;

  /// No description provided for @parasiteReviewRecommended.
  ///
  /// In en, this message translates to:
  /// **'Review FAMACHA trend and consider fecal testing / veterinary assessment according to the farm parasite-control protocol.'**
  String get parasiteReviewRecommended;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
