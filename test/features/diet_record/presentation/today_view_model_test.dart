import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  // Day 3 of a challenge that started on 2026-03-01.
  late FixedClock clock;
  late InMemoryDietRecordRepository records;
  late ProviderContainer container;

  setUp(() {
    clock = FixedClock(DateTime(2026, 3, 3, 12));
    records = InMemoryDietRecordRepository();
  });

  Future<TodayState> start() async {
    container = createContainer(records: records, clock: clock);
    container.listen(todayViewModelProvider, (_, _) {});
    return container.read(todayViewModelProvider.future);
  }

  TodayViewModel viewModel() => container.read(todayViewModelProvider.notifier);

  Future<TodayState> settled() async {
    await Future<void>.delayed(Duration.zero);
    return container.read(todayViewModelProvider.future);
  }

  test("creates today's record on first open", () async {
    final state = await start();

    expect(state.day, 3);
    expect(state.hasWoken, isFalse);
    expect(records.get(3), const DietRecord(date: '2026-03-03'));
  });

  group('recordWakeTime', () {
    test('lays out the meals that fit after the wake-up time', () async {
      await start();

      await viewModel().recordWakeTime(DateTime(2026, 3, 3, 10));
      final state = await settled();

      expect(state.record.meals.map((m) => m.label), ['점심', '간식', '저녁']);
      expect(state.wakeTime, DateTime(2026, 3, 3, 10));
    });

    test('keeps missions, bedtime and recorded meals when corrected', () async {
      records = InMemoryDietRecordRepository({
        3: const DietRecord(
          date: '2026-03-03',
          wakeTime: '2026-03-03T07:00:00.000',
          bedTime: '2026-03-03T23:00:00.000',
          dailyChecklist: {'water': true, 'workout': true},
          meals: [
            MealRecord(label: '아침', checked: true, foodText: '두부'),
            MealRecord(label: '점심'),
            MealRecord(label: '간식'),
            MealRecord(label: '저녁'),
          ],
        ),
      });
      await start();

      await viewModel().recordWakeTime(DateTime(2026, 3, 3, 6, 30));
      final record = (await settled()).record;

      expect(record.wakeTime, '2026-03-03T06:30:00.000');
      expect(record.dailyChecklist, {'water': true, 'workout': true});
      expect(record.bedTime, '2026-03-03T23:00:00.000');
      expect(record.mealOf('아침')?.foodText, '두부');
    });
  });

  test('toggleMission and skipMeal leave the rest of the day intact', () async {
    records = InMemoryDietRecordRepository({
      3: const DietRecord(
        date: '2026-03-03',
        wakeTime: '2026-03-03T07:00:00.000',
        meals: [MealRecord(label: '아침', guideText: '기상 후 30~90분')],
      ),
    });
    await start();

    await viewModel().toggleMission('water');
    await viewModel().skipMeal('아침', reason: '늦잠');
    final record = (await settled()).record;

    expect(record.dailyChecklist, {'water': true});
    expect(
      record.mealOf('아침'),
      const MealRecord(
        label: '아침',
        skipped: true,
        guideText: '기상 후 30~90분',
        skipReason: '늦잠',
      ),
    );
  });

  test(
    'the timeline marks closed windows as missed and the next open one',
    () async {
      records = InMemoryDietRecordRepository({
        3: const DietRecord(
          date: '2026-03-03',
          wakeTime: '2026-03-03T07:00:00.000',
          meals: [
            MealRecord(label: '아침'),
            MealRecord(label: '점심'),
            MealRecord(label: '간식'),
          ],
        ),
      });

      final timeline = (await start()).timeline;

      // At 12:00 breakfast (07:30-08:30) is over and lunch (10:30-11:30) too.
      expect(timeline.map((t) => (t.isMissed, t.isNext)), [
        (true, false),
        (true, false),
        (false, true),
      ]);
    },
  );

  test(
    "recordMissedBedtime writes yesterday's bedtime on yesterday's date",
    () async {
      records = InMemoryDietRecordRepository({
        2: const DietRecord(
          date: '2026-03-02',
          wakeTime: '2026-03-02T07:00:00.000',
        ),
      });
      final state = await start();
      expect(state.hasMissedBedtime, isTrue);

      await viewModel().recordMissedBedtime(
        const TimeOfDay(hour: 23, minute: 30),
      );

      expect(records.get(2)!.bedTime, '2026-03-02T23:30:00.000');
      expect((await settled()).hasMissedBedtime, isFalse);
    },
  );

  test('picks up writes made elsewhere', () async {
    await start();

    await records.save(3, const DietRecord(date: '2026-03-03', weight: 60));

    expect((await settled()).record.weight, 60);
  });
}
