# Architecture decisions

Short records of the decisions behind the current structure. Each entry gives the context, the decision,
and what it costs.

## ADR-1: Feature-first folders with domain / data / presentation layers

**Context.** The app started with folders by kind: `screens/`, `services/` and `models/`. Business rules lived in
static services and inside `StatefulWidget`s, so they could only be exercised through the UI. Screens read
and wrote Hive directly, so after any write the other screens had to be told to reload.

**Decision.** Code is grouped by feature (`program`, `diet_record`, `meal`, `coach`, `analysis`, `settings`).
Each feature has up to three layers:

- `domain`: pure Dart. Entities, repository interfaces, use cases, rules.
- `data`: Hive and HTTP behind those interfaces.
- `presentation`: views and view models.

App-wide code lives in `core/`, and startup and the shell live in `app/`. Dependencies point towards `domain`.
`scripts/check_quality.sh` fails on imports that break this rule.

**Consequences.** Rules such as the wake-up meal layout or the review time windows can be unit-tested without
Flutter. A feature can depend on another feature's domain (for example, `meal` uses `coach`'s
`AiCoachRepository`), but not on its data or presentation code. The cost is more files and an explicit
mapping between Hive models and entities.

## ADR-2: Riverpod Notifier / AsyncNotifier instead of Bloc

**Context.** The app already ran inside a `ProviderScope`. It needs dependency injection that tests can
override, per-screen state, and async loading.

**Decision.** View models are `Notifier` / `AsyncNotifier` classes, with `family` used for per-item state
such as one chat thread per date. Providers are declared by hand in one `<feature>_providers.dart` file per
feature, without `riverpod_generator`.

**Why not Bloc.** Bloc's event classes and stream transformations would add ceremony to screens whose
events are plain method calls. It also needs a separate DI solution. Riverpod covers both, and
`ProviderContainer(overrides: …)` gives each test its own wiring.

**Why no code generation for providers.** `riverpod_generator` needs a newer analyzer than `hive_generator`
supports, and the hand-written providers are short.

**Consequences.** View models write to repositories and do not set their own state. They rebuild from
`dietRecordsProvider`, a stream over the Hive box, so each change has one source of truth. One-off UI
effects (snackbars, dialogs) are returned from view-model methods instead of being kept in state.

## ADR-3: Freezed for entities, view states and unions

**Context.** The original models were mutable Hive classes that screens edited in place. Copy constructors
listed every field, and some of them dropped fields: correcting the wake-up time lost the daily
missions.

**Decision.** Entities and view states are Freezed classes. Results and messages with several shapes are
sealed unions, `CoachAction` and `RecordMealOutcome`, handled with exhaustive `switch`.
`AiFailure` is a plain sealed class, because exceptions need no `copyWith` or value equality.

**Consequences.**

- Updates are `copyWith` calls, so fields cannot be dropped by accident.
- Tests compare whole records.
- The generated `*.freezed.dart` files are committed, like the Hive adapters, so the project builds
  without running `build_runner`.
- `freezed` is held below 2.5.3, which needs analyzer 7, until `hive_generator` supports a newer analyzer.

## ADR-4: Use cases only where they own logic

**Context.** A use case per repository method would add a layer that only passes calls through.

**Decision.** A use case exists when it does one of these things:

- coordinates several steps or repositories: `RecordMeal`, `SendCoachMessage`, `ResetChallenge`
- applies a rule: `RecordWakeTime`, `ApplyCoachActions`
- depends on time windows: `GenerateDailyFeedback`, `GenerateWeeklySummary`

Toggling a mission or saving a bedtime is a one-line `copyWith`, and the view model calls the repository
directly. Pure rules without I/O are plain domain classes or functions: `ChallengeCalendar`,
`MealSchedule`, `FoodRules` and `CoachGreeting`.

**Consequences.** Every use case has a reason to exist and a test. The layering stays uneven on purpose:
`analysis` has use cases but no data or presentation layer.

## ADR-5: Keep the Hive format byte-compatible

**Context.** People already have data on their devices. Hive stores type ids and field numbers in the binary
format.

**Decision.**

- The data-layer models keep the original type ids (0, 1, 3) and `@HiveField` numbers. Only the class
  names change.
- Defaults are declared on `@HiveField` so that older records with missing fields still load.
- The unused legacy settings field is preserved when settings are saved.
- Type id 4 was registered but never written, so it is retired, not reused.
- `test/fixtures/legacy_boxes` holds boxes written by the original adapters, and repository tests read them.

**Consequences.** No migration is needed. Changing the schema means adding new field numbers and extending
the fixture test.
