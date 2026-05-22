# Times — Agent onboarding

Prayer times app (Flutter, Material 3, flutter_bloc, adhan_dart). Targets **Android + iOS** only. **MVP roadmap (Phases 0–9) is complete** — see `docs/BACKLOG.md` for follow-ups.

## Start here

1. Read [`docs/PROGRESS.md`](docs/PROGRESS.md) for current phase and checklist.
2. Follow [`.cursor/rules/`](.cursor/rules/) — especially `times-git.mdc` for branches/commits.
3. Full roadmap: `.cursor/plans/prayer_times_roadmap_360b6a1c.plan.md` (if present).

## Run locally

```bash
flutter pub get
flutter gen-l10n   # if l10n changed
flutter run
```

## Git workflow

- Branch: `feature/phase-<n>-<name>` per phase
- Conventional Commits; update `docs/PROGRESS.md` when completing items
- `flutter analyze` before merging to `main`

## Architecture

- `lib/features/` — prayer, settings, location, qibla, notifications, coming_soon
- Local-first calculation via `adhan_dart`
- Required setup: calculation method + location before showing timetable
