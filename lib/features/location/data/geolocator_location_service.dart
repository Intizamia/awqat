import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:times/core/utils/timezone_resolver.dart';
import 'package:times/features/location/data/location_service.dart';
import 'package:times/features/location/domain/city_search_result.dart';
import 'package:times/features/location/domain/location_exception.dart';
import 'package:times/features/settings/domain/user_location.dart';

class GeolocatorLocationService implements LocationService {
  @override
  Future<UserLocation> getCurrentLocation() async {
    await _ensurePermissionAndService();

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );

    return locationFromCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Future<List<CitySearchResult>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      return [];
    }

    try {
      final locations = await locationFromAddress(trimmed);
      if (locations.isEmpty) {
        return [];
      }

      final results = <CitySearchResult>[];
      final seen = <String>{};

      for (final loc in locations.take(5)) {
        final label = await _labelForCoordinates(
          loc.latitude,
          loc.longitude,
          fallback: trimmed,
        );
        final key = '${loc.latitude.toStringAsFixed(3)},${loc.longitude.toStringAsFixed(3)}';
        if (seen.add(key)) {
          results.add(
            CitySearchResult(
              label: label,
              latitude: loc.latitude,
              longitude: loc.longitude,
            ),
          );
        }
      }

      return results;
    } catch (_) {
      throw const LocationSearchFailed();
    }
  }

  @override
  Future<UserLocation> locationFromCoordinates({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final timeZoneId = resolveTimeZoneId(latitude, longitude);
    final resolvedLabel = label ?? await _labelForCoordinates(latitude, longitude);

    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      timeZoneId: timeZoneId,
      label: resolvedLabel,
    );
  }

  Future<void> _ensurePermissionAndService() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw const LocationServiceDisabled();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedForever();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationPermissionDenied();
    }
  }

  Future<String> _labelForCoordinates(
    double latitude,
    double longitude, {
    String fallback = '',
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) {
        return fallback.isNotEmpty
            ? fallback
            : '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
      }
      final p = placemarks.first;
      final parts = <String>[
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
        if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
          p.administrativeArea!,
        if (p.country != null && p.country!.isNotEmpty) p.country!,
      ];
      if (parts.isEmpty) {
        return fallback.isNotEmpty
            ? fallback
            : '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
      }
      return parts.join(', ');
    } catch (_) {
      return fallback.isNotEmpty
          ? fallback
          : '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
    }
  }
}
