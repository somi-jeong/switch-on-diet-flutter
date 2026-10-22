# 스위치온 다이어트 앱 - 설계 문서 (한국어)

28일(4주) 스위치온 다이어트 챌린지를 기록하고 AI 코칭을 받는 Flutter 앱입니다.
모든 데이터는 기기(Hive)에 저장되며, 외부로 나가는 통신은 Claude API 호출뿐입니다.

## 기술 스택

| 항목 | 기술 |
|---|---|
| 프레임워크 | Flutter 3.35+ (Dart 3.8+), Material 3 |
| 상태 | `ProviderScope`(flutter_riverpod) + `StatefulWidget` |
| 로컬 DB | Hive / hive_flutter, 어댑터는 hive_generator로 생성 (`*.g.dart` 커밋됨) |
| AI | Anthropic Messages API (`http`, 모델 `claude-haiku-4-5`) |
| 시간 | timezone (Asia/Tokyo 고정), intl |
| 설정 | `--dart-define=ANTHROPIC_API_KEY` 또는 `.env`(flutter_dotenv) |
| 알림 | flutter_local_notifications (시작 시 초기화, 식사 알림 스케줄러는 `NotificationService`에 구현) |

## 폴더 구조

```
lib/
├── main.dart                    # env → timezone → Hive → 알림 초기화, 온보딩/메인 분기
├── constants/
│   ├── colors.dart              # 컬러 토큰
│   ├── diet_data.dart           # 주차별 허용/금지 식품, 단계 정보
│   └── meal_offsets.dart        # 기상 기준 식사 시간대(분)
├── models/                      # Hive 타입 (DietRecord, MealRecord, AppSettings, ChatMessage)
│   └── coach_action.dart        # AI 응답의 <ACTION> 태그 파서
├── services/
│   ├── claude_service.dart      # 기능별 AI 호출 + 토큰 예산
│   ├── prompts/                 # 시스템/유저 프롬프트 생성
│   ├── parsers/                 # HTTP 클라이언트, 응답 파싱
│   ├── coach_action_processor.dart  # 코치 액션 → 기록 반영
│   ├── daily_analysis_service.dart  # 하루 피드백 자동 생성
│   ├── weekly_analysis_service.dart # 주간 요약 자동 생성
│   ├── meal_timing_service.dart     # 식사 시간대 계산
│   ├── jst_service.dart             # JST 시간 유틸
│   ├── notification_service.dart
│   └── storage_service.dart         # Hive 박스 접근 단일 창구
├── screens/
│   ├── onboarding_screen.dart
│   ├── main_screen.dart         # 하단 탭 셸, 앱 재개 시 데이터 재로드
│   ├── tabs/                    # 오늘 / 캘린더 / 식단 / 마이 + 위젯
│   ├── record_meal_screen.dart  # 텍스트 식사 기록 + AI 판정
│   ├── ai_coach_bottom_sheet.dart
│   ├── chat_history_screen.dart, chat_detail/  # 코치 히스토리
│   ├── diet_history_screen.dart, diet_history/ # 식단·수면 기록
│   ├── past_date_meal_selection_screen.dart    # 지난 날짜 소급 입력
│   └── dialogs/                 # 기상·취침·식사·설정 다이얼로그
└── utils/time_validator.dart    # 기상/취침/수면 시간 규칙
```

## 데이터 모델 (Hive)

| 박스 | 키 | 값 |
|---|---|---|
| `records` | dayIdx (1~28) | `DietRecord`: 날짜, 기상/취침 시간, 끼니 목록, 체중·체지방, 데일리 미션, AI 피드백, 주간 요약 |
| `settings` | `'settings'` | `AppSettings`: 시작일, 이름, 알림 설정 |
| `chat_json` | `chat_YYYY-MM-DD` | 날짜별 코치 대화(JSON 문자열) |
| `day_summaries` | `summary_YYYY-MM-DD` | 날짜별 요약 (조회용) |

`MealRecord`에는 끼니 이름, 기록 여부, 음식 텍스트, AI 판정(`ALLOWED`/`WARNING`/`FORBIDDEN`)과 코멘트,
식사 시각, 스킵 여부와 사유, 늦은 입력 사유가 들어갑니다.

달성률은 `DietRecord.score`에서 계산하며, 스킵한 끼니를 제외한 끼니 중 기록한 끼니의 비율입니다.

## 핵심 흐름

