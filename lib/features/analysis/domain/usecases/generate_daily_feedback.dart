import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

/// Writes the end-of-day review for today.
///
/// There is no backend, so this runs whenever the app opens or resumes and
/// only does work between 23:00 and 23:59 JST, for a day with a recorded
/// wake-up time and no review yet.
class GenerateDailyFeedback {
  const GenerateDailyFeedback({
    required DietRecordRepository records,
    required AiCoachRepository coach,
    required Clock clock,
  }) : _records = records,
       _coach = coach,
       _clock = clock;

  static const windowHour = 23;

  final DietRecordRepository _records;
  final AiCoachRepository _coach;
  final Clock _clock;

  /// Returns whether a review was written.
  Future<bool> runIfDue({required String startDate}) async {
    final now = _clock.now();
    if (now.hour != windowHour) return false;

    final day = ChallengeCalendar.fromIsoDate(startDate).dayAt(now);
    final record = _records.get(day);
    if (record == null || !record.hasWoken) return false;
    if (record.aiFeedback?.isNotEmpty ?? false) return false;

    final feedback = await _coach.dailyFeedback(
      buildReport(record, day: day, now: now),
    );
    final latest = _records.get(day) ?? record;
    await _records.save(day, latest.copyWith(aiFeedback: feedback));
    return true;
  }

  static DailyReport buildReport(
    DietRecord record, {
    required int day,
    required DateTime now,
  }) {
    final wakeTime = Jst.parse(record.wakeTime!);
    final active = record.meals.where((m) => !m.skipped).toList();
    final completed = active.where((m) => m.checked).length;

    return DailyReport(
      day: day,
      week: ChallengeCalendar.weekOf(day),
      wakeTime: wakeTime,
      fastingHours: now.difference(wakeTime).inHours,
      scorePercent: active.isEmpty
          ? 0
          : (completed / active.length * 100).round(),
      completedMeals: completed,
      totalMeals: active.length,
      allowedCount: record.countVerdict(MealVerdict.allowed),
      warningCount: record.countVerdict(MealVerdict.warning),
      forbiddenCount: record.countVerdict(MealVerdict.forbidden),
      warningCountTotal: record.warningCount,
      meals: record.meals,
      dailyChecklist: record.dailyChecklist ?? const {},
      weight: record.weight,
      bodyFat: record.bodyFat,
      confession: record.confession,
      bedTime: record.bedTime,
      actualBedTime: record.actualBedTime,
    );
  }
}
