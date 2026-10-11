import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../../quick_log/domain/record_weight.dart';

/// Records a weight (and optionally a BCS score) through the care controller.
class WeightEntryPage extends ConsumerStatefulWidget {
  const WeightEntryPage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<WeightEntryPage> createState() => _WeightEntryPageState();
}

class _WeightEntryPageState extends ConsumerState<WeightEntryPage> {
  final TextEditingController _weight = TextEditingController();
  final TextEditingController _bcs = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  String _method = 'scale';

  @override
  void dispose() {
    _weight.dispose();
    _bcs.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ListView(
      key: const Key('weight-entry-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.recordWeight, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('weight-value'),
          controller: _weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${strings.weight} (${strings.kgUnit})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(strings.method, style: Theme.of(context).textTheme.titleMedium),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: 'scale', label: Text(strings.methodScale)),
            ButtonSegment(value: 'estimated', label: Text(strings.methodEstimated)),
          ],
          selected: {_method},
          onSelectionChanged: (value) => setState(() => _method = value.first),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('weight-bcs'),
          controller: _bcs,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: strings.bcs,
            helperText: '1 – 5',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('weight-notes'),
          controller: _notes,
          minLines: 2,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: strings.notes,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            key: const Key('save-weight'),
            onPressed: () => _save(strings),
            icon: const Icon(Icons.save_outlined),
            label: Text(strings.saveWeight),
          ),
        ),
      ],
    );
  }

  void _save(AppLocalizations strings) {
    final weight = LocaleFormatters.parseNumber(_weight.text)?.toDouble();
    if (weight == null || !weight.isFinite || weight <= 0) {
      _showError(strings.weightInvalid);
      return;
    }
    double? bcs;
    if (_bcs.text.trim().isNotEmpty) {
      bcs = LocaleFormatters.parseNumber(_bcs.text)?.toDouble();
      if (bcs == null || !BcsValidator.isValid(bcs)) {
        _showError(strings.bcsInvalid);
        return;
      }
    }
    ref.read(careProvider.notifier).recordWeight(
      sheepId: widget.sheepId,
      weightKg: weight,
      occurredAt: DateTime.now(),
      recordedBy: 'Ahmed',
      method: _method,
      notes: _notes.text.trim(),
      bcs: bcs,
    );
    if (mounted) context.pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
