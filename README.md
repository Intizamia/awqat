# Awqat

Offline-first Islamic prayer times app for Android and iOS. Built with Flutter, Material 3, and `flutter_bloc`.

## Development

```bash
flutter pub get
flutter gen-l10n   # after editing lib/l10n/*.arb
dart run flutter_launcher_icons   # after changing assets/branding/icon.png
dart run flutter_native_splash:create   # after splash config changes
flutter run
flutter analyze
flutter test
```

Device integration tests:

```bash
flutter test integration_test/app_flow_test.dart
```

See [`AGENTS.md`](AGENTS.md), [`docs/PROGRESS.md`](docs/PROGRESS.md), and [`docs/BACKLOG.md`](docs/BACKLOG.md).

## MVP features

- Local prayer calculation (`adhan_dart`) with configurable methods, madhab, offsets
- English, Urdu, Arabic (RTL for ur/ar)
- GPS + city search location, timezone-aware times
- Hijri + Gregorian date header
- Qibla compass from saved location
- Prayer notifications (master + per-prayer toggles)
- System / light / dark theme
