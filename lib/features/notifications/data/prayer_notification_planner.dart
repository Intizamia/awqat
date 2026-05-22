import 'package:times/features/notifications/data/prayer_notification_ids.dart';
import 'package:times/features/notifications/domain/scheduled_prayer_notification.dart';
import 'package:times/features/prayer/data/adhan_calculation_engine.dart';
import 'package:times/features/prayer/domain/prayer_schedule.dart';
import 'package:times/features/prayer/presentation/prayer_name_l10n.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/l10n/app_localizations.dart';

/// Builds upcoming prayer notifications for the next few days.
List<ScheduledPrayerNotification> planPrayerNotifications({
  required AppSettings settings,
  required AdhanCalculationEngine engine,
  required AppLocalizations l10n,
  DateTime? now,
}) {
  if (!settings.notifications.enabled || !settings.setup.isComplete) {
    return const [];
  }

  final location = settings.location;
  if (location == null) return const [];

  final clock = now ?? DateTime.now();
  final today = DateTime(clock.year, clock.month, clock.day);
  final planned = <ScheduledPrayerNotification>[];

  for (var dayOffset = 0; dayOffset < kPrayerNotificationDayHorizon; dayOffset++) {
    final date = today.add(Duration(days: dayOffset));
    final schedule = engine.compute(
      date: date,
      location: location,
      calculation: settings.calculation,
    );
    planned.addAll(
      _planDay(
        schedule: schedule,
        settings: settings,
        l10n: l10n,
        dayOffset: dayOffset,
        now: clock,
      ),
    );
  }

  planned.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  return planned;
}

List<ScheduledPrayerNotification> _planDay({
  required PrayerSchedule schedule,
  required AppSettings settings,
  required AppLocalizations l10n,
  required int dayOffset,
  required DateTime now,
}) {
  final items = <ScheduledPrayerNotification>[];

  for (final entry in schedule.entries) {
    if (!settings.notifications.isPrayerEnabled(entry.name)) continue;
    if (!entry.time.isAfter(now)) continue;

    items.add(
      ScheduledPrayerNotification(
        id: prayerNotificationId(prayer: entry.name, dayOffset: dayOffset),
        prayer: entry.name,
        scheduledAt: entry.time,
        title: entry.name.label(l10n),
        body: l10n.notificationPrayerBody(entry.name.label(l10n)),
      ),
    );
  }

  return items;
}
