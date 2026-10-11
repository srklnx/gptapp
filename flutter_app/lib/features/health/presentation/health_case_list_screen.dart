import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/health_case_providers.dart';
import '../domain/health_case.dart';
import 'health_center_screen.dart' show healthCaseStatusLabel;

class HealthCaseListScreen extends ConsumerWidget {
  const HealthCaseListScreen({required this.sheepId, super.key});

  final String sheepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final cases = ref.watch(healthCaseProvider).forSheep(sheepId)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));

    if (cases.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(strings.noActiveHealthCases, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(strings.noHealthCasesDetail, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      key: const Key('health-case-list-screen'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: cases.length,
      itemBuilder: (context, index) {
        final healthCase = cases[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ExpansionTile(
            title: Text(
              healthCase.symptoms.isEmpty
                  ? strings.healthCheck
                  : healthCase.symptoms.join(' + '),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              '${healthCaseStatusLabel(strings, healthCase.status)} · ${LocaleFormatters.dateForContext(context, healthCase.startedAt)}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (healthCase.severity != null)
                      Text('${strings.caseSeverity}: ${healthCase.severity}'),
                    if (healthCase.symptoms.isNotEmpty)
                      Text('${strings.caseObservations}: ${healthCase.symptoms.join(', ')}'),
                    const SizedBox(height: AppSpacing.sm),
                    Text(strings.caseStatus, style: Theme.of(context).textTheme.titleSmall),
                    DropdownButton<HealthCaseStatus>(
                      value: healthCase.status,
                      items: [
                        for (final status in HealthCaseStatus.values)
                          DropdownMenuItem(
                            value: status,
                            child: Text(healthCaseStatusLabel(strings, status)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ref
                              .read(healthCaseProvider.notifier)
                              .updateStatus(healthCase.id, value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
