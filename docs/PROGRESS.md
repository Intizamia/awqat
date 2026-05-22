# Times — Development Progress

**Last updated:** 2026-05-22  
**Current phase:** Phase 2 complete → Phase 3 next  
**Active branch:** `feature/phase-2-calculation`

## Quick status

- [x] Phase −1 Agent docs & rules
- [x] Phase 0 Foundation
- [x] Phase 1 Settings domain & persistence
- [x] Phase 2 Calculation engine + theme mode
- [ ] Phase 3 Location
- [ ] Phase 4 Prayer Times UI
- [ ] Phase 5 Settings UI
- [ ] Phase 6 Hijri display
- [ ] Phase 7 Qibla
- [ ] Phase 8 Notifications
- [ ] Phase 9 Polish

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

- Middle nav real feature
- Aladhan / IslamicFinder API sources
- Home screen widgets
- Custom adhan sounds
- M3 Expressive tokens
- More languages

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

## Session notes

- **2026-05-22:** Phase 2 on `feature/phase-2-calculation` — live prayer times when method + location set; theme toggle at bottom of Settings. Next: Phase 3 GPS/city picker.
