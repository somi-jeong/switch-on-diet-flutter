import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';

part 'coach_requests.freezed.dart';

/// Where the user is in the program, sent with every chat message.
@freezed
class CoachContext with _$CoachContext {
  const factory CoachContext({
    required int day,
    required int week,
    required String? wakeTime,
    required List<MealRecord> meals,
    required FoodRules foodRules,
    String? yesterdaySummary,
  }) = _CoachContext;
}

@freezed
class MealAnalysis with _$MealAnalysis {
  const factory MealAnalysis({
    required MealVerdict verdict,
    required String feedback,
  }) = _MealAnalysis;
}

/// Statistics for one day, used to write the end-of-day feedback.
@freezed
class DailyReport with _$DailyReport {
  const factory DailyReport({
    required int day,
    required int week,
    required DateTime wakeTime,
    required int fastingHours,
    required int scorePercent,
    required int completedMeals,
    required int totalMeals,
    required int allowedCount,
    required int warningCount,
    required int forbiddenCount,
    required int warningCountTotal,
    required List<MealRecord> meals,
    required Map<String, bool> dailyChecklist,
    double? weight,
    double? bodyFat,
    String? confession,
    String? bedTime,
    String? actualBedTime,
  }) = _DailyReport;

  const DailyReport._();

  int get missionsCompleted =>
      dailyChecklist.values.where((done) => done).length;

  int get missionsTotal => dailyChecklist.length;
}

/// One day of a week, used to write the weekly summary.
@freezed
class WeeklyDayReport with _$WeeklyDayReport {
  const factory WeeklyDayReport({
    required int day,
    required List<MealRecord> meals,
    required double score,
    required List<String> lateRecordings,
    required String wakeTimeStatus,
    required int missionsCompleted,
    required int missionsTotal,
  }) = _WeeklyDayReport;
}
