import 'package:equatable/equatable.dart';
import '../../prayer/domain/prayer_name.dart';

/// Per-prayer notification toggles and master enable flag.
class NotificationSettings extends Equatable {
  const NotificationSettings({
    this.enabled = false,
    this.prayerEnabled = const {
      PrayerName.fajr: true,
      PrayerName.sunrise: false,
      PrayerName.dhuhr: true,
      PrayerName.asr: true,
      PrayerName.maghrib: true,
      PrayerName.isha: true,
    },
    this.preReminderEnabled = false,
    this.preReminderMinutes = 10,
  });

  final bool enabled;
  final Map<PrayerName, bool> prayerEnabled;
  final bool preReminderEnabled;
  final int preReminderMinutes;

  bool isPrayerEnabled(PrayerName name) => prayerEnabled[name] ?? false;

  NotificationSettings copyWith({
    bool? enabled,
    Map<PrayerName, bool>? prayerEnabled,
    bool? preReminderEnabled,
    int? preReminderMinutes,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      prayerEnabled: prayerEnabled ?? this.prayerEnabled,
      preReminderEnabled: preReminderEnabled ?? this.preReminderEnabled,
      preReminderMinutes: preReminderMinutes ?? this.preReminderMinutes,
    );
  }

  NotificationSettings copyWithPrayer(PrayerName name, bool value) {
    return copyWith(prayerEnabled: {...prayerEnabled, name: value});
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'prayerEnabled': {
      for (final entry in prayerEnabled.entries) entry.key.name: entry.value,
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

    return NotificationSettings(
      enabled: json['enabled'] as bool? ?? false,
      prayerEnabled: prayers.isEmpty
          ? const NotificationSettings().prayerEnabled
          : {...const NotificationSettings().prayerEnabled, ...prayers},
      preReminderEnabled: json['preReminderEnabled'] as bool? ?? false,
      preReminderMinutes: json['preReminderMinutes'] as int? ?? 10,
    );
  }

  @override
  List<Object?> get props => [enabled, prayerEnabled, preReminderEnabled, preReminderMinutes];
}
