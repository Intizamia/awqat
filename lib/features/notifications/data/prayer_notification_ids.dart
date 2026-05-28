import '../../prayer/domain/prayer_name.dart';

/// Stable notification ids: day bucket × prayer index (keeps pending count low).
int prayerNotificationId({required PrayerName prayer, required int dayOffset}) {
  return (dayOffset + 1) * 10 + prayer.index + 1;
}

/// Pre-reminder ids use a 100× bucket to avoid colliding with prayer ids.
int preReminderNotificationId({
  required PrayerName prayer,
  required int dayOffset,
}) {
  return (dayOffset + 1) * 100 + prayer.index + 1;
}

const kPrayerNotificationDayHorizon = 3;
