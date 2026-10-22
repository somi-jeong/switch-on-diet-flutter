import 'package:hive/hive.dart';
import 'meal_record.dart';

part 'diet_record.g.dart';

@HiveType(typeId: 0)
class DietRecord {
  @HiveField(0)
  String date; // "2025-03-12"

  @HiveField(1)
  String? wakeTime; // JST ISO string

  @HiveField(2)
  List<MealRecord> meals;

  @HiveField(3)
  double? weight;

  @HiveField(4)
  double? bodyFat;

  @HiveField(5)
  String? diary; // 식사일기

  @HiveField(6)
  String? aiFeedback; // 하루마감 AI 피드백

  @HiveField(7)
  String? weeklySummary; // 주간 종합 분석 (7일, 14일, 21일, 28일차에만)

  @HiveField(8)
  String? confession; // 오늘의 고백

  @HiveField(9)
  String? confessionFeedback; // 고백에 대한 AI 피드백

  @HiveField(10)
  String? bedTime; // 취침 예정 시간 JST ISO string

  @HiveField(11)
  int warningCount; // 하루 경고 누적 횟수

  @HiveField(12)
  String? actualBedTime; // 실제 취침 시간 JST ISO string

  @HiveField(13)
  String? bedTimeFeedback; // 취침 시간 AI 피드백

  @HiveField(14)
  Map<String, bool>? dailyChecklist; // 데일리 미션 체크리스트 (water, supplements, workout)

  DietRecord({
    required this.date,
    this.wakeTime,
    List<MealRecord>? meals,
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
  }) : meals = meals ?? [];

  double get score {
    if (meals.isEmpty) return 0;
    // 스킵되지 않은 끼니만 카운트
    final activeMeals = meals.where((m) => !m.skipped).toList();
    if (activeMeals.isEmpty) return 0;
    final checkedCount = activeMeals.where((m) => m.checked).length;
    return checkedCount / activeMeals.length;
  }
}
