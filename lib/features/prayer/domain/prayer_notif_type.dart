enum PrayerNotifType { silent, reminder, firstSentence, fullAthan }

extension PrayerNotifTypeX on PrayerNotifType {
  String get label {
    switch (this) {
      case PrayerNotifType.silent:
        return 'Silent';
      case PrayerNotifType.reminder:
        return 'Reminder';
      case PrayerNotifType.firstSentence:
        return 'First Sentence';
      case PrayerNotifType.fullAthan:
        return 'Full Athan';
    }
  }
}
