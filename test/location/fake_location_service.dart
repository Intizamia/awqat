import 'package:times/features/location/data/location_service.dart';
import 'package:times/features/location/domain/city_search_result.dart';
import 'package:times/features/settings/domain/user_location.dart';

class FakeLocationService implements LocationService {
  FakeLocationService({
    this.currentLocation = kDefaultUserLocation,
    this.searchResults = const [],
  });

  UserLocation currentLocation;
  List<CitySearchResult> searchResults;

  @override
  Future<UserLocation> getCurrentLocation() async => currentLocation;

  @override
  Future<List<CitySearchResult>> searchCities(String query) async {
    if (query.length < 2) return [];
    return searchResults;
  }

  @override
  Future<UserLocation> locationFromCoordinates({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    return UserLocation(
      latitude: latitude,
      longitude: longitude,
      timeZoneId: 'Asia/Karachi',
      label: label,
    );
  }
}
