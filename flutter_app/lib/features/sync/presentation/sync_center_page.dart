import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/app_settings.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/models/entities.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/sync_providers.dart';

class SyncCenterPage extends ConsumerStatefulWidget {
  const SyncCenterPage({super.key});

  @override
  ConsumerState<SyncCenterPage> createState() => _SyncCenterPageState();
}

class _SyncCenterPageState extends ConsumerState<SyncCenterPage> {
  SyncStatus? _filter = SyncStatus.pending;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final state = ref.watch(syncCenterProvider);
    final controller = ref.read(syncCenterProvider.notifier);
    final statuses = SyncStatus.values;
    final items = state.items
        .where((item) => _filter == null || item.status == _filter)
        .toList();

    final header = <Widget>[
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    state.isOnline ? Icons.cloud_done : Icons.cloud_off,
                    color: state.isOnline
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      state.isOnline ? strings.online : strings.offline,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                state.isOnline
                    ? strings.syncOnlineDescription
                    : strings.offlineSavedDescription,
              ),
              if (state.count(SyncStatus.syncing) > 0) ...[
                const SizedBox(height: AppSpacing.md),
                Semantics(
                  label: strings.syncInProgress,
                  child: const LinearProgressIndicator(),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(strings.syncInProgress),
              ],
              const SizedBox(height: AppSpacing.md),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(value: true, label: Text(strings.online)),
                  ButtonSegment(value: false, label: Text(strings.offline)),
                ],
                selected: {state.isOnline},
                onSelectionChanged: (selected) => ref
                    .read(appSettingsProvider.notifier)
                    .setOnline(selected.first),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  key: const Key('sync-now'),
                  onPressed:
                      state.isOnline &&
                          state.count(SyncStatus.pending) > 0 &&
                          state.count(SyncStatus.syncing) == 0
                      ? controller.syncNow
                      : null,
                  icon: const Icon(Icons.sync),
                  label: Text(strings.syncNow),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final status in statuses)
            _StatusCount(
              label: _statusLabel(strings, status),
              count: state.count(status),
              color: _statusColor(context, status),
            ),
        ],
      ),
      const SizedBox(height: AppSpacing.lg),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _filterChip(strings.all, null, state.items.length),
            for (final status in statuses)
              _filterChip(
                _statusLabel(strings, status),
                status,
                state.count(status),
              ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.md),
    ];
    return ListView.builder(
      key: const Key('sync-center-page'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: header.length + items.length + (items.isEmpty ? 2 : 1),
      itemBuilder: (context, index) {
        if (index < header.length) return header[index];
        final queueIndex = index - header.length;
        if (queueIndex < items.length) {
          final item = items[queueIndex];
          return _QueueItemCard(
            item: item,
            statusLabel: LocaleFormatters.textForContext(
              context,
              _statusLabel(strings, item.status),
            ),
            timestamp:
                '${LocaleFormatters.dateForContext(context, item.createdAt)} · '
                '${LocaleFormatters.textForContext(context, DateFormat.jm(Localizations.localeOf(context).toLanguageTag()).format(item.createdAt))}',
            onRetry: () => controller.retry(item.id),
            onReview: () => _reviewConflict(item, controller, strings),
            onDismiss: () => controller.dismiss(item.id),
          );
        }
        if (items.isEmpty && queueIndex == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Center(child: Text(strings.syncQueueEmpty)),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.sm),
          child: Text(
            '${strings.schemaVersion} ${state.cursor.schemaVersion}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, SyncStatus? status, int count) => Padding(
    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
    child: ChoiceChip(
      label: Text(
        '${LocaleFormatters.textForContext(context, label)} · ${LocaleFormatters.numberForContext(context, count)}',
      ),
      selected: _filter == status,
      onSelected: (_) => setState(() => _filter = status),
    ),
  );

  Future<void> _reviewConflict(
    SyncQueueItem item,
    SyncCenterController controller,
    AppLocalizations strings,
  ) async {
    final review = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.conflictReview),
        content: Text(strings.criticalConflictDescription(item.entityType)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.keepLocalAndRetry),
          ),
        ],
      ),
    );
    if (review == true) {
      controller.reviewConflict(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.conflictQueuedForReview)),
        );
      }
    }
  }
}

class _StatusCount extends StatelessWidget {
  const _StatusCount({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) => Chip(
    avatar: CircleAvatar(backgroundColor: color, radius: 5),
    label: Text('${LocaleFormatters.numberForContext(context, count)} $label'),
    visualDensity: VisualDensity.standard,
  );
}

class _QueueItemCard extends StatelessWidget {
  const _QueueItemCard({
    required this.item,
    required this.statusLabel,
    required this.timestamp,
    required this.onRetry,
    required this.onReview,
    required this.onDismiss,
  });

  final SyncQueueItem item;
  final String statusLabel;
  final String timestamp;
  final VoidCallback onRetry;
  final VoidCallback onReview;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    final color = _statusColor(context, item.status);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_statusIcon(item.status), color: color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    _localizedEntityType(strings, item.entityType),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(statusLabel, style: TextStyle(color: color)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${_operationLabel(strings, item.operation)} · ${item.entityId}',
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(timestamp, style: Theme.of(context).textTheme.bodySmall),
            if (item.retryCount > 0) Text(strings.retryCount(item.retryCount)),
            if (item.status == SyncStatus.failed ||
                item.status == SyncStatus.conflict ||
                item.status == SyncStatus.synced) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  if (item.status == SyncStatus.failed)
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(strings.retry),
                    ),
                  if (item.status == SyncStatus.conflict)
                    TextButton.icon(
                      onPressed: onReview,
                      icon: const Icon(Icons.rule),
                      label: Text(strings.review),
                    ),
                  if (item.status == SyncStatus.failed ||
                      item.status == SyncStatus.synced)
                    TextButton(
                      onPressed: onDismiss,
                      child: Text(strings.dismiss),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _statusLabel(AppLocalizations strings, SyncStatus status) =>
    switch (status) {
      SyncStatus.pending => strings.pendingStatus,
      SyncStatus.syncing => strings.syncingStatus,
      SyncStatus.synced => strings.syncedStatus,
      SyncStatus.failed => strings.failedStatus,
      SyncStatus.conflict => strings.conflictStatus,
    };

String _operationLabel(AppLocalizations strings, SyncOperation operation) =>
    switch (operation) {
      SyncOperation.create => strings.createOperation,
      SyncOperation.update => strings.updateOperation,
      SyncOperation.delete => strings.deleteOperation,
    };

String _localizedEntityType(AppLocalizations strings, String entityType) =>
    switch (entityType) {
      'Treatment' => strings.treatmentAction,
      'Task' => strings.tasks,
      'Event' => strings.eventLabel,
      'Weight' => strings.weight,
      'BCS' => strings.bcs,
      'Breeding' => strings.breeding,
      'Sheep' => strings.sheepEntity,
      _ => entityType,
    };

IconData _statusIcon(SyncStatus status) => switch (status) {
  SyncStatus.pending => Icons.schedule,
  SyncStatus.syncing => Icons.sync,
  SyncStatus.synced => Icons.check_circle_outline,
  SyncStatus.failed => Icons.error_outline,
  SyncStatus.conflict => Icons.warning_amber,
};

Color _statusColor(BuildContext context, SyncStatus status) {
  final scheme = Theme.of(context).colorScheme;
  return switch (status) {
    SyncStatus.pending => scheme.secondary,
    SyncStatus.syncing => scheme.primary,
    SyncStatus.synced => scheme.primary,
    SyncStatus.failed => scheme.error,
    SyncStatus.conflict => scheme.tertiary,
  };
}
