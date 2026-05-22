import 'package:equatable/equatable.dart';

class UserLocation extends Equatable {
  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.timeZoneId,
    this.label,
  });

  final double latitude;
  final double longitude;

  /// IANA timezone, e.g. `Asia/Karachi`.
  final String timeZoneId;
  final String? label;

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'timeZoneId': timeZoneId,
        'label': label,
      };

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      timeZoneId: json['timeZoneId'] as String,
      label: json['label'] as String?,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, timeZoneId, label];
}

/// Default fixture for tests.
const kDefaultUserLocation = UserLocation(
  latitude: 24.8607,
  longitude: 67.0011,
  timeZoneId: 'Asia/Karachi',
  label: 'Karachi',
);
