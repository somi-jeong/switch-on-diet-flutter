import 'package:hive/hive.dart';

part 'app_settings_model.g.dart';

/// Hive representation of the settings. Field numbers are part of the
/// on-disk format: never reuse or renumber them.
@HiveType(typeId: 3)
class AppSettingsModel {
  const AppSettingsModel({
    required this.startDate,
    this.mealAlarmEnabled = true,
    this.legacyApiKey,
    this.totalWarningCount = 0,
    this.userName = '다이어터',
  });

  @HiveField(0)
  final String startDate;

  @HiveField(1, defaultValue: true)
  final bool mealAlarmEnabled;

  /// Left over from an earlier AI provider. No longer read, but preserved so
  /// that saving settings does not rewrite fields the app does not own.
  @HiveField(2)
  final String? legacyApiKey;

  @HiveField(3, defaultValue: 0)
  final int totalWarningCount;

  @HiveField(4, defaultValue: '다이어터')
  final String userName;
}
