import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/route_paths.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme_extension.dart';
import '../../../core/widgets/app_section_title.dart';
import '../../quick_log/data/care_providers.dart';
import '../../sheep/data/sheep_providers.dart';
import '../../sync/data/sync_providers.dart';
import '../../../core/models/entities.dart';
import '../../../core/utils/locale_formatters.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../app/app_settings.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppLocalizations.of(context);
    final care = ref.watch(careProvider);
    final sync = ref.watch(syncCenterProvider);
    final settings = ref.watch(appSettingsProvider);
    final statusColors = Theme.of(context).extension<AppStatusColors>()!;
    final sheep = ref.watch(sheepRecordsProvider);
    final withdrawalIds = care.sheepInWithdrawal.toList();
    final withdrawalTags = withdrawalIds
        .map((id) => sheep.where((animal) => animal.id == id))
        .where((matching) => matching.isNotEmpty)
        .map((matching) => '#${matching.first.tagNumber}')
        .join(', ');
    return ListView(
      key: const Key('home-page'),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: [
        _FarmHeader(strings: s, numerals: settings.numeralSystem),
        _AttentionHeader(
          strings: s,
          sync: sync,
          locale: settings.locale,
          numerals: settings.numeralSystem,
        ),
        AppSectionTitle(s.needsAttention),
        Row(
          children: [
            _CountTile(
              value: LocaleFormatters.digits('3', settings.numeralSystem),
              label: s.urgentCount,
              color: statusColors.urgent,
            ),
            const SizedBox(width: AppSpacing.sm),
            _CountTile(
              value: LocaleFormatters.digits('8', settings.numeralSystem),
              label: s.dueTodayCount,
              color: AppColors.attention,
            ),
            const SizedBox(width: AppSpacing.sm),
            _CountTile(
              value: LocaleFormatters.digits('14', settings.numeralSystem),
              label: s.dueWeekCount,
              color: AppColors.secondary,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _AttentionRow(
          icon: Icons.vaccines_outlined,
          title: s.attentionDueVaccination,
          detail: s.pregnantEwes,
          color: AppColors.urgent,
          onTap: () => context.go(flockRoute),
        ),
        if (withdrawalIds.isNotEmpty)
          _AttentionRow(
            key: const Key('home-withdrawal-alert'),
            icon: Icons.hourglass_bottom,
            title: LocaleFormatters.textForContext(
              context,
              s.withdrawalAlertCount(withdrawalIds.length),
            ),
            detail: LocaleFormatters.textForContext(context, withdrawalTags),
            color: statusColors.withdrawal,
            onTap: () => context.go('$flockRoute/sheep/${withdrawalIds.first}'),
          ),
        _AttentionRow(
          icon: Icons.monitor_weight_outlined,
          title: s.attentionLowBcs,
          detail: s.attention,
          color: statusColors.attention,
          onTap: () => context.go(flockRoute),
        ),
        _AttentionRow(
          icon: Icons.thermostat,
          title: s.attentionHeat,
          detail: s.northPasture,
          color: statusColors.heatRisk,
          onTap: () => context.go(heatStressRoute),
        ),
        AppSectionTitle(
          s.todaysTasks,
          trailing:
              '${LocaleFormatters.digits('12', settings.numeralSystem)}  ·  ${s.tasks}',
          onTap: () => context.go('/tasks'),
        ),
        _TaskRow(
          title: s.farmTaskVaccinate,
          detail: s.pregnantEwes,
          count: LocaleFormatters.digits('47', settings.numeralSystem),
        ),
        _TaskRow(
          title: s.farmTaskCheckWater,
          detail: s.northPasture,
          count: '›',
        ),
        _TaskRow(
          title: s.farmTaskWeighLambs,
          detail: s.groupB,
          count: LocaleFormatters.digits('32', settings.numeralSystem),
        ),
        _TaskRow(
          title: s.farmTaskBcs,
          detail: LocaleFormatters.textForContext(context, s.ewesTwelve),
          count: LocaleFormatters.digits('12', settings.numeralSystem),
        ),
        AppSectionTitle(
          s.flockSnapshot,
          trailing: s.seeAll,
          onTap: () => context.go(flockRoute),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 2.05,
          children: [
            _SnapshotTile(
              value: LocaleFormatters.digits('486', settings.numeralSystem),
              label: s.total,
            ),
            _SnapshotTile(
              value: LocaleFormatters.digits('312', settings.numeralSystem),
              label: s.ewes,
            ),
            _SnapshotTile(
              value: LocaleFormatters.digits('18', settings.numeralSystem),
              label: s.rams,
            ),
            _SnapshotTile(
              value: LocaleFormatters.digits('156', settings.numeralSystem),
              label: s.lambs,
            ),
            _SnapshotTile(
              value: LocaleFormatters.digits('47', settings.numeralSystem),
              label: s.pregnantCount,
            ),
          ],
        ),
        AppSectionTitle(s.heatRiskHigh),
        _HeatCard(strings: s, onTap: () => context.go(heatStressRoute)),
      ],
    );
  }
}

class _FarmHeader extends StatelessWidget {
  const _FarmHeader({required this.strings, required this.numerals});
  final AppLocalizations strings;
  final NumeralSystem numerals;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          child: const Icon(Icons.agriculture, color: Colors.white),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.farmName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                LocaleFormatters.digits(
                  '${strings.flockName} · ${strings.sheepCount}',
                  numerals,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 17,
          backgroundColor: Color(0xFFE3E9DC),
          child: Text(
            strings.farmInitials,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

class _AttentionHeader extends StatelessWidget {
  const _AttentionHeader({
    required this.strings,
    required this.sync,
    required this.locale,
    required this.numerals,
  });
  final AppLocalizations strings;
  final SyncCenterState sync;
  final Locale locale;
  final NumeralSystem numerals;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadii.lg),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFFFFD497),
                  size: 29,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  '${LocaleFormatters.number(43, locale: locale, numerals: numerals, decimalDigits: 0)}°C',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF77451D),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                strings.heatRiskHigh,
                style: const TextStyle(
                  color: Color(0xFFFFD497),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  sync.isOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: const Color(0xFFC4D9B5),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    sync.isOnline
                        ? strings.syncOnlineDescription
                        : strings.offlineSavedDescription,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                LocaleFormatters.textForContext(
                  context,
                  strings.pendingCountValue(sync.count(SyncStatus.pending)),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CountTile extends StatelessWidget {
  const _CountTile({
    required this.value,
    required this.label,
    required this.color,
  });
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.detail,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String detail;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Icon(icon, color: color, size: 19),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  LocaleFormatters.textForContext(context, detail),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left
                : Icons.chevron_right,
            color: AppColors.mutedText,
          ),
        ],
      ),
    ),
  );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.title,
    required this.detail,
    required this.count,
  });
  final String title;
  final String detail;
  final String count;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Icon(
          Icons.check_box_outline_blank,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                LocaleFormatters.textForContext(context, detail),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Text(
          count,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    ),
  );
}

class _SnapshotTile extends StatelessWidget {
  const _SnapshotTile({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(AppRadii.md),
    ),
    child: Row(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}

class _HeatCard extends StatelessWidget {
  const _HeatCard({required this.strings, required this.onTap});
  final AppLocalizations strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      border: Border.all(color: AppColors.attention.withValues(alpha: 0.45)),
      borderRadius: BorderRadius.circular(AppRadii.lg),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  strings.heatRiskHigh,
                  style: const TextStyle(
                    color: AppColors.heatRisk,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${LocaleFormatters.numberForContext(context, 43, decimalDigits: 0)}°C',
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(color: AppColors.heatRisk),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            LocaleFormatters.textForContext(context, strings.humidityReading),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          _Recommendation(icon: Icons.park_outlined, text: strings.moveToShade),
          _Recommendation(
            icon: Icons.water_drop_outlined,
            text: strings.checkWater,
          ),
          _Recommendation(
            icon: Icons.front_hand_outlined,
            text: strings.avoidHandling,
          ),
        ],
      ),
    ),
  );
}

class _Recommendation extends StatelessWidget {
  const _Recommendation({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: AppColors.secondary),
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
