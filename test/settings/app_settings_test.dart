import 'package:flutter_test/flutter_test.dart';
import 'package:times/features/settings/domain/app_settings.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/domain/user_location.dart';

void main() {
  test('AppSettings round-trip includes theme and location', () {
    const original = AppSettings(
      calculation: CalculationSettings(method: CalculationMethodId.karachi),
      localeCode: 'ur',
      themeMode: ThemeModeId.dark,
      location: kDefaultUserLocation,
    );

    final restored = AppSettings.fromJson(original.toJson());

    expect(restored.themeMode, ThemeModeId.dark);
    expect(restored.localeCode, 'ur');
    expect(restored.location?.latitude, kDefaultUserLocation.latitude);
    expect(restored.setup.isComplete, isTrue);
  });
}
