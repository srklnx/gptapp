import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/quick_log/presentation/quick_log_sheet.dart';
import '../l10n/generated/app_localizations.dart';
import 'app_settings.dart';
import 'route_paths.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_extension.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final settingsController = ref.read(appSettingsProvider.notifier);
    final title = _titleFor(location, strings);
    final fieldSettings = Theme.of(context).extension<AppFieldSettings>()!;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final navigationItemHeight = (fieldSettings.minimumTouchTarget * textScale)
        .ceil()
        .clamp(fieldSettings.minimumTouchTarget, 96)
        .toInt();

    return Scaffold(
      appBar: AppBar(
        leading:
            location.startsWith('$flockRoute/sheep/') ||
                location.startsWith('$groupsRoute/') ||
                location == treatmentEntryRoute ||
                location == editSheepRoute ||
                location == weightEntryRoute ||
                location == healthObservationRoute ||
                location == medicationLibraryRoute ||
                location == healthCenterRoute ||
                location == healthCaseListRoute ||
                location == parasiteManagementRoute ||
                location == famachaEntryRoute ||
                location == fecalTestEntryRoute ||
                location == dewormingRoute
            ? IconButton(
                key: const Key('profile-back'),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: () => context.pop(),
                icon: const BackButtonIcon(),
              )
            : null,
        title: Text(title),
        actions: [
          IconButton(
            key: const Key('theme-toggle'),
            tooltip: _themeLabel(settings.themeMode, strings),
            onPressed: settingsController.cycleThemeMode,
            icon: Icon(_themeIcon(settings.themeMode)),
          ),
          TextButton(
            key: const Key('locale-toggle'),
            onPressed: settingsController.toggleLocale,
            child: Text(
              settings.locale.languageCode == 'en'
                  ? strings.arabic
                  : strings.english,
            ),
          ),
        ],
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: SafeArea(
        top: false,
        child: SizedBox(
          height: navigationItemHeight + 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavigationItem(
                key: const Key('nav-home'),
                label: strings.home,
                icon: Icons.home_outlined,
                selected: location == homeRoute,
                itemHeight: navigationItemHeight,
                onPressed: () => context.go(homeRoute),
              ),
              _NavigationItem(
                key: const Key('nav-flock'),
                label: strings.flock,
                icon: Icons.pets_outlined,
                selected:
                    location == flockRoute ||
                    location.startsWith('$flockRoute/sheep/'),
                itemHeight: navigationItemHeight,
                onPressed: () => context.go(flockRoute),
              ),
              _QuickLogItem(
                key: const Key('nav-quick-log'),
                label: strings.quickLog,
                onPressed: () => showQuickLogSheet(
                  context,
                  initialSheepId: _selectedSheepId(location),
                ),
              ),
              _NavigationItem(
                key: const Key('nav-tasks'),
                label: strings.tasks,
                icon: Icons.checklist_outlined,
                selected: location == tasksRoute,
                itemHeight: navigationItemHeight,
                onPressed: () => context.go(tasksRoute),
              ),
              _NavigationItem(
                key: const Key('nav-more'),
                label: strings.more,
                icon: Icons.more_horiz,
                selected: _isMoreSection(location),
                itemHeight: navigationItemHeight,
                onPressed: () => context.go(moreRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _titleFor(String location, AppLocalizations strings) =>
      location.startsWith('$flockRoute/sheep/')
      ? strings.flock
      : location.startsWith('$groupsRoute/')
      ? strings.groups
      : switch (location) {
          homeRoute => strings.home,
          flockRoute => strings.flock,
          tasksRoute => strings.tasks,
          breedingRoute => strings.breeding,
          heatStressRoute => strings.heatStressTitle,
          eidRoute => strings.eidMode,
          moreRoute => strings.more,
          settingsRoute => strings.settings,
          syncRoute => strings.sync,
          treatmentEntryRoute => strings.treatmentAction,
          groupsRoute => strings.groups,
          _ => strings.appTitle,
        };

  static bool _isMoreSection(String location) =>
      location == moreRoute ||
      location == groupsRoute ||
      location.startsWith('$groupsRoute/') ||
      location == settingsRoute ||
      location == syncRoute ||
      location == breedingRoute ||
      location == heatStressRoute ||
      location == eidRoute;

  static IconData _themeIcon(AppThemeMode mode) => switch (mode) {
    AppThemeMode.light => Icons.light_mode_outlined,
    AppThemeMode.dark => Icons.dark_mode_outlined,
    AppThemeMode.sun => Icons.wb_sunny_outlined,
  };

  static String _themeLabel(AppThemeMode mode, AppLocalizations strings) =>
      switch (mode) {
        AppThemeMode.light => strings.lightMode,
        AppThemeMode.dark => strings.darkMode,
        AppThemeMode.sun => strings.sunMode,
      };

  static String? _selectedSheepId(String location) {
    final segments = location.split('/');
    return segments.length == 4 && segments[1] == 'flock'
        ? segments.last
        : null;
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.itemHeight,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final int itemHeight;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: itemHeight.toDouble(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: selected ? colors.primary : null),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? colors.primary : null,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickLogItem extends StatelessWidget {
  const _QuickLogItem({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true,
      label: label,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
