import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:flutter_test/flutter_test.dart';
import 'package:times/features/prayer/data/adhan_calculation_engine.dart';
import 'package:times/features/prayer/data/calculation_settings_mapper.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/domain/prayer_offsets.dart';
import 'package:times/features/settings/domain/user_location.dart';

void main() {
  const mapper = CalculationSettingsMapper();
  final engine = AdhanCalculationEngine(mapper: mapper);

  test('maps Karachi method to adhan parameters', () {
    const settings = CalculationSettings(
      method: CalculationMethodId.karachi,
      madhab: MadhabId.shafi,
    );

    final params = mapper.toParameters(settings);

    expect(params.method, adhan.CalculationMethod.karachi);
    expect(params.fajrAngle, 18);
    expect(params.ishaAngle, 18);
    expect(params.madhab, adhan.Madhab.shafi);
  });

  test('applies per-prayer and global offsets', () {
    const settings = CalculationSettings(
      method: CalculationMethodId.karachi,
      globalOffsetMinutes: 2,
      prayerOffsets: PrayerOffsets(fajr: 3, isha: -1),
    );

    final params = mapper.toParameters(settings);

    expect(params.adjustments[adhan.Prayer.fajr], greaterThan(2));
    expect(params.adjustments[adhan.Prayer.isha], isNot(0));
  });

  test('maps Hanafi madhab and high latitude rule', () {
    const settings = CalculationSettings(
      method: CalculationMethodId.muslimWorldLeague,
      madhab: MadhabId.hanafi,
      highLatitudeRule: HighLatitudeRuleId.seventhOfTheNight,
    );

    final params = mapper.toParameters(settings);

    expect(params.madhab, adhan.Madhab.hanafi);
    expect(params.highLatitudeRule, adhan.HighLatitudeRule.seventhOfTheNight);
  });

  test('computes six prayer times for Karachi on fixed date', () {
    const settings = CalculationSettings(method: CalculationMethodId.karachi);
    final date = DateTime(2026, 5, 22);

    final schedule = engine.compute(
      date: date,
      location: kDefaultUserLocation,
      calculation: settings,
    );

    expect(schedule.entries, hasLength(6));
    expect(schedule.nextPrayer, isNotNull);
    for (final entry in schedule.entries) {
      expect(entry.time.year, 2026);
    }
  });
}
