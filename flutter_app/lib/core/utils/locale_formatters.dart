import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../app/app_settings.dart';

class LocalePreferences extends InheritedWidget {
  const LocalePreferences({
    required this.numerals,
    required this.calendar,
    required super.child,
    super.key,
  });

  final NumeralSystem numerals;
  final CalendarSystem calendar;

  static LocalePreferences of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocalePreferences>() ??
      const LocalePreferences(
        numerals: NumeralSystem.western,
        calendar: CalendarSystem.gregorian,
        child: SizedBox.shrink(),
      );

  @override
  bool updateShouldNotify(LocalePreferences oldWidget) =>
      numerals != oldWidget.numerals || calendar != oldWidget.calendar;
}

abstract final class LocaleFormatters {
  static String dateForContext(BuildContext context, DateTime value) {
    final preferences = LocalePreferences.of(context);
    return date(
      value,
      locale: Localizations.localeOf(context),
      numerals: preferences.numerals,
      calendar: preferences.calendar,
    );
  }

  static String numberForContext(
    BuildContext context,
    num value, {
    int? decimalDigits,
  }) {
    final preferences = LocalePreferences.of(context);
    return number(
      value,
      locale: Localizations.localeOf(context),
      numerals: preferences.numerals,
      decimalDigits: decimalDigits,
    );
  }

  static String textForContext(BuildContext context, String value) =>
      digits(value, LocalePreferences.of(context).numerals);

  static String number(
    num value, {
    required Locale locale,
    required NumeralSystem numerals,
    int? decimalDigits,
  }) {
    final pattern = decimalDigits == null
        ? NumberFormat.decimalPattern(locale.toLanguageTag())
        : NumberFormat.decimalPatternDigits(
            locale: locale.toLanguageTag(),
            decimalDigits: decimalDigits,
          );
    return digits(pattern.format(value), numerals);
  }

  static String digits(String value, NumeralSystem numerals) {
    if (numerals == NumeralSystem.western) return value;
    const western = '0123456789';
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    return value.split('').map((character) {
      final index = western.indexOf(character);
      if (index >= 0) return arabicIndic[index];
      if (character == '.') return '٫';
      if (character == ',') return '٬';
      return character;
    }).join();
  }

  static String text(String value, NumeralSystem numerals) =>
      digits(value, numerals);

  static String westernizeDigits(String value) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    const easternArabicIndic = '۰۱۲۳۴۵۶۷۸۹';
    const western = '0123456789';
    return value.split('').map((character) {
      final arabicIndex = arabicIndic.indexOf(character);
      if (arabicIndex >= 0) return western[arabicIndex];
      final easternIndex = easternArabicIndic.indexOf(character);
      if (easternIndex >= 0) return western[easternIndex];
      if (character == '٫') return '.';
      if (character == '٬' || character == '،') return ',';
      return character;
    }).join();
  }

  static num? parseNumber(String value) {
    final western = westernizeDigits(value)
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim();
    return num.tryParse(western);
  }

  static String date(
    DateTime value, {
    required Locale locale,
    required NumeralSystem numerals,
    required CalendarSystem calendar,
  }) {
    final formatted = calendar == CalendarSystem.gregorian
        ? DateFormat.yMMMd(locale.toLanguageTag()).format(value)
        : _hijriDate(value, locale.languageCode);
    return digits(formatted, numerals);
  }

  static String _hijriDate(DateTime value, String languageCode) {
    final (day, month, year) = _gregorianToIslamic(value);
    final monthName = languageCode == 'ar'
        ? _arabicMonths[month - 1]
        : _englishMonths[month - 1];
    if (languageCode == 'ar') {
      return '$day $monthName $year هـ';
    }
    return '$day $monthName $year AH';
  }

  static (int, int, int) _gregorianToIslamic(DateTime date) {
    final julianDay = _gregorianToJulianDay(date.year, date.month, date.day);
    var days = julianDay - 1948440 + 10632;
    final cycle = ((days - 1) / 10631).floor();
    days = days - 10631 * cycle + 354;
    final yearPart =
        (((10985 - days) / 5316).floor() * ((50 * days / 17719).floor())) +
        ((days / 5670).floor() * ((43 * days / 15238).floor()));
    days =
        days -
        (((30 - yearPart) / 15).floor() * ((17719 * yearPart / 50).floor())) -
        ((yearPart / 16).floor() * ((15238 * yearPart / 43).floor())) +
        29;
    final month = (24 * days / 709).floor();
    final day = days - (709 * month / 24).floor();
    final year = 30 * cycle + yearPart - 30;
    return (day, month, year);
  }

  static int _gregorianToJulianDay(int year, int month, int day) {
    final a = ((14 - month) / 12).floor();
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        ((153 * m + 2) / 5).floor() +
        365 * y +
        (y / 4).floor() -
        (y / 100).floor() +
        (y / 400).floor() -
        32045;
  }

  static const _englishMonths = [
    'Muharram',
    'Safar',
    'Rabi I',
    'Rabi II',
    'Jumada I',
    'Jumada II',
    'Rajab',
    'Sha’ban',
    'Ramadan',
    'Shawwal',
    'Dhu al-Qi’dah',
    'Dhu al-Hijjah',
  ];

  static const _arabicMonths = [
    'محرّم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوّال',
    'ذو القعدة',
    'ذو الحجة',
  ];
}
