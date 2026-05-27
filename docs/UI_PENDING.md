# UI Pending Items

Items from the Cohere design that need additional implementation work beyond the current UI shell.

---

## Notifications (prayer_times_screen)

**Design**: Per-prayer notification button on each row opens a pop-up with 4 types:
- `silent` — no audible alert
- `reminder` — standard notification tone
- `first` — plays first sentence of Adhan
- `full` — plays full Adhan (~2 min)

**Current state**: Icon shows on/off state only (binary, matching existing `NotificationSettings` domain).

**Required work**:
1. Add `NotificationType` enum: `silent | reminder | firstSentence | fullAdhan`
2. Extend `NotificationSettings.prayerEnabled: Map<PrayerName, bool>` → `prayerTypes: Map<PrayerName, NotificationType>`
3. Implement audio playback for `firstSentence` and `fullAdhan` types
4. Update notification service to schedule correct sound per prayer
5. Wire pop-up `NotifPop` UI on each `_PrayerRow` tapping the bell icon

---

## Notifications — Pre-prayer reminder toggle

**Design**: Toggle in Notifications settings — "Notify 10 minutes before each prayer"

**Current state**: UI not implemented. No domain field.

**Required work**:
1. Add `bool preReminderEnabled` to `NotificationSettings`
2. Persist and schedule a 10-min-before notification alongside the prayer time notification
3. Add toggle row to `NotificationsSettingsScreen`

---

## Notifications — Silent during Friday Khutbah

**Design**: Toggle — "Silent during Friday Khutbah"

**Current state**: UI not implemented. No domain field.

**Required work**:
1. Add `bool fridayKhutbahSilent` to `NotificationSettings`
2. Implement logic to suppress Dhuhr notification on Friday between Adhan and estimated Khutbah end
3. Add toggle row to `NotificationsSettingsScreen`

---

## Discover — Coming Soon features

Three placeholder rows in `DiscoverScreen` are UI-only:
- **Quran Reader** — Read with translations, bookmarks, tafsir
- **Digital Tasbih** — Counter for dhikr
- **Mosques Nearby** — Find prayer spaces around you

All show "SOON" tag and are disabled. No implementation planned yet.

---

## Qibla — Distance to Makkah

**Current state**: Distance calculated via Haversine and displayed in `_QiblaInfoRow`.

**Note**: Distance displayed as km and miles. No further work needed unless the design adds route/map view.

---

## Prayer Times — Variation B and C

Design shows 3 variations (A=Editorial, B=Dark band hero, C=Timeline). 

**Current state**: Only Variation A (editorial list) is implemented.

**Required work** (if desired):
- User preference toggle to switch between layouts
- Implement B: dark hero band with large prayer name + countdown
- Implement C: proportional timeline view

---

## Settings — Location screen back label

**Current state**: Back button on location screen shows hardcoded "Settings" string.

**Required work**: Conditionally show "Settings" vs "Setup" depending on `popOnSelect` mode or navigation context.
