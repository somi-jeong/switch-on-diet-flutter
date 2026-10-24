import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

/// Writes the weekly review on days 7, 14, 21 and 28.
///
/// Like [GenerateDailyFeedback], it runs when the app opens or
/// resumes, only between 17:00 and 18:59 JST, and at most once per week.
class GenerateWeeklySummary {
  const GenerateWeeklySummary({
    required DietRecordRepository records,
    required AiCoachRepository coach,
    required Clock clock,
  }) : _records = records,
       _coach = coach,
       _clock = clock;

  static const windowStartHour = 17;
  static const windowEndHour = 19;

  /// Meals logged this long after they were eaten count as late entries.
  static const lateRecordingThreshold = Duration(hours: 2);

  final DietRecordRepository _records;
  final AiCoachRepository _coach;
  final Clock _clock;

  /// Returns whether a summary was written.
  Future<bool> runIfDue({required String startDate}) async {
    final now = _clock.now();
    if (now.hour < windowStartHour || now.hour >= windowEndHour) return false;

    final day = ChallengeCalendar.fromIsoDate(startDate).dayAt(now);
    if (!ChallengeCalendar.isLastDayOfWeek(day)) return false;

    final records = _records.getAll();
    final today = records[day];
    if (today?.weeklySummary?.isNotEmpty ?? false) return false;

    final days = [
      for (var d = day - 6; d <= day; d++)
        if (records[d] case final record?) buildDayReport(record, day: d),
    ];
    if (days.isEmpty) return false;

    final summary = await _coach.weeklySummary(
      week: ChallengeCalendar.weekOf(day),
      days: days,
    );
    final latest = _records.get(day) ?? DietRecord(date: Jst.isoDate(now));
    await _records.save(day, latest.copyWith(weeklySummary: summary));
    return true;
  }

  static WeeklyDayReport buildDayReport(DietRecord record, {required int day}) {
    final checklist = record.dailyChecklist ?? const {};
    return WeeklyDayReport(
      day: day,
      meals: record.meals,
      score: record.score,
      lateRecordings: [
        for (final meal in record.meals)
          if (_recordingDelay(meal.recordedAt, meal.eatenAt) case final delay?
              when delay >= lateRecordingThreshold)
            '${meal.label} (${delay.inHours}시간 차이)',
      ],
      wakeTimeStatus: record.hasWoken
          ? WakeCategory.ofHour(Jst.parse(record.wakeTime!).hour).label
          : WakeCategory.onTime.label,
      missionsCompleted: checklist.values.where((done) => done).length,
      missionsTotal: checklist.length,
    );
  }

  static Duration? _recordingDelay(String? recordedAt, String? eatenAt) {
    if (recordedAt == null || recordedAt.isEmpty) return null;
    if (eatenAt == null || eatenAt.isEmpty) return null;
    return Jst.parse(recordedAt).difference(Jst.parse(eatenAt)).abs();
  }
}
