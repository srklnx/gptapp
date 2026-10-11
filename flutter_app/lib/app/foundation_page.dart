import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import 'app_settings.dart';
import 'route_paths.dart';
import 'theme/app_spacing.dart';
import 'theme/app_theme.dart';

class FoundationPage extends ConsumerWidget {
  const FoundationPage({required this.routePath, super.key});

  final String routePath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final routeTitle = _routeTitle(strings);
    return Semantics(
      key: Key('route-$routePath'),
      container: true,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Icon(
            _routeIcon(),
            size: 42,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            strings.placeholderTitle(routeTitle),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(strings.placeholderBody),
          if (routePath == moreRoute) ...[
            const SizedBox(height: AppSpacing.xl),
            _RouteButton(
              label: strings.openGroups,
              onPressed: () => context.go(groupsRoute),
            ),
            _RouteButton(
              label: strings.openBreeding,
              onPressed: () => context.go(breedingRoute),
            ),
            _RouteButton(
              label: strings.openSettings,
              onPressed: () => context.go(settingsRoute),
            ),
            _RouteButton(
              label: strings.openSync,
              onPressed: () => context.go(syncRoute),
            ),
            _RouteButton(
              label: strings.openHeatStress,
              onPressed: () => context.go(heatStressRoute),
            ),
            _RouteButton(
              label: strings.openEid,
              onPressed: () => context.go(eidRoute),
            ),
          ],
          if (routePath == settingsRoute) ...[
            Text(
              strings.connectionMode,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _ConnectionSelector(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              strings.selectTheme,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _ThemeSelector(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              strings.selectLanguage,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            _LanguageSelector(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              strings.numeralSystemTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _NumeralSelector(),
            const SizedBox(height: AppSpacing.xl),
            Text(
              strings.calendarSystemTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            const _CalendarSelector(),
          ],
        ],
      ),
    );
  }

  String _routeTitle(AppLocalizations strings) => switch (routePath) {
    homeRoute => strings.home,
    flockRoute => strings.flock,
    tasksRoute => strings.tasks,
    breedingRoute => strings.breeding,
    moreRoute => strings.more,
    settingsRoute => strings.settings,
    syncRoute => strings.sync,
    _ => strings.appTitle,
  };

  IconData _routeIcon() => switch (routePath) {
    homeRoute => Icons.home_outlined,
    flockRoute => Icons.pets_outlined,
    tasksRoute => Icons.checklist_outlined,
    breedingRoute => Icons.favorite_outline,
    moreRoute => Icons.more_horiz,
    settingsRoute => Icons.settings_outlined,
    syncRoute => Icons.sync,
    _ => Icons.agriculture_outlined,
  };
}

class _RouteButton extends StatelessWidget {
  const _RouteButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: OutlinedButton(
      onPressed: onPressed,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(label),
      ),
    ),
  );
}

class _ConnectionSelector extends ConsumerWidget {
  const _ConnectionSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final online = ref.watch(appSettingsProvider).isOnline;
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment(value: false, label: Text(strings.offline)),
        ButtonSegment(value: true, label: Text(strings.online)),
      ],
      selected: {online},
      onSelectionChanged: (selection) =>
          ref.read(appSettingsProvider.notifier).setOnline(selection.first),
    );
  }
}

class _ThemeSelector extends ConsumerWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final selected = ref.watch(appSettingsProvider).themeMode;
    return SegmentedButton<AppThemeMode>(
      segments: [
        ButtonSegment(
          value: AppThemeMode.light,
          label: Text(strings.lightMode),
          icon: const Icon(Icons.light_mode_outlined),
        ),
        ButtonSegment(
          value: AppThemeMode.dark,
          label: Text(strings.darkMode),
          icon: const Icon(Icons.dark_mode_outlined),
        ),
        ButtonSegment(
          value: AppThemeMode.sun,
          label: Text(strings.sunMode),
          icon: const Icon(Icons.wb_sunny_outlined),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) =>
          ref.read(appSettingsProvider.notifier).setThemeMode(selection.first),
    );
  }
}

class _LanguageSelector extends ConsumerWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final selected = ref.watch(appSettingsProvider).locale.languageCode;
    return SegmentedButton<String>(
      segments: [
        ButtonSegment(value: 'en', label: Text(strings.english)),
        ButtonSegment(value: 'ar', label: Text(strings.arabic)),
      ],
      selected: {selected},
      onSelectionChanged: (selection) => ref
          .read(appSettingsProvider.notifier)
          .setLocale(Locale(selection.first)),
    );
  }
}

class _NumeralSelector extends ConsumerWidget {
  const _NumeralSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final selected = ref.watch(appSettingsProvider).numeralSystem;
    return RadioGroup<NumeralSystem>(
      groupValue: selected,
      onChanged: (value) {
        if (value != null) {
          ref.read(appSettingsProvider.notifier).setNumeralSystem(value);
        }
      },
      child: Column(
        children: [
          RadioListTile<NumeralSystem>(
            value: NumeralSystem.western,
            title: Text(strings.westernNumerals),
          ),
          RadioListTile<NumeralSystem>(
            value: NumeralSystem.arabicIndic,
            title: Text(strings.arabicIndicNumerals),
          ),
        ],
      ),
    );
  }
}

class _CalendarSelector extends ConsumerWidget {
  const _CalendarSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final selected = ref.watch(appSettingsProvider).calendarSystem;
    return SegmentedButton<CalendarSystem>(
      segments: [
        ButtonSegment(
          value: CalendarSystem.gregorian,
          label: Text(strings.gregorianCalendar),
        ),
        ButtonSegment(
          value: CalendarSystem.hijri,
          label: Text(strings.hijriCalendar),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) => ref
          .read(appSettingsProvider.notifier)
          .setCalendarSystem(selection.first),
    );
  }
}
