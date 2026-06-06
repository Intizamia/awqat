import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/timezone_resolver.dart';
import '../data/location_service.dart';
import '../domain/city_entry.dart';
import '../domain/city_search_result.dart';
import '../domain/location_exception.dart';
import 'location_state.dart';
import '../../settings/domain/user_location.dart';
import '../../settings/presentation/settings_cubit.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required LocationService locationService,
    required SettingsCubit settingsCubit,
  })  : _locationService = locationService,
        _settingsCubit = settingsCubit,
        super(const LocationState());

  final LocationService _locationService;
  final SettingsCubit _settingsCubit;

  Future<void> useCurrentLocation() async {
    emit(state.copyWith(isAcquiringGps: true, clearError: true));
    try {
      final coords = await _locationService.getGpsCoordinates();
      final tzId = resolveTimeZoneId(coords.latitude, coords.longitude);
      final preliminary = UserLocation(
        latitude: coords.latitude,
        longitude: coords.longitude,
        timeZoneId: tzId,
        label: 'Detected — loading name',
      );
      await _settingsCubit.setLocation(preliminary);
      emit(state.copyWith(isAcquiringGps: false, isResolvingName: true));
      _resolveNameInBackground(coords.latitude, coords.longitude);
    } on LocationException catch (e) {
      emit(state.copyWith(isAcquiringGps: false, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        isAcquiringGps: false,
        errorMessage: const LocationGpsFailed().message,
      ));
    }
  }

  Future<void> selectManualCoordinates(double lat, double lon) async {
    final tzId = resolveTimeZoneId(lat, lon);
    final preliminary = UserLocation(
      latitude: lat,
      longitude: lon,
      timeZoneId: tzId,
      label: 'Detected — loading name',
    );
    await _settingsCubit.setLocation(preliminary);
    emit(state.copyWith(isResolvingName: true));
    _resolveNameInBackground(lat, lon);
  }

  Future<void> selectCity(CityEntry city) async {
    final tzId = resolveTimeZoneId(city.latitude, city.longitude);
    final location = UserLocation(
      latitude: city.latitude,
      longitude: city.longitude,
      timeZoneId: tzId,
      label: '${city.city}, ${city.country}',
    );
    await _settingsCubit.setLocation(location);
  }

  Future<void> selectSearchResult(CitySearchResult result) async {
    emit(state.copyWith(clearError: true));
    try {
      final tzId = resolveTimeZoneId(result.latitude, result.longitude);
      final location = UserLocation(
        latitude: result.latitude,
        longitude: result.longitude,
        timeZoneId: tzId,
        label: result.label,
      );
      await _settingsCubit.setLocation(location);
      emit(state.copyWith(clearResults: true, isSearching: false));
    } catch (_) {
      emit(state.copyWith(errorMessage: const LocationSearchFailed().message));
    }
  }

  void beginSearch() {
    emit(state.copyWith(
      isSearching: true,
      searchReturnedEmpty: false,
      clearResults: true,
      clearError: true,
    ));
  }

  Future<void> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      emit(state.copyWith(
        clearResults: true,
        clearError: true,
        isSearching: false,
        searchReturnedEmpty: false,
      ));
      return;
    }
    emit(state.copyWith(
      isSearching: true,
      clearError: true,
      clearResults: true,
      searchReturnedEmpty: false,
    ));
    try {
      final results = await _locationService.searchCities(trimmed);
      emit(state.copyWith(
        isSearching: false,
        searchResults: results,
        searchReturnedEmpty: results.isEmpty,
      ));
    } on LocationException catch (e) {
      emit(state.copyWith(
        isSearching: false,
        clearResults: true,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSearching: false,
        clearResults: true,
        errorMessage: const LocationSearchFailed().message,
      ));
    }
  }

  void clearSearch() {
    emit(state.copyWith(
      clearResults: true,
      clearError: true,
      isSearching: false,
      searchReturnedEmpty: false,
    ));
  }

  Future<void> clearLocation() async {
    await _settingsCubit.clearLocation();
    emit(state.copyWith(isResolvingName: false));
  }

  void _resolveNameInBackground(double lat, double lon) {
    _locationService.reverseGeocodeLabel(lat, lon).then((label) {
      if (isClosed) return;
      final current = _settingsCubit.state.settings.location;
      if (current == null) return;
      final updated = current.copyWith(
        label: label ?? 'Detected — name unavailable',
      );
      _settingsCubit.setLocation(updated);
      emit(state.copyWith(isResolvingName: false));
    }).catchError((_) {
      if (isClosed) return;
      final current = _settingsCubit.state.settings.location;
      if (current == null) return;
      _settingsCubit.setLocation(
        current.copyWith(label: 'Detected — name unavailable'),
      );
      emit(state.copyWith(isResolvingName: false));
    });
  }
}

bool shouldSuggestHighLatitudeRule(UserLocation location) {
  return location.latitude.abs() > 48;
}
