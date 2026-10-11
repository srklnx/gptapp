import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme_extension.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../quick_log/data/care_providers.dart';
import '../../sheep/domain/sheep_record.dart';
import '../../tasks/domain/bulk_action.dart';
import '../../tasks/domain/farm_task.dart';
import '../../tasks/presentation/task_card.dart';
import '../data/group_providers.dart';
import '../domain/group_record.dart';

class GroupDetailPage extends ConsumerWidget {
  const GroupDetailPage({required this.groupId, super.key});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final group = ref.watch(flockGroupByIdProvider(groupId));
    if (group == null) {
      return Center(child: Text(strings.groupNotFound));
    }
    final care = ref.watch(careProvider);
    final groupTasks =
        care.farmTasks.where((task) => task.targetGroupId == group.id).toList()
          ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    final header = <Widget>[
      Text(
        _localizedGroupName(strings, group.name),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        LocaleFormatters.textForContext(
          context,
          strings.groupCount(group.sheepCount),
        ),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: AppSpacing.xs),
      Text(
        '${strings.groupLocation}: ${_localizedLocation(strings, group.location)}',
      ),
      const SizedBox(height: AppSpacing.md),
      _GroupStatus(group: group),
      const SizedBox(height: AppSpacing.lg),
      SizedBox(
        height: 56,
        child: FilledButton.icon(
          key: const Key('open-bulk-action'),
          onPressed: () => _openBulkAction(context, ref, group, groupTasks),
          icon: const Icon(Icons.playlist_add_check),
          label: Text(strings.bulkAction),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Text(strings.taskToday, style: Theme.of(context).textTheme.titleLarge),
      if (groupTasks.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(strings.taskEmpty),
        )
      else
        for (final task in groupTasks) FarmTaskCard(task: task),
      const SizedBox(height: AppSpacing.sm),
      Text(strings.allSheep, style: Theme.of(context).textTheme.titleLarge),
    ];
    return ListView.builder(
      key: Key('group-detail-${group.id}'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: header.length + group.sheep.length,
      itemBuilder: (context, index) {
        if (index < header.length) return header[index];
        final animal = group.sheep[index - header.length];
        final status = care.statusFor(animal);
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.pets_outlined)),
          title: Text(
            '#${LocaleFormatters.textForContext(context, animal.tagNumber)} · ${_localizedBreed(strings, animal.breed)}',
          ),
          subtitle: Text(
            '${LocaleFormatters.numberForContext(context, animal.weightKg, decimalDigits: 1)} kg · ${strings.bcs} ${LocaleFormatters.numberForContext(context, animal.bcs, decimalDigits: 1)}',
          ),
          trailing: Icon(
            _statusIcon(status),
            color: _statusColor(context, status),
          ),
        );
      },
    );
  }

  String _localizedBreed(AppLocalizations strings, String breed) =>
      switch (breed) {
        'Awassi' => strings.breedAwassi,
        'Najdi' => strings.breedNajdi,
        'Naimi' => strings.breedNaimi,
        'Suffolk' => strings.breedSuffolk,
        _ => breed,
      };

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

  Future<void> _openBulkAction(
    BuildContext context,
    WidgetRef ref,
    FlockGroup group,
    List<FarmTask> tasks,
  ) async {
    final result = await showModalBottomSheet<BulkActionResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => _BulkActionSheet(group: group, tasks: tasks),
    );
    if (result == null || !context.mounted) return;
    final strings = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(strings.bulkActionSaved(result.events.length)),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: strings.undo,
            onPressed: () {
              try {
                ref
                    .read(careProvider.notifier)
                    .undoBulkAction(result.undoReceipt);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(strings.bulkActionUndone)),
                  );
              } on StateError {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(strings.bulkActionFailed)),
                  );
              }
            },
          ),
        ),
      );
  }

  static IconData _statusIcon(SheepHealthStatus status) => switch (status) {
    SheepHealthStatus.healthy => Icons.check_circle_outline,
    SheepHealthStatus.attention => Icons.error_outline,
    SheepHealthStatus.urgent => Icons.warning_amber_rounded,
    SheepHealthStatus.withdrawal => Icons.hourglass_bottom,
  };

  Color _statusColor(BuildContext context, SheepHealthStatus status) {
    final colors = Theme.of(context).extension<AppStatusColors>()!;
    return switch (status) {
      SheepHealthStatus.healthy => colors.healthy,
      SheepHealthStatus.attention => colors.attention,
      SheepHealthStatus.urgent => colors.urgent,
      SheepHealthStatus.withdrawal => colors.withdrawal,
    };
  }
}

