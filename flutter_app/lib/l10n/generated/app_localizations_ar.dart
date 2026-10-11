// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'هيردهَب للأغنام';

  @override
  String get home => 'الرئيسية';

  @override
  String get flock => 'القطيع';

  @override
  String get tasks => 'المهام';

  @override
  String get breeding => 'التناسل';

  @override
  String get more => 'المزيد';

  @override
  String get quickLog => 'تسجيل سريع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get sync => 'المزامنة';

  @override
  String placeholderTitle(String page) {
    return 'التهيئة الأولية · $page';
  }

  @override
  String get placeholderBody => 'هذه الشاشة مؤقتة في المرحلة التأسيسية.';

  @override
  String get theme => 'المظهر';

  @override
  String get lightMode => 'فاتح';

  @override
  String get darkMode => 'داكن';

  @override
  String get sunMode => 'وضع الشمس';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get selectLanguage => 'اختيار اللغة';

  @override
  String get selectTheme => 'اختيار المظهر';

  @override
  String get quickLogComingSoon => 'ستتم إضافة التسجيل السريع في مرحلة لاحقة.';

  @override
  String get whatToRecord => 'ما الذي تريد تسجيله؟';

  @override
  String get healthActions => 'الصحة';

  @override
  String get conditionActions => 'الحالة';

  @override
  String get breedingActions => 'التناسل';

  @override
  String get otherActions => 'أخرى';

  @override
  String get treatmentAction => 'العلاج';

  @override
  String get vaccinationAction => 'التطعيم';

  @override
  String get dewormingAction => 'مضاد الديدان';

  @override
  String get dippingAction => 'تغطيس / طفيليات';

  @override
  String get hoofTrimAction => 'تقليم الحوافر';

  @override
  String get shearingAction => 'جزّ الصوف';

  @override
  String get weightAction => 'الوزن';

  @override
  String get bcsAction => 'حالة الجسم';

  @override
  String get heatCheckAction => 'فحص الإجهاد الحراري';

  @override
  String get feedWaterAction => 'العلف / الماء';

  @override
  String get matingAction => 'تلقيح';

  @override
  String get pregnancyAction => 'الحمل';

  @override
  String get lambingAction => 'الولادة';

  @override
  String get photoAction => 'صورة';

  @override
  String get voiceNoteAction => 'ملاحظة صوتية';

  @override
  String get noteAction => 'ملاحظة';

  @override
  String get selectSheep => 'الخروف';

  @override
  String get selectMedication => 'الدواء';

  @override
  String get dose => 'الجرعة';

  @override
  String get route => 'طريقة الإعطاء';

  @override
  String get date => 'التاريخ';

  @override
  String get notes => 'ملاحظات';

  @override
  String get saveTreatment => 'حفظ العلاج';

  @override
  String get treatmentRecorded => 'تم تسجيل العلاج';

  @override
  String get followUpCreated => 'تم إنشاء مهمة متابعة';

  @override
  String get treatmentWithdrawalNotice =>
      'تُحسب فترة السحب تلقائياً من بيانات العلاج.';

  @override
  String get meatWithdrawal => 'فترة سحب اللحم';

  @override
  String get milkWithdrawal => 'فترة سحب الحليب';

  @override
  String days(int count) {
    return '$count أيام';
  }

  @override
  String recordAction(String action) {
    return 'تسجيل $action';
  }

  @override
  String get saveRecord => 'حفظ السجل';

  @override
  String get recorded => 'تم التسجيل';

  @override
  String get value => 'القيمة';

  @override
  String get invalidValue => 'أدخل قيمة صحيحة.';

  @override
  String get invalidDose => 'أدخل جرعة أكبر من صفر.';

  @override
  String get bcsValueHelp => 'أدخل تقييماً من ٠ إلى ٥.';

  @override
  String get routeOral => 'عن طريق الفم';

  @override
  String get routeInjection => 'حقن';

  @override
  String get routeTopical => 'موضعي';

  @override
  String get routeIntramuscular => 'حقن عضلي';

  @override
  String get routeSubcutaneous => 'تحت الجلد';

  @override
  String recordTreatmentFor(String tag) {
    return 'علاج الخروف رقم $tag';
  }

  @override
  String get activeTreatment => 'علاج فعّال';

  @override
  String get clearance => 'انتهاء السحب';

  @override
  String get noActiveTreatment => 'لا توجد فترة سحب فعّالة';

  @override
  String get treatmentFollowUp => 'متابعة العلاج';

  @override
  String get groups => 'المجموعات';

  @override
  String get savedViewsTitle => 'العروض المحفوظة';

  @override
  String groupCount(int count) {
    return '$count رأس';
  }

  @override
  String get groupLocation => 'الموقع';

  @override
  String get groupCurrentTask => 'المهمة الحالية';

  @override
  String get groupStatus => 'الحالة';

  @override
  String get groupStatusNormal => 'على المسار';

  @override
  String get groupStatusAttention => 'تحتاج إلى متابعة';

  @override
  String get groupStatusUrgent => 'عاجل';

  @override
  String get openGroups => 'إدارة المجموعات';

  @override
  String get viewGroup => 'فتح المجموعة';

  @override
  String get bulkAction => 'إجراء جماعي';

  @override
  String get chooseBulkAction => 'اختر إجراءً';

  @override
  String sheepSelected(int count) {
    return 'تم تحديد $count رأس';
  }

  @override
  String vaccinateCount(int count) {
    return 'تحصين $count رأس';
  }

  @override
  String completeActionCount(String action, int count) {
    return 'تسجيل $action لـ $count رأس';
  }

  @override
  String bulkActionSaved(int count) {
    return 'تم حفظ $count سجلاً';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get bulkActionUndone => 'تم التراجع عن الإجراء الجماعي';

  @override
  String get bulkActionFailed => 'تعذر التراجع بأمان عن هذا الإجراء الجماعي.';

  @override
  String get taskToday => 'اليوم';

  @override
  String get taskUpcoming => 'قادم';

  @override
  String get taskCompleted => 'مكتمل';

  @override
  String get taskPending => 'بانتظار التنفيذ';

  @override
  String get taskInProgress => 'قيد التنفيذ';

  @override
  String get taskSkipped => 'تم تخطيها';

  @override
  String get taskCancelled => 'ملغاة';

  @override
  String get taskStart => 'ابدأ';

  @override
  String get taskComplete => 'إكمال';

  @override
  String get taskSkip => 'تخطي';

  @override
  String get taskEmpty => 'لا توجد مهام في هذه القائمة.';

  @override
  String nextTaskDue(String date) {
    return 'المهمة التالية في $date';
  }

  @override
  String get upcomingSavedViewWithdrawal => 'فترة السحب فعالة';

  @override
  String get upcomingSavedViewLowBcs => 'حالة جسم منخفضة';

  @override
  String get upcomingSavedViewVaccination => 'موعد التحصين';

  @override
  String get upcomingSavedViewEid => 'مرشحو الأضاحي';

  @override
  String get bulkVaccination => 'التحصين';

  @override
  String get bulkDeworming => 'مضاد الديدان';

  @override
  String get bulkWeight => 'تسجيل الوزن';

  @override
  String get bulkBcs => 'تقييم حالة الجسم';

  @override
  String get taskUpdated => 'تم تحديث المهمة';

  @override
  String get groupNotFound => 'لم يتم العثور على المجموعة';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get openSync => 'فتح مركز المزامنة';

  @override
  String get openBreeding => 'فتح التناسل';

  @override
  String get farmName => 'مزرعة النور';

  @override
  String get flockName => 'القطيع الشمالي';

  @override
  String get sheepCount => '٤٨٦ رأساً';

  @override
  String get heatRiskHigh => 'خطر الإجهاد الحراري · مرتفع';

  @override
  String get offlinePending => 'دون اتصال · حُفظت التغييرات محلياً';

  @override
  String get pendingCount => '١٢ بانتظار المزامنة';

  @override
  String get needsAttention => 'يحتاج إلى متابعة';

  @override
  String get urgentCount => 'عاجل';

  @override
  String get dueTodayCount => 'مستحق اليوم';

  @override
  String get dueWeekCount => 'هذا الأسبوع';

  @override
  String get vaccinationDue => 'موعد التحصين';

  @override
  String get withdrawalActive => 'فترة السحب فعالة';

  @override
  String get lowBcs => 'حالة جسم منخفضة';

  @override
  String get heatCheck => 'فحص الحرارة';

  @override
  String get pregnantEwes => 'النعاج الحوامل';

  @override
  String get priorityHigh => 'عالية';

  @override
  String get taskCheckWater => 'فحص الماء';

  @override
  String get taskWeighLambs => 'وزن الحملان';

  @override
  String get taskBcsCheck => 'تقييم حالة الجسم';

  @override
  String get northPasture => 'المرعى الشمالي';

  @override
  String get groupB => 'المجموعة ب';

  @override
  String get ewesTwelve => '١٢ نعجة';

  @override
  String get flockSnapshot => 'ملخص القطيع';

  @override
  String get total => 'الإجمالي';

  @override
  String get ewes => 'نعاج';

  @override
  String get rams => 'كباش';

  @override
  String get lambs => 'حملان';

  @override
  String get pregnantCount => 'حوامل';

  @override
  String get humidity => 'رطوبة';

  @override
  String get recommended => 'التوصيات';

  @override
  String get moveToShade => 'انقلها إلى الظل';

  @override
  String get checkWater => 'افحص الماء';

  @override
  String get avoidHandling => 'تجنب التعامل غير الضروري';

  @override
  String get searchSheep => 'ابحث برقم الشارة أو المجموعة أو السلالة';

  @override
  String get scanTag => 'مسح الشارة';

  @override
  String get addSheep => 'إضافة خروف';

  @override
  String get addSheepTitle => 'إضافة خروف';

  @override
  String get duplicateTagError => 'هذه الشارة مسجلة بالفعل في القطيع.';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get invalidWeight => 'أدخل وزناً صحيحاً أكبر من صفر.';

  @override
  String get invalidBcs => 'أدخل تقييماً لحالة الجسم بين ١ و٥.';

  @override
  String get selectBreed => 'اختر السلالة';

  @override
  String get defaultGroup => 'القطيع الشمالي';

  @override
  String get defaultLocation => 'المرعى الشمالي';

  @override
  String get saveSheep => 'حفظ بيانات الخروف';

  @override
  String get all => 'الكل';

  @override
  String get sick => 'مريضة';

  @override
  String get withdrawal => 'فترة السحب';

  @override
  String get dueToday => 'مستحق اليوم';

  @override
  String get savedViews => 'عروض محفوظة';

  @override
  String get dueVaccination => 'موعد التحصين';

  @override
  String get dueDeworming => 'موعد مضاد الديدان';

  @override
  String get withdrawalView => 'فترة السحب فعالة';

  @override
  String get pregnantView => 'حوامل';

  @override
  String get eidCandidates => 'مرشحو الأضاحي';

  @override
  String get allSheep => 'جميع الأغنام';

  @override
  String get nextRoutine => 'التالي';

  @override
  String get weight => 'الوزن';

  @override
  String get bcs => 'تقييم حالة الجسم';

  @override
  String get attention => 'يحتاج متابعة';

  @override
  String get healthy => 'سليم';

  @override
  String get urgent => 'عاجل';

  @override
  String get sexEwe => 'نعجة';

  @override
  String get sexRam => 'كبش';

  @override
  String get sexLamb => 'حمل';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get health => 'الحالة الصحية';

  @override
  String get identity => 'الهوية';

  @override
  String get currentStatus => 'الحالة الحالية';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get tag => 'الشارة';

  @override
  String get breed => 'السلالة';

  @override
  String get sex => 'الجنس';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get group => 'المجموعة';

  @override
  String get location => 'الموقع';

  @override
  String get healthRoutines => 'الرعاية الدورية';

  @override
  String get activeTreatments => 'العلاجات الفعالة';

  @override
  String get breedingStatus => 'حالة التناسل';

  @override
  String get confirmed => 'مؤكد';

  @override
  String get matingDate => 'تاريخ التلقيح';

  @override
  String get ramLabel => 'الكبش';

  @override
  String get expectedLambing => 'موعد الولادة المتوقع';

  @override
  String get weightTrend => 'اتجاه الوزن';

  @override
  String get timeline => 'السجل';

  @override
  String get clearForSale => 'مصرّح للبيع';

  @override
  String get notClearForSale => 'غير مصرّح للبيع';

  @override
  String withdrawalDays(int count) {
    return 'متبقي $count أيام';
  }

  @override
  String clearanceDate(String date) {
    return 'انتهاء السحب · $date';
  }

  @override
  String get noSheepFound => 'لم يتم العثور على أغنام';

  @override
  String get tryAnotherSearch => 'جرّب بحثاً أو مرشحاً آخر.';

  @override
  String get farmTaskVaccinate => 'تحصين النعاج الحوامل';

  @override
  String get farmTaskCheckWater => 'فحص الماء · المرعى الشمالي';

  @override
  String get farmTaskWeighLambs => 'وزن الحملان · المجموعة ب';

  @override
  String get farmTaskBcs => 'تقييم الحالة · ١٢ نعجة';

  @override
  String get activityBcs => 'تم تسجيل حالة الجسم · ٢٫٥';

  @override
  String get activityTreatment => 'علاج · ألبيندازول';

  @override
  String eventTreatmentTitle(String medication) {
    return 'علاج · $medication';
  }

  @override
  String eventBcsRecorded(String score) {
    return 'تم تسجيل حالة الجسم · $score';
  }

  @override
  String milkClearanceActive(int days) {
    return 'سحب الحليب · متبقي $days أيام';
  }

  @override
  String get activityWeight => 'تم تسجيل الوزن · ٦٢٫٤ كغ';

  @override
  String get activityMating => 'تلقيح · كركول #R12';

  @override
  String get activityVaccination => 'تحصين · كلوستريدي';

  @override
  String get lastDate => 'آخر مرة';

  @override
  String get nextDate => 'التالي';

  @override
  String get routineVaccination => 'التحصين';

  @override
  String get routineDeworming => 'مضاد الديدان';

  @override
  String get routineDipping => 'التغطيس';

  @override
  String get routineHoof => 'تقليم الحوافر';

  @override
  String get routineShearing => 'جزّ الصوف';

  @override
  String get routineSupplements => 'المكملات';

  @override
  String get profileNotFound => 'لم يتم العثور على الخروف';

  @override
  String get profileNotFoundDetails => 'ربما أُزيل هذا الخروف من القطيع.';

  @override
  String get backToFlock => 'العودة إلى القطيع';

  @override
  String get dueInThreeDays => 'بعد ٣ أيام';

  @override
  String get weightRecorded => 'تم تسجيل الوزن';

  @override
  String get breedAwassi => 'عواسي';

  @override
  String get breedNajdi => 'نجدي';

  @override
  String get breedNaimi => 'نعيمي';

  @override
  String get breedSuffolk => 'سوفولك';

  @override
  String get groupsCount => 'رأس';

  @override
  String get attentionDueVaccination => '٤ أغنام · موعد التحصين';

  @override
  String get attentionWithdrawal => '٣ أغنام · فترة السحب فعالة';

  @override
  String withdrawalAlertCount(int count) {
    return '$count أغنام · فترة السحب فعالة';
  }

  @override
  String get attentionLowBcs => 'خروفان · حالة جسم منخفضة';

  @override
  String get attentionHeat => '٣ أغنام · تتطلب فحص الحرارة';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get pregnancy => 'الحمل';

  @override
  String get noWithdrawal => 'لا توجد فترة سحب فعالة';

  @override
  String get recordWeight => 'تسجيل الوزن';

  @override
  String get expected => 'متوقع';

  @override
  String get lambingHistory => 'سجل الولادات';

  @override
  String get healthyTwins => 'توأم · بصحة جيدة';

  @override
  String get todaysTasks => 'مهام اليوم';

  @override
  String get humidityReading => '٢٨٪ رطوبة · ١٤:٢٠';

  @override
  String get routineDueInDays => 'بعد ٣ أيام';

  @override
  String treatmentAdministered(
    String date,
    String dose,
    String unit,
    String route,
  ) {
    return 'أُعطي في $date · $dose $unit · $route';
  }

  @override
  String withdrawalClearance(String date) {
    return 'انتهاء السحب · $date';
  }

  @override
  String get farmRole => 'مدير المزرعة';

  @override
  String get dewormingInDays => 'مستحق بعد ١٢ يوماً';

  @override
  String get hoofTrimInWeeks => 'مستحق بعد أسبوعين';

  @override
  String get routineNotDue => 'لا توجد رعاية مستحقة';

  @override
  String get bcsCheckDue => 'موعد تقييم حالة الجسم';

  @override
  String get weightCheckDue => 'الوزن · ١٢ أكتوبر';

  @override
  String get withdrawalDueDays => 'فترة السحب · متبقي ٥ أيام';

  @override
  String get confirmedPregnancy => 'حمل مؤكد';

  @override
  String get numeralSystemTitle => 'نظام الأرقام';

  @override
  String get westernNumerals => 'الأرقام الغربية (123)';

  @override
  String get arabicIndicNumerals => 'الأرقام العربية الهندية (١٢٣)';

  @override
  String get calendarSystemTitle => 'التقويم';

  @override
  String get gregorianCalendar => 'ميلادي';

  @override
  String get hijriCalendar => 'هجري حسابي';

  @override
  String ramKarakul(String tag) {
    return 'كركول رقم $tag';
  }

  @override
  String pregnancyDayProgress(String day, String total) {
    return 'الحمل · اليوم $day من $total';
  }

  @override
  String get recordedByName => 'سجّلها أحمد';

  @override
  String get southPasture => 'المرعى الجنوبي';

  @override
  String get dryEwes => 'النعاج غير الحوامل';

  @override
  String get eastPaddock => 'الحظيرة الشرقية';

  @override
  String get lambingBarn => 'حظيرة الولادة';

  @override
  String get lambsGroupB => 'الحملان · المجموعة ب';

  @override
  String get eventLabel => 'سجل';

  @override
  String get sheepEntity => 'خروف';

  @override
  String get farmInitials => 'ن';

  @override
  String get userAhmed => 'أحمد';

  @override
  String get userSara => 'سارة';

  @override
  String get connectionMode => 'حالة الاتصال';

  @override
  String get online => 'متصل';

  @override
  String get offline => 'دون اتصال';

  @override
  String get syncOnlineDescription => 'متصل · جاهز للمزامنة';

  @override
  String get offlineSavedDescription => 'دون اتصال · حُفظت التغييرات محلياً';

  @override
  String pendingCountValue(int count) {
    return '$count بانتظار المزامنة';
  }

  @override
  String get syncNow => 'زامن الآن';

  @override
  String get pendingStatus => 'بانتظار المزامنة';

  @override
  String get syncingStatus => 'جارٍ التزامن';

  @override
  String get syncedStatus => 'تمت المزامنة';

  @override
  String get failedStatus => 'فشل';

  @override
  String get conflictStatus => 'تعارض';

  @override
  String get syncQueueEmpty => 'لا توجد تغييرات في هذا العرض.';

  @override
  String get schemaVersion => 'إصدار مخطط البيانات';

  @override
  String retryCount(int count) {
    return 'المحاولة $count';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get review => 'مراجعة';

  @override
  String get dismiss => 'إخفاء';

  @override
  String get createOperation => 'إنشاء';

  @override
  String get updateOperation => 'تحديث';

  @override
  String get deleteOperation => 'حذف';

  @override
  String get conflictReview => 'مراجعة تعارض المزامنة';

  @override
  String criticalConflictDescription(String entity) {
    return 'تم تغيير سجل $entity على جهاز آخر. راجع السجل المحلي قبل إعادة المحاولة؛ لا تُستبدل السجلات المهمة تلقائياً.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get keepLocalAndRetry => 'احتفظ بالمحلي وأعد المحاولة';

  @override
  String get conflictQueuedForReview =>
      'تم الاحتفاظ بالسجل المحلي وإدراجه للمزامنة بعد المراجعة.';

  @override
  String get savedLocallyWaiting => 'حُفظ محلياً · بانتظار المزامنة';

  @override
  String get heatStressTitle => 'الإجهاد الحراري';

  @override
  String get heatFactors => 'الظروف';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get thiIndex => 'مؤشر الحرارة والرطوبة';

  @override
  String get recheckInThirty => 'أعد فحص القطيع بعد ٣٠ دقيقة';

  @override
  String get recordHeatCheck => 'تسجيل فحص الحرارة';

  @override
  String get recentHeatChecks => 'فحوص الحرارة الأخيرة';

  @override
  String get noHeatChecks => 'لم تُسجل فحوص للحرارة بعد.';

  @override
  String get symptoms => 'العلامات الملحوظة';

  @override
  String get panting => 'اللهاث';

  @override
  String get lethargy => 'الخمول';

  @override
  String get excessiveSalivation => 'فرط إفراز اللعاب';

  @override
  String get waterAvailable => 'الماء متوفر';

  @override
  String get shadeAvailable => 'الظل متوفر';

  @override
  String get actionsTaken => 'الإجراءات المتخذة';

  @override
  String get heatRiskGuidance =>
      'هذه القراءة القابلة للضبط أداة مساندة للقرار وليست تشخيصاً بيطرياً.';

  @override
  String get heatRiskSafe => 'آمن';

  @override
  String get heatRiskAlert => 'تنبيه';

  @override
  String get heatRiskDanger => 'خطر';

  @override
  String get heatRiskEmergency => 'طارئ';

  @override
  String get breedingDashboard => 'التناسل';

  @override
  String get breedingDescription =>
      'سجّل التلقيح والحمل والولادة في مكان واحد.';

  @override
  String get recordMating => 'تسجيل التلقيح';

  @override
  String get upcomingLambings => 'الولادات القادمة';

  @override
  String get noUpcomingLambings => 'لا توجد ولادات مؤكدة قادمة.';

  @override
  String get pregnancyConfirmed => 'حمل مؤكد';

  @override
  String siredBy(String tag) {
    return 'الأب الكبش رقم $tag';
  }

  @override
  String get recentMatings => 'التلقيحات الأخيرة';

  @override
  String get noRecentMatings => 'لا توجد سجلات تلقيح بعد.';

  @override
  String get ramNotRecorded => 'لم يُسجل الكبش';

  @override
  String get pregnantSheep => 'النعاج الحوامل';

  @override
  String lambCount(int count) {
    return '$count مواليد';
  }

  @override
  String get ramTag => 'رقم شارة الكبش';

  @override
  String get eidMode => 'وضع الأضاحي';

  @override
  String get eidCountdown => 'العد التنازلي لعيد الأضحى';

  @override
  String daysToEid(String count) {
    return 'متبقي $count يوماً';
  }

  @override
  String estimatedEidDate(String date) {
    return 'التاريخ التقديري · $date';
  }

  @override
  String get eidDateDisclaimer =>
      'التاريخ تقديري وقد يختلف بحسب رؤية الهلال المحلية.';

  @override
  String readyCandidates(String ready, String total) {
    return '$ready من $total مصرّح بها للبيع';
  }

  @override
  String get eidStatusReady => 'تستوفي المعايير المضبوطة';

  @override
  String get eidStatusUnderweight => 'أقل من الحد الأدنى للوزن';

  @override
  String get eidStatusLowBcs => 'تقييم حالة الجسم أقل من النطاق';

  @override
  String get eidStatusHighBcs => 'تقييم حالة الجسم أعلى من النطاق';

  @override
  String get eidStatusHealth => 'الحالة الصحية تحتاج إلى مراجعة';

  @override
  String get eidStatusWithdrawal => 'فترة السحب فعّالة';

  @override
  String get eidHealthClear => 'لا توجد ملاحظة صحية مسجلة';

  @override
  String get eidHealthConcern => 'ملاحظة صحية';

  @override
  String eidCriteriaSummary(String weight, String bcs) {
    return 'الحدود المضبوطة: $weight كغ وحالة جسم $bcs.';
  }

  @override
  String get openHeatStress => 'فتح الإجهاد الحراري';

  @override
  String get openEid => 'فتح وضع الأضاحي';

  @override
  String get recordPregnancy => 'تسجيل الحمل';

  @override
  String get recordLambing => 'تسجيل الولادة';

  @override
  String get pregnancyStatus => 'حالة الحمل';

  @override
  String get pregnancyOpen => 'غير حامل';

  @override
  String get pregnancyAborted => 'فقد الحمل';

  @override
  String get lambCountLabel => 'عدد المواليد';

  @override
  String get noEwesAvailable =>
      'لا توجد نعاج متاحة لتسجيل هذا الإجراء التناسلي.';

  @override
  String get ramRequired => 'أدخل رقم شارة الكبش قبل حفظ التلقيح.';

  @override
  String get syncInProgress => 'المزامنة قيد التنفيذ';

  @override
  String get editSheep => 'تعديل بيانات الخروف';

  @override
  String get edit => 'تعديل';

  @override
  String get identificationSection => 'التعريف';

  @override
  String get animalInfoSection => 'معلومات الحيوان';

  @override
  String get managementSection => 'الإدارة';

  @override
  String get tagNumber => 'رقم الشارة';

  @override
  String get sheepName => 'الاسم';

  @override
  String get rfidEid => 'رقم RFID / الهوية الإلكترونية';

  @override
  String get color => 'اللون';

  @override
  String get markings => 'العلامات';

  @override
  String get primaryGroup => 'المجموعة الأساسية';

  @override
  String get source => 'المصدر / المنشأ';

  @override
  String get purchaseDate => 'تاريخ الشراء';

  @override
  String get purchasePrice => 'سعر الشراء';

  @override
  String get birthDateUnknown => 'تاريخ الميلاد غير معروف';

  @override
  String get estimatedAge => 'العمر التقديري';

  @override
  String get photo => 'الصورة';

  @override
  String get photoPlaceholder =>
      'التقاط الصور غير متاح بعد؛ هذه المساحة مهيأة للمستقبل.';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get duplicateTagMessage => 'رقم الشارة هذا مخصص لخروف آخر.';

  @override
  String get breedCrossbred => 'هجين';

  @override
  String get breedMixed => 'مختلط';

  @override
  String get breedUnknown => 'غير معروف';

  @override
  String get breedOther => 'أخرى';

  @override
  String get breedLocal => 'محلي';

  @override
  String get breedAssaf => 'عساف';

  @override
  String get breedDorper => 'دوربر';

  @override
  String get breedMerino => 'مرينو';

  @override
  String get breedNajdiCross => 'نجدي هجين';

  @override
  String get customBreed => 'سلالة مخصصة';

  @override
  String get recordBcs => 'تسجيل حالة الجسم';

  @override
  String recordWeightFor(String tag) {
    return 'وزن الخروف رقم $tag';
  }

  @override
  String get weightUnit => 'الوحدة';

  @override
  String get method => 'الطريقة';

  @override
  String get methodScale => 'ميزان';

  @override
  String get methodEstimated => 'تقديري';

  @override
  String get kgUnit => 'كغ';

  @override
  String get lbUnit => 'رطل';

  @override
  String get saveWeight => 'حفظ الوزن';

  @override
  String get bcsInvalid =>
      'يجب أن يكون تقييم حالة الجسم بين ١ و٥ بخطوات نصف درجة.';

  @override
  String get weightInvalid => 'أدخل وزناً أكبر من صفر.';

  @override
  String get healthObservation => 'ملاحظة صحية';

  @override
  String get whatDidYouObserve => 'ماذا لاحظت؟';

  @override
  String get whoIsThisFor => 'لمن هذه الملاحظة؟';

  @override
  String get thisSheep => 'هذا الخروف';

  @override
  String get groupScope => 'مجموعة';

  @override
  String get entireFlock => 'القطيع كاملاً';

  @override
  String get selectSymptoms => 'اختر العلامات';

  @override
  String get symptomCategoryEating => 'الأكل والهضم';

  @override
  String get symptomCategoryBreathing => 'التنفس';

  @override
  String get symptomCategoryEyes => 'العيون';

  @override
  String get symptomCategoryMovement => 'الحركة';

  @override
  String get symptomCategorySkin => 'الجلد';

  @override
  String get symptomCategoryGeneral => 'عام';

  @override
  String get symptomCategoryOther => 'أخرى';

  @override
  String get severity => 'الشدة';

  @override
  String get severityMild => 'خفيفة';

  @override
  String get severityModerate => 'متوسطة';

  @override
  String get severitySevere => 'شديدة';

  @override
  String get urgentAttention => 'انتباه عاجل';

  @override
  String get urgentAttentionBody =>
      'قد تتطلب هذه الملاحظة تقييماً بيطرياً عاجلاً.';

  @override
  String get observationSummary => 'ملخص الملاحظة';

  @override
  String get observedSigns => 'العلامات الملحوظة';

  @override
  String get durationLabel => 'المدة';

  @override
  String get drinking => 'الشرب';

  @override
  String get suggestedChecks => 'الفحوص المقترحة';

  @override
  String get possibleAreas => 'مجالات محتملة للتحقق';

  @override
  String get recommendedNextAction => 'الإجراء التالي الموصى به';

  @override
  String get saveObservation => 'حفظ الملاحظة';

  @override
  String get createFollowUp => 'إنشاء مهمة متابعة';

  @override
  String get recordTreatment => 'تسجيل علاج';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get followUpQuestions => 'أسئلة المتابعة';

  @override
  String get symptomNotEating => 'لا يأكل';

  @override
  String get symptomReducedAppetite => 'قلة الشهية';

  @override
  String get symptomDiarrhea => 'إسهال';

  @override
  String get symptomConstipation => 'إمساك';

  @override
  String get symptomBloating => 'انتفاخ';

  @override
  String get symptomAbnormalStool => 'براز غير طبيعي';

  @override
  String get symptomDrinkingLess => 'شرب أقل';

  @override
  String get symptomNotDrinking => 'لا يشرب';

  @override
  String get symptomCoughing => 'سعال';

  @override
  String get symptomDifficultyBreathing => 'صعوبة في التنفس';

  @override
  String get symptomNasalDischarge => 'إفرازات أنفية';

  @override
  String get symptomEyeRedness => 'احمرار العين';

  @override
  String get symptomEyeDischarge => 'إفرازات العين';

  @override
  String get symptomEyeCloudiness => 'غشاوة العين';

  @override
  String get symptomEyeSwelling => 'انتفاخ العين';

  @override
  String get symptomKeepsEyeClosed => 'يُبقي العين مغلقة';

  @override
  String get symptomPossibleEyeInjury => 'إصابة محتملة في العين';

  @override
  String get symptomLameness => 'عرج';

  @override
  String get symptomSwollenJoint => 'انتفاخ الساق/المفصل';

  @override
  String get symptomHoofProblem => 'مشكلة في الحافر';

  @override
  String get symptomItching => 'حكة';

  @override
  String get symptomHairLoss => 'تساقط الصوف';

  @override
  String get symptomSkinLesion => 'آفة جلدية';

  @override
  String get symptomWeakness => 'ضعف';

  @override
  String get symptomLethargy => 'خمول';

  @override
  String get symptomFever => 'حمى / حرارة';

  @override
  String get symptomWeightLoss => 'نقص الوزن';

  @override
  String get symptomPaleEyelids => 'شحوب الجفون/اللثة';

  @override
  String get symptomAbnormalUrine => 'بول غير طبيعي';

  @override
  String get symptomOther => 'أخرى';

  @override
  String get qAppetiteDuration => 'منذ متى؟';

  @override
  String get qDrinking => 'هل يشرب الخروف؟';

  @override
  String get qAppetiteOtherSigns => 'أي علامات أخرى؟';

  @override
  String get qDiarrheaDuration => 'منذ متى؟';

  @override
  String get qStoolAppearance => 'شكل البراز';

  @override
  String get qDiarrheaOtherSigns => 'علامات أخرى؟';

  @override
  String get qEyeWhatSee => 'ماذا ترى؟';

  @override
  String get qEyeOneOrBoth => 'عين واحدة أم كلتاهما؟';

  @override
  String get qEyeRubbing => 'هل يحكّ الخروف عينه؟';

  @override
  String get qEyeInjury => 'هل توجد إصابة واضحة؟';

  @override
  String get qLamenessSeverity => 'الشدة';

  @override
  String get qLamenessLeg => 'أي ساق؟';

  @override
  String get qHoofAppearance => 'شكل الحافر';

  @override
  String get optLess12h => 'أقل من ١٢ ساعة';

  @override
  String get opt12_24h => '١٢–٢٤ ساعة';

  @override
  String get opt1_2Days => 'يوم إلى يومين';

  @override
  String get optMore2Days => 'أكثر من يومين';

  @override
  String get optUnknown => 'غير معروف';

  @override
  String get optNormally => 'بشكل طبيعي';

  @override
  String get optLessThanNormal => 'أقل من الطبيعي';

  @override
  String get optNotDrinking => 'لا يشرب';

  @override
  String get optTeethGrinding => 'صرير الأسنان';

  @override
  String get optLess1Day => 'أقل من يوم';

  @override
  String get opt3_5Days => '٣–٥ أيام';

  @override
  String get optMore5Days => 'أكثر من ٥ أيام';

  @override
  String get optLoose => 'رخو';

  @override
  String get optWatery => 'مائي';

  @override
  String get optVeryWatery => 'شديد السيولة';

  @override
  String get optMucus => 'يوجد مخاط';

  @override
  String get optBlood => 'يوجد دم';

  @override
  String get optRedness => 'احمرار';

  @override
  String get optCloudiness => 'غشاوة';

  @override
  String get optDischarge => 'إفرازات';

  @override
  String get optSwelling => 'انتفاخ';

  @override
  String get optKeepsClosed => 'يُبقي العين مغلقة';

  @override
  String get optTearing => 'دمع غزير';

  @override
  String get optPossibleInjury => 'إصابة محتملة';

  @override
  String get optDifficultySeeing => 'صعوبة في الرؤية';

  @override
  String get optLeft => 'يسرى';

  @override
  String get optRight => 'يمنى';

  @override
  String get optBoth => 'كلتاهما';

  @override
  String get optYes => 'نعم';

  @override
  String get optNo => 'لا';

  @override
  String get optNotSure => 'غير متأكد';

  @override
  String get optSlight => 'طفيف';

  @override
  String get optModerate => 'متوسط';

  @override
  String get optSevere => 'شديد';

  @override
  String get optUnableToWalk => 'غير قادر على المشي';

  @override
  String get optFrontLeft => 'الأمامية اليسرى';

  @override
  String get optFrontRight => 'الأمامية اليمنى';

  @override
  String get optRearLeft => 'الخلفية اليسرى';

  @override
  String get optRearRight => 'الخلفية اليمنى';

  @override
  String get optNormal => 'طبيعي';

  @override
  String get optOvergrown => 'متضخم';

  @override
  String get optDamaged => 'تالف';

  @override
  String get optSwollen => 'منتفخ';

  @override
  String get optBadOdor => 'رائحة كريهة';

  @override
  String get checkTemperature => 'افحص درجة الحرارة';

  @override
  String get checkHydration => 'افحص الترطيب';

  @override
  String get checkEyelidColor => 'افحص لون الجفون/اللثة';

  @override
  String get checkFeces => 'افحص البراز';

  @override
  String get checkFeedChanges => 'راجع التغييرات الأخيرة في العلف';

  @override
  String get checkOtherSheep => 'تحقق من إصابة أغنام أخرى';

  @override
  String get monitorWater => 'راقب استهلاك الماء';

  @override
  String get examineEyeLight => 'افحص العين في إضاءة جيدة';

  @override
  String get checkForeignMaterial => 'تحقق من وجود جسم غريب أو إصابة';

  @override
  String get monitorVision => 'راقب تأثر الرؤية';

  @override
  String get inspectHoof => 'افحص الحافر';

  @override
  String get areaDigestiveProblem => 'مشكلة هضمية';

  @override
  String get areaFeedRelated => 'مشكلة مرتبطة بالعلف';

  @override
  String get areaParasiteBurden => 'عبء طفيلي';

  @override
  String get areaInfection => 'عدوى';

  @override
  String get areaDentalMouth => 'مشكلة أسنان/فم';

  @override
  String get areaPainInjury => 'ألم أو إصابة';

  @override
  String get areaUnderlying => 'حالة كامنة أخرى';

  @override
  String get areaEyeIrritation => 'تهيّج';

  @override
  String get areaEyeInjury => 'إصابة';

  @override
  String get areaEyeInfection => 'مشكلة عين معدية';

  @override
  String get areaEyeForeignMaterial => 'جسم غريب';

  @override
  String get areaHoofProblem => 'مشكلة في الحافر';

  @override
  String get areaJointProblem => 'مشكلة مفصلية';

  @override
  String get actionMonitorClosely =>
      'راقب عن كثب وراجع الطبيب البيطري إذا استمرت الأعراض أو ساءت.';

  @override
  String get actionInspectEye => 'افحص العين';

  @override
  String get actionInspectHoof => 'افحص الحافر';

  @override
  String get actionSeparateFlock => 'اعزل عن القطيع إذا لزم';

  @override
  String get redFlagSevereBreathing => 'صعوبة شديدة في التنفس';

  @override
  String get redFlagSevereBloating => 'انتفاخ شديد';

  @override
  String get redFlagSevereWeakness => 'ضعف شديد';

  @override
  String get redFlagNotDrinking => 'لا يشرب';

  @override
  String get redFlagUnableToStand => 'غير قادر على الوقوف';

  @override
  String get redFlagSevereEyeInjury => 'إصابة العين تتطلب تقييماً';

  @override
  String get medicationLibrary => 'مكتبة الأدوية';

  @override
  String get searchMedication => 'ابحث عن دواء...';

  @override
  String get medicationCategory => 'الفئة';

  @override
  String get categoryAntibiotic => 'مضاد حيوي';

  @override
  String get categoryAntiparasitic => 'مضاد طفيليات';

  @override
  String get categoryAntiInflammatory => 'مضاد التهاب';

  @override
  String get categoryPainRelief => 'مسكّن ألم';

  @override
  String get categoryVitaminMineral => 'فيتامين / معادن';

  @override
  String get categoryElectrolyte => 'محلول الكهارل';

  @override
  String get categoryEyeTreatment => 'علاج العين';

  @override
  String get categoryTopicalTreatment => 'علاج موضعي';

  @override
  String get categoryHoofTreatment => 'علاج الحافر';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get activeIngredient => 'المادة الفعالة';

  @override
  String get availableRoutes => 'طرق الإعطاء المتاحة';

  @override
  String get select => 'اختيار';

  @override
  String get medicationInformation => 'معلومات الدواء';

  @override
  String get treatmentOptionsDisclaimer =>
      'خيارات علاجية تُناقش مع الطبيب البيطري';

  @override
  String get filter => 'تصفية';

  @override
  String get doseUnit => 'الوحدة';

  @override
  String get unitMl => 'مل';

  @override
  String get unitMg => 'ملغ';

  @override
  String get unitG => 'غ';

  @override
  String get unitTablet => 'قرص';

  @override
  String get unitBolus => 'كبسولة كبيرة (بولص)';

  @override
  String get unitOther => 'أخرى';

  @override
  String get routeEye => 'عين';

  @override
  String get routeOther => 'أخرى';

  @override
  String get administeredBy => 'أُعطي بواسطة';

  @override
  String get dateTime => 'التاريخ/الوقت';

  @override
  String get clear => 'سليم';

  @override
  String get meatClearance => 'سحب اللحم';

  @override
  String get milkClearance => 'سحب الحليب';

  @override
  String meatWithdrawalUntil(String date) {
    return 'سحب اللحم حتى $date';
  }

  @override
  String milkWithdrawalUntil(String date) {
    return 'سحب الحليب حتى $date';
  }

  @override
  String get followUp => 'متابعة';

  @override
  String get followUpTitle => 'عنوان المهمة';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get priority => 'الأولوية';

  @override
  String get priorityLow => 'منخفضة';

  @override
  String get priorityNormal => 'عادية';

  @override
  String get assignedTo => 'مُسندة إلى';

  @override
  String get saveFollowUp => 'حفظ المتابعة';

  @override
  String get followUpSaved => 'تم إنشاء مهمة متابعة';

  @override
  String get activeWithdrawals => 'فترات سحب نشطة';

  @override
  String sheepNeedAttention(int count) {
    return '$count رأس تحتاج إلى انتباه';
  }

  @override
  String get healthConcerns => 'ملاحظات صحية';

  @override
  String get underWithdrawal => 'تحت فترة سحب';

  @override
  String get followUpDueToday => 'متابعة مستحقة اليوم';

  @override
  String get recentHealthObservation => 'ملاحظة صحية حديثة';

  @override
  String get eventHealthObservation => 'ملاحظة صحية';

  @override
  String get eventIdentityChanged => 'تم تحديث التعريف';

  @override
  String identityChangeDetail(String field, String old, String newValue) {
    return '$field · $old ← $newValue';
  }

  @override
  String get today => 'اليوم';

  @override
  String get symptomRapidBreathing => 'تنفس سريع';

  @override
  String get symptomTearing => 'دمع';

  @override
  String get symptomHoofSwelling => 'انتفاخ الحافر';

  @override
  String get symptomHoofBadOdor => 'رائحة كريهة (الحافر)';

  @override
  String get symptomAbdominalPain => 'ألم بطني';

  @override
  String get symptomBottleJaw => 'وذمة الفك';

  @override
  String get symptomRecumbent => 'غير قادر على الوقوف / مستلقٍ';

  @override
  String get symptomNeurologicSigns => 'علامات عصبية';

  @override
  String get symptomSuddenIllness => 'مرض شديد مفاجئ';

  @override
  String get symptomSuddenDeath => 'نفوق مفاجئ';

  @override
  String get symptomCrusts => 'قشور';

  @override
  String get symptomVisibleParasites => 'طفيليات ظاهرة';

  @override
  String get conditionHaemonchosis => 'داء الهيمونكس';

  @override
  String get conditionGastrointestinalParasitism => 'طفيليات الجهاز الهضمي';

  @override
  String get conditionCoccidiosis => 'الكوكسيديا';

  @override
  String get conditionGrainOverload => 'الإفراط في الحبوب / الحماض اللبني';

  @override
  String get conditionEnterotoxemia => 'التسمم المعوي';

  @override
  String get conditionBacterialPneumonia => 'التهاب رئوي بكتيري';

  @override
  String get conditionRespiratoryDisease => 'مرض تنفسي';

  @override
  String get conditionPinkeye => 'العين الوردية';

  @override
  String get conditionFootrot => 'عفونة الحافر';

  @override
  String get conditionPregnancyToxemia => 'تسمم الحمل';

  @override
  String get conditionHypocalcemia => 'نقص كالسيوم الدم';

  @override
  String get conditionExternalParasites => 'طفيليات خارجية';

  @override
  String get conditionDehydration => 'جفاف';

  @override
  String get conditionFeverInfection => 'حمى / عدوى';

  @override
  String get conditionGeneralEnteritis => 'التهاب معوي عام';

  @override
  String get conditionSalmonellosis => 'داء السالمونيلا';

  @override
  String get categoryDigestive => 'هضمي';

  @override
  String get categoryRespiratory => 'تنفسي';

  @override
  String get categoryEye => 'عين';

  @override
  String get categoryHoof => 'الحافر / العضلات والعظام';

  @override
  String get categoryMetabolic => 'أيضي';

  @override
  String get categoryParasite => 'طفيليات';

  @override
  String get categorySkin => 'جلد';

  @override
  String get categoryGeneral => 'عام / معدي';

  @override
  String get categoryReproductive => 'تناسلي';

  @override
  String get compatibilityStronglyCompatible => 'نمط متوافق بقوة';

  @override
  String get compatibilityCompatible => 'نمط متوافق';

  @override
  String get compatibilityPossible => 'محتمل';

  @override
  String get compatibilityLessLikely => 'أقل احتمالاً';

  @override
  String get compatibilityInsufficient => 'معلومات غير كافية';

  @override
  String get riskRoutine => 'روتيني';

  @override
  String get riskNeedsAttention => 'يحتاج إلى انتباه';

  @override
  String get riskUrgent => 'عاجل';

  @override
  String get redFlagNeurologicSigns => 'علامات عصبية';

  @override
  String get redFlagSuddenDeath => 'نفوق مفاجئ';

  @override
  String get redFlagSevereDehydration => 'جفاف شديد';

  @override
  String get checkFamacha => 'تقييم فاماشا';

  @override
  String get checkFecalEggCount => 'عدّ بيوض الديدان في البراز';

  @override
  String get checkBodyCondition => 'حالة الجسم';

  @override
  String get checkDewormingHistory => 'تاريخ مضاد الديدان الحديث';

  @override
  String get checkAge => 'العمر';

  @override
  String get checkFecalExam => 'فحص البراز';

  @override
  String get checkBloodMucus => 'دم/مخاط في البراز';

  @override
  String get checkGestationStage => 'مرحلة الحمل';

  @override
  String get checkLitterSize => 'عدد الأجنة';

  @override
  String get checkKetoneBhb => 'الكيتونات / BHB';

  @override
  String get checkBloodGlucose => 'سكر الدم';

  @override
  String get checkRespiratoryRate => 'معدل التنفس';

  @override
  String get checkRumen => 'الكرش / الانتفاخ';

  @override
  String get checkVaccinationStatus => 'حالة التطعيم';

  @override
  String get checkAffectedAgeGroup => 'الفئة العمرية المصابة';

  @override
  String get checkNumberAffected => 'عدد المصابين';

  @override
  String get checkCorneal => 'غشاوة القرنية';

  @override
  String get checkOneBothEyes => 'عين واحدة أم كلتاهما';

  @override
  String get checkUlcerInjury => 'تقرح / إصابة';

  @override
  String get checkPainSquinting => 'ألم / إغماض';

  @override
  String get checkVision => 'الرؤية';

  @override
  String get checkHoofOdor => 'رائحة الحافر';

  @override
  String get checkVisibleParasites => 'طفيليات ظاهرة';

  @override
  String get checkAffectedAreas => 'المناطق المصابة';

  @override
  String get checkNasalDischarge => 'إفرازات أنفية';

  @override
  String get checkDrinking => 'الشرب';

  @override
  String get checkRecentFeedChange => 'تغيير حديث في العلف';

  @override
  String get actionIsolate => 'اعزل الخروف';

  @override
  String get actionCleanWater => 'وفّر ماءً نظيفاً';

  @override
  String get actionAssessNow => 'قيّم فوراً';

  @override
  String get actionRemoveFeed => 'أزل الوصول إلى العلف المشتبه به';

  @override
  String get actionContactVet => 'تواصل مع الطبيب البيطري';

  @override
  String get actionRecordTemperature => 'سجّل درجة الحرارة';

  @override
  String get actionInspectEyes => 'افحص العينين';

  @override
  String get actionCheckMucousMembrane => 'افحص لون الأغشية المخاطية';

  @override
  String get actionMoveCleanDry => 'انقل إلى ظروف أنظف/أجف';

  @override
  String get actionSupportNutrition => 'ادعم التغذية';

  @override
  String get actionMonitorFlock => 'راقب الأغنام الأخرى';

  @override
  String get actionReviewVaccination => 'راجع حالة التطعيم';

  @override
  String get treatmentSupportiveCare => 'رعاية داعمة';

  @override
  String get treatmentAntiparasitic => 'مضاد طفيليات';

  @override
  String get treatmentAnticoccidial => 'مضاد الكوكسيديا';

  @override
  String get treatmentAntimicrobial => 'مضاد ميكروبي';

  @override
  String get treatmentAntiInflammatory => 'مضاد التهاب';

  @override
  String get treatmentElectrolyte => 'محاليل الكهارل / السوائل';

  @override
  String get treatmentNutritional => 'دعم غذائي';

  @override
  String get treatmentTopical => 'علاج موضعي';

  @override
  String get treatmentFootbath => 'مغطس الحافر / إدارة الحوافر';

  @override
  String get treatmentIsolation => 'عزل';

  @override
  String get treatmentSurgical => 'تدخل جراحي / بيطري';

  @override
  String get treatmentMonitoring => 'مراقبة';

  @override
  String get treatmentPreventiveVaccination => 'تطعيم وقائي';

  @override
  String get treatmentOther => 'أخرى';

  @override
  String get protocolSupportiveCare => 'رعاية داعمة';

  @override
  String get protocolParasiteControl => 'بروتوكول مكافحة الطفيليات';

  @override
  String get protocolAnticoccidialTherapy => 'علاج الكوكسيديا';

  @override
  String get protocolAntimicrobialWhenIndicated =>
      'مضاد ميكروبي (عند الاقتضاء)';

  @override
  String get protocolOphthalmic => 'علاج عيني';

  @override
  String get protocolFootbathHoof => 'مغطس الحافر / إدارة الحوافر';

  @override
  String get protocolMetabolic => 'علاج أيضي بإشراف بيطري';

  @override
  String get protocolIsolation => 'عزل';

  @override
  String get protocolMonitoring => 'مراقبة';

  @override
  String get protocolTopical => 'علاج موضعي';

  @override
  String get protocolPreventiveVaccination => 'تطعيم وقائي';

  @override
  String get protocolElectrolyte => 'محاليل الكهارل / السوائل';

  @override
  String get riskRecentFeedChange => 'تغيير حديث في العلف';

  @override
  String get riskRecentGrainAccess => 'وصول حديث إلى الحبوب';

  @override
  String get riskMultipleAffected => 'إصابة عدة أغنام';

  @override
  String get riskCrowded => 'تكدّس';

  @override
  String get riskPastureExposure => 'الرعي في المراعي';

  @override
  String get riskWetConditions => 'ظروف رطبة';

  @override
  String get riskRecentTransport => 'نقل حديث';

  @override
  String get riskRecentStress => 'إجهاد حديث';

  @override
  String get riskPregnant => 'حامل';

  @override
  String get riskLateGestation => 'أواخر الحمل';

  @override
  String get riskLowBcs => 'حالة جسم منخفضة';

  @override
  String get riskLactating => 'مُرضِعة';

  @override
  String get ageGroupNeonatal => 'حَمَل حديث الولادة';

  @override
  String get ageGroupYoungLamb => 'حَمَل صغير';

  @override
  String get ageGroupGrowingLamb => 'حَمَل نامٍ';

  @override
  String get ageGroupAdult => 'بالغ';

  @override
  String get ageGroupSenior => 'مسنّ';

  @override
  String get conditionsToConsider => 'حالات يجب التفكير فيها';

  @override
  String get whyThisAppears => 'لماذا تظهر';

  @override
  String get checkNext => 'ما يجب فحصه';

  @override
  String get treatmentApproach => 'نهج العلاج';

  @override
  String get viewProtocol => 'عرض البروتوكول';

  @override
  String get viewMedications => 'عرض الأدوية';

  @override
  String get healthAssessment => 'التقييم الصحي';

  @override
  String get clinicalDifferential => 'التشخيص التفريقي السريري';

  @override
  String get advancedHealthView => 'عرض صحي متقدم';

  @override
  String get possibleFlockProblem => 'مشكلة محتملة على مستوى القطيع';

  @override
  String get flockProblemBody => 'عدة أغنام لديها ملاحظات متشابهة.';

  @override
  String get medicationRequiresVerification =>
      'يتطلب الدواء تحققاً بيطرياً / من نشرة المنتج.';

  @override
  String get labelStatusApprovedForSheep => 'مصرّح للأغنام';

  @override
  String get labelStatusApprovedForIndication => 'مصرّح لهذه الاستطبابة';

  @override
  String get labelStatusVeterinaryDirected => 'بتوجيه بيطري / خارج النشرة';

  @override
  String get labelStatusVerificationRequired => 'يتطلب تحققاً';

  @override
  String get labelStatusUnknown => 'غير معروف';

  @override
  String get reasonForTreatment => 'لماذا تعالج؟';

  @override
  String get treatmentReasonHealthObservation => 'ملاحظة صحية';

  @override
  String get treatmentReasonConfirmedDiagnosis => 'تشخيص مؤكد';

  @override
  String get treatmentReasonPreventive => 'بروتوكول وقائي';

  @override
  String get treatmentReasonVaccination => 'تطعيم';

  @override
  String get treatmentReasonRoutineParasite => 'مكافحة روتينية للطفيليات';

  @override
  String get treatmentReasonOther => 'أخرى';

  @override
  String get confirmTreatment => 'تأكيد العلاج';

  @override
  String get confirmAndRecord => 'تأكيد وتسجيل';

  @override
  String get healthGuidanceDatabase => 'قاعدة بيانات الإرشاد الصحي';

  @override
  String get lastVerified => 'آخر تحقق';

  @override
  String knowledgeVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get famacha => 'فاماشا';

  @override
  String get eyelidColor => 'لون الجفن';

  @override
  String get gestationStage => 'مرحلة الحمل';

  @override
  String get litterSize => 'عدد الأجنة';

  @override
  String get whyExpandable => 'لماذا أرى هذا؟';

  @override
  String get whatMoreLikely => 'ما الذي يزيد احتماله؟';

  @override
  String get whatLessLikely => 'ما الذي يقلل احتماله؟';

  @override
  String get antibioticNotIndicated =>
      'لا يُستدل تلقائياً على العلاج بالمضادات الحيوية من هذه العلامات وحدها.';

  @override
  String get urgentVeterinaryAssessment => 'تقييم بيطري عاجل';

  @override
  String get doNotDewormRoutinely =>
      'لا تعالج بالديدان تلقائياً بناءً على الإسهال وحده.';

  @override
  String get healthCenter => 'المركز الصحي';

  @override
  String get changeSheep => 'تغيير الخروف';

  @override
  String get healthCheck => 'فحص الصحة';

  @override
  String get stable => 'مستقر';

  @override
  String get underTreatment => 'تحت العلاج';

  @override
  String get weightBcs => 'الوزن / حالة الجسم';

  @override
  String get deworming => 'علاج الديدان';

  @override
  String get healthCases => 'الحالات الصحية';

  @override
  String get preventiveCare => 'الرعاية الوقائية';

  @override
  String get measurements => 'القياسات';

  @override
  String get history => 'السجل';

  @override
  String get lastHealthCheck => 'آخر فحص صحي';

  @override
  String get upcoming => 'القادم';

  @override
  String get caseStatus => 'الحالة';

  @override
  String get caseSeverity => 'الشدة';

  @override
  String get caseStarted => 'تاريخ البدء';

  @override
  String get caseSummary => 'ملخص الحالة';

  @override
  String get caseObservations => 'الملاحظات';

  @override
  String get caseAssessment => 'التقييم';

  @override
  String get caseChecks => 'الفحوص';

  @override
  String get noActiveHealthCases => 'لا توجد حالات صحية نشطة';

  @override
  String get noHealthCasesDetail =>
      'لا توجد حالات صحية مفتوحة لهذا الخروف حالياً.';

  @override
  String get caseOpen => 'مفتوحة';

  @override
  String get caseMonitoring => 'مراقبة';

  @override
  String get caseTreatment => 'علاج';

  @override
  String get caseAwaitingVet => 'بانتظار المراجعة البيطرية';

  @override
  String get caseImproving => 'تتحسن';

  @override
  String get caseResolved => 'تم حلها';

  @override
  String get caseChronic => 'مزمنة';

  @override
  String get caseClosed => 'مغلقة';

  @override
  String get parasiteManagement => 'إدارة الطفيليات';

  @override
  String get currentParasiteStatus => 'حالة الطفيليات الحالية';

  @override
  String get lastFamacha => 'آخر فاماشا';

  @override
  String get lastFecalTest => 'آخر فحص براز';

  @override
  String get lastDeworming => 'آخر علاج للديدان';

  @override
  String get currentWithdrawal => 'فترة السحب الحالية';

  @override
  String get nextAction => 'الإجراء التالي';

  @override
  String get deworm => 'علاج الديدان';

  @override
  String get fecalTest => 'فحص البراز';

  @override
  String get parasiteObservation => 'ملاحظة طفيليات';

  @override
  String get viewHistory => 'عرض السجل';

  @override
  String get whyDeworming => 'لماذا تعالج الديدان؟';

  @override
  String get dewormingReasonTreatment => 'علاج — علامات توافق مرض الطفيليات';

  @override
  String get dewormingReasonPositiveTest => 'فحص براز إيجابي';

  @override
  String get dewormingReasonFamacha => 'تقييم فاماشا / فقر الدم';

  @override
  String get dewormingReasonRoutine => 'بروتوكول روتيني';

  @override
  String get dewormingReasonGroup => 'علاج مجموعة';

  @override
  String get dewormingReasonVet => 'توصية بيطرية';

  @override
  String get dewormingReasonOther => 'أخرى';

  @override
  String get parasiteAssessment => 'تقييم الطفيليات';

  @override
  String get bottleJaw => 'وذمة الفك';

  @override
  String get recentFecalTest => 'فحص براز حديث';

  @override
  String get previousProduct => 'المنتج السابق';

  @override
  String get otherSheepAffected => 'هل أصيبت أغنام أخرى؟';

  @override
  String get reviewRecommended => 'يُنصح بالمراجعة';

  @override
  String get findings => 'النتائج';

  @override
  String get pattern => 'النمط';

  @override
  String get importantNextCheck => 'الفحص التالي المهم';

  @override
  String get viewParasiteProtocol => 'عرض بروتوكول علاج الطفيليات';

  @override
  String get famachaTrend => 'اتجاه فاماشا';

  @override
  String get famachaWorsening => 'ارتفعت درجة فاماشا — تحتاج إلى انتباه';

  @override
  String get recordFamacha => 'تسجيل فاماشا';

  @override
  String get recordFecalTest => 'تسجيل فحص البراز';

  @override
  String get fecalTestType => 'نوع الفحص';

  @override
  String get fecalEggCount => 'عدّ بيوض الديدان';

  @override
  String get resultLevel => 'النتيجة';

  @override
  String get parasitesDetected => 'الطفيليات المكتشفة';

  @override
  String get laboratory => 'المختبر';

  @override
  String get testTypeFecalEggCount => 'عدّ بيوض الديدان';

  @override
  String get testTypeMcMaster => 'ماكماستر';

  @override
  String get testTypeOocyst => 'عدّ البيوض المتكيسة';

  @override
  String get testTypeGeneral => 'فحص براز عام';

  @override
  String get testTypeOther => 'أخرى';

  @override
  String get fecalNegative => 'سلبي';

  @override
  String get fecalLow => 'منخفض';

  @override
  String get fecalModerate => 'متوسط';

  @override
  String get fecalHigh => 'مرتفع';

  @override
  String get fecalSpecific => 'تم اكتشاف طفيلي محدد';

  @override
  String get fecalPending => 'قيد الانتظار';

  @override
  String get parasiteHistory => 'سجل الطفيليات';

  @override
  String get dewormingHistory => 'سجل علاج الديدان';

  @override
  String get noDewormingRecorded => 'لا يوجد علاج ديدان مسجل';

  @override
  String get noDewormingDetail =>
      'ابدأ بتسجيل علاجات الطفيليات لبناء سجل كامل.';

  @override
  String get noFamachaRecorded => 'لا يوجد فاماشا مسجل';

  @override
  String get noFamachaDetail => 'سجّل درجة فاماشا لبدء مراقبة الطفيليات.';

  @override
  String get noFecalTests => 'لا توجد فحوص براز مسجلة';

  @override
  String get recordDeworming => 'تسجيل علاج الديدان';

  @override
  String get dewormingRecorded => 'تم تسجيل علاج الديدان';

  @override
  String get treatmentResponse => 'استجابة العلاج';

  @override
  String get responseImproved => 'تحسّن';

  @override
  String get responseUnchanged => 'بدون تغيير';

  @override
  String get responseWorse => 'أسوأ';

  @override
  String get responseUnknown => 'غير معروف';

  @override
  String get concentration => 'التركيز';

  @override
  String get weightAtTreatment => 'الوزن عند العلاج';

  @override
  String get calculatedDose => 'الجرعة المحسوبة';

  @override
  String get basedOn => 'بناءً على';

  @override
  String get protocolMgPerKg => 'البروتوكول (ملغ/كغ)';

  @override
  String get productMgPerMl => 'المنتج (ملغ/مل)';

  @override
  String get underdoseWarning => 'الجرعة المدخلة أقل من البروتوكول المحدد.';

  @override
  String get overdoseWarning => 'الجرعة تتطلب تحققاً.';

  @override
  String get parasiteRisk => 'خطر الطفيليات';

  @override
  String get riskLow => 'منخفض';

  @override
  String get riskMonitor => 'مراقبة';

  @override
  String get riskNeedsAssessment => 'يحتاج تقييماً';

  @override
  String get riskHighConcern => 'قلق مرتفع';

  @override
  String get demoMedication => 'تجريبي — تحقق من المنتج';

  @override
  String get possibleReducedEffectiveness =>
      'احتمال انخفاض فعالية العلاج — يُنصح بمراجعة بيطرية.';

  @override
  String get parasiteReviewRecommended =>
      'راجع اتجاه فاماشا وفكّر في فحص البراز / التقييم البيطري وفق بروتوكول مكافحة الطفيليات.';
}
