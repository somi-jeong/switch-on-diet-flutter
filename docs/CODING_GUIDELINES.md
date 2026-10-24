# Coding Guidelines

Conventions used in this codebase. They are enforced by `analysis_options.yaml`
and the optional `scripts/check_quality.sh` report.

## 1. Lints are errors

`flutter analyze` must report **no issues**. The analyzer runs with `strict-casts`, `strict-inference` and
`strict-raw-types`, and these lints are promoted to errors in `analysis_options.yaml`:

- `unused_import`, `unused_local_variable`, `unused_element`, `dead_code`
- `prefer_const_constructors`, `prefer_const_declarations`,
  `prefer_const_literals_to_create_immutables`
- `unnecessary_null_checks`

Other enabled rules include `prefer_final_locals`, `always_use_package_imports`, `avoid_dynamic_calls`,
`unawaited_futures` and `use_build_context_synchronously`.

### `const` everywhere it is possible

```dart
// Good
const SizedBox(width: 8);
const EdgeInsets.symmetric(horizontal: 20);
const TextStyle(fontSize: 14, color: Color(0xFF000000)); // no nested const

// Bad
SizedBox(width: 8);
const TextStyle(color: const Color(0xFF000000)); // redundant inner const
```

### Modern APIs

```dart
Colors.white.withValues(alpha: 0.5); // not withOpacity()
'$week주차';                          // not '${week}주차'
```

### `BuildContext` across async gaps

Check `mounted` (in a `State`) or `context.mounted` (in a function that
receives a context) **before** using the context after an `await`.

## 2. File size: 500 lines max

Every hand-written Dart file stays under 500 lines (400+ is a warning). When a screen grows, extract widgets
into a sibling `widgets/` folder. If a widget starts to hold logic, move that logic into its view model or
into the domain.

## 3. Layering

| Layer | Contains | Must not import |
|---|---|---|
| `features/*/domain` | Freezed entities, repository interfaces, use cases, rules | Flutter, Riverpod, Hive, `http`, `data/`, `presentation/` |
| `features/*/data` | Hive models + mappers, data sources, repository implementations | `presentation/`, Riverpod |
| `features/*/presentation` | Views (widgets) and view models (`Notifier` / `AsyncNotifier`) | Hive, `http`, data sources |
| `features/*/<feature>_providers.dart` | Wiring: which implementation backs which interface | — |
| `core/` | Config, DI basics, theme, `Clock` / JST, shared utils | `features/`, `app/` |

`scripts/check_quality.sh` checks the import rules.

Additional rules:

- **No `DateTime.now()`.** Read the time from `clockProvider` in view models, or receive a `Clock` in use
  cases. Convert and format stored timestamps with `Jst`.
- **Views do not touch repositories.** They render state and call view-model methods. Navigation, dialogs
  and snackbars stay in the view.
- **Write through repositories, read from `dietRecordsProvider`.** Do not cache records in widget state.
- **Hive schema changes** need `dart run build_runner build --delete-conflicting-outputs`. Never reuse or
  renumber a `@HiveField` index or a type id.

## 4. Formatting

- `dart format` with the default 80-column width (`scripts/format_all.sh`).
- Single quotes, trailing commas on multi-line argument lists.

## 5. Before committing

```bash
flutter analyze
flutter test
./scripts/check_quality.sh   # analyze + file size + layer dependency rule
```
