import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

/// Maps app locale to hijri package locale (`en` or `ar` only).
String hijriPackageLocale(String appLocaleCode) {
  return appLocaleCode == 'ar' ? 'ar' : 'en';
}

/// Formatted Hijri date for display (Umm al-Qura tabular calendar).
String formatHijriDate(
  DateTime gregorianDate, {
  required int adjustmentDays,
  required String appLocaleCode,
  String suffix = 'AH',
}) {
  HijriCalendar.setLocal(hijriPackageLocale(appLocaleCode));
  final adjusted = gregorianDate.add(Duration(days: adjustmentDays));
  final hijri = HijriCalendar.fromDate(adjusted);
  return '${hijri.toFormat('DD, MMMM dd, yyyy')} $suffix';
}

/// Gregorian date line for the prayer screen header.
String formatGregorianDate(DateTime date, String appLocaleCode) {
  return DateFormat.yMMMMEEEEd(appLocaleCode).format(date);
}
