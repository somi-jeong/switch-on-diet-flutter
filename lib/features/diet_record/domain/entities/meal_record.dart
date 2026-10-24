import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

part 'meal_record.freezed.dart';

/// One meal slot of a day. Timestamps are ISO-8601 strings in JST.
@freezed
class MealRecord with _$MealRecord {
  const factory MealRecord({
    /// Meal name, e.g. `아침`. Also identifies the slot within a day.
    required String label,
    @Default(false) bool checked,
    @Default(false) bool skipped,
    String? foodText,
    String? eatenAt,
    String? recordedAt,
    MealVerdict? verdict,
    String? aiFeedback,
    String? mealTime,
    String? guideText,
    String? skipReason,
    String? lateReason,
    String? photoPath,
    String? photoTimestamp,
  }) = _MealRecord;

  const MealRecord._();

  /// Neither eaten nor skipped yet.
  // `this.` keeps `checked` from resolving to the `@checked` annotation.
  bool get isPending => !this.checked && !skipped;

  /// The slot with everything the user entered removed.
  MealRecord cleared() =>
      MealRecord(label: label, mealTime: mealTime, guideText: guideText);
}
