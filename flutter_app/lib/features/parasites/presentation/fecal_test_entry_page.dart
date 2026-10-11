import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/parasite_providers.dart';
import '../domain/parasite_records.dart';
import 'parasite_labels.dart';

class FecalTestEntryPage extends ConsumerStatefulWidget {
  const FecalTestEntryPage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<FecalTestEntryPage> createState() => _FecalTestEntryPageState();
}

class _FecalTestEntryPageState extends ConsumerState<FecalTestEntryPage> {
  FecalTestType _type = FecalTestType.fecalEggCount;
  FecalResultLevel _result = FecalResultLevel.pending;
  final _eggCount = TextEditingController();
  final _parasites = TextEditingController();

  @override
  void dispose() {
    _eggCount.dispose();
    _parasites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ListView(
      key: const Key('fecal-test-entry-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.recordFecalTest, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<FecalTestType>(
          initialValue: _type,
          decoration: InputDecoration(
            labelText: strings.fecalTestType,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final type in FecalTestType.values)
              DropdownMenuItem(
                value: type,
                child: Text(ParasiteLabels.testType(strings, type)),
              ),
          ],
          onChanged: (value) => setState(() => _type = value ?? _type),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('fecal-egg-count'),
          controller: _eggCount,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: strings.fecalEggCount,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<FecalResultLevel>(
          initialValue: _result,
          decoration: InputDecoration(
            labelText: strings.resultLevel,
            border: const OutlineInputBorder(),
          ),
          items: [
            for (final level in FecalResultLevel.values)
              DropdownMenuItem(
                value: level,
                child: Text(ParasiteLabels.resultLevel(strings, level)),
              ),
          ],
          onChanged: (value) => setState(() => _result = value ?? _result),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('fecal-parasites'),
          controller: _parasites,
          decoration: InputDecoration(
            labelText: strings.parasitesDetected,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            key: const Key('save-fecal-test'),
            onPressed: _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(strings.saveRecord),
          ),
        ),
      ],
    );
  }

  void _save() {
    final eggCount = int.tryParse(
      LocaleFormatters.westernizeDigits(_eggCount.text.trim()),
    );
    ref.read(parasiteProvider.notifier).recordFecalTest(
      sheepId: widget.sheepId,
      date: DateTime.now(),
      testType: _type,
      fecalEggCount: eggCount,
      parasitesDetected: _parasites.text.trim().isEmpty
          ? const []
          : _parasites.text.trim().split(','),
      resultLevel: _result,
    );
    if (mounted) context.pop();
  }
}
