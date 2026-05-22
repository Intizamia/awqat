import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get appTitle;

  /// No description provided for @navPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get navPrayerTimes;

  /// No description provided for @navComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get navComingSoon;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature is on the way. Check back in a future update.'**
  String get comingSoonMessage;

  /// No description provided for @prayerTimesTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup;

  /// No description provided for @setupRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete setup'**
  String get setupRequiredTitle;

  /// No description provided for @setupRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose your calculation method and location to see prayer times.'**
  String get setupRequiredMessage;

  /// No description provided for @chooseCalculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose calculation method'**
  String get chooseCalculationMethod;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayer;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @locationNotSet.
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get locationNotSet;

  /// No description provided for @locationUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown place'**
  String get locationUnknown;

  /// No description provided for @locationClear.
  ///
  /// In en, this message translates to:
  /// **'Clear location'**
  String get locationClear;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @locationAcquiring.
  ///
  /// In en, this message translates to:
  /// **'Getting location…'**
  String get locationAcquiring;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @searchCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. London, Karachi, Dubai'**
  String get searchCityHint;

  /// No description provided for @highLatitudeHint.
  ///
  /// In en, this message translates to:
  /// **'High latitude detected — consider a high-latitude rule under calculation settings.'**
  String get highLatitudeHint;

  /// No description provided for @calculationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation'**
  String get calculationSectionTitle;

  /// No description provided for @calculationSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Method and jurisprudence for prayer times'**
  String get calculationSectionSubtitle;

  /// No description provided for @madhabTitle.
  ///
  /// In en, this message translates to:
  /// **'Madhab (Asr)'**
  String get madhabTitle;

  /// No description provided for @madhabShafi.
  ///
  /// In en, this message translates to:
  /// **'Shafi'**
  String get madhabShafi;

  /// No description provided for @madhabHanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhabHanafi;

  /// No description provided for @highLatitudeTitle.
  ///
  /// In en, this message translates to:
  /// **'High latitude rule'**
  String get highLatitudeTitle;

  /// No description provided for @highLatitudeMiddle.
  ///
  /// In en, this message translates to:
  /// **'Middle of the night'**
  String get highLatitudeMiddle;

  /// No description provided for @highLatitudeSeventh.
  ///
  /// In en, this message translates to:
  /// **'One-seventh of night'**
  String get highLatitudeSeventh;

  /// No description provided for @highLatitudeAngle.
  ///
  /// In en, this message translates to:
  /// **'Twilight angle'**
  String get highLatitudeAngle;

  /// No description provided for @advancedSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedSectionTitle;

  /// No description provided for @advancedSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fine-tune angles and offsets'**
  String get advancedSectionSubtitle;

  /// No description provided for @fajrAngle.
  ///
  /// In en, this message translates to:
  /// **'Fajr angle'**
  String get fajrAngle;

  /// No description provided for @ishaAngle.
  ///
  /// In en, this message translates to:
  /// **'Isha angle'**
  String get ishaAngle;

  /// No description provided for @ishaIntervalMinutes.
  ///
  /// In en, this message translates to:
  /// **'Isha interval after Maghrib (minutes)'**
  String get ishaIntervalMinutes;

  /// No description provided for @globalOffsetMinutes.
  ///
  /// In en, this message translates to:
  /// **'Global offset (all prayers)'**
  String get globalOffsetMinutes;

  /// No description provided for @ramadanIshaBoost.
  ///
  /// In en, this message translates to:
  /// **'Ramadan Isha +30 min'**
  String get ramadanIshaBoost;

  /// No description provided for @ramadanIshaBoostSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended for Umm Al-Qura method'**
  String get ramadanIshaBoostSubtitle;

  /// No description provided for @perPrayerOffsets.
  ///
  /// In en, this message translates to:
  /// **'Per-prayer offsets (minutes)'**
  String get perPrayerOffsets;

  /// No description provided for @displaySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displaySectionTitle;

  /// No description provided for @displaySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time format and calendar'**
  String get displaySectionSubtitle;

  /// No description provided for @timeFormatTitle.
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get timeFormatTitle;

  /// No description provided for @timeFormat24.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get timeFormat24;

  /// No description provided for @timeFormat12.
  ///
  /// In en, this message translates to:
  /// **'12-hour'**
  String get timeFormat12;

  /// No description provided for @showSunrise.
  ///
  /// In en, this message translates to:
  /// **'Show Sunrise'**
  String get showSunrise;

  /// No description provided for @hijriAdjustmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Hijri date adjustment'**
  String get hijriAdjustmentTitle;

  /// No description provided for @hijriAdjustmentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Days to add or subtract for local moon sighting'**
  String get hijriAdjustmentSubtitle;

  /// No description provided for @appearanceSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSectionTitle;

  /// No description provided for @resetCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset calculation settings'**
  String get resetCalculationTitle;

  /// No description provided for @resetCalculationMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset madhab, high-latitude rule, and offsets? Your method and location are kept.'**
  String get resetCalculationMessage;

  /// No description provided for @resetDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset display & theme'**
  String get resetDisplayTitle;

  /// No description provided for @resetDisplayMessage.
  ///
  /// In en, this message translates to:
  /// **'Reset language, theme, time format, and display options? Location and calculation method are kept.'**
  String get resetDisplayMessage;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @initialSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Times'**
  String get initialSetupTitle;

  /// No description provided for @initialSetupMessage.
  ///
  /// In en, this message translates to:
  /// **'Choose the calculation method used by your local mosque or region.'**
  String get initialSetupMessage;

  /// No description provided for @todayDate.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayDate;

  /// No description provided for @hijriSuffix.
  ///
  /// In en, this message translates to:
  /// **'AH'**
  String get hijriSuffix;

  /// No description provided for @hijriAdjustmentApplied.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1 {Hijri date adjusted by 1 day for local moon sighting} other {Hijri date adjusted by {days} days for local moon sighting}}'**
  String hijriAdjustmentApplied(int days);

  /// No description provided for @qiblaTitle.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qiblaTitle;

  /// No description provided for @qiblaDirectionToKaaba.
  ///
  /// In en, this message translates to:
  /// **'Direction to the Kaaba from your saved location'**
  String get qiblaDirectionToKaaba;

  /// No description provided for @qiblaBearingDegrees.
  ///
  /// In en, this message translates to:
  /// **'{degrees}° from north'**
  String qiblaBearingDegrees(String degrees);

  /// No description provided for @qiblaCalibratedHint.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat and rotate until the arrow points up'**
  String get qiblaCalibratedHint;

  /// No description provided for @qiblaAligned.
  ///
  /// In en, this message translates to:
  /// **'You are facing the Qibla'**
  String get qiblaAligned;

  /// No description provided for @qiblaSensorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Compass sensor unavailable on this device. Bearing shown for your location.'**
  String get qiblaSensorUnavailable;

  /// No description provided for @qiblaLocationRequired.
  ///
  /// In en, this message translates to:
  /// **'Set your location in Settings to see the Qibla direction.'**
  String get qiblaLocationRequired;

  /// No description provided for @notificationsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsSectionTitle;

  /// No description provided for @notificationsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer time alerts on this device'**
  String get notificationsSectionSubtitle;

  /// No description provided for @notificationsMaster.
  ///
  /// In en, this message translates to:
  /// **'Prayer time notifications'**
  String get notificationsMaster;

  /// No description provided for @notificationsMasterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Uses your system notification sound'**
  String get notificationsMasterSubtitle;

  /// No description provided for @notificationsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was denied. Enable notifications in system settings.'**
  String get notificationsPermissionDenied;

  /// No description provided for @notificationPrayerBody.
  ///
  /// In en, this message translates to:
  /// **'Time for {prayer}'**
  String notificationPrayerBody(String prayer);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
