import '../domain/city_search_result.dart';

abstract class LocationService {
  /// Returns GPS lat/lon — no reverse geocoding (fast).
  Future<({double latitude, double longitude})> getGpsCoordinates();

  /// Reverse geocode a human-readable label. Returns null if unavailable.
  Future<String?> reverseGeocodeLabel(double latitude, double longitude);

  /// Search cities via Nominatim.
  Future<List<CitySearchResult>> searchCities(String query);
}
