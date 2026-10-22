import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 3)
class AppSettings {
  @HiveField(0)
  String startDate; // "2025-03-12"

  @HiveField(1)
  bool mealAlarmEnabled;

  @HiveField(2)
  String? geminiApiKey;

  @HiveField(3)
  int totalWarningCount; // 전체 챌린지 경고 누적 횟수 (5회 도달 시 강제 리셋)

  @HiveField(4)
  String userName; // 사용자 이름 (기본값: "다이어터")

  AppSettings({
    required this.startDate,
    this.mealAlarmEnabled = true,
    this.geminiApiKey,
    this.totalWarningCount = 0,
    this.userName = '다이어터',
  });
}
