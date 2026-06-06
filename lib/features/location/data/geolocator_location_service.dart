import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'location_service.dart';
import '../domain/city_search_result.dart';
import '../domain/location_exception.dart';

class GeolocatorLocationService implements LocationService {
  static const _userAgent = 'Awqat Prayer Times/1.0';

  @override
  Future<({double latitude, double longitude})> getGpsCoordinates() async {
    await _ensurePermissionAndService();

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );

    return (latitude: position.latitude, longitude: position.longitude);
  }

  @override
  Future<String?> reverseGeocodeLabel(
    double latitude,
    double longitude,
  ) async {
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'format': 'jsonv2',
        'addressdetails': '1',
      });

      final body = await _get(uri);
      final json = jsonDecode(body) as Map<String, dynamic>;
      final label = _labelFromAddress(json['address'] as Map<String, dynamic>?);
      return label.isEmpty ? null : label;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<CitySearchResult>> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return [];

    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': trimmed,
        'format': 'jsonv2',
        'limit': '5',
        'addressdetails': '1',
      });

      final body = await _get(uri);
      final list = jsonDecode(body) as List<dynamic>;

      final results = <CitySearchResult>[];
      final seen = <String>{};

      for (final raw in list) {
        final map = raw as Map<String, dynamic>;
        final lat = double.tryParse(map['lat'] as String? ?? '');
        final lon = double.tryParse(map['lon'] as String? ?? '');
        if (lat == null || lon == null) continue;

        final label = _labelFromAddress(
          map['address'] as Map<String, dynamic>?,
          fallback: trimmed,
        );
        final key = '${lat.toStringAsFixed(3)},${lon.toStringAsFixed(3)}';
        if (seen.add(key)) {
          results.add(
            CitySearchResult(label: label, latitude: lat, longitude: lon),
          );
        }
      }

      return results;
    } catch (_) {
      throw const LocationSearchFailed();
    }
  }

  Future<void> _ensurePermissionAndService() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw const LocationServiceDisabled();

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

  String _labelFromAddress(
    Map<String, dynamic>? address, {
    String fallback = '',
  }) {
    if (address == null) return fallback;

    final city = address['city'] as String? ??
        address['town'] as String? ??
        address['village'] as String? ??
        address['municipality'] as String?;
    final state =
        address['state'] as String? ?? address['region'] as String?;
    final country = address['country'] as String?;

    final parts = <String>[
      if (city != null && city.isNotEmpty) city,
      if (state != null && state.isNotEmpty) state,
      if (country != null && country.isNotEmpty) country,
    ];

    return parts.isEmpty ? fallback : parts.join(', ');
  }

  Future<String> _get(Uri uri) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(uri);
      request.headers
        ..set(HttpHeaders.userAgentHeader, _userAgent)
        ..set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      if (response.statusCode != 200) {
        throw Exception('Nominatim HTTP ${response.statusCode}');
      }
      return await response.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}
