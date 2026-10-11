import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../../sheep/data/sheep_providers.dart';
import '../../sheep/domain/sheep_record.dart';
import '../data/health_case_providers.dart';
import '../domain/health_case.dart';

class HealthCenterScreen extends ConsumerStatefulWidget {
  const HealthCenterScreen({required this.sheepId, super.key});
  final String sheepId;
  @override
  ConsumerState<HealthCenterScreen> createState() => _HealthCenterScreenState();
}

class _HealthCenterScreenState extends ConsumerState<HealthCenterScreen> {
  late String _sheepId = widget.sheepId;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepByIdProvider(_sheepId));
    final care = ref.watch(careProvider);
    final cases = ref.watch(healthCaseProvider).forSheep(_sheepId);
    final openCases = cases
        .where(
          (c) =>
              c.status != HealthCaseStatus.resolved &&
              c.status != HealthCaseStatus.closed,
        )
        .toList();
    final status = sheep == null ? SheepHealthStatus.healthy : care.statusFor(sheep);

    return ListView(
      key: const Key('health-center-screen'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.healthCenter, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String>(
          initialValue: _sheepId,
          decoration: InputDecoration(labelText: strings.changeSheep, border: const OutlineInputBorder()),
          items: [
            for (final animal in ref.watch(sheepRecordsProvider))
              DropdownMenuItem(
                value: animal.id,
                child: Text('#${LocaleFormatters.textForContext(context, animal.tagNumber)}'),
              ),
          ],
          onChanged: (value) => setState(() => _sheepId = value ?? _sheepId),
        ),
        const SizedBox(height: AppSpacing.md),
        _StatusCard(status: status, strings: strings),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                key: const Key('hc-health-check'),
                onPressed: () => context.push('$healthObservationRoute?sheepId=$_sheepId'),
                icon: const Icon(Icons.monitor_heart_outlined),
                label: Text(strings.healthCheck),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('hc-treatment'),
                onPressed: () => context.push('$treatmentEntryRoute?sheepId=$_sheepId'),
                icon: const Icon(Icons.medication_outlined),
                label: Text(strings.treatmentAction),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('hc-deworm'),
                onPressed: () => context.push('$parasiteManagementRoute?sheepId=$_sheepId'),
                icon: const Icon(Icons.pest_control_outlined),
                label: Text(strings.deworming),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('hc-weight'),
                onPressed: () => context.push('$weightEntryRoute?sheepId=$_sheepId'),
                icon: const Icon(Icons.monitor_weight_outlined),
                label: Text(strings.weightBcs),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: Text(strings.healthCases, style: Theme.of(context).textTheme.titleMedium)),
            TextButton(
              key: const Key('hc-view-cases'),
              onPressed: () => context.push('$healthCaseListRoute?sheepId=$_sheepId'),
              child: Text(strings.viewHistory),
            ),
          ],
        ),
        if (openCases.isEmpty)
          _EmptyCase(strings: strings, onAction: () => context.push('$healthObservationRoute?sheepId=$_sheepId'))
        else
          for (final healthCase in openCases.take(4))
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(healthCase.symptoms.isEmpty ? strings.healthCheck : healthCase.symptoms.join(' + ')),
              subtitle: Text(
                '${healthCaseStatusLabel(strings, healthCase.status)} · ${LocaleFormatters.dateForContext(context, healthCase.startedAt)}',
              ),
            ),
      ],
    );
  }
}

String healthCaseStatusLabel(AppLocalizations strings, HealthCaseStatus status) =>
    switch (status) {
      HealthCaseStatus.open => strings.caseOpen,
      HealthCaseStatus.monitoring => strings.caseMonitoring,
      HealthCaseStatus.treatment => strings.caseTreatment,
      HealthCaseStatus.awaitingVetReview => strings.caseAwaitingVet,
      HealthCaseStatus.improving => strings.caseImproving,
      HealthCaseStatus.resolved => strings.caseResolved,
      HealthCaseStatus.chronic => strings.caseChronic,
      HealthCaseStatus.closed => strings.caseClosed,
    };

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.strings});

  final SheepHealthStatus status;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      SheepHealthStatus.urgent => (strings.urgent, Theme.of(context).colorScheme.error, Icons.error),
      SheepHealthStatus.withdrawal => (strings.underWithdrawal, const Color(0xFF99521F), Icons.hourglass_bottom),
      SheepHealthStatus.attention => (strings.attention, const Color(0xFFA76510), Icons.warning_amber),
      SheepHealthStatus.healthy => (strings.stable, Theme.of(context).colorScheme.primary, Icons.check_circle),
    };
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '${strings.currentStatus}: $label',
              style: TextStyle(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCase extends StatelessWidget {
  const _EmptyCase({required this.strings, required this.onAction});

  final AppLocalizations strings;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Card(
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text(strings.noActiveHealthCases, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(strings.noHealthCasesDetail, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: onAction, child: Text(strings.healthCheck)),
        ],
      ),
    ),
  );
}
