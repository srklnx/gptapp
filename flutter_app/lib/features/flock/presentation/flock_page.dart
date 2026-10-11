import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/sheep/data/sheep_providers.dart';
import '../../../features/sheep/domain/sheep_record.dart';
import '../../../features/quick_log/data/care_providers.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/flock_filter.dart';
import 'sheep_card.dart';

class FlockPage extends ConsumerStatefulWidget {
  const FlockPage({super.key});

  @override
  ConsumerState<FlockPage> createState() => _FlockPageState();
}

class _FlockPageState extends ConsumerState<FlockPage> {
  final TextEditingController _searchController = TextEditingController();
  FlockFilter _filter = FlockFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context);
    final sheep = ref.watch(sheepRecordsProvider);
    final care = ref.watch(careProvider);
    final filtered = filterSheep(
      sheep,
      query: LocaleFormatters.westernizeDigits(_searchController.text),
      filter: _filter,
      sheepInWithdrawal: care.sheepInWithdrawal,
    );
    return CustomScrollView(
      key: const Key('flock-page'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            0,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.flock,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            s.flockName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.mutedText),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      key: const Key('scan-tag'),
                      tooltip: s.scanTag,
                      onPressed: () => _showMessage(s.scanTag),
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    FilledButton.icon(
                      key: const Key('add-sheep'),
                      onPressed: _addSheep,
                      icon: const Icon(Icons.add),
                      label: Text(s.addSheep),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  key: const Key('flock-search'),
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: s.searchSheep,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            key: const Key('clear-flock-search'),
                            tooltip: MaterialLocalizations.of(context)
                                .deleteButtonTooltip,
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close),
                          ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final filter in _mainFilters)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: AppSpacing.sm,
                          ),
                          child: ChoiceChip(
                            label: Text(_filterLabel(s, filter)),
                            selected: _filter == filter,
                            onSelected: (_) => setState(() => _filter = filter),
                          ),
                        ),
                    ],
                  ),
                ),
                AppSectionTitle(s.savedViews),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _SavedView(
                      label: s.dueVaccination,
                      icon: Icons.vaccines_outlined,
                      selected: _filter == FlockFilter.dueVaccination,
                      onTap: () => _setFilter(FlockFilter.dueVaccination),
                    ),
                    _SavedView(
                      label: s.dueDeworming,
                      icon: Icons.pest_control_outlined,
                      selected: _filter == FlockFilter.dueDeworming,
                      onTap: () => _setFilter(FlockFilter.dueDeworming),
                    ),
                    _SavedView(
                      label: s.withdrawalView,
                      icon: Icons.hourglass_bottom,
                      selected: _filter == FlockFilter.withdrawal,
                      onTap: () => _setFilter(FlockFilter.withdrawal),
                    ),
                    _SavedView(
                      label: s.lowBcs,
                      icon: Icons.monitor_weight_outlined,
                      selected: _filter == FlockFilter.lowBcs,
                      onTap: () => _setFilter(FlockFilter.lowBcs),
                    ),
                    _SavedView(
                      label: s.pregnantView,
                      icon: Icons.favorite_outline,
                      selected: _filter == FlockFilter.pregnant,
                      onTap: () => _setFilter(FlockFilter.pregnant),
                    ),
                    _SavedView(
                      label: s.eidCandidates,
                      icon: Icons.verified_outlined,
                      selected: _filter == FlockFilter.eidCandidates,
                      onTap: () => _setFilter(FlockFilter.eidCandidates),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  key: const Key('open-groups'),
                  onPressed: () => context.push(groupsRoute),
                  icon: const Icon(Icons.groups_outlined),
                  label: Text(s.openGroups),
                ),
                AppSectionTitle(
                  s.allSheep,
                  trailing:
                      '${LocaleFormatters.numberForContext(context, filtered.length)} / ${LocaleFormatters.numberForContext(context, sheep.length)}',
                ),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: _EmptyResults(
                      title: s.noSheepFound,
                      details: s.tryAnotherSearch,
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (filtered.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            sliver: SliverList.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final animal = filtered[index];
                return SheepCard(
                  sheep: animal,
                  status: care.statusFor(animal),
                  withdrawalDays: care.withdrawalDaysFor(animal.id),
                );
              },
            ),
          ),
      ],
    );
  }

  static const _mainFilters = [
    FlockFilter.all,
    FlockFilter.ewes,
    FlockFilter.rams,
    FlockFilter.lambs,
    FlockFilter.pregnant,
    FlockFilter.sick,
    FlockFilter.withdrawal,
    FlockFilter.dueToday,
  ];

  String _filterLabel(AppLocalizations s, FlockFilter filter) =>
      switch (filter) {
        FlockFilter.all => s.all,
        FlockFilter.ewes => s.ewes,
        FlockFilter.rams => s.rams,
        FlockFilter.lambs => s.lambs,
        FlockFilter.pregnant => s.pregnantView,
        FlockFilter.sick => s.sick,
        FlockFilter.withdrawal => s.withdrawal,
        FlockFilter.dueToday => s.dueToday,
        FlockFilter.dueVaccination => s.dueVaccination,
        FlockFilter.dueDeworming => s.dueDeworming,
        FlockFilter.lowBcs => s.lowBcs,
        FlockFilter.eidCandidates => s.eidCandidates,
      };

  void _setFilter(FlockFilter filter) => setState(() => _filter = filter);

  Future<void> _addSheep() async {
    final animal = await showModalBottomSheet<SheepRecord>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _AddSheepSheet(),
    );
    if (!mounted || animal == null) return;

    try {
      ref.read(sheepDirectoryControllerProvider.notifier).add(animal);
    } on StateError {
      _showMessage(AppLocalizations.of(context).duplicateTagError);
      return;
    }
    _searchController.clear();
    setState(() => _filter = FlockFilter.all);
    context.push('$flockRoute/sheep/${animal.id}');
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

