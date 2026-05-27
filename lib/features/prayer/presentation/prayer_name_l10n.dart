import '../domain/prayer_name.dart';
import '../../../l10n/app_localizations.dart';

extension PrayerNameL10n on PrayerName {
  String label(AppLocalizations l10n) {
    return switch (this) {
      PrayerName.fajr => l10n.prayerFajr,
      PrayerName.sunrise => l10n.prayerSunrise,
      PrayerName.dhuhr => l10n.prayerDhuhr,
      PrayerName.asr => l10n.prayerAsr,
      PrayerName.maghrib => l10n.prayerMaghrib,
      PrayerName.isha => l10n.prayerIsha,
    };
  }
}
