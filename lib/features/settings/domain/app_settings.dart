import 'package:equatable/equatable.dart';
import 'calculation_settings.dart';
import 'notification_settings.dart';
import 'setup_completion_status.dart';
import 'theme_mode_id.dart';
import 'time_format_id.dart';
import 'user_location.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.calculation = const CalculationSettings(),
    this.localeCode = 'en',
    this.themeMode = ThemeModeId.system,
    this.timeFormat = TimeFormatId.hour12,
    this.hijriAdjustmentDays = 0,
    this.showSunrise = true,
    this.location,
    this.notifications = const NotificationSettings(),
    this.setupDismissed = false,
  });

  final CalculationSettings calculation;
  final String localeCode;
  final ThemeModeId themeMode;
  final TimeFormatId timeFormat;
  final int hijriAdjustmentDays;
  final bool showSunrise;
  final UserLocation? location;
  final NotificationSettings notifications;
  final bool setupDismissed;

  bool get isLocationConfigured => location != null;

  SetupCompletionStatus get setup => SetupCompletionStatus(
    isCalculationConfigured: calculation.isConfigured,
    isLocationConfigured: isLocationConfigured,
  );

  AppSettings copyWith({
    CalculationSettings? calculation,
    String? localeCode,
    ThemeModeId? themeMode,
    TimeFormatId? timeFormat,
    int? hijriAdjustmentDays,
    bool? showSunrise,
    UserLocation? location,
    bool clearLocation = false,
    NotificationSettings? notifications,
    bool? setupDismissed,
  }) {
    return AppSettings(
      calculation: calculation ?? this.calculation,
      localeCode: localeCode ?? this.localeCode,
      themeMode: themeMode ?? this.themeMode,
      timeFormat: timeFormat ?? this.timeFormat,
      hijriAdjustmentDays: hijriAdjustmentDays ?? this.hijriAdjustmentDays,
      showSunrise: showSunrise ?? this.showSunrise,
      location: clearLocation ? null : (location ?? this.location),
      notifications: notifications ?? this.notifications,
      setupDismissed: setupDismissed ?? this.setupDismissed,
    );
  }

  Map<String, dynamic> toJson() => {
    'calculation': calculation.toJson(),
    'localeCode': localeCode,
    'themeMode': themeMode.name,
    'timeFormat': timeFormat.name,
    'hijriAdjustmentDays': hijriAdjustmentDays,
    'showSunrise': showSunrise,
    'location': location?.toJson(),
    'isLocationConfigured': isLocationConfigured,
    'notifications': notifications.toJson(),
    'setupDismissed': setupDismissed,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    UserLocation? location;
    if (json['location'] != null) {
      location = UserLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      );
    } else if (json['isLocationConfigured'] == true) {
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
      timeFormat: TimeFormatId.values.byName(
        json['timeFormat'] as String? ?? 'hour12',
      ),
      hijriAdjustmentDays: json['hijriAdjustmentDays'] as int? ?? 0,
      showSunrise: json['showSunrise'] as bool? ?? true,
      location: location,
      notifications: NotificationSettings.fromJson(
        json['notifications'] as Map<String, dynamic>?,
      ),
      setupDismissed: json['setupDismissed'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
    calculation,
    localeCode,
    themeMode,
    timeFormat,
    hijriAdjustmentDays,
    showSunrise,
    location,
    notifications,
    setupDismissed,
  ];
}
