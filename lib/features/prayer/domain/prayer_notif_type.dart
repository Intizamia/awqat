enum PrayerNotifType { none, reminder, takbir, fullAthan }

extension PrayerNotifTypeX on PrayerNotifType {
  String get label {
    switch (this) {
      case PrayerNotifType.none:
        return 'None';
      case PrayerNotifType.reminder:
        return 'Reminder';
      case PrayerNotifType.takbir:
        return 'Takbīr';
      case PrayerNotifType.fullAthan:
        return 'Full Athan';
    }
  }
}
