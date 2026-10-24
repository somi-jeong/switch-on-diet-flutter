# Switch-On Diet

[English](README.md)

28일 스위치온 다이어트용으로 만든 기록 앱입니다.

<p>
  <img src="docs/screenshots/01-today.png" width="19%">
  <img src="docs/screenshots/02-meal-timeline.png" width="19%">
  <img src="docs/screenshots/03-calendar.png" width="19%">
  <img src="docs/screenshots/04-diet-guide.png" width="19%">
  <img src="docs/screenshots/05-ai-coach.png" width="19%">
</p>

## 기능

- 기상 시간 기준 식사 시간 설정, 공복 타이머
- 먹은 음식을 이번 주 규칙으로 AI 판정
- 28일 캘린더, 식단 가이드, AI 코치 채팅

## 아키텍처

MVVM + 클린 아키텍처 (기능별 `domain` / `data` / `presentation`)

- 상태 관리: Riverpod (`Notifier`, `AsyncNotifier`)
- 모델: Freezed
- 저장소: Hive

자세한 내용: [docs/ARCHITECTURE.ko.md](docs/ARCHITECTURE.ko.md)

## 실행

```bash
cp .env.example .env
flutter pub get
flutter run --dart-define=ANTHROPIC_API_KEY=your-key
```

## License

MIT
