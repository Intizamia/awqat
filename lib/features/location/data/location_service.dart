import '../domain/city_search_result.dart';
import '../../settings/domain/user_location.dart';

/// Resolves GPS position and city search into [UserLocation].
abstract class LocationService {
  Future<UserLocation> getCurrentLocation();

  Future<List<CitySearchResult>> searchCities(String query);

  Future<UserLocation> locationFromCoordinates({
    required double latitude,
    required double longitude,
    String? label,
  });
}
