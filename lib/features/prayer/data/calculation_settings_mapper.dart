import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/domain/prayer_offsets.dart';

class CalculationSettingsMapper {
  const CalculationSettingsMapper();

  adhan.CalculationParameters toParameters(CalculationSettings settings) {
    final method = settings.method;
    if (method == null) {
      throw StateError('Calculation method must be configured');
    }

    var params = _baseParameters(method);

    params.madhab = settings.madhab == MadhabId.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;

    params.highLatitudeRule = switch (settings.highLatitudeRule) {
      HighLatitudeRuleId.middleOfTheNight =>
        adhan.HighLatitudeRule.middleOfTheNight,
      HighLatitudeRuleId.seventhOfTheNight =>
        adhan.HighLatitudeRule.seventhOfTheNight,
      HighLatitudeRuleId.twilightAngle =>
        adhan.HighLatitudeRule.twilightAngle,
    };

    if (method == CalculationMethodId.other) {
      params = adhan.CalculationParameters(
        method: adhan.CalculationMethod.other,
        fajrAngle: settings.fajrAngle ?? 18,
        ishaAngle: settings.ishaAngle ?? 17,
        ishaInterval: settings.ishaIntervalMinutes ?? 0,
        madhab: params.madhab,
        highLatitudeRule: params.highLatitudeRule,
        adjustments: params.adjustments,
        methodAdjustments: params.methodAdjustments,
      );
    } else {
      if (settings.fajrAngle != null) {
        params.fajrAngle = settings.fajrAngle!;
      }
      if (settings.ishaAngle != null) {
        params.ishaAngle = settings.ishaAngle!;
      }
      if (settings.ishaIntervalMinutes != null) {
        params.ishaInterval = settings.ishaIntervalMinutes;
      }
    }

    params.adjustments = _buildAdjustments(
      base: params.adjustments,
      methodAdjustments: params.methodAdjustments,
      offsets: settings.prayerOffsets,
      globalOffset: settings.globalOffsetMinutes,
      ramadanIshaBoost: settings.ramadanIshaBoost &&
          method == CalculationMethodId.ummAlQura,
    );

    return params;
  }

  Map<adhan.Prayer, int> _buildAdjustments({
    required Map<adhan.Prayer, int> base,
    required Map<adhan.Prayer, int> methodAdjustments,
    required PrayerOffsets offsets,
    required int globalOffset,
    required bool ramadanIshaBoost,
  }) {
    final result = <adhan.Prayer, int>{};
    for (final prayer in adhan.Prayer.values) {
      final methodAdj = methodAdjustments[prayer] ?? 0;
      final baseAdj = base[prayer] ?? 0;
      final perPrayer = _offsetForPrayer(offsets, prayer);
      var total = baseAdj + methodAdj + perPrayer + globalOffset;
      if (ramadanIshaBoost && prayer == adhan.Prayer.isha) {
        total += 30;
      }
      result[prayer] = total;
    }
    return result;
  }

  int _offsetForPrayer(PrayerOffsets offsets, adhan.Prayer prayer) {
    return switch (prayer) {
      adhan.Prayer.fajr => offsets.fajr,
      adhan.Prayer.sunrise => offsets.sunrise,
      adhan.Prayer.dhuhr => offsets.dhuhr,
      adhan.Prayer.asr => offsets.asr,
      adhan.Prayer.maghrib => offsets.maghrib,
      adhan.Prayer.isha => offsets.isha,
      adhan.Prayer.ishaBefore || adhan.Prayer.fajrAfter => 0,
    };
  }

  adhan.CalculationParameters _baseParameters(CalculationMethodId method) {
    return switch (method) {
      CalculationMethodId.muslimWorldLeague =>
        adhan.CalculationMethodParameters.muslimWorldLeague(),
      CalculationMethodId.egyptian =>
        adhan.CalculationMethodParameters.egyptian(),
      CalculationMethodId.karachi => adhan.CalculationMethodParameters.karachi(),
      CalculationMethodId.ummAlQura =>
        adhan.CalculationMethodParameters.ummAlQura(),
      CalculationMethodId.dubai => adhan.CalculationMethodParameters.dubai(),
      CalculationMethodId.moonsightingCommittee =>
        adhan.CalculationMethodParameters.moonsightingCommittee(),
      CalculationMethodId.northAmerica =>
        adhan.CalculationMethodParameters.northAmerica(),
      CalculationMethodId.kuwait => adhan.CalculationMethodParameters.kuwait(),
      CalculationMethodId.qatar => adhan.CalculationMethodParameters.qatar(),
      CalculationMethodId.singapore =>
        adhan.CalculationMethodParameters.singapore(),
      CalculationMethodId.tehran => adhan.CalculationMethodParameters.tehran(),
      CalculationMethodId.turkey => adhan.CalculationMethodParameters.turkiye(),
      CalculationMethodId.other => adhan.CalculationMethodParameters.other(),
    };
  }
}
