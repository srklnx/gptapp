import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../../quick_log/domain/care_records.dart';
import '../../quick_log/domain/withdrawal_calculator.dart';
import '../data/parasite_providers.dart';
import '../domain/parasite_records.dart';
import '../domain/parasite_service.dart';
import 'parasite_labels.dart';

class DewormingFlowPage extends ConsumerStatefulWidget {
  const DewormingFlowPage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<DewormingFlowPage> createState() => _DewormingFlowPageState();
}

class _DewormingFlowPageState extends ConsumerState<DewormingFlowPage> {
  int _step = 0;
  DewormingReason? _reason;
  int? _famacha;
  bool _bottleJaw = false;
  bool _diarrhea = false;
  bool _weightLoss = false;
  bool _paleEyelids = false;
  String? _medicationId;
  final _dose = TextEditingController();
  final _weight = TextEditingController();
  final _notes = TextEditingController();
  bool _saved = false;

  @override
  void dispose() {
    _dose.dispose();
    _weight.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final care = ref.watch(careProvider);
    final medications = care.medications
        .where((m) => m.category == MedicationCategory.antiparasitic)
        .toList();
    final medication = medications.any((m) => m.id == _medicationId)
        ? medications.firstWhere((m) => m.id == _medicationId)
        : (medications.isEmpty ? null : medications.first);

    if (_saved) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            strings.dewormingRecorded,
            key: const Key('deworming-confirmation'),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      );
    }

    return Column(
      key: const Key('deworming-flow-page'),
      children: [
        Expanded(
          child: switch (_step) {
            0 => _reasonStep(context, strings),
            1 => _assessmentStep(context, strings),
            _ => _productStep(context, strings, medication, medications),
          },
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              if (_step > 0)
                OutlinedButton(
                  onPressed: () => setState(() => _step--),
                  child: Text(strings.back),
                ),
              const Spacer(),
              FilledButton(
                key: const Key('deworm-next'),
                onPressed: _canNext
                    ? () {
                        if (_step == 2) {
                          _save(medication!);
                        } else {
                          setState(() => _step++);
                        }
                      }
                    : null,
                child: Text(_step == 2 ? strings.saveTreatment : strings.next),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _canNext => switch (_step) {
    0 => _reason != null,
    1 => true,
    _ => _medicationId != null,
  };

  Widget _reasonStep(BuildContext context, AppLocalizations strings) => ListView(
    padding: const EdgeInsets.all(AppSpacing.lg),
    children: [
      Text(strings.whyDeworming, style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: AppSpacing.md),
      RadioGroup<DewormingReason>(
        groupValue: _reason,
        onChanged: (value) => setState(() => _reason = value),
        child: Column(
          children: [
            for (final reason in DewormingReason.values)
              RadioListTile<DewormingReason>(
                value: reason,
                title: Text(ParasiteLabels.reason(strings, reason)),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _assessmentStep(BuildContext context, AppLocalizations strings) {
    final risk = ParasiteRiskService.assess(
      famachaScore: _famacha,
      bottleJaw: _bottleJaw ? true : null,
      diarrhea: _diarrhea ? true : null,
      weightLoss: _weightLoss ? true : null,
      paleEyelids: _paleEyelids ? true : null,
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.parasiteAssessment, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(strings.famacha, style: Theme.of(context).textTheme.titleMedium),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (var score = 1; score <= 5; score++)
              ChoiceChip(
                key: Key('dew-famacha-$score'),
                label: Text(LocaleFormatters.numberForContext(context, score)),
                selected: _famacha == score,
                onSelected: (_) => setState(() => _famacha = score),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SwitchListTile(title: Text(strings.bottleJaw), value: _bottleJaw, onChanged: (v) => setState(() => _bottleJaw = v)),
        SwitchListTile(title: Text(strings.symptomDiarrhea), value: _diarrhea, onChanged: (v) => setState(() => _diarrhea = v)),
        SwitchListTile(title: Text(strings.symptomWeightLoss), value: _weightLoss, onChanged: (v) => setState(() => _weightLoss = v)),
        SwitchListTile(title: Text(strings.symptomPaleEyelids), value: _paleEyelids, onChanged: (v) => setState(() => _paleEyelids = v)),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${strings.parasiteRisk}: ${ParasiteLabels.risk(strings, risk.riskLevel)}',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              if (risk.needsAction) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(strings.parasiteReviewRecommended),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _productStep(
    BuildContext context,
    AppLocalizations strings,
    MedicationRecord? medication,
    List<MedicationRecord> medications,
  ) {
    if (medication == null) {
      return Center(child: Text(strings.medicationRequiresVerification));
    }
    final clearance = WithdrawalCalculator.clearanceDatesFor(
      medication,
      DateTime.now(),
    );
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.recordDeworming, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          key: const Key('dew-medication'),
          initialValue: medication.id,
          decoration: InputDecoration(
            labelText: strings.selectMedication,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final item in medications)
              DropdownMenuItem(value: item.id, child: Text(item.name)),
          ],
          onChanged: (value) => setState(() => _medicationId = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          medication.labelStatus == LabelStatus.verificationRequired
              ? strings.demoMedication
              : medication.activeIngredient,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('dew-dose'),
          controller: _dose,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${strings.dose} (${medication.doseUnit})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('dew-weight'),
          controller: _weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${strings.weightAtTreatment} (${strings.kgUnit})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('${strings.route}: ${medication.route.name}'),
        Text('${strings.meatWithdrawal}: ${strings.days(medication.meatWithdrawalDays)}'),
        Text(
          '${strings.clearance}: ${LocaleFormatters.dateForContext(context, clearance.meat)}',
        ),
      ],
    );
  }

  void _save(MedicationRecord medication) {
    final dose = LocaleFormatters.parseNumber(_dose.text)?.toDouble();
    if (dose == null || dose <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).invalidDose)),
      );
      return;
    }
    ref.read(parasiteProvider.notifier).recordDeworming(
      sheepId: widget.sheepId,
      reason: _reason!,
      medication: medication,
      dose: dose,
      administeredAt: DateTime.now(),
      administeredBy: 'Ahmed',
      weightAtTreatment: LocaleFormatters.parseNumber(_weight.text)?.toDouble(),
      followUpDate: DateTime.now().add(const Duration(days: 7)),
    );
    setState(() => _saved = true);
  }
}

