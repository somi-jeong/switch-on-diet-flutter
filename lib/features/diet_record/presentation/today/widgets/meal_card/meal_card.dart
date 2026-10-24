import 'package:flutter/material.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/completed_meal.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/locked_meal.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/missed_meal.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/next_meal.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/pending_meal.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/skipped_meal.dart';

/// 식사 타임라인 카드
/// 상태: 완료(checked), 현재(next), 대기(pending), 잠김(locked), 미입력(missed), 스킵(skipped)
class MealCard extends StatelessWidget {
  final MealRecord meal;
  final bool isNext;
  final bool isLocked;
  final bool isMissed;
  final VoidCallback? onRecord;
  final VoidCallback? onSkip;
  final VoidCallback? onEdit;
  final VoidCallback? onRecordLate;

  const MealCard({
    super.key,
    required this.meal,
    this.isNext = false,
    this.isLocked = false,
    this.isMissed = false,
    this.onRecord,
    this.onSkip,
    this.onEdit,
    this.onRecordLate,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return LockedMeal(meal: meal);
    } else if (meal.skipped) {
      return SkippedMeal(meal: meal);
    } else if (isMissed && !meal.checked) {
      return MissedMeal(meal: meal, onRecordLate: onRecordLate);
    } else if (isNext) {
      return NextMeal(meal: meal, onRecord: onRecord, onSkip: onSkip);
    } else if (meal.checked) {
      return CompletedMeal(meal: meal, onEdit: onEdit);
    } else {
      return PendingMeal(meal: meal);
    }
  }
}
