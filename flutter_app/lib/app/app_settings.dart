import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/app_theme.dart';

enum NumeralSystem { western, arabicIndic }

enum CalendarSystem { gregorian, hijri }

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = AppThemeMode.light,
    this.locale = const Locale('en'),
    this.isOnline = false,
    this.numeralSystem = NumeralSystem.western,
    this.calendarSystem = CalendarSystem.gregorian,
  });

  final AppThemeMode themeMode;
  final Locale locale;
  final bool isOnline;
  final NumeralSystem numeralSystem;
  final CalendarSystem calendarSystem;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    Locale? locale,
    bool? isOnline,
    NumeralSystem? numeralSystem,
    CalendarSystem? calendarSystem,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    isOnline: isOnline ?? this.isOnline,
    numeralSystem: numeralSystem ?? this.numeralSystem,
    calendarSystem: calendarSystem ?? this.calendarSystem,
  );
}

class AppSettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setThemeMode(AppThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void cycleThemeMode() {
    final next = switch (state.themeMode) {
      AppThemeMode.light => AppThemeMode.dark,
      AppThemeMode.dark => AppThemeMode.sun,
      AppThemeMode.sun => AppThemeMode.light,
    };
    setThemeMode(next);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void toggleLocale() {
    setLocale(
      state.locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en'),
    );
  }

  void setOnline(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }

  void toggleConnection() => setOnline(!state.isOnline);

  void setNumeralSystem(NumeralSystem numeralSystem) {
    state = state.copyWith(numeralSystem: numeralSystem);
  }

  void setCalendarSystem(CalendarSystem calendarSystem) {
    state = state.copyWith(calendarSystem: calendarSystem);
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsController, AppSettings>(
      AppSettingsController.new,
    );
