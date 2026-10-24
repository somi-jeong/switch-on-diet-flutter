import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';

/// Thrown when the day or the meal slot to record does not exist.
class MealSlotNotFound implements Exception {
  const MealSlotNotFound(this.day, this.label);

  final int day;
  final String label;

  @override
  String toString() => 'MealSlotNotFound: day $day has no $label';
}

/// Records what the user ate and asks the coach for a verdict.
///
/// The meal is saved before the AI call, so an entry is never lost when the
/// analysis fails; in that case the [AiFailure] is rethrown to the caller.
class RecordMeal {
  const RecordMeal({
    required DietRecordRepository records,
    required AiCoachRepository coach,
    required Clock clock,
  }) : _records = records,
       _coach = coach,
       _clock = clock;

  final DietRecordRepository _records;
  final AiCoachRepository _coach;
  final Clock _clock;

  Future<MealAnalysis> call({
    required int day,
    required String label,
    required String foodText,
    required DateTime eatenAt,
    String? lateReason,
  }) async {
    final record = _records.get(day);
    if (record?.mealOf(label) == null) throw MealSlotNotFound(day, label);

    await _records.save(
      day,
      record!.updateMeal(
        label,
        (meal) => meal.copyWith(
          foodText: foodText,
          eatenAt: eatenAt.toIso8601String(),
          recordedAt: _clock.now().toIso8601String(),
          checked: true,
          skipped: false,
          lateReason: lateReason ?? meal.lateReason,
        ),
      ),
    );

    final analysis = await _coach.analyzeMeal(
      foodText: foodText,
      day: day,
      week: ChallengeCalendar.weekOf(day),
      foodRules: FoodRules.forDay(day),
    );

    // Re-read: the record may have changed while the request was in flight.
    final latest = _records.get(day)!;
    await _records.save(
      day,
      latest.updateMeal(
        label,
        (meal) => meal.copyWith(
          verdict: analysis.verdict,
          aiFeedback: analysis.feedback,
        ),
      ),
    );
    return analysis;
  }
}
