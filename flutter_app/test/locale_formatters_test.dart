import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:herd_hub_sheep/app/app_settings.dart';
import 'package:herd_hub_sheep/core/utils/locale_formatters.dart';

void main() {
  setUpAll(initializeDateFormatting);

  test('formats Western and Arabic-Indic numerals consistently', () {
    expect(
      LocaleFormatters.number(
        43,
        locale: const Locale('ar'),
        numerals: NumeralSystem.western,
        decimalDigits: 0,
      ),
      '43',
    );
    expect(
      LocaleFormatters.number(
        62.4,
        locale: const Locale('ar'),
        numerals: NumeralSystem.arabicIndic,
        decimalDigits: 1,
      ),
      '٦٢٫٤',
    );
    expect(LocaleFormatters.parseNumber('٦٢٫٤'), 62.4);
    expect(LocaleFormatters.parseNumber('۱۲٫۴'), 12.4);
  });

  test(
    'formats Gregorian and Hijri dates while preserving date-only storage',
    () {
      final date = DateTime.utc(2026, 9, 30);
      expect(
        LocaleFormatters.date(
          date,
          locale: const Locale('en'),
          numerals: NumeralSystem.western,
          calendar: CalendarSystem.gregorian,
        ),
        'Sep 30, 2026',
      );
      expect(
        LocaleFormatters.date(
          date,
          locale: const Locale('ar'),
          numerals: NumeralSystem.arabicIndic,
          calendar: CalendarSystem.hijri,
        ),
        '١٧ ربيع الآخر ١٤٤٨ هـ',
      );
    },
  );
}
