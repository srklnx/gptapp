import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/app_settings.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/sheep/data/sheep_providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/care_providers.dart';
import '../domain/care_records.dart';

class TreatmentEntryPage extends ConsumerStatefulWidget {
  const TreatmentEntryPage({
    required this.initialSheepId,
    this.initialMedicationId,
    this.observationId,
    super.key,
  });

  final String? initialSheepId;
  final String? initialMedicationId;
  final String? observationId;

  @override
  ConsumerState<TreatmentEntryPage> createState() => _TreatmentEntryPageState();
}

class _TreatmentEntryPageState extends ConsumerState<TreatmentEntryPage> {
  late String _sheepId = widget.initialSheepId ?? '184';
  String? _medicationId;
  String _reason = 'health_observation';
  DateTime _administeredAt = DateTime.now();
  final TextEditingController _doseController = TextEditingController(
    text: '10',
  );
  final TextEditingController _notesController = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _medicationId = widget.initialMedicationId;
  }

  @override
  void dispose() {
    _doseController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepRecordsProvider);
    final care = ref.watch(careProvider);
    final animal = sheep.firstWhere(
      (record) => record.id == _sheepId,
      orElse: () => sheep.first,
    );
    _sheepId = animal.id;
    final medicationId =
        care.medications.any((medication) => medication.id == _medicationId)
        ? _medicationId!
        : care.medications.first.id;
    _medicationId = medicationId;
    final medication = care.medications.firstWhere(
      (record) => record.id == medicationId,
    );
    final clearance = care.clearanceDatesFor(medication, _administeredAt);

    if (_saved) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 64, color: Colors.green),
              const SizedBox(height: AppSpacing.md),
              Text(
                ref.read(appSettingsProvider).isOnline
                    ? strings.treatmentRecorded
                    : strings.savedLocallyWaiting,
                key: const Key('treatment-confirmation'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (medication.followUpAfterDays != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(strings.followUpCreated),
              ],
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      key: const Key('treatment-entry-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          strings.recordTreatmentFor(animal.tagNumber),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          key: const Key('treatment-sheep'),
          initialValue: _sheepId,
          decoration: InputDecoration(
            labelText: strings.selectSheep,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final record in sheep)
              DropdownMenuItem(
                value: record.id,
                child: Text(
                  '#${LocaleFormatters.textForContext(context, record.tagNumber)} · ${record.breed}',
                ),
              ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => _sheepId = value);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          key: const Key('treatment-medication'),
          initialValue: medicationId,
          decoration: InputDecoration(
            labelText: strings.selectMedication,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final item in care.medications)
              DropdownMenuItem(value: item.id, child: Text(item.name)),
          ],
          onChanged: (value) => setState(() => _medicationId = value),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          key: const Key('treatment-reason'),
          initialValue: _reason,
          decoration: InputDecoration(
            labelText: strings.reasonForTreatment,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: 'health_observation',
              child: Text(strings.treatmentReasonHealthObservation),
            ),
            DropdownMenuItem(
              value: 'confirmed_diagnosis',
              child: Text(strings.treatmentReasonConfirmedDiagnosis),
            ),
            DropdownMenuItem(
              value: 'preventive',
              child: Text(strings.treatmentReasonPreventive),
            ),
            DropdownMenuItem(
              value: 'vaccination',
              child: Text(strings.treatmentReasonVaccination),
            ),
            DropdownMenuItem(
              value: 'routine_parasite',
              child: Text(strings.treatmentReasonRoutineParasite),
            ),
            DropdownMenuItem(
              value: 'other',
              child: Text(strings.treatmentReasonOther),
            ),
          ],
          onChanged: (value) => setState(() => _reason = value ?? _reason),
        ),
        const SizedBox(height: AppSpacing.md),
        TextFormField(
          key: const Key('treatment-dose'),
          controller: _doseController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${strings.dose} (${medication.doseUnit})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        InputDecorator(
          decoration: InputDecoration(
            labelText: strings.route,
            border: const OutlineInputBorder(),
          ),
          child: Text(_routeLabel(strings, medication.route)),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          key: const Key('treatment-date'),
          onPressed: _chooseDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(
            '${strings.date} · ${LocaleFormatters.dateForContext(context, _administeredAt)}',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('treatment-notes'),
          controller: _notesController,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: strings.notes,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.treatmentWithdrawalNotice,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${strings.meatWithdrawal}: ${strings.days(medication.meatWithdrawalDays)}',
                ),
                Text(
                  '${strings.milkWithdrawal}: ${strings.days(medication.milkWithdrawalDays)}',
                ),
                Text(
                  '${strings.clearance}: ${LocaleFormatters.dateForContext(context, clearance.meat)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            key: const Key('save-treatment'),
            onPressed: () => _save(medication),
            icon: const Icon(Icons.save_outlined),
            label: Text(strings.saveTreatment),
          ),
        ),
      ],
    );
  }

  Future<void> _chooseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _administeredAt,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date != null && mounted) {
      setState(
        () => _administeredAt = DateTime(
          date.year,
          date.month,
          date.day,
          _administeredAt.hour,
          _administeredAt.minute,
        ),
      );
    }
  }

  void _save(MedicationRecord medication) {
    final dose = LocaleFormatters.parseNumber(_doseController.text)?.toDouble();
    if (dose == null || !dose.isFinite || dose <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).invalidDose)),
      );
      return;
    }
    ref
        .read(careProvider.notifier)
        .recordTreatment(
          sheepId: _sheepId,
          medication: medication,
          dose: dose,
          administeredAt: _administeredAt,
          administeredBy: 'Ahmed',
          notes: _notesController.text.trim(),
          observationId: widget.observationId,
          treatmentReason: _reason,
        );
    setState(() => _saved = true);
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
