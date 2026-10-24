import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/models/meal_record_model.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

extension DietRecordModelMapper on DietRecordModel {
  DietRecord toEntity() => DietRecord(
    date: date,
    wakeTime: wakeTime,
    meals: [for (final meal in meals) meal.toEntity()],
    weight: weight,
    bodyFat: bodyFat,
    diary: diary,
    aiFeedback: aiFeedback,
    weeklySummary: weeklySummary,
    confession: confession,
    confessionFeedback: confessionFeedback,
    bedTime: bedTime,
    warningCount: warningCount,
    actualBedTime: actualBedTime,
    bedTimeFeedback: bedTimeFeedback,
    dailyChecklist: dailyChecklist,
  );
}

extension DietRecordMapper on DietRecord {
  DietRecordModel toModel() => DietRecordModel(
    date: date,
    wakeTime: wakeTime,
    meals: [for (final meal in meals) meal.toModel()],
    weight: weight,
    bodyFat: bodyFat,
    diary: diary,
    aiFeedback: aiFeedback,
    weeklySummary: weeklySummary,
    confession: confession,
    confessionFeedback: confessionFeedback,
    bedTime: bedTime,
    warningCount: warningCount,
    actualBedTime: actualBedTime,
    bedTimeFeedback: bedTimeFeedback,
    dailyChecklist: dailyChecklist,
  );
}

extension MealRecordModelMapper on MealRecordModel {
  MealRecord toEntity() => MealRecord(
    label: label,
    checked: checked,
    skipped: skipped,
    foodText: foodText,
    eatenAt: eatenAt,
    recordedAt: recordedAt,
    verdict: MealVerdict.fromCode(aiStatus),
    aiFeedback: aiFeedback,
    mealTime: mealTime,
    guideText: guideText,
    skipReason: skipReason,
    lateReason: lateReason,
    photoPath: photoPath,
    photoTimestamp: photoTimestamp,
  );
}

extension MealRecordMapper on MealRecord {
  MealRecordModel toModel() => MealRecordModel(
    label: label,
    checked: checked,
    skipped: skipped,
    foodText: foodText,
    eatenAt: eatenAt,
    recordedAt: recordedAt,
    aiStatus: verdict?.code,
    aiFeedback: aiFeedback,
    mealTime: mealTime,
    guideText: guideText,
    skipReason: skipReason,
    lateReason: lateReason,
    photoPath: photoPath,
    photoTimestamp: photoTimestamp,
  );
}
