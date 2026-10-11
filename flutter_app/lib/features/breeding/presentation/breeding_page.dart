import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/sheep/data/sheep_providers.dart';
import '../../../features/sheep/domain/sheep_record.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/breeding_providers.dart';
import '../domain/breeding_record.dart';

class BreedingPage extends ConsumerWidget {
  const BreedingPage({this.initialSheepId, super.key});

  final String? initialSheepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final records = ref.watch(breedingProvider);
    final sheep = ref.watch(sheepRecordsProvider);
    final upcoming =
        records
            .where(
              (record) =>
                  record.expectedLambingDate != null &&
                  record.expectedLambingDate!.isAfter(DateTime.now()) &&
                  record.pregnancyStatus == PregnancyStatus.confirmed,
            )
            .toList()
          ..sort(
            (a, b) => a.expectedLambingDate!.compareTo(b.expectedLambingDate!),
          );
    final recent = records.where((record) => record.matingDate != null).toList()
      ..sort((a, b) => b.matingDate!.compareTo(a.matingDate!));

    return ListView(
      key: const Key('breeding-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          strings.breedingDashboard,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(strings.breedingDescription),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 54,
          child: FilledButton.icon(
            key: const Key('record-mating'),
            onPressed: () =>
                _recordMating(context, ref, preferredSheepId: initialSheepId),
            icon: const Icon(Icons.favorite_outline),
            label: Text(strings.recordMating),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              key: const Key('record-pregnancy'),
              onPressed: () => _recordPregnancy(
                context,
                ref,
                preferredSheepId: initialSheepId,
              ),
              icon: const Icon(Icons.pregnant_woman),
              label: Text(strings.recordPregnancy),
            ),
            OutlinedButton.icon(
              key: const Key('record-lambing'),
              onPressed: () => _recordLambing(
                context,
                ref,
                preferredSheepId: initialSheepId,
              ),
              icon: const Icon(Icons.child_friendly),
              label: Text(strings.recordLambing),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(title: strings.upcomingLambings, count: upcoming.length),
        if (upcoming.isEmpty)
          Text(strings.noUpcomingLambings)
        else
          for (final record in upcoming)
            _BreedingRecordTile(
              record: record,
              tag: _tag(sheep, record.sheepId),
              title: strings.expectedLambing,
              date: LocaleFormatters.dateForContext(
                context,
                record.expectedLambingDate!,
              ),
              detail: record.ramTag == null
                  ? strings.pregnancyConfirmed
                  : strings.siredBy(
                      LocaleFormatters.textForContext(context, record.ramTag!),
                    ),
              onTap: () => context.push('$flockRoute/sheep/${record.sheepId}'),
            ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(title: strings.recentMatings, count: recent.length),
        if (recent.isEmpty)
          Text(strings.noRecentMatings)
        else
          for (final record in recent)
            _BreedingRecordTile(
              record: record,
              tag: _tag(sheep, record.sheepId),
              title: strings.matingAction,
              date: LocaleFormatters.dateForContext(
                context,
                record.matingDate!,
              ),
              detail: record.ramTag == null
                  ? strings.ramNotRecorded
                  : strings.siredBy(
                      LocaleFormatters.textForContext(context, record.ramTag!),
                    ),
              onTap: () => context.push('$flockRoute/sheep/${record.sheepId}'),
            ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeader(title: strings.pregnantSheep, count: upcoming.length),
        for (final record in upcoming)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(child: Icon(Icons.pets_outlined)),
            title: Text('#${_tag(sheep, record.sheepId)}'),
            subtitle: Text(strings.confirmedPregnancy),
            trailing: Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left
                  : Icons.chevron_right,
            ),
            onTap: () => context.push('$flockRoute/sheep/${record.sheepId}'),
          ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          strings.lambingHistory,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        for (final record in records)
          for (final lambing in record.lambingHistory)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('#${_tag(sheep, record.sheepId)}'),
              subtitle: Text(
                '${LocaleFormatters.dateForContext(context, lambing.date)} · ${strings.lambCount(lambing.lambCount)}',
              ),
            ),
      ],
    );
  }

  static String _tag(List<SheepRecord> sheep, String id) {
    for (final animal in sheep) {
      if (animal.id == id) return animal.tagNumber;
    }
    return id;
  }

  static String _breed(AppLocalizations strings, String breed) =>
      switch (breed.toLowerCase()) {
        'awassi' => strings.breedAwassi,
        'najdi' => strings.breedNajdi,
        'naimi' => strings.breedNaimi,
        'suffolk' => strings.breedSuffolk,
        _ => breed,
      };

