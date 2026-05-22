import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/domain/time_format_id.dart';
import 'package:times/features/settings/domain/user_location.dart';
import 'package:times/l10n/app_localizations.dart';

String madhabLabel(AppLocalizations l10n, MadhabId madhab) {
  return switch (madhab) {
    MadhabId.shafi => l10n.madhabShafi,
    MadhabId.hanafi => l10n.madhabHanafi,
  };
}

String highLatitudeLabel(AppLocalizations l10n, HighLatitudeRuleId rule) {
  return switch (rule) {
    HighLatitudeRuleId.middleOfTheNight => l10n.highLatitudeMiddle,
    HighLatitudeRuleId.seventhOfTheNight => l10n.highLatitudeSeventh,
    HighLatitudeRuleId.twilightAngle => l10n.highLatitudeAngle,
  };
}

String timeFormatLabel(AppLocalizations l10n, TimeFormatId format) {
  return switch (format) {
    TimeFormatId.hour24 => l10n.timeFormat24,
    TimeFormatId.hour12 => l10n.timeFormat12,
  };
}

String themeModeLabel(AppLocalizations l10n, ThemeModeId mode) {
  return switch (mode) {
    ThemeModeId.system => l10n.themeSystem,
    ThemeModeId.light => l10n.themeLight,
    ThemeModeId.dark => l10n.themeDark,
  };
}

String languageLabel(String code) {
  return switch (code) {
    'ur' => 'Urdu',
    'ar' => 'Arabic',
    _ => 'English',
  };
}

String locationSummary(AppLocalizations l10n, UserLocation? location) {
  if (location == null) return l10n.locationNotSet;
  return location.label ?? l10n.locationUnknown;
}

String notificationsSummary(AppLocalizations l10n, AppSettings settings) {
  if (!settings.notifications.enabled) return l10n.notificationsOff;
  final enabled = settings.notifications.prayerEnabled.entries
      .where((e) => e.value)
      .length;
  return l10n.notificationsOnCount(enabled);
}

String displaySummary(AppLocalizations l10n, AppSettings settings) {
  final format = timeFormatLabel(l10n, settings.timeFormat);
  final hijri = settings.hijriAdjustmentDays;
  final hijriPart = hijri == 0
      ? l10n.hijriAdjustmentNeutral
      : l10n.hijriAdjustmentDaysShort(
          hijri > 0 ? '+$hijri' : '$hijri',
        );
  return '$format · $hijriPart';
}

String advancedCalculationSummary(AppLocalizations l10n, AppSettings settings) {
  final offset = settings.calculation.globalOffsetMinutes;
  if (offset == 0) return l10n.advancedSummaryDefault;
  return l10n.advancedSummaryWithOffset(offset);
}
