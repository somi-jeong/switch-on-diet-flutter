import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/daily_mission.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

part 'diet_record.freezed.dart';

/// Everything recorded for one program day. Timestamps are ISO-8601 strings
/// in JST; [date] is `yyyy-MM-dd`.
@freezed
class DietRecord with _$DietRecord {
  const factory DietRecord({
    required String date,
    String? wakeTime,
    @Default(<MealRecord>[]) List<MealRecord> meals,
    double? weight,
    double? bodyFat,
    String? diary,
    String? aiFeedback,
    String? weeklySummary,
    String? confession,
    String? confessionFeedback,
    String? bedTime,
    @Default(0) int warningCount,
    String? actualBedTime,
    String? bedTimeFeedback,
    Map<String, bool>? dailyChecklist,
  }) = _DietRecord;

  const DietRecord._();

  bool get hasWoken => wakeTime?.isNotEmpty ?? false;

  bool get hasBedTime => bedTime?.isNotEmpty ?? false;

  /// Share of non-skipped meals that were eaten, from 0 to 1.
  ///
  /// Skipped meals are left out so a late wake-up is not penalised for
  /// meals that no longer fit in the day.
  double get score {
    final active = meals.where((m) => !m.skipped).toList();
    if (active.isEmpty) return 0;
    return active.where((m) => m.checked).length / active.length;
  }

  int countVerdict(MealVerdict verdict) =>
      meals.where((m) => m.verdict == verdict).length;

  bool isMissionDone(DailyMission mission) =>
      dailyChecklist?[mission.key] ?? false;

  DietRecord toggleMission(String key) => copyWith(
    dailyChecklist: {...?dailyChecklist, key: !(dailyChecklist?[key] ?? false)},
  );

  /// Replaces the meal called [label]; returns this record unchanged if the
  /// day has no such meal.
  DietRecord updateMeal(String label, MealRecord Function(MealRecord) update) {
    final index = meals.indexWhere((m) => m.label == label);
    if (index == -1) return this;
    return copyWith(meals: [...meals]..[index] = update(meals[index]));
  }

  MealRecord? mealOf(String label) {
    for (final meal in meals) {
      if (meal.label == label) return meal;
    }
    return null;
  }
}
