import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

/// Sets the wake-up time of a day and lays out the meals that still fit.
///
/// Meals already recorded for a slot that is still available are kept, and
/// everything else on the record (missions, bedtime, feedback) is untouched,
/// so correcting the wake-up time never discards what the user entered.
class RecordWakeTime {
  const RecordWakeTime(this._records);

  final DietRecordRepository _records;

  Future<DietRecord> call({
    required int day,
    required DateTime wakeTime,
  }) async {
    final current =
        _records.get(day) ?? DietRecord(date: Jst.isoDate(wakeTime));
    final updated = current.copyWith(
      wakeTime: wakeTime.toIso8601String(),
      meals: [
        for (final slot in MealSchedule.slotsForWakeHour(wakeTime.hour))
          current.mealOf(slot.label) ?? MealRecord(label: slot.label),
      ],
    );
    await _records.save(day, updated);
    return updated;
  }
}
