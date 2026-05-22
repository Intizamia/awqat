import 'package:equatable/equatable.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/setup_completion_status.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.calculation = const CalculationSettings(),
    this.localeCode = 'en',
    this.isLocationConfigured = false,
  });

  final CalculationSettings calculation;
  final String localeCode;
  final bool isLocationConfigured;

  SetupCompletionStatus get setup => SetupCompletionStatus(
        isCalculationConfigured: calculation.isConfigured,
        isLocationConfigured: isLocationConfigured,
      );

  AppSettings copyWith({
    CalculationSettings? calculation,
    String? localeCode,
    bool? isLocationConfigured,
  }) {
    return AppSettings(
      calculation: calculation ?? this.calculation,
      localeCode: localeCode ?? this.localeCode,
      isLocationConfigured:
          isLocationConfigured ?? this.isLocationConfigured,
    );
  }

  Map<String, dynamic> toJson() => {
        'calculation': calculation.toJson(),
        'localeCode': localeCode,
        'isLocationConfigured': isLocationConfigured,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      calculation: CalculationSettings.fromJson(
        json['calculation'] as Map<String, dynamic>? ?? {},
      ),
      localeCode: json['localeCode'] as String? ?? 'en',
      isLocationConfigured: json['isLocationConfigured'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [calculation, localeCode, isLocationConfigured];
}
