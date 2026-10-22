import 'package:flutter/material.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/screens/diary/widgets/components/locked_meal.dart';
import 'package:switchon_diet/screens/diary/widgets/components/next_meal.dart';
import 'package:switchon_diet/screens/diary/widgets/components/completed_meal.dart';
import 'package:switchon_diet/screens/diary/widgets/components/pending_meal.dart';
import 'package:switchon_diet/screens/diary/widgets/components/missed_meal.dart';
import 'package:switchon_diet/screens/diary/widgets/components/skipped_meal.dart';

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
