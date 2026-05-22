import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:times/features/notifications/data/prayer_notification_planner.dart';
import 'package:times/features/prayer/data/adhan_calculation_engine.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/notification_settings.dart';
import 'package:times/features/settings/domain/user_location.dart';
import 'package:times/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  test('plans upcoming enabled prayers for Karachi', () {
    const settings = AppSettings(
      calculation: CalculationSettings(method: CalculationMethodId.karachi),
      location: kDefaultUserLocation,
      notifications: NotificationSettings(enabled: true),
    );

    final planned = planPrayerNotifications(
      settings: settings,
      engine: AdhanCalculationEngine(),
      l10n: l10n,
      now: DateTime(2026, 5, 22, 2, 0),
    );

    expect(planned, isNotEmpty);
    expect(
      planned.any((n) => n.prayer == PrayerName.fajr),
      isTrue,
    );
    expect(
      planned.any((n) => n.prayer == PrayerName.sunrise),
      isFalse,
    );
    expect(planned.every((n) => n.scheduledAt.isAfter(DateTime(2026, 5, 22, 2, 0))),
        isTrue);
  });

  test('returns empty when notifications disabled', () {
    const settings = AppSettings(
      calculation: CalculationSettings(method: CalculationMethodId.karachi),
      location: kDefaultUserLocation,
      notifications: NotificationSettings(enabled: false),
    );

    final planned = planPrayerNotifications(
      settings: settings,
      engine: AdhanCalculationEngine(),
      l10n: l10n,
    );

    expect(planned, isEmpty);
  });
}
