import 'package:equatable/equatable.dart';
import '../../prayer/domain/prayer_name.dart';
import '../../prayer/domain/prayer_notif_type.dart';

class ScheduledPrayerNotification extends Equatable {
  const ScheduledPrayerNotification({
    required this.id,
    required this.prayer,
    required this.scheduledAt,
    required this.title,
    required this.body,
    required this.notifType,
  });

  final int id;
  final PrayerName prayer;
  final DateTime scheduledAt;
  final String title;
  final String body;
  final PrayerNotifType notifType;

  @override
  List<Object?> get props => [id, prayer, scheduledAt, title, body, notifType];
}
