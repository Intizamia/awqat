import 'package:equatable/equatable.dart';
import '../../prayer/domain/prayer_name.dart';
import '../../prayer/domain/prayer_notif_type.dart';

/// Per-prayer notification toggles and master enable flag.
class NotificationSettings extends Equatable {
  const NotificationSettings({
    this.enabled = false,
    this.onboardingDone = false,
    this.prayerEnabled = const {
      PrayerName.fajr: true,
      PrayerName.sunrise: false,
      PrayerName.dhuhr: true,
      PrayerName.asr: true,
      PrayerName.maghrib: true,
      PrayerName.isha: true,
    },
    this.prayerNotifType = const {
      PrayerName.fajr: PrayerNotifType.none,
      PrayerName.sunrise: PrayerNotifType.none,
      PrayerName.dhuhr: PrayerNotifType.none,
      PrayerName.asr: PrayerNotifType.none,
      PrayerName.maghrib: PrayerNotifType.none,
      PrayerName.isha: PrayerNotifType.none,
    },
    this.preReminderEnabled = false,
    this.preReminderMinutes = 10,
  });

  final bool enabled;
  final bool onboardingDone;
  final Map<PrayerName, bool> prayerEnabled;
  final Map<PrayerName, PrayerNotifType> prayerNotifType;
  final bool preReminderEnabled;
  final int preReminderMinutes;

  bool isPrayerEnabled(PrayerName name) => prayerEnabled[name] ?? false;

  PrayerNotifType notifTypeFor(PrayerName name) =>
      prayerNotifType[name] ?? PrayerNotifType.none;

  NotificationSettings copyWith({
    bool? enabled,
    bool? onboardingDone,
    Map<PrayerName, bool>? prayerEnabled,
    Map<PrayerName, PrayerNotifType>? prayerNotifType,
    bool? preReminderEnabled,
    int? preReminderMinutes,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      prayerEnabled: prayerEnabled ?? this.prayerEnabled,
      prayerNotifType: prayerNotifType ?? this.prayerNotifType,
      preReminderEnabled: preReminderEnabled ?? this.preReminderEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
    );
  }

  NotificationSettings copyWithPrayer(PrayerName name, bool value) {
    return copyWith(prayerEnabled: {...prayerEnabled, name: value});
  }

  NotificationSettings copyWithNotifType(PrayerName name, PrayerNotifType type) {
    return copyWith(prayerNotifType: {...prayerNotifType, name: type});
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'onboardingDone': onboardingDone,
    'prayerEnabled': {
      for (final entry in prayerEnabled.entries) entry.key.name: entry.value,
    },
    'prayerNotifType': {
      for (final entry in prayerNotifType.entries) entry.key.name: entry.value.name,
    },
    'preReminderEnabled': preReminderEnabled,
    'preReminderMinutes': preReminderMinutes,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NotificationSettings();

    final raw = json['prayerEnabled'] as Map<String, dynamic>?;
    final prayers = <PrayerName, bool>{};
    if (raw != null) {
      for (final name in PrayerName.values) {
        if (raw.containsKey(name.name)) {
          prayers[name] = raw[name.name] as bool? ?? false;
        }
      }
    }

    final rawTypes = json['prayerNotifType'] as Map<String, dynamic>?;
    final notifTypes = <PrayerName, PrayerNotifType>{};
    if (rawTypes != null) {
      for (final name in PrayerName.values) {
        if (rawTypes.containsKey(name.name)) {
          final str = rawTypes[name.name] as String?;
          notifTypes[name] = PrayerNotifType.values.firstWhere(
            (t) => t.name == str,
            orElse: () => PrayerNotifType.none,
          );
        }
      }
    }

    return NotificationSettings(
      enabled: json['enabled'] as bool? ?? false,
      onboardingDone: json['onboardingDone'] as bool? ?? false,
      prayerEnabled: prayers.isEmpty
          ? const NotificationSettings().prayerEnabled
          : {...const NotificationSettings().prayerEnabled, ...prayers},
      prayerNotifType: notifTypes.isEmpty
          ? const NotificationSettings().prayerNotifType
          : {...const NotificationSettings().prayerNotifType, ...notifTypes},
      preReminderEnabled: json['preReminderEnabled'] as bool? ?? false,
      preReminderMinutes: json['preReminderMinutes'] as int? ?? 10,
    );
  }

  @override
  List<Object?> get props => [
    enabled,
    onboardingDone,
    prayerEnabled,
    prayerNotifType,
    preReminderEnabled,
    preReminderMinutes,
  ];
}
