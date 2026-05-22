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

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get locationTitle => 'الموقع';

  @override
  String get locationNotSet => 'لم يتم اختيار موقع';

  @override
  String get locationUnknown => 'مكان غير معروف';

  @override
  String get locationClear => 'مسح الموقع';

  @override
  String get useMyLocation => 'استخدم موقعي';

  @override
  String get locationAcquiring => 'جاري تحديد الموقع…';

  @override
  String get searchCity => 'ابحث عن مدينة';

  @override
  String get searchCityHint => 'مثال: لندن، كراتشي، دبي';

  @override
  String get highLatitudeHint =>
      'خط عرض مرتفع — فكّر في قاعدة خط العرض العالي في إعدادات الحساب.';
}
