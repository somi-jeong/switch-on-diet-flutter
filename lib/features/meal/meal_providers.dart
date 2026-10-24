import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/meal/domain/usecases/record_meal.dart';

final recordMealProvider = Provider<RecordMeal>(
  (ref) => RecordMeal(
    records: ref.watch(dietRecordRepositoryProvider),
    coach: ref.watch(aiCoachRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
