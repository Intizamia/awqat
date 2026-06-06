import 'package:awqat/features/location/data/location_service.dart';
import 'package:awqat/features/location/domain/city_search_result.dart';

class FakeLocationService implements LocationService {
  FakeLocationService({
    this.gpsCoordinates = (latitude: 24.8607, longitude: 67.0011),
    this.reverseLabel,
    this.searchResults = const [],
  });

  ({double latitude, double longitude}) gpsCoordinates;
  String? reverseLabel;
  List<CitySearchResult> searchResults;

  @override
  Future<({double latitude, double longitude})> getGpsCoordinates() async =>
      gpsCoordinates;

  @override
  Future<String?> reverseGeocodeLabel(double latitude, double longitude) async =>
      reverseLabel;

  @override
  Future<List<CitySearchResult>> searchCities(String query) async {
    if (query.length < 2) return [];
    return searchResults;
  }
}