### 기상 기록
1. 오늘 탭에서 기상 시간을 입력합니다. 이때 전날 취침 시간을 기준으로 수면 시간을 보여 주고, 6시간 미만이면 경고합니다.
2. 기상 시각에 따라 가능한 끼니만 만듭니다.
   - 09시 전: 4끼
   - 09~11시: 아침 제외
   - 11~14시: 점심·저녁
   - 14~17시: 저녁
   - 17시 이후: 없음
3. 각 끼니의 시간대는 `meal_offsets`(기상 후 +30~90 / +210~270 / +390~450 / +570~630분)로 계산합니다.

### 식사 기록
1. 끼니 카드에서 먹은 음식을 텍스트로 입력합니다. 시간대가 지난 뒤에 입력하면 늦은 입력 사유를 받습니다.
2. `ClaudeService.analyzeFoodText`가 이번 주 허용/금지 식품 목록을 기준으로 판정합니다.
3. `ClaudeResponseParser.parseTextAnalysis`가 `STATUS:`/`FEEDBACK:` 줄을 읽고, 없으면 키워드로 판정합니다.
4. 판정 결과를 `MealRecord`에 저장하고 타임라인에 배지로 표시합니다.
5. 끼니를 스킵할 때는 사유를 입력합니다.

### AI 코치
1. 처음 열면 오늘 상태(미입력 끼니, 미완료 미션, 어제 달성률)로 인사말을 로컬에서 만듭니다.
2. 메시지를 보낼 때마다 다음 내용을 시스템 프롬프트로 구성합니다.
   - 일차·주차와 기상 시간
   - 끼니 상태
   - 이번 주 허용/금지 식품
   - 어제 요약 한 줄
3. 응답에 `<ACTION>WAKE:07:00</ACTION>`, `<ACTION>MEAL:아침:계란</ACTION>`, `<ACTION>SKIP:점심</ACTION>`,
   `<ACTION>SLEEP:23:00</ACTION>` 태그가 있으면 `CoachAction.parseActions`가 추출해 화면 텍스트에서 지우고,
   `CoachActionProcessor`가 해당 기록을 Hive에 반영합니다.
4. 대화는 날짜별로 저장됩니다. 네트워크·요청 한도 오류가 나면 재시도 다이얼로그를 띄웁니다.

### 자동 분석 (서버 없이)
`MainScreen`이 로드될 때(앱 시작·재개) 아래 조건을 확인합니다. 결과는 한 번만 생성해 기록에 저장합니다.
- **하루 피드백**: 23:00~23:59 JST이고 오늘 기상 기록이 있을 때 → `DietRecord.aiFeedback`
- **주간 요약**: 7·14·21·28일차 17:00~19:00 JST일 때 → `DietRecord.weeklySummary`

두 결과는 마이 탭 > AI 코치 히스토리에서 볼 수 있습니다.

## 화면

| 화면 | 내용 |
|---|---|
| 온보딩 | 챌린지 시작일 선택 |
| 오늘 | 단계 안내 카드, 달성률, 데일리 미션(물·영양제·운동·수면), 공복 타이머(목표 14시간), 끼니 타임라인, 취침 기록, AI 코치 버튼 |
| 캘린더 | 28일 그리드(완벽/주의/미입력), 진행률과 성장 배지, 선택한 날의 식단·규칙·AI 피드백, 지난 날짜 소급 입력 |
| 식단 | 주차·단계별 식단 가이드(현재 단계 강조) |
| 마이 | 기본 수칙, 식단 및 수면 기록, AI 코치 히스토리, 이름·시작일 변경, 데이터 초기화 |

## 규칙

- 시간은 항상 `JstService`를 거칩니다. `timezone` DB를 쓸 수 없으면 UTC+9로 대신 계산합니다.
- Hive 접근은 `StorageService`에서만 합니다.
- Hive 필드 번호(`@HiveField`)는 재사용하거나 바꾸지 않습니다.
- 그 밖의 코드 규칙은 [`CODING_GUIDELINES.md`](CODING_GUIDELINES.md)를 참고하세요.

## API 키

- 저장소에 키를 포함하지 않습니다. `--dart-define=ANTHROPIC_API_KEY=...`가 `.env`보다 우선합니다.
- 클라이언트에서 직접 API를 호출하는 구조이므로, 배포할 때는 서버 프록시를 두는 것을 권장합니다.

## 라이선스

MIT License — 루트의 `LICENSE`를 참고하세요.
