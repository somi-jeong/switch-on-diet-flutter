import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/usecases/record_wake_time.dart';

/// Saves the records the coach extracted from a chat reply.
///
/// Actions are applied in order against today's record. An action that does
/// not fit (unparsable time, unknown meal, no record yet) is skipped rather
/// than failing the whole reply.
typedef DietRecordUpdate = DietRecord Function(DietRecord record);

class ApplyCoachActions {
  const ApplyCoachActions({
    required DietRecordRepository records,
    required RecordWakeTime recordWakeTime,
    required Clock clock,
  }) : _records = records,
       _recordWakeTime = recordWakeTime,
       _clock = clock;

  final DietRecordRepository _records;
  final RecordWakeTime _recordWakeTime;
  final Clock _clock;

  Future<void> call(List<CoachAction> actions, {required int day}) async {
    for (final action in actions) {
      switch (action) {
        case WakeAction(:final time):
          final wakeTime = _todayAt(time);
          if (wakeTime != null) {
            await _recordWakeTime(day: day, wakeTime: wakeTime);
          }
        case MealAction(:final mealType, :final foods):
          await _update(
            day,
            (record) => record.updateMeal(
              mealType,
              (meal) => meal.copyWith(
                checked: true,
                foodText: foods,
                eatenAt: _clock.now().toIso8601String(),
              ),
            ),
          );
        case SkipAction(:final mealType):
          await _update(
            day,
            (record) => record.updateMeal(
              mealType,
              (meal) => meal.copyWith(skipped: true, checked: false),
            ),
          );
        case SleepAction(:final time):
          final bedTime = _todayAt(time);
          if (bedTime != null) {
            await _update(
              day,
              (record) => record.copyWith(bedTime: bedTime.toIso8601String()),
            );
          }
      }
    }
  }

  Future<void> _update(int day, DietRecordUpdate update) async {
    final record = _records.get(day);
    if (record == null) return;
    final updated = update(record);
    if (updated != record) await _records.save(day, updated);
  }

  /// Parses `H:mm` / `HH:mm` into a time on today's date.
  DateTime? _todayAt(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0].trim());
    final minute = int.tryParse(parts[1].trim());
    if (hour == null || minute == null) return null;
    final now = _clock.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
