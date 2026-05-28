import 'package:intl/intl.dart';
import '../../features/settings/domain/time_format_id.dart';

String formatPrayerTime(
  DateTime time, {
  TimeFormatId format = TimeFormatId.hour24,
}) {
  return switch (format) {
    TimeFormatId.hour24 => DateFormat.Hm().format(time),
    TimeFormatId.hour12 => DateFormat.jm().format(time),
  };
}

String formatCountdown(Duration remaining) {
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes}m ${seconds}s';
  }
  if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  }
  return '${seconds}s';
}
