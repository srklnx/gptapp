import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/app_settings.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/sheep/data/sheep_providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/care_providers.dart';

Future<void> showQuickLogSheet(
  BuildContext context, {
  String? initialSheepId,
}) async {
  final router = GoRouter.of(context);
  String? treatmentSheepId;
  String? destination;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => _QuickLogSheet(
      initialSheepId: initialSheepId,
      onTreatmentSelected: (sheepId) => treatmentSheepId = sheepId,
      onNavigate: (path) => destination = path,
    ),
  );
  if (treatmentSheepId != null) {
    router.push('$treatmentEntryRoute?sheepId=$treatmentSheepId');
  } else if (destination != null) {
    router.push(destination!);
  }
}

class _QuickLogSheet extends ConsumerStatefulWidget {
  const _QuickLogSheet({
    this.initialSheepId,
    required this.onTreatmentSelected,
    required this.onNavigate,
  });

  final String? initialSheepId;
  final ValueChanged<String> onTreatmentSelected;
  final ValueChanged<String> onNavigate;

  @override
  ConsumerState<_QuickLogSheet> createState() => _QuickLogSheetState();
}

class _QuickLogSheetState extends ConsumerState<_QuickLogSheet> {
  late String _sheepId = widget.initialSheepId ?? '184';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final sheep = ref.watch(sheepRecordsProvider);
    final selectedSheep = sheep.any((record) => record.id == _sheepId)
        ? _sheepId
        : sheep.first.id;
    _sheepId = selectedSheep;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .88,
      minChildSize: .65,
      maxChildSize: .94,
      builder: (context, scrollController) => ListView(
        key: const Key('quick-log-sheet'),
        controller: scrollController,
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        children: [
          Text(
            strings.whatToRecord,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            key: const Key('quick-log-sheep'),
            initialValue: selectedSheep,
            decoration: InputDecoration(
              labelText: strings.selectSheep,
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final animal in sheep)
                DropdownMenuItem(
                  value: animal.id,
                  child: Text(
                    '#${LocaleFormatters.textForContext(context, animal.tagNumber)} · ${animal.breed}',
                  ),
                ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _sheepId = value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _ActionSection(
            title: strings.healthActions,
            actions: [
              _Action(
                strings.treatmentAction,
                Icons.medication_outlined,
                'Treatment',
              ),
              _Action(
                strings.vaccinationAction,
                Icons.vaccines_outlined,
                'Vaccination',
              ),
              _Action(
                strings.dewormingAction,
                Icons.pest_control_outlined,
                'Deworming',
              ),
              _Action(
                strings.dippingAction,
                Icons.water_drop_outlined,
                'Dipping',
              ),
              _Action(strings.hoofTrimAction, Icons.content_cut, 'Hoof trim'),
              _Action(strings.shearingAction, Icons.content_cut, 'Shearing'),
            ],
            onSelected: _selectAction,
          ),
          _ActionSection(
            title: strings.conditionActions,
            actions: [
              _Action(
                strings.weightAction,
                Icons.monitor_weight_outlined,
                'Weight',
              ),
              _Action(strings.bcsAction, Icons.assessment_outlined, 'BCS'),
              _Action(strings.heatCheckAction, Icons.thermostat, 'Heat check'),
              _Action(
                strings.feedWaterAction,
                Icons.water_outlined,
                'Feed / Water',
              ),
            ],
            onSelected: _selectAction,
          ),
          _ActionSection(
            title: strings.breedingActions,
            actions: [
              _Action(strings.matingAction, Icons.favorite_outline, 'Mating'),
              _Action(
                strings.pregnancyAction,
                Icons.pregnant_woman,
                'Pregnancy',
              ),
              _Action(strings.lambingAction, Icons.child_friendly, 'Lambing'),
            ],
            onSelected: _selectAction,
          ),
          _ActionSection(
            title: strings.parasiteManagement,
            actions: [
              _Action(strings.deworming, Icons.medication_outlined, 'Deworming'),
              _Action(strings.famacha, Icons.visibility_outlined, 'FAMACHA'),
              _Action(strings.fecalTest, Icons.biotech_outlined, 'Fecal test'),
            ],
            onSelected: _selectAction,
          ),
          _ActionSection(
            title: strings.otherActions,
            actions: [
              _Action(
                strings.healthObservation,
                Icons.monitor_heart_outlined,
                'Health Observation',
              ),
              _Action(
                strings.photoAction,
                Icons.photo_camera_outlined,
                'Photo',
              ),
              _Action(strings.voiceNoteAction, Icons.mic_none, 'Voice note'),
              _Action(strings.noteAction, Icons.note_alt_outlined, 'Note'),
            ],
            onSelected: _selectAction,
          ),
        ],
      ),
    );
  }

