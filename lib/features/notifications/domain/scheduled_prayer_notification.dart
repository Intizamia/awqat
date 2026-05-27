import 'package:equatable/equatable.dart';
import 'package:awqat/features/prayer/domain/prayer_name.dart';

class ScheduledPrayerNotification extends Equatable {
  const ScheduledPrayerNotification({
    required this.id,
    required this.prayer,
    required this.scheduledAt,
    required this.title,
    required this.body,
  });

  final int id;
  final PrayerName prayer;
  final DateTime scheduledAt;
  final String title;
  final String body;

  @override
  List<Object?> get props => [id, prayer, scheduledAt, title, body];
}
