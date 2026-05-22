import 'package:adhan_dart/adhan_dart.dart';

/// Bearing from true north to the Kaaba in degrees (0–360).
double qiblaBearingFromNorth({
  required double latitude,
  required double longitude,
}) {
  return Qibla.qibla(Coordinates(latitude, longitude));
}

/// Compass needle rotation: device heading plus offset to Qibla.
double qiblaPointerDegrees({
  required double deviceHeading,
  required double bearingFromNorth,
}) {
  return deviceHeading + (360 - bearingFromNorth);
}
