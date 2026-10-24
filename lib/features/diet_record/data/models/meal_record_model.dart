import 'package:hive/hive.dart';

part 'meal_record_model.g.dart';

/// Hive representation of a meal. Field numbers are part of the on-disk
/// format: never reuse or renumber them.
@HiveType(typeId: 1)
class MealRecordModel {
  const MealRecordModel({
    required this.label,
    this.checked = false,
    this.photoPath,
    this.photoTimestamp,
    this.aiStatus,
    this.aiFeedback,
    this.mealTime,
    this.foodText,
    this.recordedAt,
    this.skipped = false,
    this.eatenAt,
    this.guideText,
    this.skipReason,
    this.lateReason,
  });

  @HiveField(0)
  final String label;

  @HiveField(1, defaultValue: false)
  final bool checked;

  @HiveField(2)
  final String? photoPath;

  @HiveField(3)
  final String? photoTimestamp;

  /// `ALLOWED`, `WARNING` or `FORBIDDEN`.
  @HiveField(4)
  final String? aiStatus;

  @HiveField(5)
  final String? aiFeedback;

  @HiveField(6)
  final String? mealTime;

  @HiveField(7)
  final String? foodText;

  @HiveField(8)
  final String? recordedAt;

  @HiveField(9, defaultValue: false)
  final bool skipped;

  @HiveField(10)
  final String? eatenAt;

  @HiveField(11)
  final String? guideText;

  @HiveField(12)
  final String? skipReason;

  @HiveField(13)
  final String? lateReason;
}
