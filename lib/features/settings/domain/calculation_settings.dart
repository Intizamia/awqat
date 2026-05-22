import 'package:equatable/equatable.dart';
import 'package:times/features/settings/domain/calculation_method_id.dart';
import 'package:times/features/settings/domain/high_latitude_rule_id.dart';
import 'package:times/features/settings/domain/madhab_id.dart';

class CalculationSettings extends Equatable {
  const CalculationSettings({
    this.method,
    this.madhab = MadhabId.shafi,
    this.highLatitudeRule = HighLatitudeRuleId.twilightAngle,
    this.fajrAngle,
    this.ishaAngle,
    this.ishaIntervalMinutes,
    this.globalOffsetMinutes = 0,
  });

  /// Null until user explicitly chooses (first-run requirement).
  final CalculationMethodId? method;
  final MadhabId madhab;
  final HighLatitudeRuleId highLatitudeRule;
  final double? fajrAngle;
  final double? ishaAngle;
  final int? ishaIntervalMinutes;
  final int globalOffsetMinutes;

  bool get isConfigured => method != null;

  CalculationSettings copyWith({
    CalculationMethodId? method,
    bool clearMethod = false,
    MadhabId? madhab,
    HighLatitudeRuleId? highLatitudeRule,
    double? fajrAngle,
    double? ishaAngle,
    int? ishaIntervalMinutes,
    int? globalOffsetMinutes,
  }) {
    return CalculationSettings(
      method: clearMethod ? null : (method ?? this.method),
      madhab: madhab ?? this.madhab,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaAngle: ishaAngle ?? this.ishaAngle,
      ishaIntervalMinutes: ishaIntervalMinutes ?? this.ishaIntervalMinutes,
      globalOffsetMinutes: globalOffsetMinutes ?? this.globalOffsetMinutes,
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
      ];
}
