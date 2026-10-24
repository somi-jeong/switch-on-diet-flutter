# 스위치온 다이어트 앱 설계 문서

28일(4주) 스위치온 다이어트 챌린지를 기록하고 AI 코칭을 받는 Flutter 앱입니다.
데이터는 모두 기기(Hive)에 저장되고, 외부와 통신하는 것은 Claude API 호출뿐입니다.

## 1. 구조 한눈에 보기

**Clean Architecture로 레이어를 나누고, 화면은 MVVM**으로 구성했습니다. 폴더는 기능(feature) 단위로 나누고,
각 기능 안에서 다시 레이어를 나눕니다.

| 레이어 | 들어 있는 것 | 의존할 수 있는 대상 |
|---|---|---|
| presentation | View(위젯), ViewModel(Riverpod `Notifier`/`AsyncNotifier`), 화면 상태(Freezed) | domain, core |
| domain | 엔티티(Freezed), 리포지토리 인터페이스, 유스케이스, 프로그램 규칙 | core의 순수 Dart 코드 |
| data | Hive 모델·매퍼, 리포지토리 구현, 데이터 소스(Hive 박스, Anthropic API) | domain, core |

**의존성 규칙**: 의존성은 항상 domain 쪽을 향합니다.

- domain은 Flutter, Riverpod, Hive, HTTP를 import하지 않습니다.
- data는 presentation을 모릅니다.
- core는 feature를 모릅니다.

`scripts/check_quality.sh`가 이 규칙을 검사합니다.
의존성 연결은 기능마다 하나씩 있는 `<feature>_providers.dart`에서 합니다.
`app/bootstrap.dart`가 앱 시작 시 Hive 박스를 열어 provider override로 넘깁니다.

## 2. 폴더 구조

```
lib/
├── main.dart                 # bootstrap() → ProviderScope(overrides) → SwitchOnDietApp
├── app/                      # 앱 루트(온보딩/메인 분기), bootstrap, 하단 탭 셸
├── core/                     # config(API 키), di, theme, time(Clock/JstClock), utils
└── features/
    ├── program/              # 프로그램 규칙: ChallengeCalendar, MealSchedule, FoodRules, ProgramPhase + 식단 탭
    ├── diet_record/          # 하루 기록: 오늘 탭, 캘린더, 식단·수면 기록, 지난 날짜 입력
    ├── meal/                 # 식사 기록과 AI 판정, 식사 알림
    ├── coach/                # AI 코치 대화, 코치 히스토리, Claude 연동(data)
    ├── analysis/             # 하루 피드백·주간 요약 자동 생성(유스케이스만 있음)
    └── settings/             # 온보딩, 마이 페이지, 설정 변경, 초기화
```

## 3. 화면 상태 (MVVM)

- **View**는 상태를 그리고 사용자 이벤트를 ViewModel에 넘깁니다. 다이얼로그, 내비게이션, 스낵바처럼 `BuildContext`가 필요한 일만 View에 둡니다.
- **ViewModel**은 Riverpod `Notifier`/`AsyncNotifier`입니다. 화면 하나 또는 항목 하나(`family`)마다 인스턴스가 생기고, 화면을 닫으면 `autoDispose`로 정리됩니다.
- 로딩과 에러는 `AsyncValue`로 표현하고, 데이터 상태는 Freezed 클래스로 표현합니다.
- 결과가 여러 갈래인 동작은 sealed union으로 돌려줍니다. 예를 들어 `RecordMealOutcome`은 `analyzed`, `analysisFailed`, `notFound` 중 하나입니다.
- 기록을 쓰는 곳은 리포지토리 하나입니다. Hive 박스가 바뀌면 `dietRecordsProvider` 스트림이 다시 값을 내보내고, 그 스트림을 보는 ViewModel(오늘, 캘린더, 기록)이 모두 다시 계산됩니다. 그래서 다른 화면에 "새로고침하라"고 알릴 필요가 없습니다.
- 캘린더와 식단 기록처럼 읽기만 하는 화면은 Notifier 대신 파생 `Provider`를 씁니다. 선택한 날짜 같은 일시적인 UI 상태는 위젯에 둡니다.

| 화면 | ViewModel / 상태 |
|---|---|
| 오늘 | `TodayViewModel` → `TodayState` (공복 시간, 식사 타임라인, 취침 누락 배너) |
| 식사 기록 | `RecordMealViewModel` (family: `RecordMealTarget`) → `RecordMealState`, `RecordMealOutcome` |
| AI 코치 시트 / 대화 상세 | `CoachChatViewModel` (family: `CoachThread`) → `CoachChatState` |
| 코치 히스토리 | `ChatHistoryViewModel` → `ChatHistoryState` |
| 캘린더 / 식단·수면 기록 | `calendarProvider` → `CalendarState`, `dietHistoryProvider` → `DayHistory` |
| 지난 날짜 입력 | `PastDayViewModel` (family: day) |
| 설정 전체 | `SettingsNotifier` (`settingsProvider`) |

## 4. 요청 흐름 예시: 식사 기록

1. `RecordMealScreen` → `RecordMealViewModel.save()`
2. `RecordMeal` 유스케이스가 먼저 `DietRecordRepository`에 식사를 저장합니다. AI가 실패해도 기록은 남깁니다.
3. 이어서 `AiCoachRepository.analyzeMeal`을 호출합니다.
4. `ClaudeAiCoachRepository`가 다음 순서로 처리합니다.
   - `ClaudePromptBuilder`: 프롬프트 생성
   - `AnthropicRemoteDataSource`: HTTP 요청. HTTP 오류는 여기서 `AiFailure`로 바꿉니다.
   - `ClaudeResponseParser`: `STATUS`/`FEEDBACK` 파싱. 형식이 맞지 않으면 키워드로 판정하고, 그래도 안 되면 기본값을 씁니다.
