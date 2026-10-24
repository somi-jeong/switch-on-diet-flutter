import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';

abstract interface class SettingsRepository {
  /// `null` until onboarding has been completed.
  AppSettings? get();

  Future<void> save(AppSettings settings);

  Future<void> clear();
}
