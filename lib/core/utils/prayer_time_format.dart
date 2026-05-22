import 'package:intl/intl.dart';

String formatPrayerTime(DateTime time) {
  return DateFormat.Hm().format(time);
}

String formatCountdown(Duration remaining) {
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  return '${minutes}m';
}
