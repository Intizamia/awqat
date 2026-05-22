import 'package:equatable/equatable.dart';
import 'package:times/features/prayer/domain/prayer_name.dart';

class PrayerTimeEntry extends Equatable {
  const PrayerTimeEntry({
    required this.name,
    required this.time,
  });

  final PrayerName name;
  final DateTime time;

  @override
  List<Object?> get props => [name, time];
}
