# Times — Development Progress

**Last updated:** 2026-05-22  
**Current phase:** MVP complete (Phase 9)  
**Active branch:** `feature/phase-9-polish`

## Quick status

- [x] Phase −1 Agent docs & rules
- [x] Phase 0 Foundation
- [x] Phase 1 Settings domain & persistence
- [x] Phase 2 Calculation engine + theme mode
- [x] Phase 3 Location (GPS + city search)
- [x] Phase 4 Prayer Times UI (done in Phase 2)
- [x] Phase 5 Settings UI (full calculation & display)
- [x] Phase 6 Hijri display
- [x] Phase 7 Qibla
- [x] Phase 8 Notifications
- [x] Phase 9 Polish

## Phase −1 — Agent docs

- [x] `.cursor/rules/times-project.mdc`
- [x] `.cursor/rules/times-git.mdc`
- [x] `.cursor/rules/times-flutter.mdc`
- [x] `.cursor/rules/times-settings.mdc`
- [x] `AGENTS.md`
- [x] `docs/PROGRESS.md`

## Phase 0 — Foundation

- [x] Dependencies in `pubspec.yaml`
- [x] `lib/` folder structure
- [x] M3 green theme
- [x] go_router + 3-tab NavigationBar
- [x] l10n ARB (en, ur, ar)
- [x] Placeholder feature screens (prayer setup CTA, coming soon, settings)
- [x] `SettingsCubit` + `SetupCompletionStatus` skeleton
- [x] `flutter analyze` clean
- [x] Basic widget test

## Post-MVP backlog

See [`docs/BACKLOG.md`](BACKLOG.md).

## Phase 1 — Settings domain

- [x] `CalculationMethodId`, `MadhabId`, `HighLatitudeRuleId`
- [x] `CalculationSettings` + `AppSettings` JSON serialization
- [x] `SettingsRepository` (shared_preferences)
- [x] `SettingsCubit` wired to persistence
- [x] Method picker in Settings UI

## Phase 2 — Calculation engine

- [x] `CalculationSettingsMapper` → adhan_dart
- [x] `AdhanCalculationEngine` + `PrayerSchedule`
- [x] `PrayerTimesCubit` + prayer list UI (next prayer card)
- [x] `UserLocation` model (placeholder Karachi until Phase 3)
- [x] Theme mode: System / Light / Dark (persisted, end of Settings)
- [x] Unit tests (mapper + engine + app settings theme)

## Phase 3 — Location

- [x] `geolocator` + `geocoding` + `lat_lng_to_timezone`
- [x] `GeolocatorLocationService` + `LocationCubit`
- [x] Settings location section (GPS, city search, clear)
- [x] Android/iOS location permissions
- [x] Prayer times refresh on location change + app resume
- [x] High-latitude hint (|lat| > 48°)
- [x] Tests (timezone resolver, location cubit)

## Phase 5 — Settings UI

- [x] Grouped sections: Calculation, Advanced, Location, Display, Appearance
- [x] Madhab + high-latitude rule pickers
- [x] Custom angles, global/per-prayer offsets, Ramadan Isha boost
- [x] Time format 12h/24h, show Sunrise, Hijri adjustment (−2..+2)
- [x] First-run calculation method dialog (non-dismissible)
- [x] Reset calculation / reset display actions
- [x] Prayer list respects display settings

## Phase 6 — Hijri display

- [x] `hijri` package (Umm al-Qura tabular)
- [x] `PrayerDateHeader` — Gregorian + Hijri on prayer screen
- [x] Hijri adjustment (−2..+2) wired from settings
- [x] Localized date symbols (en, ar, ur)
- [x] Unit tests for Hijri formatting

## Phase 7 — Qibla

- [x] `flutter_qiblah` + `adhan_dart` Qibla bearing from saved location
- [x] `QiblaScreen` with live compass dial (`flutter_compass_v2`)
- [x] Static bearing fallback when sensor unavailable
- [x] Route `/qibla` + compass action on Prayer Times app bar
- [x] l10n (en, ur, ar)
- [x] Unit tests for bearing + pointer math

## Phase 8 — Notifications

- [x] `flutter_local_notifications` + `timezone` (zoned schedules)
- [x] `NotificationSettings` master + per-prayer toggles (persisted)
- [x] `PrayerNotificationService` schedules next 3 days; reschedules on change/resume
- [x] Settings notifications section + permission prompt
- [x] Android exact-alarm manifest, boot receiver, desugaring
- [x] l10n (en, ur, ar); system default sound
- [x] Unit tests (settings, planner)

## Phase 9 — Polish

- [x] Brand app icon + native splash (`#2E7D32`, `assets/branding/icon.png`)
- [x] RTL locale config + explicit directionality for ar/ur
- [x] Accessibility semantics (next prayer, prayer rows, setup, Qibla)
- [x] Theme tap targets + page transitions
- [x] Integration test (configured app shows timetable)
- [x] `docs/BACKLOG.md`, README MVP feature list

## Session notes

- **2026-05-22:** Phase 9 on `feature/phase-9-polish`. **MVP roadmap complete.**
