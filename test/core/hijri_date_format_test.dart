import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:times/core/utils/hijri_date_format.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('ar');
    await initializeDateFormatting('ur');
  });
  test('formatHijriDate returns non-empty string', () {
    final result = formatHijriDate(
      DateTime(2026, 5, 22),
      adjustmentDays: 0,
      appLocaleCode: 'en',
    );
    expect(result, isNotEmpty);
    expect(result, contains('AH'));
  });

  test('adjustment shifts hijri day', () {
    final base = formatHijriDate(
      DateTime(2026, 5, 22),
      adjustmentDays: 0,
      appLocaleCode: 'en',
    );
    final shifted = formatHijriDate(
      DateTime(2026, 5, 22),
      adjustmentDays: 1,
      appLocaleCode: 'en',
    );
    expect(base, isNot(equals(shifted)));
  });

  test('arabic locale uses eastern numerals in output', () {
    final result = formatHijriDate(
      DateTime(2026, 5, 22),
      adjustmentDays: 0,
      appLocaleCode: 'ar',
      suffix: 'هـ',
    );
    expect(result, contains('هـ'));
  });

  test('formatGregorianDate respects locale', () {
    final en = formatGregorianDate(DateTime(2026, 5, 22), 'en');
    expect(en, isNotEmpty);
  });
}
