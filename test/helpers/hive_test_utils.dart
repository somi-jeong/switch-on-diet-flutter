import 'dart:io';

import 'package:hive/hive.dart';
import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/models/meal_record_model.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';

/// Points Hive at a fresh temporary directory, optionally seeded with the
/// box files in [fixtureDir]. Call [tearDownHive] when done.
Future<Directory> setUpHive({String? fixtureDir}) async {
  final dir = await Directory.systemTemp.createTemp('switchon_hive_');
  if (fixtureDir != null) {
    for (final file in Directory(fixtureDir).listSync().whereType<File>()) {
      file.copySync('${dir.path}/${file.uri.pathSegments.last}');
    }
  }
  Hive.init(dir.path);
  _registerAdapter(DietRecordModelAdapter());
  _registerAdapter(MealRecordModelAdapter());
  _registerAdapter(AppSettingsModelAdapter());
  return dir;
}

Future<void> tearDownHive(Directory dir) async {
  await Hive.close();
  await dir.delete(recursive: true);
}

void _registerAdapter<T>(TypeAdapter<T> adapter) {
  if (!Hive.isAdapterRegistered(adapter.typeId)) Hive.registerAdapter(adapter);
}
