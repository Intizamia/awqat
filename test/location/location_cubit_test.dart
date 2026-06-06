import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awqat/features/location/domain/city_search_result.dart';
import 'package:awqat/features/location/presentation/location_cubit.dart';
import 'package:awqat/features/location/presentation/location_state.dart';
import 'package:awqat/features/settings/data/settings_repository.dart';
import 'package:awqat/features/settings/presentation/settings_cubit.dart';

import 'fake_location_service.dart';

void main() {
  late SettingsRepository repository;
  late SettingsCubit settingsCubit;
  late FakeLocationService fakeLocation;
  late LocationCubit locationCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    repository = await SettingsRepository.create();
    settingsCubit = SettingsCubit(repository);
    await settingsCubit.load();
    fakeLocation = FakeLocationService(
      searchResults: const [
        CitySearchResult(
          label: 'London, UK',
          latitude: 51.5074,
          longitude: -0.1278,
        ),
      ],
    );
    locationCubit = LocationCubit(
      locationService: fakeLocation,
      settingsCubit: settingsCubit,
    );
  });

  blocTest<LocationCubit, LocationState>(
    'useCurrentLocation saves location to settings',
    build: () => locationCubit,
    act: (cubit) => cubit.useCurrentLocation(),
    verify: (_) {
      expect(settingsCubit.state.settings.location, isNotNull);
      expect(
        settingsCubit.state.settings.location!.latitude,
        fakeLocation.gpsCoordinates.latitude,
      );
    },
  );

  blocTest<LocationCubit, LocationState>(
    'selectSearchResult saves chosen city',
    build: () => locationCubit,
    seed: () => const LocationState(
      searchResults: [
        CitySearchResult(
          label: 'London, UK',
          latitude: 51.5074,
          longitude: -0.1278,
        ),
      ],
    ),
    act: (cubit) => cubit.selectSearchResult(
      const CitySearchResult(
        label: 'London, UK',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
    ),
    verify: (_) {
      expect(settingsCubit.state.settings.isLocationConfigured, isTrue);
    },
  );
}