  static Future<void> _recordMating(
    BuildContext context,
    WidgetRef ref, {
    String? preferredSheepId,
  }) async {
    final strings = AppLocalizations.of(context);
    final sheep = _ewesOrNotify(context, ref, strings);
    if (sheep.isEmpty) return;
    var ramTag = '';
    var selectedSheepId = sheep.any((animal) => animal.id == preferredSheepId)
        ? preferredSheepId!
        : sheep.first.id;
    final input = await showDialog<(String, String)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(strings.recordMating),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedSheepId,
                decoration: InputDecoration(labelText: strings.selectSheep),
                items: [
                  for (final animal in sheep)
                    DropdownMenuItem(
                      value: animal.id,
                      child: Text(
                        '#${animal.tagNumber} · ${_breed(AppLocalizations.of(context), animal.breed)}',
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedSheepId = value);
                },
              ),
              TextField(
                onChanged: (value) => ramTag = value,
                decoration: InputDecoration(labelText: strings.ramTag),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, (
                selectedSheepId,
                ramTag.trim(),
              )),
              child: Text(strings.saveRecord),
            ),
          ],
        ),
      ),
    );
    if (input == null || !context.mounted) return;
    if (input.$2.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.ramRequired)));
      return;
    }
    ref
        .read(breedingProvider.notifier)
        .recordMating(
          sheepId: input.$1,
          matingDate: DateTime.now(),
          ramTag: input.$2,
        );
  }

  static Future<void> _recordPregnancy(
    BuildContext context,
    WidgetRef ref, {
    String? preferredSheepId,
  }) async {
    final strings = AppLocalizations.of(context);
    final sheep = _ewesOrNotify(context, ref, strings);
    if (sheep.isEmpty) return;
    var selectedSheepId = sheep.any((animal) => animal.id == preferredSheepId)
        ? preferredSheepId!
        : sheep.first.id;
    var status = PregnancyStatus.confirmed;
    final input = await showDialog<(String, PregnancyStatus)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(strings.recordPregnancy),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedSheepId,
                decoration: InputDecoration(labelText: strings.selectSheep),
                items: [
                  for (final animal in sheep)
                    DropdownMenuItem(
                      value: animal.id,
                      child: Text(
                        '#${animal.tagNumber} · ${_breed(strings, animal.breed)}',
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedSheepId = value);
                },
              ),
              DropdownButtonFormField<PregnancyStatus>(
                initialValue: status,
                decoration: InputDecoration(labelText: strings.pregnancyStatus),
                items: [
                  DropdownMenuItem(
                    value: PregnancyStatus.confirmed,
                    child: Text(strings.confirmed),
                  ),
                  DropdownMenuItem(
                    value: PregnancyStatus.open,
                    child: Text(strings.pregnancyOpen),
                  ),
                  DropdownMenuItem(
                    value: PregnancyStatus.aborted,
                    child: Text(strings.pregnancyAborted),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => status = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, (selectedSheepId, status)),
              child: Text(strings.saveRecord),
            ),
          ],
        ),
      ),
    );
    if (input == null || !context.mounted) return;
    ref.read(breedingProvider.notifier).updatePregnancy(input.$1, input.$2);
  }

  static Future<void> _recordLambing(
    BuildContext context,
    WidgetRef ref, {
    String? preferredSheepId,
  }) async {
    final strings = AppLocalizations.of(context);
    final sheep = _ewesOrNotify(context, ref, strings);
    if (sheep.isEmpty) return;
    var countText = '1';
    var selectedSheepId = sheep.any((animal) => animal.id == preferredSheepId)
        ? preferredSheepId!
        : sheep.first.id;
    final input = await showDialog<(String, int)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(strings.recordLambing),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: selectedSheepId,
                decoration: InputDecoration(labelText: strings.selectSheep),
                items: [
                  for (final animal in sheep)
                    DropdownMenuItem(
                      value: animal.id,
                      child: Text(
                        '#${animal.tagNumber} · ${_breed(strings, animal.breed)}',
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => selectedSheepId = value);
                },
              ),
              TextField(
                onChanged: (value) => countText = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: strings.lambCountLabel),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton(
              onPressed: () {
                final count = int.tryParse(
                  LocaleFormatters.westernizeDigits(countText),
                );
                if (count == null || count < 1) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(strings.invalidValue)));
                  return;
                }
                Navigator.pop(dialogContext, (selectedSheepId, count));
              },
              child: Text(strings.saveRecord),
            ),
          ],
        ),
      ),
    );
    if (input == null || !context.mounted) return;
    ref
        .read(breedingProvider.notifier)
        .recordLambing(
          sheepId: input.$1,
          date: DateTime.now(),
          lambCount: input.$2,
        );
  }

  static List<SheepRecord> _ewesOrNotify(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations strings,
  ) {
    final sheep = ref
        .read(sheepRecordsProvider)
        .where((animal) => animal.sex == SheepSex.ewe)
        .toList();
    if (sheep.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(strings.noEwesAvailable)));
    }
    return sheep;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        Text(LocaleFormatters.numberForContext(context, count)),
      ],
    ),
  );
}

class _BreedingRecordTile extends StatelessWidget {
  const _BreedingRecordTile({
    required this.record,
    required this.tag,
    required this.title,
    required this.date,
    required this.detail,
    required this.onTap,
  });

  final BreedingRecord record;
  final String tag;
  final String title;
  final String date;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: ListTile(
      onTap: onTap,
      leading: const CircleAvatar(child: Icon(Icons.pets_outlined)),
      title: Text('#${LocaleFormatters.textForContext(context, tag)} · $title'),
      subtitle: Text('$date · $detail'),
      trailing: Icon(
        Directionality.of(context) == TextDirection.rtl
            ? Icons.chevron_left
            : Icons.chevron_right,
      ),
    ),
  );
}
