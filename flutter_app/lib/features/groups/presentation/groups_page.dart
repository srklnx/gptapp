import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../features/flock/presentation/sheep_card.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../data/group_providers.dart';
import '../domain/group_record.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final groups = ref.watch(flockGroupsProvider);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).cardColor,
            child: TabBar(
              tabs: [
                Tab(text: strings.groups),
                Tab(text: strings.savedViewsTitle),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  key: const Key('groups-list'),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: groups.length,
                  itemBuilder: (context, index) =>
                      _GroupCard(group: groups[index]),
                ),
                const _SavedViewsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});
  final FlockGroup group;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final status = switch (group.status) {
      GroupStatus.normal => strings.groupStatusNormal,
      GroupStatus.attention => strings.groupStatusAttention,
      GroupStatus.urgent => strings.groupStatusUrgent,
    };
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        key: Key('group-card-${group.id}'),
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: () => context.push('$groupsRoute/${group.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .secondaryContainer,
                child: const Icon(Icons.pets_outlined),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _localizedGroupName(strings, group.name),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      LocaleFormatters.textForContext(
                        context,
                        strings.groupCount(group.sheepCount),
                      ),
                    ),
                    Text(
                      '${strings.groupLocation}: ${_localizedLocation(strings, group.location)}',
                    ),
                    if (group.currentTask != null)
                      Text(
                        '${strings.groupCurrentTask}: ${_localizedTask(strings, group.currentTask!)}',
                      ),
                    Text('${strings.groupStatus}: $status'),
                  ],
                ),
              ),
              Icon(
                Directionality.of(context) == TextDirection.rtl
                    ? Icons.chevron_left
                    : Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _localizedGroupName(AppLocalizations strings, String name) =>
      switch (name) {
        'Pregnant Ewes' => strings.pregnantEwes,
        'Dry Ewes' => strings.dryEwes,
        'Lambs · Group B' => strings.lambsGroupB,
        'Rams' => strings.rams,
        'North Flock' => strings.flockName,
        _ => name,
      };

  String _localizedLocation(AppLocalizations strings, String location) =>
      switch (location) {
        'North Pasture' => strings.northPasture,
        'South Pasture' => strings.southPasture,
        'East Paddock' => strings.eastPaddock,
        'Lambing Barn' => strings.lambingBarn,
        _ => location,
      };

  String _localizedTask(AppLocalizations strings, String? task) =>
      switch (task) {
        'Vaccinate Pregnant Ewes' => strings.farmTaskVaccinate,
        'Check Water' => strings.taskCheckWater,
        'Weigh Lambs' => strings.taskWeighLambs,
        'BCS Check' => strings.taskBcsCheck,
        _ => task ?? '',
      };
}

class _SavedViewsList extends ConsumerWidget {
  const _SavedViewsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final views = [
      (
        SavedView.withdrawalActive,
        strings.upcomingSavedViewWithdrawal,
        Icons.hourglass_bottom,
      ),
      (
        SavedView.lowBcs,
        strings.upcomingSavedViewLowBcs,
        Icons.monitor_weight_outlined,
      ),
      (
        SavedView.dueVaccination,
        strings.upcomingSavedViewVaccination,
        Icons.vaccines_outlined,
      ),
      (
        SavedView.eidCandidates,
        strings.upcomingSavedViewEid,
        Icons.verified_outlined,
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final view in views)
          Builder(
            builder: (context) {
              final sheep = ref.watch(savedViewSheepProvider(view.$1));
              final care = ref.watch(careProvider);
              return ExpansionTile(
                key: Key('saved-view-${view.$1.name}'),
                leading: Icon(view.$3),
                title: Text(view.$2),
                subtitle: Text(strings.groupCount(sheep.length)),
                children: [
                  if (sheep.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Text(strings.noSheepFound),
                    )
                  else
                    SizedBox(
                      height: (MediaQuery.sizeOf(context).height * .52).clamp(
                        280,
                        460,
                      ),
                      child: ListView.builder(
                        itemCount: sheep.length,
                        itemBuilder: (context, index) {
                          final animal = sheep[index];
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
            },
          ),
      ],
    );
  }
}
