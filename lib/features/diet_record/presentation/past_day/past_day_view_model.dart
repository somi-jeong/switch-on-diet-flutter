import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

final pastDayViewModelProvider = NotifierProvider.autoDispose
    .family<PastDayViewModel, DietRecord, int>(PastDayViewModel.new);

/// Backfilling a past day: its record (or an empty one) and its wake-up.
class PastDayViewModel extends AutoDisposeFamilyNotifier<DietRecord, int> {
  DateTime get _date => ref.read(challengeCalendarProvider)!.dateOf(arg);

  @override
  DietRecord build(int day) {
    final records = ref.watch(dietRecordsProvider).valueOrNull;
    return records?[day] ?? DietRecord(date: Jst.isoDate(_date));
  }

  /// Logs the wake-up hour on that day's date and lays out all four meals
  /// with their planned windows, so any of them can be filled in.
  Future<void> recordWakeHour(int hour) {
    final date = _date;
    final wakeTime = DateTime(date.year, date.month, date.day, hour);
    final meals = [
      for (final slot in MealSchedule.slots)
        MealRecord(
          label: slot.label,
          guideText:
              '${Jst.hourMinute(slot.startAfter(wakeTime))} ~ '
              '${Jst.hourMinute(slot.endAfter(wakeTime))} 예정',
        ),
    ];
    return ref
        .read(dietRecordRepositoryProvider)
        .save(
          arg,
          state.copyWith(wakeTime: wakeTime.toIso8601String(), meals: meals),
        );
  }
}
