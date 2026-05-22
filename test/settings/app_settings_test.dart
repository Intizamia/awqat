import 'package:flutter_test/flutter_test.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/notification_settings.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/prayer_offsets.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/domain/time_format_id.dart';
import 'package:times/features/settings/domain/user_location.dart';

void main() {
  test('AppSettings round-trip includes theme and location', () {
    const original = AppSettings(
      calculation: CalculationSettings(
        method: CalculationMethodId.karachi,
        prayerOffsets: PrayerOffsets(isha: 2),
        globalOffsetMinutes: 1,
      ),
      localeCode: 'ur',
      themeMode: ThemeModeId.dark,
      timeFormat: TimeFormatId.hour12,
      hijriAdjustmentDays: 1,
      showSunrise: false,
      location: kDefaultUserLocation,
      notifications: NotificationSettings(
        enabled: true,
        prayerEnabled: {PrayerName.fajr: true, PrayerName.isha: false},
      ),
    );

    final restored = AppSettings.fromJson(original.toJson());

    expect(restored.themeMode, ThemeModeId.dark);
    expect(restored.localeCode, 'ur');
    expect(restored.timeFormat, TimeFormatId.hour12);
    expect(restored.hijriAdjustmentDays, 1);
    expect(restored.showSunrise, isFalse);
    expect(restored.calculation.prayerOffsets.isha, 2);
    expect(restored.location?.latitude, kDefaultUserLocation.latitude);
    expect(restored.notifications.enabled, isTrue);
    expect(restored.notifications.isPrayerEnabled(PrayerName.isha), isFalse);
    expect(restored.setup.isComplete, isTrue);
  });
}
