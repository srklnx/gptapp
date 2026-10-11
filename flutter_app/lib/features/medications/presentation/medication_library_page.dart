import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../health/presentation/health_labels.dart';
import '../../quick_log/data/care_providers.dart';
import '../../quick_log/domain/care_records.dart';
import '../domain/medication_search.dart';

/// Searchable medication library. Selecting a medication continues to the
/// treatment form, carrying the originating sheep and observation.
class MedicationLibraryPage extends ConsumerStatefulWidget {
  const MedicationLibraryPage({this.sheepId, this.observationId, super.key});

  final String? sheepId;
  final String? observationId;

  @override
  ConsumerState<MedicationLibraryPage> createState() =>
      _MedicationLibraryPageState();
}

class _MedicationLibraryPageState extends ConsumerState<MedicationLibraryPage> {
  final TextEditingController _search = TextEditingController();
  MedicationCategory? _category;
  TreatmentRoute? _route;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final medications = ref.watch(careProvider).medications;
    final results = MedicationSearchService.search(
      medications,
      query: _search.text,
      category: _category,
      route: _route,
    );
    return ListView(
      key: const Key('medication-library-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          strings.medicationLibrary,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          strings.treatmentOptionsDisclaimer,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('medication-search'),
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: strings.searchMedication,
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final category in MedicationCategory.values)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                  child: ChoiceChip(
                    label: Text(HealthLabels.medicationCategory(strings, category)),
                    selected: _category == category,
                    onSelected: (selected) => setState(
                      () => _category = selected ? category : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final medication in results)
          _MedicationCard(
            medication: medication,
            strings: strings,
            onSelect: () => _select(medication),
          ),
      ],
    );
  }

  void _select(MedicationRecord medication) {
    final sheepId = widget.sheepId;
    final observationId = widget.observationId;
    final query = [
      if (sheepId != null) 'sheepId=$sheepId',
      if (observationId != null) 'observationId=$observationId',
      'medicationId=${medication.id}',
    ].join('&');
    context.go('$treatmentEntryRoute?$query');
  }
}

class _MedicationCard extends StatelessWidget {
  const _MedicationCard({
    required this.medication,
    required this.strings,
    required this.onSelect,
  });

  final MedicationRecord medication;
  final AppLocalizations strings;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final routes = medication.routeOptions
        .map((route) => HealthLabels.route(strings, route))
        .join(' · ');
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        title: Text(medication.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medication.activeIngredient),
            Text(
              '${HealthLabels.medicationCategory(strings, medication.category)} · $routes',
            ),
            Text(
              '${strings.meatWithdrawal}: ${strings.days(medication.meatWithdrawalDays)} · '
              '${strings.milkWithdrawal}: ${strings.days(medication.milkWithdrawalDays)}',
            ),
          ],
        ),
        trailing: FilledButton(onPressed: onSelect, child: Text(strings.select)),
      ),
    );
  }
}
