import 'package:flutter_test/flutter_test.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';
import 'package:times/features/settings/domain/notification_settings.dart';

void main() {
  test('NotificationSettings round-trip JSON', () {
    const original = NotificationSettings(
      enabled: true,
      prayerEnabled: {
        PrayerName.fajr: true,
        PrayerName.sunrise: true,
        PrayerName.dhuhr: false,
        PrayerName.asr: true,
        PrayerName.maghrib: true,
        PrayerName.isha: false,
      },
    );

    final restored = NotificationSettings.fromJson(original.toJson());

    expect(restored.enabled, isTrue);
    expect(restored.isPrayerEnabled(PrayerName.sunrise), isTrue);
    expect(restored.isPrayerEnabled(PrayerName.dhuhr), isFalse);
    expect(restored.isPrayerEnabled(PrayerName.isha), isFalse);
  });

  test('copyWithPrayer updates a single prayer toggle', () {
    const settings = NotificationSettings();
    final updated = settings.copyWithPrayer(PrayerName.maghrib, false);
    expect(updated.isPrayerEnabled(PrayerName.maghrib), isFalse);
    expect(updated.isPrayerEnabled(PrayerName.fajr), isTrue);
  });
}
