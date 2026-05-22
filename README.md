# Times

Offline-first Islamic prayer times app for Android and iOS. Built with Flutter, Material 3, and `flutter_bloc`.

## Development

```bash
flutter pub get
flutter gen-l10n   # after editing lib/l10n/*.arb
flutter run
flutter analyze
flutter test
```

See [`AGENTS.md`](AGENTS.md) and [`docs/PROGRESS.md`](docs/PROGRESS.md) for roadmap and agent context.

## Features (in progress)

- Local prayer calculation (`adhan_dart`)
- English, Urdu, Arabic
- First-run setup (method + location)
- Qibla, notifications — planned
