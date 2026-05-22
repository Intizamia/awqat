// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الأوقات';

  @override
  String get navPrayerTimes => 'مواقيت الصلاة';

  @override
  String get navComingSoon => 'قريباً';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get comingSoonTitle => 'قريباً';

  @override
  String get comingSoonMessage => 'هذه الميزة قادمة في تحديث لاحق.';

  @override
  String get prayerTimesTitle => 'مواقيت الصلاة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get setup => 'إعداد';

  @override
  String get setupRequiredTitle => 'أكمل الإعداد';

  @override
  String get setupRequiredMessage =>
      'اختر طريقة الحساب والموقع لعرض مواقيت الصلاة.';

  @override
  String get chooseCalculationMethod => 'اختر طريقة الحساب';
}