class _GroupStatus extends StatelessWidget {
  const _GroupStatus({required this.group});
  final FlockGroup group;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final text = switch (group.status) {
      GroupStatus.normal => strings.groupStatusNormal,
      GroupStatus.attention => strings.groupStatusAttention,
      GroupStatus.urgent => strings.groupStatusUrgent,
    };
    final palette = Theme.of(context).extension<AppStatusColors>()!;
    final color = switch (group.status) {
      GroupStatus.normal => palette.healthy,
      GroupStatus.attention => palette.attention,
      GroupStatus.urgent => palette.urgent,
    };
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        border: Border.all(color: color.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text('${strings.groupStatus}: $text'),
    );
  }
}

class _BulkActionSheet extends ConsumerStatefulWidget {
  const _BulkActionSheet({required this.group, required this.tasks});

  final FlockGroup group;
  final List<FarmTask> tasks;

  @override
  ConsumerState<_BulkActionSheet> createState() => _BulkActionSheetState();
}

class _BulkActionSheetState extends ConsumerState<_BulkActionSheet> {
  String _selectedAction = 'Vaccination';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final actions = [
      ('Vaccination', strings.bulkVaccination, Icons.vaccines_outlined),
      ('Deworming', strings.bulkDeworming, Icons.pest_control_outlined),
      ('Dipping', strings.dippingAction, Icons.water_drop_outlined),
      ('Hoof trim', strings.hoofTrimAction, Icons.content_cut),
    ];
    FarmTask? task;
    for (final record in widget.tasks) {
      if (record.action == _selectedAction &&
          (record.status == FarmTaskStatus.pending ||
              record.status == FarmTaskStatus.inProgress) &&
          record.sheepIds.toSet().containsAll(widget.group.sheepIds) &&
          widget.group.sheepIds.toSet().containsAll(record.sheepIds)) {
        task = record;
        break;
      }
    }
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            strings.chooseBulkAction,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          RadioGroup<String>(
            groupValue: _selectedAction,
            onChanged: (value) {
              if (value != null) setState(() => _selectedAction = value);
            },
            child: Column(
              children: [
                for (final action in actions)
                  RadioListTile<String>(
                    key: Key('bulk-action-${action.$1.toLowerCase()}'),
                    value: action.$1,
                    secondary: Icon(action.$3),
                    title: Text(action.$2),
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: AppSpacing.xs,
                  ),
              ],
            ),
          ),
          const Divider(),
          Text(
            strings.sheepSelected(widget.group.sheepCount),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 56,
            child: FilledButton(
              key: const Key('confirm-bulk-action'),
              onPressed: () {
                final result = ref
                    .read(careProvider.notifier)
                    .performBulkAction(
                      groupId: widget.group.id,
                      sheepIds: widget.group.sheepIds,
                      action: _selectedAction,
                      task: task,
                      occurredAt: DateTime.now(),
                      recordedBy: 'Ahmed',
                    );
                Navigator.of(context).pop(result);
              },
              child: Text(
                _selectedAction == 'Vaccination'
                    ? strings.vaccinateCount(widget.group.sheepCount)
                    : strings.completeActionCount(
                        actionLabel(strings, _selectedAction),
                        widget.group.sheepCount,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String actionLabel(AppLocalizations strings, String action) =>
      switch (action) {
        'Vaccination' => strings.bulkVaccination,
        'Deworming' => strings.bulkDeworming,
        'Dipping' => strings.dippingAction,
        'Hoof trim' => strings.hoofTrimAction,
        _ => action,
      };
}
