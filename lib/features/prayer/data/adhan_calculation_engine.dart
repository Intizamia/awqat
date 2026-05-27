import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'calculation_settings_mapper.dart';
import '../domain/prayer_name.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_time_entry.dart';
import '../../settings/domain/calculation_settings.dart';
import '../../settings/domain/user_location.dart';

class AdhanCalculationEngine {
  AdhanCalculationEngine({CalculationSettingsMapper? mapper})
    : _mapper = mapper ?? const CalculationSettingsMapper();

  final CalculationSettingsMapper _mapper;

  PrayerSchedule compute({
    required DateTime date,
    required UserLocation location,
    required CalculationSettings calculation,
  }) {
    final params = _mapper.toParameters(calculation);
    final coordinates = adhan.Coordinates(
      location.latitude,
      location.longitude,
    );

    final localDate = DateTime(date.year, date.month, date.day);
    final times = adhan.PrayerTimes(
      date: localDate,
      coordinates: coordinates,
      calculationParameters: params,
    );

    final entries = <PrayerTimeEntry>[
      PrayerTimeEntry(name: PrayerName.fajr, time: times.fajr.toLocal()),
      PrayerTimeEntry(name: PrayerName.sunrise, time: times.sunrise.toLocal()),
      PrayerTimeEntry(name: PrayerName.dhuhr, time: times.dhuhr.toLocal()),
      PrayerTimeEntry(name: PrayerName.asr, time: times.asr.toLocal()),
      PrayerTimeEntry(name: PrayerName.maghrib, time: times.maghrib.toLocal()),
      PrayerTimeEntry(name: PrayerName.isha, time: times.isha.toLocal()),
    ]..sort((a, b) => a.time.compareTo(b.time));

    final now = DateTime.now();
    PrayerTimeEntry? next;
    for (final entry in entries) {
      if (entry.name == PrayerName.sunrise) continue;
      if (entry.time.isAfter(now)) {
        next = entry;
        break;
      }
    }

    if (next == null) {
      // All prayers passed — find tomorrow's Fajr
      final tomorrow = localDate.add(const Duration(days: 1));
      final tomorrowTimes = adhan.PrayerTimes(
        date: tomorrow,
        coordinates: coordinates,
        calculationParameters: params,
      );
      next = PrayerTimeEntry(
        name: PrayerName.fajr,
        time: tomorrowTimes.fajr.toLocal(),
      );
    }

    return PrayerSchedule(date: localDate, entries: entries, nextPrayer: next);
  }
}
