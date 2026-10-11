import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/parasite_providers.dart';

class FamachaEntryPage extends ConsumerStatefulWidget {
  const FamachaEntryPage({required this.sheepId, super.key});

  final String sheepId;

  @override
  ConsumerState<FamachaEntryPage> createState() => _FamachaEntryPageState();
}

class _FamachaEntryPageState extends ConsumerState<FamachaEntryPage> {
  int? _score;
  final _weight = TextEditingController();
  final _bcs = TextEditingController();

  @override
  void dispose() {
    _weight.dispose();
    _bcs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return ListView(
      key: const Key('famacha-entry-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(strings.recordFamacha, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.md),
        Text(strings.eyelidColor, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (var score = 1; score <= 5; score++)
              ChoiceChip(
                key: Key('famacha-score-$score'),
                label: Text(LocaleFormatters.numberForContext(context, score)),
                selected: _score == score,
                onSelected: (_) => setState(() => _score = score),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('famacha-weight'),
          controller: _weight,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '${strings.weight} (${strings.kgUnit})',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          key: const Key('famacha-bcs'),
          controller: _bcs,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: strings.bcs,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            key: const Key('save-famacha'),
            onPressed: _score == null ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(strings.saveRecord),
          ),
        ),
      ],
    );
  }

  void _save() {
    ref.read(parasiteProvider.notifier).recordFamacha(
      sheepId: widget.sheepId,
      score: _score!,
      date: DateTime.now(),
      observer: 'Ahmed',
      weightKg: LocaleFormatters.parseNumber(_weight.text)?.toDouble(),
      bcs: LocaleFormatters.parseNumber(_bcs.text)?.toDouble(),
    );
    if (mounted) context.pop();
  }
}