class _AddSheepSheet extends ConsumerStatefulWidget {
  const _AddSheepSheet();

  @override
  ConsumerState<_AddSheepSheet> createState() => _AddSheepSheetState();
}

class _AddSheepSheetState extends ConsumerState<_AddSheepSheet> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  final _weightController = TextEditingController();
  final _bcsController = TextEditingController(text: '3.0');
  late final TextEditingController _groupController;
  late final TextEditingController _locationController;
  String? _breed;
  SheepSex _sex = SheepSex.ewe;

  @override
  void initState() {
    super.initState();
    _groupController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _tagController.dispose();
    _weightController.dispose();
    _bcsController.dispose();
    _groupController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    _groupController.text = _groupController.text.isEmpty
        ? strings.defaultGroup
        : _groupController.text;
    _locationController.text = _locationController.text.isEmpty
        ? strings.defaultLocation
        : _locationController.text;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                strings.addSheepTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('new-sheep-tag'),
                controller: _tagController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: strings.tag,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final tag = value?.trim() ?? '';
                  if (tag.isEmpty) return strings.requiredField;
                  final exists = ref
                      .read(sheepRecordsProvider)
                      .any((sheep) => sheep.tagNumber == tag);
                  return exists ? strings.duplicateTagError : null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                key: const Key('new-sheep-breed'),
                initialValue: _breed,
                decoration: InputDecoration(
                  labelText: strings.breed,
                  border: const OutlineInputBorder(),
                ),
                hint: Text(strings.selectBreed),
                items: [
                  DropdownMenuItem(
                    value: 'Awassi',
                    child: Text(strings.breedAwassi),
                  ),
                  DropdownMenuItem(
                    value: 'Najdi',
                    child: Text(strings.breedNajdi),
                  ),
                  DropdownMenuItem(
                    value: 'Naimi',
                    child: Text(strings.breedNaimi),
                  ),
                  DropdownMenuItem(
                    value: 'Suffolk',
                    child: Text(strings.breedSuffolk),
                  ),
                ],
                onChanged: (value) => setState(() => _breed = value),
                validator: (value) =>
                    value == null ? strings.requiredField : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<SheepSex>(
                key: const Key('new-sheep-sex'),
                initialValue: _sex,
                decoration: InputDecoration(
                  labelText: strings.sex,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: SheepSex.ewe,
                    child: Text(strings.sexEwe),
                  ),
                  DropdownMenuItem(
                    value: SheepSex.ram,
                    child: Text(strings.sexRam),
                  ),
                  DropdownMenuItem(
                    value: SheepSex.lamb,
                    child: Text(strings.sexLamb),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sex = value);
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                key: const Key('new-sheep-weight'),
                controller: _weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: '${strings.weight} (kg)',
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final weight = LocaleFormatters.parseNumber(value ?? '');
                  return weight == null || weight <= 0
                      ? strings.invalidWeight
                      : null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                key: const Key('new-sheep-bcs'),
                controller: _bcsController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: strings.bcs,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  final bcs = LocaleFormatters.parseNumber(value ?? '');
                  return bcs == null || bcs < 1 || bcs > 5
                      ? strings.invalidBcs
                      : null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                key: const Key('new-sheep-group'),
                controller: _groupController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: strings.group,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                key: const Key('new-sheep-location'),
                controller: _locationController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: strings.location,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                key: const Key('save-new-sheep'),
                onPressed: _save,
                child: Text(strings.saveSheep),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(strings.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _breed == null) return;
    final tag = LocaleFormatters.westernizeDigits(_tagController.text.trim());
    final weight = LocaleFormatters.parseNumber(_weightController.text)!
        .toDouble();
    final bcs = LocaleFormatters.parseNumber(_bcsController.text)!.toDouble();
    final now = DateTime.now();
    Navigator.of(context).pop(
      SheepRecord(
        id: tag,
        tagNumber: tag,
        breed: _breed!,
        sex: _sex,
        weightKg: weight,
        bcs: bcs,
        status: SheepHealthStatus.healthy,
        nextRoutine: 'Healthy · no routine due',
        groupName: _groupController.text.trim(),
        birthDate: now.subtract(const Duration(days: 365)),
        location: _locationController.text.trim(),
        activities: const [],
      ),
    );
  }
}

class _SavedView extends StatelessWidget {
  const _SavedView({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 17),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      backgroundColor: selected
          ? Theme.of(context).colorScheme.secondaryContainer
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
    ),
  );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.title, required this.details});
  final String title;
  final String details;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.xl),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(AppRadii.lg),
    ),
    child: Column(
      children: [
        const Icon(Icons.search_off, size: 32),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          details,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
