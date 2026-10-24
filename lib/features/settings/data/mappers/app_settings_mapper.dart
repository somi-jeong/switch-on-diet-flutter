import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';

extension AppSettingsModelMapper on AppSettingsModel {
  AppSettings toEntity() => AppSettings(
    startDate: startDate,
    userName: userName,
    mealAlarmEnabled: mealAlarmEnabled,
    totalWarningCount: totalWarningCount,
  );
}

extension AppSettingsMapper on AppSettings {
  AppSettingsModel toModel({String? legacyApiKey}) => AppSettingsModel(
    startDate: startDate,
    userName: userName,
    mealAlarmEnabled: mealAlarmEnabled,
    totalWarningCount: totalWarningCount,
    legacyApiKey: legacyApiKey,
  );
}
