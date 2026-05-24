// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'ٹائمز';

  @override
  String get navPrayerTimes => 'نماز کے اوقات';

  @override
  String get navComingSoon => 'جلد آ رہا ہے';

  @override
  String get navSettings => 'ترتیبات';

  @override
  String get comingSoonTitle => 'جلد آ رہا ہے';

  @override
  String get comingSoonMessage => 'یہ فیچر جلد دستیاب ہوگا۔';

  @override
  String get prayerTimesTitle => 'نماز کے اوقات';

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String settingsVersionLabel(String version, String build) {
    return 'Times $version ($build)';
  }

  @override
  String get setup => 'سیٹ اپ';

  @override
  String get setupRequiredTitle => 'سیٹ اپ مکمل کریں';

  @override
  String get setupRequiredMessage =>
      'نماز کے اوقات دیکھنے کے لیے حساب کا طریقہ اور مقام منتخب کریں۔';

  @override
  String get setupChecklistGroupLabel => 'ضروری مراحل';

  @override
  String get chooseCalculationMethod => 'حساب کا طریقہ منتخب کریں';

  @override
  String get language => 'زبان';

  @override
  String get themeMode => 'تھیم';

  @override
  String get themeSystem => 'سسٹم';

  @override
  String get themeLight => 'لائٹ';

  @override
  String get themeDark => 'ڈارک';

  @override
  String get nextPrayer => 'اگلی نماز';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerSunrise => 'طلوع';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get locationTitle => 'مقام';

  @override
  String get locationNotSet => 'کوئی مقام منتخب نہیں';

  @override
  String get locationUnknown => 'نامعلوم مقام';

  @override
  String get locationClear => 'مقام حذف کریں';

  @override
  String get useMyLocation => 'میرا مقام استعمال کریں';

  @override
  String get locationAcquiring => 'مقام حاصل ہو رہا ہے…';

  @override
  String get searchCity => 'شہر تلاش کریں';

  @override
  String get searchCityHint => 'مثلاً لندن، کراچی، دبئی';

  @override
  String get highLatitudeHint =>
      'اعلی عرض بلد — حساب کی ترتیبات میں high-latitude rule غور کریں۔';

  @override
  String get calculationSectionTitle => 'حساب';

  @override
  String get calculationSectionSubtitle => 'طریقہ اور فقہ برائے اوقات';

  @override
  String get calculationMethodTitle => 'حساب کا طریقہ';

  @override
  String get calculationMethodSubtitle =>
      'اپنے علاقے یا مسجد کا طریقہ منتخب کریں';

  @override
  String get madhabSubtitle => 'صرف عصر کے وقت پر اثر';

  @override
  String get highLatitudeSubtitle => '48° سے اوپر عرض بلد کے لیے';

  @override
  String get locationSubtitle => 'GPS یا شہر سے اوقات';

  @override
  String get languageSubtitle => 'زبان اور لے آؤٹ کی سمت';

  @override
  String get themeSubtitle => 'لائٹ، ڈارک، یا سسٹم';

  @override
  String get resetSectionTitle => 'ترتیبات ری سیٹ';

  @override
  String get resetSectionSubtitle => 'ضروری چیزیں رکھ کر ڈیفالٹ بحال';

  @override
  String get resetSectionSummary => 'حساب یا ڈسپلے ڈیفالٹ';

  @override
  String get settingsGroupCalculation => 'حساب';

  @override
  String get settingsGroupLocation => 'مقام';

  @override
  String get settingsGroupNotifications => 'اطلاعات';

  @override
  String get settingsGroupDisplay => 'ڈسپلے';

  @override
  String get settingsGroupAppearance => 'ظاہری شکل';

  @override
  String get settingsGroupReset => 'ری سیٹ';

  @override
  String get notificationsOff => 'بند';

  @override
  String notificationsOnCount(int count) {
    return 'چالو · $count نمازیں';
  }

  @override
  String get hijriAdjustmentNeutral => 'ہجری ±0';

  @override
  String hijriAdjustmentDaysShort(String signedDays) {
    return 'ہجری $signedDays';
  }

  @override
  String get advancedSummaryDefault => 'ڈیفالٹ آفسیٹ';

  @override
  String advancedSummaryWithOffset(int minutes) {
    return 'عمومی آفسیٹ $minutes منٹ';
  }

  @override
  String get madhabTitle => 'مذہب (عصر)';

  @override
  String get madhabShafi => 'شافعی';

  @override
  String get madhabHanafi => 'حنفی';

  @override
  String get highLatitudeTitle => 'اعلی عرض بلد کا قاعدہ';

  @override
  String get highLatitudeMiddle => 'رات کا وسط';

  @override
  String get highLatitudeSeventh => 'ساتواں حصہ';

  @override
  String get highLatitudeAngle => 'شفق زاویہ';

  @override
  String get advancedSectionTitle => 'اعلی درجے';

  @override
  String get advancedSectionSubtitle => 'زاویے اور آفسیٹ';

  @override
  String get fajrAngle => 'فجر زاویہ';

  @override
  String get ishaAngle => 'عشاء زاویہ';

  @override
  String get ishaIntervalMinutes => 'عشاء کا وقفہ مغرب کے بعد (منٹ)';

  @override
  String get globalOffsetMinutes => 'عمومی آفسیٹ (تمام نمازیں)';

  @override
  String get ramadanIshaBoost => 'رمضان عشاء +30 منٹ';

  @override
  String get ramadanIshaBoostSubtitle => 'ام القریٰ کے لیے تجویز کردہ';

  @override
  String get perPrayerOffsets => 'ہر نماز کا آفسیٹ';

  @override
  String get displaySectionTitle => 'ڈسپلے';

  @override
  String get displaySectionSubtitle => 'وقت اور کیلنڈر';

  @override
  String get timeFormatTitle => 'وقت کی شکل';

  @override
  String get timeFormat24 => '24 گھنٹے';

  @override
  String get timeFormat12 => '12 گھنٹے';

  @override
  String get showSunrise => 'طلوع دکھائیں';

  @override
  String get hijriAdjustmentTitle => 'ہجری تاریخ کی ترتیب';

  @override
  String get hijriAdjustmentSubtitle => 'مقامی رویت کے لیے دن';

  @override
  String get appearanceSectionTitle => 'ظاہری شکل';

  @override
  String get resetCalculationTitle => 'حساب کی ترتیبات ری سیٹ';

  @override
  String get resetCalculationMessage =>
      'مذہب، قاعدہ اور آفسیٹ ری سیٹ؟ طریقہ اور مقام محفوظ رہیں گے۔';

  @override
  String get resetDisplayTitle => 'ڈسپلے اور تھیم ری سیٹ';

  @override
  String get resetDisplayMessage =>
      'زبان، تھیم اور ڈسپلے ری سیٹ؟ مقام اور طریقہ محفوظ رہیں گے۔';

  @override
  String get reset => 'ری سیٹ';

  @override
  String get cancel => 'منسوخ';

  @override
  String get initialSetupTitle => 'ٹائمز میں خوش آمدید';

  @override
  String get initialSetupMessage =>
      'اپنے علاقے یا مسجد کا حساب کا طریقہ منتخب کریں۔';

  @override
  String get todayDate => 'آج';

  @override
  String get hijriSuffix => 'ھ';

  @override
  String hijriAdjustmentApplied(int days) {
    return 'ہجری تاریخ $days دن سے ایڈجسٹ (مقامی رویت)';
  }

  @override
  String get qiblaTitle => 'قبلہ';

  @override
  String get qiblaDirectionToKaaba => 'آپ کے محفوظ مقام سے کعبہ کی سمت';

  @override
  String qiblaBearingDegrees(String degrees) {
    return 'شمال سے $degrees°';
  }

  @override
  String get qiblaCalibratedHint =>
      'فون کو سیدھا رکھیں اور تیر اوپر آنے تک گھمائیں';

  @override
  String get qiblaAligned => 'آپ قبلہ کی سمت میں ہیں';

  @override
  String get qiblaSensorUnavailable =>
      'اس ڈیوائس پر کمپاس دستیاب نہیں۔ مقام کے لیے سمت دکھائی گئی ہے۔';

  @override
  String get qiblaLocationRequired =>
      'قبلہ کی سمت کے لیے ترتیبات میں مقام سیٹ کریں۔';

  @override
  String get notificationsSectionTitle => 'اطلاعات';

  @override
  String get notificationsSectionSubtitle =>
      'اس ڈیوائس پر نماز کے وقت کی یاددہانی';

  @override
  String get notificationsMaster => 'نماز کے وقت کی اطلاعات';

  @override
  String get notificationsMasterSubtitle =>
      'سسٹم کی اطلاع کی آواز استعمال ہوگی';

  @override
  String get notificationsPermissionDenied =>
      'اطلاع کی اجازت نہیں ملی۔ سسٹم ترتیبات سے اطلاعات چالو کریں۔';

  @override
  String notificationPrayerBody(String prayer) {
    return '$prayer کا وقت ہو گیا';
  }

  @override
  String semanticsNextPrayer(String prayer, String time) {
    return 'اگلی نماز: $prayer، $time';
  }

  @override
  String semanticsPrayerTime(String prayer, String time) {
    return '$prayer، $time';
  }

  @override
  String semanticsSetupStep(String title, String value) {
    return '$title، $value';
  }
}
