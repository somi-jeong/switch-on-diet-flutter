import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

part 'calendar_state.freezed.dart';

/// The calendar is read-only, so its view model is a derived provider; the
/// selected day is ephemeral widget state.
final calendarProvider = Provider.autoDispose<CalendarState>((ref) {
  final calendar = ref.watch(challengeCalendarProvider);
  final today = ref.watch(currentDayProvider);
  if (calendar == null || today == null) {
    throw StateError('The challenge has not started.');
  }
  return CalendarState(
    today: today,
    now: ref.watch(clockProvider).now(),
    startDate: calendar.startDate,
    records: ref.watch(dietRecordsProvider).valueOrNull ?? const {},
  );
});

enum DayStatus { future, today, incomplete, warning, done }

enum MealSummaryStatus { recorded, unrecorded, skipped, violation }

@freezed
class MealSummary with _$MealSummary {
  const factory MealSummary({
    required String label,
    required String time,
    required MealSummaryStatus status,
    required String text,
    String? skipReason,
    String? lateReason,
  }) = _MealSummary;
}

@freezed
class WeekProgress with _$WeekProgress {
  const factory WeekProgress({
    required String status,
    required bool isActive,

    /// `null` for a week that has not started.
    double? progress,
  }) = _WeekProgress;
}

@freezed
class CalendarState with _$CalendarState {
  const factory CalendarState({
    required int today,
    required DateTime now,
    required DateTime startDate,
    required Map<int, DietRecord> records,
  }) = _CalendarState;

  const CalendarState._();

  /// A day counts as achieved at 80% of its meals.
  static const achievedScore = 0.8;

  /// Empty cells before day 1 so that columns line up with weekdays (Sun-Sat).
  /// Today's review is only revealed from 22:00, once the day is mostly done.
  bool get isTodayReviewVisible => now.hour >= 22;

  int get leadingBlankDays => startDate.weekday % 7;

  DateTime dateOf(int day) => startDate.add(Duration(days: day - 1));

  int get achievedDays => records.entries
      .where(
        (e) =>
            e.key <= ChallengeCalendar.totalDays &&
            e.value.score >= achievedScore,
      )
      .length;

  DayStatus statusOf(int day) {
    if (day > today) return DayStatus.future;
    if (day == today) return DayStatus.today;
    final record = records[day];
    if (record == null) return DayStatus.incomplete;
    // Every meal skipped (a very late wake-up) or a forbidden meal.
    if (record.meals.every((m) => m.skipped) ||
        record.countVerdict(MealVerdict.forbidden) > 0) {
      return DayStatus.warning;
    }
    if (record.meals.any((m) => m.isPending)) return DayStatus.incomplete;
    return DayStatus.done;
  }

  List<MealSummary> mealsOf(int day) => [
    for (final meal in records[day]?.meals ?? const <MealRecord>[])
      MealSummary(
        label: meal.label,
        time: meal.mealTime ?? (meal.skipped ? '-' : ''),
        status: meal.skipped
            ? MealSummaryStatus.skipped
            : meal.verdict == MealVerdict.forbidden
            ? MealSummaryStatus.violation
            : meal.checked
            ? MealSummaryStatus.recorded
            : MealSummaryStatus.unrecorded,
        text: meal.foodText ?? (meal.skipped ? '기상 지연으로 스킵' : ''),
        skipReason: meal.skipReason,
        lateReason: meal.lateReason,
      ),
  ];

  WeekProgress progressOf(int week) {
    final elapsed = ChallengeCalendar.daysOfWeek(
      week,
    ).where((day) => day <= today).toList();
    final achieved = elapsed
        .where((day) => (records[day]?.score ?? 0) >= achievedScore)
        .length;
    final isActive = week == ChallengeCalendar.weekOf(today);

    if (elapsed.isEmpty) {
      return WeekProgress(status: '예정', isActive: isActive);
    }
    final progress = achieved / elapsed.length;
    final label = elapsed.length < ChallengeCalendar.daysPerWeek ? '진행중' : '완료';
    return WeekProgress(
      status: '$label ${(progress * 100).round()}%',
      progress: progress,
      isActive: isActive,
    );
  }
}
