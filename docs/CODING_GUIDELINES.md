# Coding Guidelines

Conventions used in this codebase. They are enforced by `analysis_options.yaml`
and the optional `scripts/check_quality.sh` report.

## 1. Lints are errors

`flutter analyze` must report **no issues**. The following are promoted to
errors in `analysis_options.yaml`:

- `unused_import`, `unused_local_variable`, `unused_element`, `dead_code`
- `prefer_const_constructors`, `prefer_const_declarations`,
  `prefer_const_literals_to_create_immutables`
- `unnecessary_null_checks`, `unnecessary_brace_in_string_interps`

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

Every Dart file stays under 500 lines (400+ is a warning). When a screen
grows, extract widgets into a sibling `widgets/` folder and move rules and
I/O into `lib/services/`.

## 3. Layering

| Folder | Responsibility | Must not |
|---|---|---|
| `lib/screens/` | Widgets and screen state | Call `http` directly or hold business rules |
| `lib/services/` | Domain logic, persistence, AI client, notifications, time | Depend on widgets (except `BuildContext` for dialogs) |
| `lib/services/prompts/`, `lib/services/parsers/` | Prompt construction / HTTP + response parsing | Touch storage |
| `lib/models/` | Hive data types | Contain I/O |
| `lib/constants/` | Colors, meal windows, weekly diet rules | — |

Additional rules:

- **Time is always JST.** Use `JstService` instead of `DateTime.now()`.
- **Persistence goes through `StorageService`.** Widgets never open Hive boxes.
- **Hive schema changes** require `dart run build_runner build
  --delete-conflicting-outputs`; never reuse or renumber a `@HiveField` index.

## 4. Formatting

- `dart format` with the default 80-column width (`scripts/format_all.sh`).
- Single quotes, trailing commas on multi-line argument lists.

## 5. Before committing

```bash
flutter analyze
flutter test
./scripts/check_quality.sh   # analyze + file-size + structure report
```