  void _selectAction(_Action action) {
    if (action.value == 'Treatment') {
      widget.onTreatmentSelected(_sheepId);
      Navigator.of(context).pop();
      return;
    }
    if (action.value == 'Health Observation') {
      widget.onNavigate('$healthObservationRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    if (action.value == 'Deworming') {
      widget.onNavigate('$dewormingRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    if (action.value == 'FAMACHA') {
      widget.onNavigate('$famachaEntryRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    if (action.value == 'Fecal test') {
      widget.onNavigate('$fecalTestEntryRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    if (action.value == 'Weight' || action.value == 'BCS') {
      _showNumericEntry(action);
      return;
    }
    if (action.value == 'Heat check') {
      widget.onNavigate('$heatStressRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    if (const {'Mating', 'Pregnancy', 'Lambing'}.contains(action.value)) {
      widget.onNavigate('$breedingRoute?sheepId=$_sheepId');
      Navigator.of(context).pop();
      return;
    }
    ref
        .read(careProvider.notifier)
        .recordAction(
          sheepId: _sheepId,
          action: action.value,
          occurredAt: DateTime.now(),
          recordedBy: 'Ahmed',
        );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            ref.read(appSettingsProvider).isOnline
                ? AppLocalizations.of(context).recorded
                : AppLocalizations.of(context).savedLocallyWaiting,
          ),
        ),
      );
  }

  Future<void> _showNumericEntry(_Action action) async {
    final strings = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final value = await showDialog<double>(
      context: context,
      builder: (_) => _NumericEntryDialog(
        title: strings.recordAction(action.label),
        label: action.value == 'Weight'
            ? '${strings.value} (kg)'
            : strings.value,
        invalidValueMessage: action.value == 'BCS'
            ? strings.bcsValueHelp
            : strings.invalidValue,
        allowsZero: action.value == 'BCS',
        maximum: action.value == 'BCS' ? 5 : null,
        cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
        saveLabel: strings.saveRecord,
      ),
    );
    if (!mounted || value == null) return;
    ref
        .read(careProvider.notifier)
        .recordAction(
          sheepId: _sheepId,
          action: action.value,
          occurredAt: DateTime.now(),
          recordedBy: 'Ahmed',
          value: value,
        );
    if (mounted) Navigator.of(context).pop();
    if (mounted) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              ref.read(appSettingsProvider).isOnline
                  ? strings.recorded
                  : strings.savedLocallyWaiting,
            ),
          ),
        );
    }
  }
}

class _NumericEntryDialog extends StatefulWidget {
  const _NumericEntryDialog({
    required this.title,
    required this.label,
    required this.invalidValueMessage,
    required this.allowsZero,
    required this.maximum,
    required this.cancelLabel,
    required this.saveLabel,
  });

  final String title;
  final String label;
  final String invalidValueMessage;
  final bool allowsZero;
  final double? maximum;
  final String cancelLabel;
  final String saveLabel;

  @override
  State<_NumericEntryDialog> createState() => _NumericEntryDialogState();
}

class _NumericEntryDialogState extends State<_NumericEntryDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: TextField(
      key: const Key('quick-log-value'),
      controller: _controller,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: _errorText,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(widget.cancelLabel),
      ),
      FilledButton(onPressed: _save, child: Text(widget.saveLabel)),
    ],
  );

  void _save() {
    final value = LocaleFormatters.parseNumber(_controller.text)?.toDouble();
    final valid =
        value != null &&
        value.isFinite &&
        (widget.allowsZero ? value >= 0 : value > 0) &&
        (widget.maximum == null || value <= widget.maximum!);
    if (!valid) {
      setState(() => _errorText = widget.invalidValueMessage);
      return;
    }
    Navigator.pop(context, value);
  }
}

class _Action {
  const _Action(this.label, this.icon, this.value);

  final String label;
  final IconData icon;
  final String value;
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.title,
    required this.actions,
    required this.onSelected,
  });

  final String title;
  final List<_Action> actions;
  final ValueChanged<_Action> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            mainAxisExtent: 84,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return OutlinedButton(
              key: Key('quick-action-${action.value.toLowerCase()}'),
              onPressed: () => onSelected(action),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, size: 22),
                  const SizedBox(height: 5),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}
