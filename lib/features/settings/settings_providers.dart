import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/data/repositories/hive_settings_repository.dart';
import 'package:switchon_diet/features/settings/domain/repositories/settings_repository.dart';

/// Opened during bootstrap and injected with `overrideWithValue`.
final settingsBoxProvider = Provider<Box<AppSettingsModel>>(
  (ref) => throw UnimplementedError('settingsBoxProvider is not opened'),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => HiveSettingsRepository(ref.watch(settingsBoxProvider)),
);
