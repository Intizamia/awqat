import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart';

/// Resolves IANA timezone id from coordinates (e.g. `Asia/Karachi`).
String resolveTimeZoneId(double latitude, double longitude) {
  return latLngToTimezoneString(latitude, longitude);
}
