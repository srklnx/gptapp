import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../health/domain/famacha.dart';
import '../../sheep/data/sheep_providers.dart';
import '../data/parasite_providers.dart';
import '../domain/parasite_records.dart';
import '../domain/parasite_service.dart';
import 'parasite_labels.dart';

class ParasiteManagementScreen extends ConsumerWidget {
  const ParasiteManagementScreen({required this.sheepId, super.key});

  final String sheepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepByIdProvider(sheepId));
    final parasites = ref.watch(parasiteProvider);
    final famacha = [...parasites.famachaFor(sheepId)]
      ..sort((a, b) => b.date.compareTo(a.date));
    final dewormings = [...parasites.dewormingsFor(sheepId)]
      ..sort((a, b) => b.administeredAt.compareTo(a.administeredAt));
    final fecalTests = parasites.fecalTests
        .where((t) => t.sheepId == sheepId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    final lastFamacha = famacha.isEmpty ? null : famacha.first;
    final lastDeworming = dewormings.isEmpty ? null : dewormings.first;
    final risk = ParasiteRiskService.assess(
      famachaScore: lastFamacha?.score,
      recentFecalTest: fecalTests.isNotEmpty,
      lastDewormingAt: lastDeworming?.administeredAt,
    );

    return ListView(
      key: const Key('parasite-management-screen'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.parasiteManagement, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '#${LocaleFormatters.textForContext(context, sheep?.tagNumber ?? sheepId)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        _StatusCard(strings: strings, lastFamacha: lastFamacha, lastDeworming: lastDeworming, risk: risk),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                key: const Key('parasite-deworm'),
                onPressed: () => context.push('$dewormingRoute?sheepId=$sheepId'),
                icon: const Icon(Icons.medication_outlined),
                label: Text(strings.deworm),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('parasite-famacha'),
                onPressed: () => context.push('$famachaEntryRoute?sheepId=$sheepId'),
                icon: const Icon(Icons.visibility_outlined),
                label: Text(strings.famacha),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('parasite-fecal-test'),
                onPressed: () => context.push('$fecalTestEntryRoute?sheepId=$sheepId'),
                icon: const Icon(Icons.biotech_outlined),
                label: Text(strings.fecalTest),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('parasite-observation'),
                onPressed: () => context.push('$healthObservationRoute?sheepId=$sheepId'),
                icon: const Icon(Icons.pets_outlined),
                label: Text(strings.parasiteObservation),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(strings.famachaTrend, style: Theme.of(context).textTheme.titleMedium),
        if (famacha.isEmpty)
          _EmptyState(
            title: strings.noFamachaRecorded,
            detail: strings.noFamachaDetail,
            onAction: () => context.push('$famachaEntryRoute?sheepId=$sheepId'),
            actionLabel: strings.recordFamacha,
          )
        else ...[
          for (final record in famacha.take(6))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${LocaleFormatters.numberForContext(context, record.score)} — ${LocaleFormatters.dateForContext(context, record.date)}',
              ),
            ),
          Text(
            ParasiteLabels.trend(strings, FamachaService.trend(famacha)),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(strings.dewormingHistory, style: Theme.of(context).textTheme.titleMedium),
        if (dewormings.isEmpty)
          _EmptyState(
            title: strings.noDewormingRecorded,
            detail: strings.noDewormingDetail,
            onAction: () => context.push('$dewormingRoute?sheepId=$sheepId'),
            actionLabel: strings.recordDeworming,
          )
        else
          for (final record in dewormings.take(6))
            _DewormingTile(strings: strings, record: record),
        const SizedBox(height: AppSpacing.lg),
        Text(strings.lastFecalTest, style: Theme.of(context).textTheme.titleMedium),
        if (fecalTests.isEmpty)
          Text(strings.noFecalTests)
        else
          for (final test in fecalTests.take(6))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(ParasiteLabels.testType(strings, test.testType)),
              subtitle: Text(
                '${ParasiteLabels.resultLevel(strings, test.resultLevel)} · ${LocaleFormatters.dateForContext(context, test.date)}',
              ),
            ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.strings,
    required this.lastFamacha,
    required this.lastDeworming,
    required this.risk,
  });

  final AppLocalizations strings;
  final FamachaRecord? lastFamacha;
  final DewormingRecord? lastDeworming;
  final ParasiteRiskAssessment risk;

  @override
  Widget build(BuildContext context) {
    final color = risk.needsAction
        ? const Color(0xFFA76510)
        : Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${strings.currentParasiteStatus}: ${ParasiteLabels.risk(strings, risk.riskLevel)}',
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (lastFamacha != null)
            Text(
              '${strings.lastFamacha}: ${lastFamacha!.score} · ${LocaleFormatters.dateForContext(context, lastFamacha!.date)}',
            ),
          if (lastDeworming != null)
            Text(
              '${strings.lastDeworming}: ${LocaleFormatters.dateForContext(context, lastDeworming!.administeredAt)}',
            ),
          for (final reason in risk.reasons)
            Text('• ${_riskReason(context, reason)}'),
        ],
      ),
    );
  }

  String _riskReason(BuildContext context, String reason) => switch (reason) {
    'famacha_high' => '${strings.lastFamacha} ${strings.riskHighConcern}',
    'famacha_borderline' => '${strings.lastFamacha} ${strings.riskNeedsAssessment}',
    'bottle_jaw' => strings.bottleJaw,
    'pale_eyelids' => strings.symptomPaleEyelids,
    'weight_loss' => strings.symptomWeightLoss,
    'diarrhea' => strings.symptomDiarrhea,
    'no_recent_fecal_test' => strings.noFecalTests,
    'low_bcs' => strings.riskLowBcs,
    'no_recent_deworming' => strings.noDewormingRecorded,
    'flock_similar_signs' => strings.flockProblemBody,
    _ => reason,
  };
}

class _DewormingTile extends StatelessWidget {
  const _DewormingTile({required this.strings, required this.record});
  final AppLocalizations strings;
  final DewormingRecord record;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Text(
      '${LocaleFormatters.dateForContext(context, record.administeredAt)} · ${record.activeIngredient}',
    ),
    subtitle: Text(
      '${ParasiteLabels.reason(strings, record.reason)} · '
      '${record.responseStatus != null ? ParasiteLabels.response(strings, record.responseStatus!) : ''}',
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.detail,
    required this.onAction,
    required this.actionLabel,
  });

  final String title;
  final String detail;
  final VoidCallback onAction;
  final String actionLabel;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(detail, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    ),
  );
}
