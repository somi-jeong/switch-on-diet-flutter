import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

/// App-wide settings; `null` until onboarding is complete.
///
/// Every settings change goes through this notifier so that screens which
/// watch [settingsProvider] rebuild immediately.
class SettingsNotifier extends Notifier<AppSettings?> {
  @override
  AppSettings? build() => ref.watch(settingsRepositoryProvider).get();

  Future<void> start({required DateTime startDate, required String userName}) =>
      _save(
        AppSettings(
          startDate: Jst.isoDate(startDate),
          userName: userName.trim().isEmpty
              ? AppSettings.defaultUserName
              : userName.trim(),
        ),
      );

  Future<void> rename(String userName) async {
    final current = state;
    if (current == null || userName.trim().isEmpty) return;
    await _save(current.copyWith(userName: userName.trim()));
  }

  Future<void> changeStartDate(DateTime startDate) async {
    final current = state;
    if (current == null) return;
    await _save(current.copyWith(startDate: Jst.isoDate(startDate)));
  }

  /// Deletes all records, chats and settings.
  Future<void> reset() async {
    await ref.read(resetChallengeProvider).call();
    state = null;
  }

  Future<void> _save(AppSettings settings) async {
    await ref.read(settingsRepositoryProvider).save(settings);
    state = settings;
  }
}
