import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/repositories/hive_diet_record_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

import '../../../helpers/hive_test_utils.dart';

void main() {
  late Directory dir;

  tearDown(() => tearDownHive(dir));

  group('with an empty box', () {
    late HiveDietRecordRepository repository;

    setUp(() async {
      dir = await setUpHive();
      repository = HiveDietRecordRepository(
        await Hive.openBox<DietRecordModel>(HiveDietRecordRepository.boxName),
      );
    });

    test('saves and reads a record by program day', () async {
      const record = DietRecord(
        date: '2026-03-05',
        meals: [MealRecord(label: '아침', verdict: MealVerdict.forbidden)],
        dailyChecklist: {'water': true},
      );

      await repository.save(5, record);

      expect(repository.get(5), record);
      expect(repository.get(6), isNull);
      expect(repository.getAll(), {5: record});
    });

    test('watchAll emits the current records and every change', () async {
      const day1 = DietRecord(date: '2026-03-01');
      const day2 = DietRecord(date: '2026-03-02');
      await repository.save(1, day1);

      final emissions = repository.watchAll().take(3).toList();
      await Future<void>.delayed(Duration.zero);
      await repository.save(2, day2);
      await repository.clear();

      expect(await emissions, [
        {1: day1},
        {1: day1, 2: day2},
        <int, DietRecord>{},
      ]);
    });
  });

  test('reads boxes written by the original adapters', () async {
    dir = await setUpHive(fixtureDir: 'test/fixtures/legacy_boxes');
    final repository = HiveDietRecordRepository(
      await Hive.openBox<DietRecordModel>(HiveDietRecordRepository.boxName),
    );

    final record = repository.get(3)!;

    expect(record.date, '2026-03-03');
    expect(record.wakeTime, '2026-03-03T07:10:00.000');
    expect(record.weight, 61.5);
    expect(record.warningCount, 2);
    expect(record.dailyChecklist, {'water': true, 'workout': false});
    expect(record.meals.map((m) => m.label), ['아침', '점심', '간식', '저녁']);
    expect(record.meals[0].verdict, MealVerdict.allowed);
    expect(record.meals[0].foodText, '계란, 샐러드');
    expect(record.meals[1].skipped, isTrue);
    expect(record.meals[1].skipReason, '회의');
    expect(record.meals[2].verdict, MealVerdict.warning);
    expect(record.meals[3].guideText, '18:30 예정');
  });
}
