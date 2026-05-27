import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awqat/features/location/data/location_service.dart';
import 'package:awqat/features/location/domain/city_search_result.dart';
import 'package:awqat/features/location/domain/location_exception.dart';
import 'package:awqat/features/location/presentation/location_state.dart';
import 'package:awqat/features/settings/domain/user_location.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    required LocationService locationService,
    required SettingsCubit settingsCubit,
  }) : _locationService = locationService,
       _settingsCubit = settingsCubit,
       super(const LocationState());

  final LocationService _locationService;
  final SettingsCubit _settingsCubit;

  Future<void> useCurrentLocation() async {
    emit(
      state.copyWith(
        isAcquiringGps: true,
        clearError: true,
        clearResults: true,
      ),
    );
    try {
      final location = await _locationService.getCurrentLocation();
      await _settingsCubit.setLocation(location);
      emit(state.copyWith(isAcquiringGps: false));
    } on LocationException catch (e) {
      emit(state.copyWith(isAcquiringGps: false, errorMessage: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isAcquiringGps: false,
          errorMessage: const LocationGpsFailed().message,
        ),
      );
    }
  }

  void beginSearch() {
    emit(
      state.copyWith(
        isSearching: true,
        searchReturnedEmpty: false,
        clearResults: true,
        clearError: true,
      ),
    );
  }

  Future<void> searchCities(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      emit(
        state.copyWith(
          clearResults: true,
          clearError: true,
          isSearching: false,
          searchReturnedEmpty: false,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSearching: true,
        clearError: true,
        clearResults: true,
        searchReturnedEmpty: false,
      ),
    );
    try {
      final results = await _locationService.searchCities(trimmed);
      emit(
        state.copyWith(
          isSearching: false,
          searchResults: results,
          searchReturnedEmpty: results.isEmpty,
        ),
      );
    } on LocationException catch (e) {
      emit(
        state.copyWith(
          isSearching: false,
          clearResults: true,
          searchReturnedEmpty: false,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSearching: false,
          clearResults: true,
          searchReturnedEmpty: false,
          errorMessage: const LocationSearchFailed().message,
        ),
      );
    }
  }

  Future<void> selectSearchResult(CitySearchResult result) async {
    emit(state.copyWith(isSearching: true, clearError: true));
    try {
      final location = await _locationService.locationFromCoordinates(
        latitude: result.latitude,
        longitude: result.longitude,
        label: result.label,
      );
      await _settingsCubit.setLocation(location);
      emit(state.copyWith(isSearching: false, clearResults: true));
    } catch (_) {
      emit(
        state.copyWith(
          isSearching: false,
          errorMessage: const LocationSearchFailed().message,
        ),
      );
    }
  }

  void clearSearch() {
    emit(
      state.copyWith(
        clearResults: true,
        clearError: true,
        isSearching: false,
        searchReturnedEmpty: false,
      ),
    );
  }

  Future<void> clearLocation() async {
    await _settingsCubit.clearLocation();
    clearSearch();
  }
}

/// Whether high-latitude adjustment may be needed (|lat| > 48°).
bool shouldSuggestHighLatitudeRule(UserLocation location) {
  return location.latitude.abs() > 48;
}
