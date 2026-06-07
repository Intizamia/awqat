import 'dart:convert';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import '../prayer/domain/prayer_name.dart';
import '../prayer/domain/prayer_schedule.dart';
import '../prayer/domain/prayer_time_entry.dart';
import '../settings/domain/app_settings.dart';
import '../../core/utils/prayer_time_format.dart';
import '../../core/utils/hijri_date_format.dart';

class WidgetDataWriter {
  static const _androidReceiver =
      'com.intizamia.awqat.widget.AwqatWidgetRefreshReceiver';

  static Future<void> update({
    required PrayerSchedule schedule,
    required AppSettings settings,
  }) async {
    final fmt = settings.timeFormat;
    final location = settings.location;

    final next = schedule.nextPrayer;

    PrayerTimeEntry? following;
    if (next != null) {
      var foundNext = false;
      for (final e in schedule.entries) {
        if (e.name == PrayerName.sunrise) continue;
        if (foundNext) {
          following = e;
          break;
        }
        if (e.name == next.name) foundNext = true;
      }
    }

    final prayersJson = jsonEncode(
      schedule.entries.map((e) => {
        'key': e.name.name,
        'name': _name(e.name),
        'time': formatPrayerTime(e.time, format: fmt),
        'time_ms': e.time.millisecondsSinceEpoch,
      }).toList(),
    );

    final dateGreg = DateFormat('EEE, d MMM').format(schedule.date);
    final dateHijri = formatHijriDate(
      schedule.date,
      adjustmentDays: settings.hijriAdjustmentDays,
      appLocaleCode: settings.localeCode,
      suffix: 'AH',
    );

    final locationLabel = location?.label ?? location?.timeZoneId ?? '—';

    await Future.wait([
      HomeWidget.saveWidgetData<String>(
          'widget_next_name', next != null ? _name(next.name) : '—'),
      HomeWidget.saveWidgetData<int>(
          'widget_next_time_ms', next?.time.millisecondsSinceEpoch ?? 0),
      HomeWidget.saveWidgetData<String>(
          'widget_next_time_str',
          next != null ? formatPrayerTime(next.time, format: fmt) : '—'),
      HomeWidget.saveWidgetData<String>(
          'widget_next_key', next?.name.name ?? ''),
      HomeWidget.saveWidgetData<String>(
          'widget_following_name',
          following != null ? _name(following.name) : '—'),
      HomeWidget.saveWidgetData<String>(
          'widget_following_time_str',
          following != null ? formatPrayerTime(following.time, format: fmt) : '—'),
      HomeWidget.saveWidgetData<String>('widget_location', locationLabel),
      HomeWidget.saveWidgetData<String>('widget_date_greg', dateGreg),
      HomeWidget.saveWidgetData<String>('widget_date_hijri', dateHijri),
      HomeWidget.saveWidgetData<String>('widget_prayers_json', prayersJson),
    ]);

    await HomeWidget.updateWidget(
      qualifiedAndroidName: _androidReceiver,
    );
  }

  static String _name(PrayerName n) => switch (n) {
        PrayerName.fajr => 'Fajr',
        PrayerName.sunrise => 'Sunrise',
        PrayerName.dhuhr => 'Dhuhr',
        PrayerName.asr => 'Asr',
        PrayerName.maghrib => 'Maghrib',
        PrayerName.isha => 'Isha',
      };
}
