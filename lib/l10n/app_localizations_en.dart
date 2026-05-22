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
}