5. 판정을 기록에 다시 저장하면 Hive 변경 → `dietRecordsProvider` → 오늘 탭 순서로 화면이 갱신됩니다.
6. View는 `RecordMealOutcome`을 보고 스낵바나 에러 다이얼로그를 띄웁니다.

## 5. 유스케이스를 둔 기준

유스케이스는 **로직이 있을 때만** 만듭니다. 단순한 읽기·쓰기는 ViewModel이 리포지토리를 바로 호출합니다.

| 유스케이스 | 맡은 로직 |
|---|---|
| `RecordWakeTime` | 기상 시각에 맞춰 가능한 끼니 배치. 미션·취침·이미 기록한 끼니는 유지 |
| `RecordMeal` | 저장 → AI 판정 → 판정 저장. 실패해도 기록은 유지 |
| `SendCoachMessage` | 오늘·어제 기록으로 코치 컨텍스트 구성, 최근 3턴만 전송, 액션 반영 |
| `ApplyCoachActions` | `<ACTION>` 태그(기상·식사·스킵·취침)를 기록에 반영 |
| `GenerateDailyFeedback` / `GenerateWeeklySummary` | JST 시간 조건 확인, 하루 1회 생성, 리포트 통계 계산 |
| `ResetChallenge` | 기록·채팅·설정 리포지토리를 모두 초기화 |

`CoachGreeting`(코치 첫 인사)은 순수 함수라서 도메인 서비스로 둡니다.

## 6. 데이터와 호환성

| 박스 | 키 | 값 |
|---|---|---|
| `records` | 일차(1~28) | `DietRecordModel` (typeId 0), 끼니는 `MealRecordModel` (typeId 1) |
| `settings` | `'settings'` | `AppSettingsModel` (typeId 3) |
| `chat_json` | `chat_YYYY-MM-DD` | 날짜별 대화(JSON 문자열) |
| `day_summaries` | `summary_YYYY-MM-DD` | 날짜별 요약(조회만 함) |

- 기존 Hive typeId와 `@HiveField` 번호를 그대로 썼습니다. 그래서 이미 저장된 데이터를 그대로 읽습니다.
  - 기존 어댑터로 쓴 박스 파일을 `test/fixtures/legacy_boxes`에 두고 테스트로 확인합니다.
- Hive 모델(data)과 엔티티(domain)를 분리하고, 매퍼로 변환합니다.
  - AI 판정은 저장할 때는 `'ALLOWED'` 같은 문자열이고, 도메인에서는 `MealVerdict` enum입니다.
- 쓰지 않는 예전 필드(`geminiApiKey`)는 설정을 저장할 때 그대로 보존합니다.
- typeId 4(`ChatMessage`)는 등록만 되어 있었고 실제로 쓰인 적이 없어서 제거했습니다. 이 번호는 다시 쓰지 않습니다.

## 7. 시간, AI, 설정

- **시간**: "지금"이 필요한 코드는 모두 `Clock`을 주입받습니다(`clockProvider`).
  - `JstClock`은 Asia/Tokyo 기준이고, timezone DB를 쓸 수 없으면 UTC+9로 계산합니다.
  - 테스트에서는 `FixedClock`을 씁니다.
- **AI**: 기능마다 토큰 예산이 다릅니다(식사 판정 500 ~ 주간 요약 3,500).
  - 실패는 `AiFailure`(network, rate limit, credit, server, unexpected, missing key) sealed class로 표현합니다.
- **API 키**: `--dart-define=ANTHROPIC_API_KEY=...`가 `.env`보다 우선합니다. 키가 없어도 앱은 동작하고, AI 기능만 오류를 보여 줍니다.
  - 클라이언트가 API를 직접 호출하므로, 공개 배포할 때는 프록시를 두는 것이 좋습니다.

## 8. 테스트

- **domain**: 인메모리 리포지토리와 `FixedClock`으로 프로그램 규칙과 유스케이스를 검증합니다.
- **presentation**: `ProviderContainer`에서 리포지토리와 시계를 override해 ViewModel을 검증합니다.
  - 예: 기상 시간을 수정해도 데일리 미션이 유지되는지
- **data**: 임시 디렉터리의 실제 Hive, 기존 포맷 fixture, `http` `MockClient`를 씁니다.

`flutter test`로 85개 단위 테스트를 실행합니다. 위젯 테스트는 아직 없습니다.

## 9. 알려진 한계

- 타임스탬프는 ISO 문자열로 저장합니다. 일부는 기기 로컬 `DateTime`으로 만들기 때문에, JST가 보장되는 것은 기기 시간대가 JST일 때뿐입니다.
- 주간 요약은 생성해서 저장하지만, 히스토리 카드에는 고정 문구가 표시됩니다.
- 식사 알림 스케줄러는 구현되어 있지만 UI에는 아직 연결되지 않았습니다.

코드 규칙은 [`CODING_GUIDELINES.md`](CODING_GUIDELINES.md), 설계 결정 기록은 [`ARCHITECTURE_DECISIONS.md`](ARCHITECTURE_DECISIONS.md)에 있습니다.
