import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme_extension.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/quick_log/data/care_providers.dart';
import '../../../features/sheep/data/sheep_providers.dart';
import '../../../features/sheep/domain/sheep_record.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/eid_providers.dart';
import '../domain/eid_readiness.dart';

class EidPage extends ConsumerWidget {
  const EidPage({super.key});

  static final DateTime _nextEidDate = DateTime(2027, 5, 17);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepRecordsProvider);
    final care = ref.watch(careProvider);
    final criteria = ref.watch(eidCriteriaProvider);
    final candidates = [
      for (final animal in sheep)
        EidReadinessCalculator.calculate(
          sheep: animal,
          effectiveHealthStatus: animal.status,
          events: care.events,
          withdrawal: care.withdrawalFor(animal.id),
          criteria: criteria,
        ),
    ]..sort(_compareReadiness);
    final readyCount = candidates.where((item) => item.clearForSale).length;
    final daysRemaining = _nextEidDate
        .difference(DateTime.now())
        .inDays
        .clamp(0, 9999);

    return ListView(
      key: const Key('eid-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          strings.eidMode,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.eidCountdown,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                strings.daysToEid(
                  LocaleFormatters.numberForContext(context, daysRemaining),
                ),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                strings.estimatedEidDate(
                  LocaleFormatters.dateForContext(context, _nextEidDate),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(strings.eidDateDisclaimer),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: Text(
                strings.eidCandidates,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              strings.readyCandidates(
                LocaleFormatters.numberForContext(context, readyCount),
                LocaleFormatters.numberForContext(context, candidates.length),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final candidate in candidates)
          _CandidateTile(candidate: candidate, criteria: criteria),
      ],
    );
  }

  static int _compareReadiness(EidReadiness a, EidReadiness b) {
    if (a.clearForSale != b.clearForSale) return a.clearForSale ? -1 : 1;
    return a.sheep.tagNumber.compareTo(b.sheep.tagNumber);
  }
}

class _CandidateTile extends StatelessWidget {
  const _CandidateTile({required this.candidate, required this.criteria});

  final EidReadiness candidate;
  final EidCriteria criteria;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final isReady = candidate.clearForSale;
    final statusColors = Theme.of(context).extension<AppStatusColors>()!;
    final statusColor = isReady
        ? statusColors.healthy
        : candidate.status == EidReadinessStatus.withdrawal
        ? statusColors.withdrawal
        : statusColors.attention;
    final status = _statusLabel(strings, candidate.status);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.12),
                  child: Icon(Icons.pets_outlined, color: statusColor),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${LocaleFormatters.textForContext(context, candidate.sheep.tagNumber)} · ${_breed(strings, candidate.sheep.breed)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${_sex(strings, candidate.sheep.sex)} · ${_group(strings, candidate.sheep.groupName)}',
                      ),
                    ],
                  ),
                ),
                Icon(
                  isReady ? Icons.check_circle_outline : Icons.info_outline,
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                _Metric(
                  label: strings.weight,
                  value:
                      '${LocaleFormatters.numberForContext(context, candidate.weightKg, decimalDigits: 1)} kg',
                ),
                _Metric(
                  label: strings.bcs,
                  value: LocaleFormatters.numberForContext(
                    context,
                    candidate.bcs,
                    decimalDigits: 1,
                  ),
                ),
                _Metric(
                  label: strings.health,
                  value: _health(strings, candidate),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                isReady ? strings.clearForSale : strings.notClearForSale,
                style: Theme.of(context).textTheme.titleSmall
                    ?.copyWith(color: statusColor, fontWeight: FontWeight.w800),
              ),
            ),
            if (!isReady) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(status),
            ],
            if (candidate.withdrawal.notClearForSale) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.withdrawalClearance(
                  LocaleFormatters.dateForContext(
                    context,
                    candidate.withdrawal.meatClearanceDate!,
                  ),
                ),
              ),
            ],
            if (candidate.status != EidReadinessStatus.withdrawal &&
                candidate.status != EidReadinessStatus.ready)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  strings.eidCriteriaSummary(
                    LocaleFormatters.numberForContext(
                      context,
                      criteria.minimumWeightKg,
                      decimalDigits: 0,
                    ),
                    LocaleFormatters.numberForContext(
                      context,
                      criteria.minimumBcs,
                      decimalDigits: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _statusLabel(
    AppLocalizations strings,
    EidReadinessStatus status,
  ) => switch (status) {
    EidReadinessStatus.ready => strings.eidStatusReady,
    EidReadinessStatus.underweight => strings.eidStatusUnderweight,
    EidReadinessStatus.lowBcs => strings.eidStatusLowBcs,
    EidReadinessStatus.highBcs => strings.eidStatusHighBcs,
    EidReadinessStatus.healthConcern => strings.eidStatusHealth,
    EidReadinessStatus.withdrawal => strings.eidStatusWithdrawal,
  };

  static String _health(AppLocalizations strings, EidReadiness candidate) =>
      candidate.status == EidReadinessStatus.healthConcern
      ? strings.eidHealthConcern
      : strings.eidHealthClear;

  static String _breed(AppLocalizations strings, String breed) =>
      switch (breed.toLowerCase()) {
        'awassi' => strings.breedAwassi,
        'najdi' => strings.breedNajdi,
        'naimi' => strings.breedNaimi,
        'suffolk' => strings.breedSuffolk,
        _ => breed,
      };

  static String _sex(AppLocalizations strings, SheepSex sex) => switch (sex) {
    SheepSex.ewe => strings.sexEwe,
    SheepSex.ram => strings.sexRam,
    SheepSex.lamb => strings.sexLamb,
  };

  static String _group(AppLocalizations strings, String group) =>
      switch (group) {
        'Pregnant Ewes' => strings.pregnantEwes,
        'Dry Ewes' => strings.dryEwes,
        'Rams' => strings.rams,
        'Lambs · Group B' => strings.lambsGroupB,
        'North Flock' => strings.flockName,
        _ => group,
      };
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelMedium),
      Text(value, style: Theme.of(context).textTheme.titleSmall),
    ],
  );
}
