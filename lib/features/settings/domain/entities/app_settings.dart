import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// First day of the challenge, `yyyy-MM-dd`.
    required String startDate,
    @Default(AppSettings.defaultUserName) String userName,
    @Default(true) bool mealAlarmEnabled,
    @Default(0) int totalWarningCount,
  }) = _AppSettings;

  static const defaultUserName = '다이어터';
}
