import 'package:equatable/equatable.dart';
import 'package:times/features/settings/domain/calculation_settings.dart';
import 'package:times/features/settings/domain/setup_completion_status.dart';
import 'package:times/features/settings/domain/theme_mode_id.dart';
import 'package:times/features/settings/domain/user_location.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.calculation = const CalculationSettings(),
    this.localeCode = 'en',
    this.themeMode = ThemeModeId.system,
    this.location,
  });

  final CalculationSettings calculation;
  final String localeCode;
  final ThemeModeId themeMode;
  final UserLocation? location;

  bool get isLocationConfigured => location != null;

  SetupCompletionStatus get setup => SetupCompletionStatus(
        isCalculationConfigured: calculation.isConfigured,
        isLocationConfigured: isLocationConfigured,
      );

  AppSettings copyWith({
    CalculationSettings? calculation,
    String? localeCode,
    ThemeModeId? themeMode,
    UserLocation? location,
    bool clearLocation = false,
  }) {
    return AppSettings(
      calculation: calculation ?? this.calculation,
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      location: clearLocation ? null : (location ?? this.location),
    );
  }

  Map<String, dynamic> toJson() => {
        'calculation': calculation.toJson(),
        'localeCode': localeCode,
        'themeMode': themeMode.name,
        'location': location?.toJson(),
        'isLocationConfigured': isLocationConfigured,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    UserLocation? location;
    if (json['location'] != null) {
      location = UserLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      );
    } else if (json['isLocationConfigured'] == true) {
      // Migrate legacy flag-only saves.
      location = kDefaultUserLocation;
    }

    return AppSettings(
      calculation: CalculationSettings.fromJson(
        json['calculation'] as Map<String, dynamic>? ?? {},
      ),
      localeCode: json['localeCode'] as String? ?? 'en',
      themeMode: ThemeModeId.values.byName(
        json['themeMode'] as String? ?? 'system',
      ),
      location: location,
    );
  }

  @override
  List<Object?> get props => [calculation, localeCode, themeMode, location];
}
