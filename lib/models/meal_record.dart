import 'package:hive/hive.dart';

part 'meal_record.g.dart';

@HiveType(typeId: 1)
class MealRecord {
  @HiveField(0)
  String label; // "아침"

  @HiveField(1)
  bool checked;

  @HiveField(2)
  String? photoPath; // 로컬 이미지 경로

  @HiveField(3)
  String? photoTimestamp; // JST ISO string

  @HiveField(4)
  String? aiStatus; // "ALLOWED" / "WARNING" / "FORBIDDEN"

  @HiveField(5)
  String? aiFeedback; // AI 한마디

  @HiveField(6)
  String? mealTime; // 식사 시간 (HH:mm 형식)

  @HiveField(7)
  String? foodText; // 먹은 음식 텍스트 입력

  @HiveField(8)
  String? recordedAt; // 소급 입력 시점 JST ISO string

  @HiveField(9)
  bool skipped; // 늦은 기상으로 스킵된 끼니

  @HiveField(10)
  String? eatenAt; // 실제 식사 시간 JST ISO string (수동 수정 가능)

  @HiveField(11)
  String? guideText; // UI 가이드 텍스트 (예: "기상 후 30~90분", "18:30 예정")

  @HiveField(12)
  String? skipReason; // 스킵 이유

  @HiveField(13)
  String? lateReason; // 늦게 입력한 이유

  MealRecord({
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
}
