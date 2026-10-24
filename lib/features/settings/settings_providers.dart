import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/data/repositories/hive_settings_repository.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';
import 'package:switchon_diet/features/settings/domain/repositories/settings_repository.dart';
import 'package:switchon_diet/features/settings/domain/usecases/reset_challenge.dart';
import 'package:switchon_diet/features/settings/presentation/settings_notifier.dart';

/// Opened during bootstrap and injected with `overrideWithValue`.
final settingsBoxProvider = Provider<Box<AppSettingsModel>>(
  (ref) => throw UnimplementedError('settingsBoxProvider is not opened'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => HiveSettingsRepository(ref.watch(settingsBoxProvider)),
);

final resetChallengeProvider = Provider<ResetChallenge>(
  (ref) => ResetChallenge(
    records: ref.watch(dietRecordRepositoryProvider),
    settings: ref.watch(settingsRepositoryProvider),
    chats: ref.watch(chatRepositoryProvider),
  ),
);

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings?>(
  SettingsNotifier.new,
);

/// Maps dates onto the program; `null` before onboarding.
final challengeCalendarProvider = Provider<ChallengeCalendar?>((ref) {
  final startDate = ref.watch(settingsProvider.select((s) => s?.startDate));
  return startDate == null ? null : ChallengeCalendar.fromIsoDate(startDate);
});

/// Today's program day (1-28); `null` before onboarding.
///
/// Computed once and cached: the main shell invalidates it when the app
/// resumes so that a new day is picked up.
final currentDayProvider = Provider<int?>((ref) {
  final calendar = ref.watch(challengeCalendarProvider);
  return calendar?.dayAt(ref.watch(clockProvider).now());
});
