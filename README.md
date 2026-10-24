# Switch-On Diet

[한국어](README.ko.md)

A tracker app I made for the 28-day Switch-On Diet.

<p>
  <img src="docs/screenshots/01-today.png" width="19%">
  <img src="docs/screenshots/02-meal-timeline.png" width="19%">
  <img src="docs/screenshots/03-calendar.png" width="19%">
  <img src="docs/screenshots/04-diet-guide.png" width="19%">
  <img src="docs/screenshots/05-ai-coach.png" width="19%">
</p>

## Features

- Meal times set from your wake-up time, fasting timer
- AI checks each meal against the week's food rules
- 28-day calendar, diet guide, AI coach chat

## Architecture

MVVM + Clean Architecture (feature-first: `domain` / `data` / `presentation`)

- State: Riverpod (`Notifier`, `AsyncNotifier`)
- Models: Freezed
- Storage: Hive

Details: [docs/ARCHITECTURE.ko.md](docs/ARCHITECTURE.ko.md)

## Run

```bash
cp .env.example .env
flutter pub get
flutter run --dart-define=ANTHROPIC_API_KEY=your-key
```

## License

MIT
