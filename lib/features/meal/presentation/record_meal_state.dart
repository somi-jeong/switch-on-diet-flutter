import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';

part 'record_meal_state.freezed.dart';

/// Which meal the form edits.
@freezed
class RecordMealTarget with _$RecordMealTarget {
  const factory RecordMealTarget({
    required int day,
    required String mealType,

    /// Pre-fills the form; also what "delete" clears.
    MealRecord? existingMeal,

    /// Past days are logged to the hour.
    @Default(false) bool isPastDate,
  }) = _RecordMealTarget;
}

@freezed
class RecordMealState with _$RecordMealState {
  const factory RecordMealState({
    required String foodText,
    required int hour,
    required int minute,
    @Default(false) bool isSaving,
  }) = _RecordMealState;

  const RecordMealState._();

  bool get canSave => foodText.isNotEmpty && !isSaving;

  String get timeText =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// What happened when the meal was saved, for the view to report.
@freezed
sealed class RecordMealOutcome with _$RecordMealOutcome {
  const factory RecordMealOutcome.analyzed(MealAnalysis analysis) =
      MealAnalyzed;

  /// The meal was saved but the coach could not judge it.
  const factory RecordMealOutcome.analysisFailed({
    required String title,
    required String message,
  }) = MealAnalysisFailed;

  /// The day or meal no longer exists, so nothing was saved.
  const factory RecordMealOutcome.notFound() = MealNotFound;
}
