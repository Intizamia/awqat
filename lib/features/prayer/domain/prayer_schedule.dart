import 'package:equatable/equatable.dart';

import 'prayer_time_entry.dart';

class PrayerSchedule extends Equatable {
  const PrayerSchedule({
    required this.date,
    required this.entries,
    this.nextPrayer,
  });

  final DateTime date;
  final List<PrayerTimeEntry> entries;
  final PrayerTimeEntry? nextPrayer;

  @override
  List<Object?> get props => [date, entries, nextPrayer];
}
