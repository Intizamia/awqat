// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Times';

  @override
  String get navPrayerTimes => 'Prayer Times';

  @override
  String get navComingSoon => 'Coming Soon';

  @override
  String get navSettings => 'Settings';

  @override
  String get comingSoonTitle => 'Coming Soon';

  @override
  String get comingSoonMessage =>
      'This feature is on the way. Check back in a future update.';

  @override
  String get prayerTimesTitle => 'Prayer Times';

  @override
  String get settingsTitle => 'Settings';

  @override
  String settingsVersionLabel(String version, String build) {
    return 'Times $version ($build)';
  }

  @override
  String get setup => 'Setup';

  @override
  String get setupRequiredTitle => 'Complete setup';

  @override
  String get setupRequiredMessage =>
      'Choose your calculation method and location to see prayer times.';

  @override
  String get chooseCalculationMethod => 'Choose calculation method';

  @override
  String get language => 'Language';

  @override
  String get themeMode => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get locationTitle => 'Location';

  @override
  String get locationNotSet => 'No location selected';

  @override
  String get locationUnknown => 'Unknown place';

  @override
  String get locationClear => 'Clear location';

  @override
  String get useMyLocation => 'Use my location';

  @override
  String get locationAcquiring => 'Getting location…';

  @override
  String get searchCity => 'Search city';

  @override
  String get searchCityHint => 'e.g. London, Karachi, Dubai';

  @override
  String get highLatitudeHint =>
      'High latitude detected — consider a high-latitude rule under calculation settings.';

  @override
  String get calculationSectionTitle => 'Calculation';

  @override
  String get calculationSectionSubtitle =>
      'Method and jurisprudence for prayer times';

  @override
  String get calculationMethodTitle => 'Calculation method';

  @override
  String get calculationMethodSubtitle =>
      'Choose the method used by your mosque or region';

  @override
  String get madhabSubtitle => 'Affects Asr time only';

  @override
  String get highLatitudeSubtitle => 'For locations above 48° latitude';

  @override
  String get locationSubtitle => 'GPS or city search for prayer times';

  @override
  String get languageSubtitle => 'App language and layout direction';

  @override
  String get themeSubtitle => 'Light, dark, or follow system';

  @override
  String get resetSectionTitle => 'Reset settings';

  @override
  String get resetSectionSubtitle =>
      'Restore defaults while keeping essentials';

  @override
  String get resetSectionSummary => 'Calculation or display defaults';

  @override
  String get settingsGroupCalculation => 'CALCULATION';

  @override
  String get settingsGroupLocation => 'LOCATION';

  @override
  String get settingsGroupNotifications => 'NOTIFICATIONS';

  @override
  String get settingsGroupDisplay => 'DISPLAY';

  @override
  String get settingsGroupAppearance => 'APPEARANCE';

  @override
  String get settingsGroupReset => 'RESET';

  @override
  String get notificationsOff => 'Off';

  @override
  String notificationsOnCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'On · $count prayers',
      one: 'On · 1 prayer',
    );
    return '$_temp0';
  }

  @override
  String get hijriAdjustmentNeutral => 'Hijri ±0';

  @override
  String hijriAdjustmentDaysShort(String signedDays) {
    return 'Hijri $signedDays';
  }

  @override
  String get advancedSummaryDefault => 'Default offsets';

  @override
  String advancedSummaryWithOffset(int minutes) {
    return 'Global offset $minutes min';
  }

  @override
  String get madhabTitle => 'Madhab (Asr)';

  @override
  String get madhabShafi => 'Shafi';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get highLatitudeTitle => 'High latitude rule';

  @override
  String get highLatitudeMiddle => 'Middle of the night';

  @override
  String get highLatitudeSeventh => 'One-seventh of night';

  @override
  String get highLatitudeAngle => 'Twilight angle';

  @override
  String get advancedSectionTitle => 'Advanced';

  @override
  String get advancedSectionSubtitle => 'Fine-tune angles and offsets';

  @override
  String get fajrAngle => 'Fajr angle';

  @override
  String get ishaAngle => 'Isha angle';

  @override
  String get ishaIntervalMinutes => 'Isha interval after Maghrib (minutes)';

  @override
  String get globalOffsetMinutes => 'Global offset (all prayers)';

  @override
  String get ramadanIshaBoost => 'Ramadan Isha +30 min';

  @override
  String get ramadanIshaBoostSubtitle => 'Recommended for Umm Al-Qura method';

  @override
  String get perPrayerOffsets => 'Per-prayer offsets (minutes)';

  @override
  String get displaySectionTitle => 'Display';

  @override
  String get displaySectionSubtitle => 'Time format and calendar';

  @override
  String get timeFormatTitle => 'Time format';

  @override
  String get timeFormat24 => '24-hour';

  @override
  String get timeFormat12 => '12-hour';

  @override
  String get showSunrise => 'Show Sunrise';

  @override
  String get hijriAdjustmentTitle => 'Hijri date adjustment';

  @override
  String get hijriAdjustmentSubtitle =>
      'Days to add or subtract for local moon sighting';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get resetCalculationTitle => 'Reset calculation settings';

  @override
  String get resetCalculationMessage =>
      'Reset madhab, high-latitude rule, and offsets? Your method and location are kept.';

  @override
  String get resetDisplayTitle => 'Reset display & theme';

  @override
  String get resetDisplayMessage =>
      'Reset language, theme, time format, and display options? Location and calculation method are kept.';

  @override
  String get reset => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get initialSetupTitle => 'Welcome to Times';

  @override
  String get initialSetupMessage =>
      'Choose the calculation method used by your local mosque or region.';

  @override
  String get todayDate => 'Today';

  @override
  String get hijriSuffix => 'AH';

  @override
  String hijriAdjustmentApplied(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Hijri date adjusted by $days days for local moon sighting',
      one: 'Hijri date adjusted by 1 day for local moon sighting',
    );
    return '$_temp0';
  }

  @override
  String get qiblaTitle => 'Qibla';

  @override
  String get qiblaDirectionToKaaba =>
      'Direction to the Kaaba from your saved location';

  @override
  String qiblaBearingDegrees(String degrees) {
    return '$degrees° from north';
  }

  @override
  String get qiblaCalibratedHint =>
      'Hold your phone flat and rotate until the arrow points up';

  @override
  String get qiblaAligned => 'You are facing the Qibla';

  @override
  String get qiblaSensorUnavailable =>
      'Compass sensor unavailable on this device. Bearing shown for your location.';

  @override
  String get qiblaLocationRequired =>
      'Set your location in Settings to see the Qibla direction.';

  @override
  String get notificationsSectionTitle => 'Notifications';

  @override
  String get notificationsSectionSubtitle =>
      'Prayer time alerts on this device';

  @override
  String get notificationsMaster => 'Prayer time notifications';

  @override
  String get notificationsMasterSubtitle =>
      'Uses your system notification sound';

  @override
  String get notificationsPermissionDenied =>
      'Notification permission was denied. Enable notifications in system settings.';

  @override
  String notificationPrayerBody(String prayer) {
    return 'Time for $prayer';
  }

  @override
  String semanticsNextPrayer(String prayer, String time) {
    return 'Next prayer: $prayer at $time';
  }

  @override
  String semanticsPrayerTime(String prayer, String time) {
    return '$prayer at $time';
  }
}
