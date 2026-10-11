import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme_extension.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/widgets/status_badge.dart';
import '../../quick_log/data/care_providers.dart';
import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/withdrawal_calculator.dart';
import '../../health/presentation/health_labels.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/sheep_providers.dart';
import '../domain/sheep_record.dart';

class SheepProfilePage extends ConsumerStatefulWidget {
  const SheepProfilePage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<SheepProfilePage> createState() => _SheepProfilePageState();
}

class _SheepProfilePageState extends ConsumerState<SheepProfilePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 5, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepByIdProvider(widget.sheepId));
    final care = ref.watch(careProvider);
    if (sheep == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                strings.profileNotFound,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(strings.profileNotFoundDetails, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }
    return Column(
      key: Key('sheep-profile-${sheep.id}'),
      children: [
        _ProfileSummary(
          sheep: sheep,
          strings: strings,
          status: care.statusFor(sheep),
        ),
        Material(
          color: Theme.of(context).cardColor,
          child: TabBar(
            controller: _tabs,
            isScrollable: true,
            tabs: [
              Tab(text: strings.overview),
              Tab(key: const Key('profile-tab-health'), text: strings.health),
              Tab(
                key: const Key('profile-tab-breeding'),
                text: strings.breeding,
              ),
              Tab(
                key: const Key('profile-tab-weight'),
                text: strings.weightTrend,
              ),
              Tab(
                key: const Key('profile-tab-timeline'),
                text: strings.timeline,
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              _OverviewTab(
                sheep: sheep,
                strings: strings,
                events: care.eventsFor(sheep.id),
                withdrawal: care.withdrawalFor(sheep.id),
                asOf: care.asOf,
              ),
              _HealthTab(sheep: sheep, strings: strings, care: care),
              _BreedingTab(sheep: sheep, strings: strings),
              _WeightTab(sheep: sheep, strings: strings),
              _TimelineTab(
                sheep: sheep,
                strings: strings,
                events: care.eventsFor(sheep.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({
    required this.sheep,
    required this.strings,
    required this.status,
  });
  final SheepRecord sheep;
  final AppLocalizations strings;
  final SheepHealthStatus status;

  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).cardColor,
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.md,
    ),
    child: Column(
      children: [
        Container(
          height: 110,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Center(
            child: Text(
              sheep.sex == SheepSex.ram ? '🐏' : '🐑',
              style: const TextStyle(fontSize: 58),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              SizedBox(
                width: constraints.maxWidth - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${LocaleFormatters.textForContext(context, sheep.tagNumber)}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      '${_breed(strings, sheep.breed)} · ${_sex(strings, sheep.sex)} · ${_location(strings, sheep.location)}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.mutedText),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    LocaleFormatters.numberForContext(
                      context,
                      sheep.bcs,
                      decimalDigits: 1,
                    ),
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: AppColors.primary),
                  ),
                  Text(
                    strings.bcs,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              StatusBadge(status: status, label: _status(strings, status)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton.icon(
            key: const Key('edit-sheep'),
            onPressed: () =>
                context.push('$editSheepRoute?sheepId=${sheep.id}'),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(strings.edit),
          ),
        ),
      ],
    ),
  );

  static String _breed(AppLocalizations s, String breed) => switch (breed) {
    'Awassi' => s.breedAwassi,
    'Najdi' => s.breedNajdi,
    'Naimi' => s.breedNaimi,
    'Suffolk' => s.breedSuffolk,
    _ => breed,
  };

  static String _group(AppLocalizations s, String group) => switch (group) {
    'Pregnant Ewes' => s.pregnantEwes,
    'Rams' => s.rams,
    'Lambs · Group B' => s.lambsGroupB,
    _ => group,
  };

  static String _location(AppLocalizations s, String location) =>
      switch (location) {
        'North Pasture' => s.northPasture,
        'South Pasture' => s.southPasture,
        'East Paddock' => s.eastPaddock,
        'Lambing Barn' => s.lambingBarn,
        _ => location,
      };

  static String _sex(AppLocalizations s, SheepSex sex) => switch (sex) {
    SheepSex.ewe => s.sexEwe,
    SheepSex.ram => s.sexRam,
    SheepSex.lamb => s.sexLamb,
  };

  static String _status(AppLocalizations s, SheepHealthStatus status) =>
      switch (status) {
        SheepHealthStatus.healthy => s.healthy,
        SheepHealthStatus.attention => s.attention,
        SheepHealthStatus.urgent => s.urgent,
        SheepHealthStatus.withdrawal => s.withdrawal,
      };
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({
    required this.sheep,
    required this.strings,
    required this.events,
    required this.withdrawal,
    required this.asOf,
  });
  final SheepRecord sheep;
  final AppLocalizations strings;
  final List<FarmEvent> events;
  final WithdrawalSummary withdrawal;
  final DateTime asOf;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.xl,
    ),
    children: [
      Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              key: const Key('record-weight-from-profile'),
              onPressed: () =>
                  context.push('$weightEntryRoute?sheepId=${sheep.id}'),
              icon: const Icon(Icons.monitor_weight_outlined),
              label: Text(strings.recordWeight),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton.icon(
              key: const Key('health-observation-from-profile'),
              onPressed: () =>
                  context.push('$healthObservationRoute?sheepId=${sheep.id}'),
              icon: const Icon(Icons.monitor_heart_outlined),
              label: Text(strings.healthObservation),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              key: const Key('health-center-from-profile'),
              onPressed: () =>
                  context.push('$healthCenterRoute?sheepId=${sheep.id}'),
              icon: const Icon(Icons.medical_services_outlined),
              label: Text(strings.healthCenter),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: OutlinedButton.icon(
              key: const Key('parasites-from-profile'),
              onPressed: () =>
                  context.push('$parasiteManagementRoute?sheepId=${sheep.id}'),
              icon: const Icon(Icons.pest_control_outlined),
              label: Text(strings.parasiteManagement),
            ),
          ),
        ],
      ),
      const SizedBox(height: AppSpacing.md),
      AppSectionTitle(strings.identity),
      _InfoGrid(
        items: [
          (strings.tag, '#${sheep.tagNumber}'),
          (strings.breed, _ProfileSummary._breed(strings, sheep.breed)),
          (strings.sex, _ProfileSummary._sex(strings, sheep.sex)),
          (
            strings.birthDate,
            LocaleFormatters.dateForContext(context, sheep.birthDate),
          ),
          (strings.group, _ProfileSummary._group(strings, sheep.groupName)),
          (
            strings.location,
            _ProfileSummary._location(strings, sheep.location),
          ),
        ],
      ),
      AppSectionTitle(strings.currentStatus),
      _InfoGrid(
        items: [
          (
            strings.weight,
            '${LocaleFormatters.numberForContext(context, sheep.weightKg, decimalDigits: 1)} kg',
          ),
          (
            strings.bcs,
            '${LocaleFormatters.numberForContext(context, sheep.bcs, decimalDigits: 1)} / ${LocaleFormatters.numberForContext(context, 5)}',
          ),
          (strings.pregnancy, sheep.pregnant ? strings.confirmed : '—'),
          (
            strings.withdrawal,
            LocaleFormatters.textForContext(
              context,
              withdrawal.meatState == WithdrawalState.active
                  ? strings.withdrawalDays(
                      withdrawal.daysUntilMeatClearance(asOf) ?? 0,
                    )
                  : withdrawal.milkState == WithdrawalState.active
                  ? strings.milkClearanceActive(
                      withdrawal.daysUntilMilkClearance(asOf) ?? 0,
                    )
                  : strings.noWithdrawal,
            ),
          ),
        ],
      ),
      AppSectionTitle(strings.recentActivity),
      ...events
          .take(3)
          .map((event) => _ActivityTile(event: event, strings: strings)),
      if (events.isEmpty)
        Text(
          strings.recordWeight,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
    ],
  );
}

class _HealthTab extends StatelessWidget {
  const _HealthTab({
    required this.sheep,
    required this.strings,
    required this.care,
  });
  final SheepRecord sheep;
  final AppLocalizations strings;
  final CareState care;

  @override
  Widget build(BuildContext context) {
    final routines = [
      (
        strings.routineVaccination,
        DateTime(2026, 8, 12),
        DateTime(2027, 2, 12),
      ),
      (strings.routineDeworming, DateTime(2026, 7, 4), DateTime(2027, 1, 4)),
      (strings.routineDipping, DateTime(2026, 6, 18), DateTime(2026, 12, 18)),
      (strings.routineHoof, DateTime(2026, 5, 10), DateTime(2026, 11, 10)),
      (strings.routineShearing, DateTime(2026, 4, 2), DateTime(2027, 4, 2)),
      (
        strings.routineSupplements,
        DateTime(2026, 9, 15),
        DateTime(2026, 10, 15),
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        AppSectionTitle(strings.healthRoutines),
        ...routines.map(
          (routine) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              routine.$1,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${strings.lastDate}: ${LocaleFormatters.dateForContext(context, routine.$2)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  strings.nextDate,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  LocaleFormatters.dateForContext(context, routine.$3),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        AppSectionTitle(strings.activeTreatments),
        ...care
            .activeTreatmentsFor(sheep.id)
            .map(
              (treatment) => _WithdrawalCard(
                treatment: treatment,
                medication: care.medicationFor(treatment.medicationId),
                withdrawal: care.withdrawalForTreatment(treatment),
                strings: strings,
                asOf: care.asOf,
              ),
            ),
        if (care.activeTreatmentsFor(sheep.id).isEmpty)
          Card(
            elevation: 0,
            child: ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: AppColors.healthy,
              ),
              title: Text(strings.noActiveTreatment),
            ),
          ),
      ],
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  const _WithdrawalCard({
    required this.treatment,
    required this.medication,
    required this.withdrawal,
    required this.strings,
    required this.asOf,
  });
  final TreatmentRecord treatment;
  final MedicationRecord? medication;
  final WithdrawalSummary withdrawal;
  final AppLocalizations strings;
  final DateTime asOf;

  @override
  Widget build(BuildContext context) {
    final activeMeat = withdrawal.notClearForSale;
    final statusColors = Theme.of(context).extension<AppStatusColors>()!;
    final withdrawalColor = statusColors.withdrawal;
    final days = withdrawal.daysUntilMeatClearance(asOf);
    final milkDays = withdrawal.daysUntilMilkClearance(asOf);
    String dateFormat(DateTime date) =>
        LocaleFormatters.dateForContext(context, date);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        border: Border.all(color: withdrawalColor, width: 2),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.withdrawalActive.toUpperCase(),
            style: TextStyle(
              color: withdrawalColor,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            medication?.name ?? treatment.medicationId,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            strings.treatmentAdministered(
              dateFormat(treatment.administeredAt),
              LocaleFormatters.numberForContext(
                context,
                treatment.dose,
                decimalDigits: treatment.dose == treatment.dose.roundToDouble()
                    ? 0
                    : 1,
              ),
              treatment.doseUnit,
              _routeLabel(strings, treatment.route),
            ),
          ),
          const Divider(height: 24),
          if (activeMeat)
            Text(
              LocaleFormatters.textForContext(
                context,
                strings.withdrawalDays(days!),
              ),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: withdrawalColor),
            )
          else if (milkDays != null)
            Text(
              LocaleFormatters.textForContext(
                context,
                strings.milkClearanceActive(milkDays),
              ),
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(color: withdrawalColor),
            ),
          if (activeMeat)
            Text(
              strings.withdrawalClearance(
                dateFormat(withdrawal.meatClearanceDate!),
              ),
              style: TextStyle(color: withdrawalColor),
            )
          else if (milkDays != null)
            Text(
              strings.withdrawalClearance(
                dateFormat(withdrawal.milkClearanceDate!),
              ),
              style: TextStyle(color: withdrawalColor),
            ),
          const SizedBox(height: AppSpacing.sm),
          Semantics(
            liveRegion: true,
            label: activeMeat ? strings.notClearForSale : strings.clearForSale,
            child: Row(
              children: [
                Icon(
                  activeMeat ? Icons.warning_amber_rounded : Icons.check_circle,
                  color: activeMeat
                      ? statusColors.urgent
                      : statusColors.healthy,
                  size: 26,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    activeMeat ? strings.notClearForSale : strings.clearForSale,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: activeMeat
                          ? statusColors.urgent
                          : statusColors.healthy,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _routeLabel(AppLocalizations strings, TreatmentRoute route) =>
      switch (route) {
        TreatmentRoute.oral => strings.routeOral,
        TreatmentRoute.injection => strings.routeInjection,
        TreatmentRoute.topical => strings.routeTopical,
        TreatmentRoute.intramuscular => strings.routeIntramuscular,
        TreatmentRoute.subcutaneous => strings.routeSubcutaneous,
        TreatmentRoute.eye => strings.routeEye,
        TreatmentRoute.other => strings.routeOther,
      };
}

class _BreedingTab extends StatelessWidget {
  const _BreedingTab({required this.sheep, required this.strings});
  final SheepRecord sheep;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      AppSectionTitle(strings.breedingStatus),
      _InfoGrid(
        items: [
          (strings.pregnancy, sheep.pregnant ? strings.confirmed : '—'),
          (
            strings.matingDate,
            sheep.pregnant
                ? LocaleFormatters.dateForContext(context, DateTime(2026, 9, 8))
                : '—',
          ),
          (
            strings.ramLabel,
            sheep.pregnant
                ? strings.ramKarakul(
                    LocaleFormatters.textForContext(context, 'R12'),
                  )
                : '—',
          ),
          (
            strings.expectedLambing,
            sheep.pregnant
                ? LocaleFormatters.dateForContext(context, DateTime(2027, 2, 2))
                : '—',
          ),
        ],
      ),
      AppSectionTitle(strings.timeline),
      if (sheep.pregnant) ...[
        _SimpleEvent(
          date:
              '${LocaleFormatters.dateForContext(context, DateTime(2027, 2, 2))} · ${strings.expected}',
          title: strings.expectedLambing,
          details: strings.pregnancyDayProgress(
            LocaleFormatters.numberForContext(context, 22),
            LocaleFormatters.numberForContext(context, 147),
          ),
        ),
        _SimpleEvent(
          date: LocaleFormatters.dateForContext(context, DateTime(2026, 9, 8)),
          title: strings.activityMating,
          details: strings.recordedByName,
        ),
        _SimpleEvent(
          date: LocaleFormatters.dateForContext(context, DateTime(2026, 2, 12)),
          title: strings.lambingHistory,
          details: strings.healthyTwins,
        ),
      ] else
        Text(strings.profileNotFoundDetails),
    ],
  );
}

class _WeightTab extends StatelessWidget {
  const _WeightTab({required this.sheep, required this.strings});
  final SheepRecord sheep;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      AppSectionTitle(strings.weightTrend),
      Text(
        '${LocaleFormatters.numberForContext(context, sheep.weightKg, decimalDigits: 1)} kg',
        style: Theme.of(context).textTheme.headlineLarge
            ?.copyWith(color: AppColors.primary),
      ),
      const SizedBox(height: AppSpacing.md),
      SizedBox(
        height: 180,
        child: CustomPaint(
          painter: _WeightPainter(
            color: Theme.of(context).colorScheme.primary,
            grid: Theme.of(context).dividerColor,
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        List.generate(
          6,
          (index) => LocaleFormatters.textForContext(
            context,
            DateFormat.MMM(Localizations.localeOf(context).toLanguageTag())
                .format(DateTime(2026, index + 4)),
          ),
        ).join('     '),
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11),
      ),
      AppSectionTitle(strings.bcs),
      Text(
        '${LocaleFormatters.numberForContext(context, sheep.bcs, decimalDigits: 1)} / ${LocaleFormatters.numberForContext(context, 5)}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      Text(strings.recordWeight),
    ],
  );
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({
    required this.sheep,
    required this.strings,
    required this.events,
  });
  final SheepRecord sheep;
  final AppLocalizations strings;
  final List<FarmEvent> events;

  @override
  Widget build(BuildContext context) => ListView.builder(
    key: const Key('sheep-timeline-list'),
    padding: const EdgeInsets.all(AppSpacing.lg),
    itemCount: events.length + 1,
    itemBuilder: (context, index) => index == 0
        ? AppSectionTitle(strings.timeline)
        : _ActivityTile(event: events[index - 1], strings: strings),
  );
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.event, required this.strings});
  final FarmEvent event;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final title = switch (event) {
      TreatmentEvent(medicationName: final medication) =>
        strings.eventTreatmentTitle(medication),
      WeightEvent(weightKg: final weight) =>
        '${strings.weightRecorded} · ${LocaleFormatters.numberForContext(context, weight, decimalDigits: 1)} kg',
      BcsEvent(score: final score) => strings.eventBcsRecorded(
        LocaleFormatters.numberForContext(context, score, decimalDigits: 1),
      ),
      HeatCheckEvent(riskLevel: final risk) =>
        '${strings.heatCheckAction} · ${_heatRiskLabel(strings, risk)}',
      IdentityChangeEvent() => strings.eventIdentityChanged,
      HealthObservationEvent(symptomIds: final ids) =>
        '${strings.eventHealthObservation} · ${_symptomSummary(strings, ids)}',
      AnimalActionEvent(action: final action) => _localizedAction(
        context,
        strings,
        action,
      ),
    };
    final details = switch (event) {
      TreatmentEvent(
        dose: final dose,
        doseUnit: final unit,
        recordedBy: final user,
      ) =>
        '${LocaleFormatters.numberForContext(context, dose, decimalDigits: dose == dose.roundToDouble() ? 0 : 1)} $unit · ${_localizedUser(strings, user)}',
      WeightEvent(recordedBy: final user) => _localizedUser(strings, user),
      BcsEvent(recordedBy: final user) => _localizedUser(strings, user),
      HeatCheckEvent(
        temperatureC: final temperature,
        humidityPercent: final humidity,
        recordedBy: final user,
      ) =>
        '${LocaleFormatters.numberForContext(context, temperature, decimalDigits: 1)}°C · ${LocaleFormatters.numberForContext(context, humidity, decimalDigits: 0)}% · ${_localizedUser(strings, user)}',
      IdentityChangeEvent(
        field: final field,
        oldValue: final oldValue,
        newValue: final newValue,
      ) =>
        strings.identityChangeDetail(
          HealthLabels.identityField(strings, field),
          LocaleFormatters.textForContext(context, oldValue),
          LocaleFormatters.textForContext(context, newValue),
        ),
      HealthObservationEvent(recordedBy: final user) =>
        _localizedUser(strings, user),
      AnimalActionEvent(recordedBy: final user) => _localizedUser(
        strings,
        user,
      ),
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.circle, size: 11, color: AppColors.secondary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        '${LocaleFormatters.dateForContext(context, event.occurredAt)} · $details',
      ),
    );
  }

  String _heatRiskLabel(AppLocalizations strings, String risk) =>
      switch (risk) {
        'safe' => strings.heatRiskSafe,
        'alert' => strings.heatRiskAlert,
        'danger' => strings.heatRiskDanger,
        'emergency' => strings.heatRiskEmergency,
        _ => risk,
      };

  String _symptomSummary(AppLocalizations strings, List<String> ids) =>
      ids.map((id) => HealthLabels.symptom(strings, id)).join(' + ');

  static String _localizedAction(
    BuildContext context,
    AppLocalizations strings,
    String action,
  ) {
    if (action.startsWith('Mating · ')) {
      return '${strings.matingAction} · ${strings.ramKarakul(LocaleFormatters.textForContext(context, 'R12'))}';
    }
    if (action.startsWith('Vaccination · ')) {
      return '${strings.vaccinationAction} · ${action.substring('Vaccination · '.length)}';
    }
    if (action.startsWith('Pregnancy ')) {
      final status = switch (action.substring('Pregnancy '.length)) {
        'confirmed' => strings.confirmed,
        'open' => strings.pregnancyOpen,
        'aborted' => strings.pregnancyAborted,
        final value => value,
      };
      return '${strings.pregnancyAction} · $status';
    }
    return switch (action) {
      'Vaccination' => strings.vaccinationAction,
      'Deworming' => strings.dewormingAction,
      'Dipping' => strings.dippingAction,
      'Hoof trim' => strings.hoofTrimAction,
      'Shearing' => strings.shearingAction,
      'Weight' => strings.weightAction,
      'BCS' => strings.bcsAction,
      'Heat check' => strings.heatCheckAction,
      'Feed / Water' => strings.feedWaterAction,
      'Mating' => strings.matingAction,
      'Pregnancy' => strings.pregnancyAction,
      'Lambing' => strings.lambingAction,
      'Photo' => strings.photoAction,
      'Voice note' => strings.voiceNoteAction,
      'Note' => strings.noteAction,
      _ => action,
    };
  }
}

String _localizedUser(AppLocalizations strings, String user) => switch (user) {
  'Ahmed' => strings.userAhmed,
  'Sara' => strings.userSara,
  _ => user,
};

class _SimpleEvent extends StatelessWidget {
  const _SimpleEvent({
    required this.date,
    required this.title,
    required this.details,
  });
  final String date;
  final String title;
  final String details;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.circle, size: 11, color: AppColors.secondary),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text('$date\n$details'),
  );
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth < 340 ? 1 : 2;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisExtent: 96,
        ),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                items[index].$1,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 3),
              Text(
                items[index].$2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _WeightPainter extends CustomPainter {
  const _WeightPainter({required this.color, required this.grid});
  final Color color;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var row = 1; row < 4; row++) {
      canvas.drawLine(
        Offset(0, size.height * row / 4),
        Offset(size.width, size.height * row / 4),
        gridPaint,
      );
    }
    final path = Path()
      ..moveTo(0, size.height * .78)
      ..cubicTo(
        size.width * .14,
        size.height * .7,
        size.width * .2,
        size.height * .76,
        size.width * .34,
        size.height * .57,
      )
      ..cubicTo(
        size.width * .46,
        size.height * .68,
        size.width * .55,
        size.height * .43,
        size.width * .68,
        size.height * .48,
      )
      ..cubicTo(
        size.width * .8,
        size.height * .34,
        size.width * .88,
        size.height * .4,
        size.width,
        size.height * .17,
      );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WeightPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.grid != grid;
}
