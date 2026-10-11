import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../core/utils/locale_formatters.dart';
import 'app_settings.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class HerdHubApp extends ConsumerWidget {
  const HerdHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final darkMode = settings.themeMode == AppThemeMode.dark;
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => LocalePreferences(
        numerals: settings.numeralSystem,
        calendar: settings.calendarSystem,
        child: child!,
      ),
      theme: AppTheme.fromMode(
        settings.themeMode == AppThemeMode.dark
            ? AppThemeMode.light
            : settings.themeMode,
      ),
      darkTheme: AppTheme.fromMode(AppThemeMode.dark),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
