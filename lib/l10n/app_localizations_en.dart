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
}
