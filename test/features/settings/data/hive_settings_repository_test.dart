import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/data/repositories/hive_settings_repository.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';

import '../../../helpers/hive_test_utils.dart';

void main() {
  late Directory dir;
  late Box<AppSettingsModel> box;
  late HiveSettingsRepository repository;

  setUp(() async {
    dir = await setUpHive(fixtureDir: 'test/fixtures/legacy_boxes');
    box = await Hive.openBox<AppSettingsModel>(HiveSettingsRepository.boxName);
    repository = HiveSettingsRepository(box);
  });

  tearDown(() => tearDownHive(dir));

  test('reads settings written by the original adapter', () {
    expect(
      repository.get(),
      const AppSettings(
        startDate: '2026-03-01',
        userName: '소미',
        totalWarningCount: 1,
      ),
    );
  });

  test('saving keeps the legacy field it does not own', () async {
    await repository.save(repository.get()!.copyWith(userName: '새 이름'));

    expect(repository.get()!.userName, '새 이름');
    expect(box.get('settings')!.legacyApiKey, 'legacy-key');
  });

  test('clear removes the settings', () async {
    await repository.clear();

    expect(repository.get(), isNull);
  });
}
