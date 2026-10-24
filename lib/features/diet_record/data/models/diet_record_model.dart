import 'package:hive/hive.dart';
import 'package:switchon_diet/features/diet_record/data/models/meal_record_model.dart';

part 'diet_record_model.g.dart';

/// Hive representation of a day record. Field numbers are part of the
/// on-disk format: never reuse or renumber them.
@HiveType(typeId: 0)
class DietRecordModel {
  const DietRecordModel({
    required this.date,
    this.wakeTime,
    this.meals = const [],
    this.weight,
    this.bodyFat,
    this.diary,
    this.aiFeedback,
    this.weeklySummary,
    this.confession,
    this.confessionFeedback,
    this.bedTime,
    this.warningCount = 0,
    this.actualBedTime,
    this.bedTimeFeedback,
    this.dailyChecklist,
  });

  @HiveField(0)
  final String date;

  @HiveField(1)
  final String? wakeTime;

  @HiveField(2, defaultValue: <MealRecordModel>[])
  final List<MealRecordModel> meals;

  @HiveField(3)
  final double? weight;

  @HiveField(4)
  final double? bodyFat;

  @HiveField(5)
  final String? diary;

  @HiveField(6)
  final String? aiFeedback;

  @HiveField(7)
  final String? weeklySummary;

  @HiveField(8)
  final String? confession;

  @HiveField(9)
  final String? confessionFeedback;

  @HiveField(10)
  final String? bedTime;

  @HiveField(11, defaultValue: 0)
  final int warningCount;

  @HiveField(12)
  final String? actualBedTime;

  @HiveField(13)
  final String? bedTimeFeedback;

  @HiveField(14)
  final Map<String, bool>? dailyChecklist;
}
