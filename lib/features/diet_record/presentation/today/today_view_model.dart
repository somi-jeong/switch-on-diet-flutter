import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_state.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

final todayViewModelProvider =
    AsyncNotifierProvider.autoDispose<TodayViewModel, TodayState>(
      TodayViewModel.new,
    );

/// State and actions of the Today tab.
///
/// Actions write to the repository only and never set [state] themselves:
/// [build] watches [dietRecordsProvider], which re-emits after every write.
/// Updates are applied to the stored record rather than to the current
/// state, so actions issued in quick succession do not overwrite each other.
class TodayViewModel extends AutoDisposeAsyncNotifier<TodayState> {
  @override
  Future<TodayState> build() async {
    final day = ref.watch(currentDayProvider);
    if (day == null) throw StateError('The challenge has not started.');

    final records = await ref.watch(dietRecordsProvider.future);
    final now = ref.read(clockProvider).now();

    var today = records[day];
    if (today == null) {
      today = DietRecord(date: Jst.isoDate(now));
      await ref.read(dietRecordRepositoryProvider).save(day, today);
    }
    return TodayState(
      day: day,
      record: today,
      now: now,
      yesterday: records[day - 1],
    );
  }

  TodayState get _current => state.requireValue;

  Future<void> recordWakeTime(DateTime wakeTime) => ref
      .read(recordWakeTimeProvider)
      .call(day: _current.day, wakeTime: wakeTime);

  Future<void> recordWakeTimeNow() =>
      recordWakeTime(ref.read(clockProvider).now());

  Future<void> toggleMission(String key) =>
      _update(_current.day, (record) => record.toggleMission(key));

  Future<void> skipMeal(String label, {String? reason}) => _update(
    _current.day,
    (record) => record.updateMeal(
      label,
      (meal) => MealRecord(
        label: meal.label,
        skipped: true,
        guideText: meal.guideText,
        skipReason: reason,
      ),
    ),
  );

  /// Logs tonight's planned bedtime.
  Future<void> recordBedtime(TimeOfDay time) {
    final bedTime = _onDate(ref.read(clockProvider).now(), time);
    return _update(
      _current.day,
      (record) => record.copyWith(bedTime: bedTime.toIso8601String()),
    );
  }

  /// Logs the bedtime that was forgotten yesterday.
  Future<void> recordMissedBedtime(TimeOfDay time) {
    final date = ref
        .read(clockProvider)
        .now()
        .subtract(const Duration(days: 1));
    final bedTime = _onDate(date, time);
    return _update(
      _current.day - 1,
      (record) => record.copyWith(bedTime: bedTime.toIso8601String()),
    );
  }

  String recommendedTimeFor(String label) =>
      MealSchedule.recommendedTime(wakeTime: _current.wakeTime!, label: label);

  /// A pre-filled entry for a meal logged after its window closed.
  MealRecord lateEntryFor(
    MealRecord meal, {
    required TimeOfDay eatenAt,
    String? reason,
  }) => MealRecord(
    label: meal.label,
    guideText: meal.guideText,
    eatenAt: _onDate(ref.read(clockProvider).now(), eatenAt).toIso8601String(),
    lateReason: reason,
  );

  Future<void> _update(int day, DietRecord Function(DietRecord) update) async {
    final records = ref.read(dietRecordRepositoryProvider);
    final record = records.get(day);
    if (record != null) await records.save(day, update(record));
  }

  static DateTime _onDate(DateTime date, TimeOfDay time) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
