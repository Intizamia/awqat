import 'package:equatable/equatable.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';
import 'package:times/features/settings/domain/prayer_offsets.dart';

class CalculationSettings extends Equatable {
  const CalculationSettings({
    this.method,
    this.madhab = MadhabId.shafi,
    this.highLatitudeRule = HighLatitudeRuleId.twilightAngle,
    this.fajrAngle,
    this.ishaAngle,
    this.ishaIntervalMinutes,
    this.globalOffsetMinutes = 0,
    this.prayerOffsets = const PrayerOffsets(),
    this.ramadanIshaBoost = false,
  });

  /// Null until user explicitly chooses (first-run requirement).
  final CalculationMethodId? method;
  final MadhabId madhab;
  final HighLatitudeRuleId highLatitudeRule;
  final double? fajrAngle;
  final double? ishaAngle;
  final int? ishaIntervalMinutes;
  final int globalOffsetMinutes;
  final PrayerOffsets prayerOffsets;

  /// +30 min to Isha during Ramadan (recommended for Umm Al-Qura).
  final bool ramadanIshaBoost;

  bool get isConfigured => method != null;

  bool get isCustomMethod => method == CalculationMethodId.other;

  CalculationSettings copyWith({
    CalculationMethodId? method,
    bool clearMethod = false,
    MadhabId? madhab,
    HighLatitudeRuleId? highLatitudeRule,
    double? fajrAngle,
    bool clearFajrAngle = false,
    double? ishaAngle,
    bool clearIshaAngle = false,
    int? ishaIntervalMinutes,
    bool clearIshaInterval = false,
    int? globalOffsetMinutes,
    PrayerOffsets? prayerOffsets,
    bool? ramadanIshaBoost,
  }) {
    return CalculationSettings(
      method: clearMethod ? null : (method ?? this.method),
      madhab: madhab ?? this.madhab,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      fajrAngle: clearFajrAngle ? null : (fajrAngle ?? this.fajrAngle),
      ishaAngle: clearIshaAngle ? null : (ishaAngle ?? this.ishaAngle),
      ishaIntervalMinutes: clearIshaInterval
          ? null
          : (ishaIntervalMinutes ?? this.ishaIntervalMinutes),
      globalOffsetMinutes: globalOffsetMinutes ?? this.globalOffsetMinutes,
      prayerOffsets: prayerOffsets ?? this.prayerOffsets,
      ramadanIshaBoost: ramadanIshaBoost ?? this.ramadanIshaBoost,
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method?.name,
        'madhab': madhab.name,
        'highLatitudeRule': highLatitudeRule.name,
        'fajrAngle': fajrAngle,
        'ishaAngle': ishaAngle,
        'ishaIntervalMinutes': ishaIntervalMinutes,
        'globalOffsetMinutes': globalOffsetMinutes,
        'prayerOffsets': prayerOffsets.toJson(),
        'ramadanIshaBoost': ramadanIshaBoost,
      };

  factory CalculationSettings.fromJson(Map<String, dynamic> json) {
    return CalculationSettings(
      method: json['method'] != null
          ? CalculationMethodId.values.byName(json['method'] as String)
          : null,
      madhab: MadhabId.values.byName(json['madhab'] as String? ?? 'shafi'),
      highLatitudeRule: HighLatitudeRuleId.values.byName(
        json['highLatitudeRule'] as String? ?? 'twilightAngle',
      ),
      fajrAngle: (json['fajrAngle'] as num?)?.toDouble(),
      ishaAngle: (json['ishaAngle'] as num?)?.toDouble(),
      ishaIntervalMinutes: json['ishaIntervalMinutes'] as int?,
      globalOffsetMinutes: json['globalOffsetMinutes'] as int? ?? 0,
      prayerOffsets: PrayerOffsets.fromJson(
        json['prayerOffsets'] as Map<String, dynamic>?,
      ),
      ramadanIshaBoost: json['ramadanIshaBoost'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        method,
        madhab,
        highLatitudeRule,
        fajrAngle,
        ishaAngle,
        ishaIntervalMinutes,
        globalOffsetMinutes,
        prayerOffsets,
        ramadanIshaBoost,
      ];
}
