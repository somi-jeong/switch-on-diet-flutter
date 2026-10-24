import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/coach/data/datasources/chat_local_data_source.dart';
import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/models/meal_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/repositories/hive_diet_record_repository.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/meal/data/meal_reminder_service.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/data/repositories/hive_settings_repository.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';
import 'package:timezone/data/latest.dart' as tz;

/// A startup step that the app cannot run without.
class BootstrapException implements Exception {
  const BootstrapException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Prepares configuration, time zones and local storage, and returns the
/// provider overrides that hand the opened storage to the app.
Future<List<Override>> bootstrap() async {
  await _run('.env file not found or invalid', () => dotenv.load());
  await _run('Timezone init failed', () async => tz.initializeTimeZones());
  final overrides = await _run('Storage init failed', _openStorage);

  try {
    await MealReminderService().init();
  } on Object catch (error) {
    // Reminders are optional; the app works without them.
    debugPrint('Notification init failed: $error');
  }
  return overrides;
}

Future<T> _run<T>(String failure, Future<T> Function() step) async {
  try {
    return await step();
  } on Object catch (error, stack) {
    debugPrint('$failure: $error\n$stack');
    throw BootstrapException('$failure: $error');
  }
}

Future<List<Override>> _openStorage() async {
  // On the web Hive persists to IndexedDB; elsewhere to the documents folder.
  await Hive.initFlutter();
  Hive
    ..registerAdapter(DietRecordModelAdapter())
    ..registerAdapter(MealRecordModelAdapter())
    ..registerAdapter(AppSettingsModelAdapter());

  return [
    dietRecordBoxProvider.overrideWithValue(
      await Hive.openBox<DietRecordModel>(HiveDietRecordRepository.boxName),
    ),
    settingsBoxProvider.overrideWithValue(
      await Hive.openBox<AppSettingsModel>(HiveSettingsRepository.boxName),
    ),
    chatBoxProvider.overrideWithValue(
      await Hive.openBox<String>(ChatLocalDataSource.chatsBoxName),
    ),
    daySummaryBoxProvider.overrideWithValue(
      await Hive.openBox<String>(ChatLocalDataSource.daySummariesBoxName),
    ),
  ];
}
