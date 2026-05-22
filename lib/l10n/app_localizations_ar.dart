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

  @override
  String get calculationSectionTitle => 'الحساب';

  @override
  String get calculationSectionSubtitle => 'طريقة الحساب والفقه';

  @override
  String get madhabTitle => 'المذهب (العصر)';

  @override
  String get madhabShafi => 'شافعي';

  @override
  String get madhabHanafi => 'حنفي';

  @override
  String get highLatitudeTitle => 'قاعدة خط العرض العالي';

  @override
  String get highLatitudeMiddle => 'منتصف الليل';

  @override
  String get highLatitudeSeventh => 'سُبع الليل';

  @override
  String get highLatitudeAngle => 'زاوية الشفق';

  @override
  String get advancedSectionTitle => 'متقدم';

  @override
  String get advancedSectionSubtitle => 'ضبط الزوايا والإزاحات';

  @override
  String get fajrAngle => 'زاوية الفجر';

  @override
  String get ishaAngle => 'زاوية العشاء';

  @override
  String get ishaIntervalMinutes => 'فترة العشاء بعد المغرب (دقائق)';

  @override
  String get globalOffsetMinutes => 'إزاحة عامة (كل الصلوات)';

  @override
  String get ramadanIshaBoost => 'رمضان العشاء +30 د';

  @override
  String get ramadanIshaBoostSubtitle => 'موصى به لطريقة أم القرى';

  @override
  String get perPrayerOffsets => 'إزاحة لكل صلاة';

  @override
  String get displaySectionTitle => 'العرض';

  @override
  String get displaySectionSubtitle => 'تنسيق الوقت والتقويم';

  @override
  String get timeFormatTitle => 'تنسيق الوقت';

  @override
  String get timeFormat24 => '24 ساعة';

  @override
  String get timeFormat12 => '12 ساعة';

  @override
  String get showSunrise => 'إظهار الشروق';

  @override
  String get hijriAdjustmentTitle => 'تعديل التاريخ الهجري';

  @override
  String get hijriAdjustmentSubtitle => 'أيام للإضافة أو الطرح';

  @override
  String get appearanceSectionTitle => 'المظهر';

  @override
  String get resetCalculationTitle => 'إعادة ضبط الحساب';

  @override
  String get resetCalculationMessage =>
      'إعادة المذهب والقواعد والإزاحات؟ تُبقى الطريقة والموقع.';

  @override
  String get resetDisplayTitle => 'إعادة ضبط العرض';

  @override
  String get resetDisplayMessage =>
      'إعادة اللغة والمظهر والعرض؟ يُبقى الموقع وطريقة الحساب.';

  @override
  String get reset => 'إعادة ضبط';

  @override
  String get cancel => 'إلغاء';

  @override
  String get initialSetupTitle => 'مرحباً بك في الأوقات';

  @override
  String get initialSetupMessage =>
      'اختر طريقة الحساب المعتمدة في منطقتك أو مسجدك.';

  @override
  String get todayDate => 'اليوم';

  @override
  String get hijriSuffix => 'هـ';

  @override
  String hijriAdjustmentApplied(int days) {
    return 'تم تعديل التاريخ الهجري بمقدار $days يوماً (حسب الرؤية المحلية)';
  }

  @override
  String get qiblaTitle => 'القبلة';

  @override
  String get qiblaDirectionToKaaba => 'اتجاه الكعبة من موقعك المحفوظ';

  @override
  String qiblaBearingDegrees(String degrees) {
    return '$degrees° من الشمال';
  }

  @override
  String get qiblaCalibratedHint =>
      'أمسك الهاتف بشكل مستوٍ ودوّره حتى يشير السهم للأعلى';

  @override
  String get qiblaAligned => 'أنت باتجاه القبلة';

  @override
  String get qiblaSensorUnavailable =>
      'بوصلة الجهاز غير متوفرة. يُعرض الاتجاه لموقعك.';

  @override
  String get qiblaLocationRequired =>
      'حدد موقعك في الإعدادات لعرض اتجاه القبلة.';

  @override
  String get notificationsSectionTitle => 'الإشعارات';

  @override
  String get notificationsSectionSubtitle =>
      'تنبيهات مواقيت الصلاة على هذا الجهاز';

  @override
  String get notificationsMaster => 'إشعارات مواقيت الصلاة';

  @override
  String get notificationsMasterSubtitle => 'يستخدم صوت إشعارات النظام';

  @override
  String get notificationsPermissionDenied =>
      'لم يُمنح إذن الإشعارات. فعّل الإشعارات من إعدادات النظام.';

  @override
  String notificationPrayerBody(String prayer) {
    return 'حان وقت $prayer';
  }
}
