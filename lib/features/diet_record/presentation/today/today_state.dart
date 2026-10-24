import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/core/utils/time_validator.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

part 'today_state.freezed.dart';

/// Everything the Today tab renders, derived from today's and yesterday's
/// records at [now].
@freezed
class TodayState with _$TodayState {
  const factory TodayState({
    required int day,
    required DietRecord record,
    required DateTime now,
    DietRecord? yesterday,
  }) = _TodayState;

  const TodayState._();

  int get week => ChallengeCalendar.weekOf(day);

  bool get hasWoken => record.hasWoken;

  DateTime? get wakeTime => hasWoken ? Jst.parse(record.wakeTime!) : null;

  /// Waking at 17:00 or later leaves no room for any meal.
  bool get isDayLost =>
      wakeTime != null &&
      WakeCategory.ofHour(wakeTime!.hour) == WakeCategory.abnormal;

  /// The user has not logged a wake-up and it is outside 05:00-09:59.
  bool get isWakeUpOverdue =>
      TimeValidator.isWakeTimeLate(TimeOfDay.fromDateTime(now));

  /// Yesterday was started but its bedtime was never logged.
  bool get hasMissedBedtime =>
      yesterday != null &&
      yesterday!.wakeTime != null &&
      !yesterday!.hasBedTime;

  /// Time since waking, e.g. `5h 12m`, or `--` before waking.
  String get fastingText {
    final elapsed = wakeTime == null ? null : now.difference(wakeTime!);
    if (elapsed == null || elapsed.isNegative) return '--';
    return '${elapsed.inHours}h ${elapsed.inMinutes % 60}m';
  }

  /// Today's meals with their timeline state.
  ///
  /// A pending meal whose window has closed is missed; the first pending
  /// meal whose window is still open is next.
  List<MealTimelineItem> get timeline {
    final wake = wakeTime;
    if (wake == null) return const [];

    bool isMissed(MealRecord meal) =>
        meal.isPending &&
        MealSchedule.isWindowPassed(
          wakeTime: wake,
          label: meal.label,
          now: now,
        );

    final next = record.meals.indexWhere((m) => m.isPending && !isMissed(m));
    return [
      for (final (index, meal) in record.meals.indexed)
        MealTimelineItem(
          meal: meal,
          isMissed: isMissed(meal),
          isNext: index == next,
        ),
    ];
  }
}

@freezed
class MealTimelineItem with _$MealTimelineItem {
  const factory MealTimelineItem({
    required MealRecord meal,
    required bool isNext,
    required bool isMissed,
  }) = _MealTimelineItem;
}
