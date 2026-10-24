import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

void main() {
  group('MealSchedule.slotsForWakeHour', () {
    List<String> labels(int hour) =>
        MealSchedule.slotsForWakeHour(hour).map((s) => s.label).toList();

    test('waking before 09:00 keeps all four meals', () {
      expect(labels(4), ['아침', '점심', '간식', '저녁']);
      expect(labels(8), ['아침', '점심', '간식', '저녁']);
    });

    test('later wake-ups drop the meals that no longer fit', () {
      expect(labels(9), ['점심', '간식', '저녁']);
      expect(labels(11), ['점심', '저녁']);
      expect(labels(14), ['저녁']);
      expect(labels(17), isEmpty);
    });
  });

  group('meal windows', () {
    final wake = DateTime(2026, 3, 1, 7);

    test('a window is passed only after its end', () {
      bool passed(DateTime now) => MealSchedule.isWindowPassed(
        wakeTime: wake,
        label: MealSchedule.breakfast,
        now: now,
      );

      expect(passed(DateTime(2026, 3, 1, 8, 30)), isFalse);
      expect(passed(DateTime(2026, 3, 1, 8, 31)), isTrue);
    });

    test('recommended time is the middle of the window', () {
      expect(
        MealSchedule.recommendedTime(wakeTime: wake, label: MealSchedule.lunch),
        '11:00',
      );
      expect(MealSchedule.recommendedTime(wakeTime: wake, label: '야식'), '');
    });
  });

  test('food rules switch on day 4 and then by week', () {
    expect(FoodRules.forDay(3).allowed, contains('단백질 쉐이크(하루4회)'));
    expect(FoodRules.forDay(4).allowed, contains('단백질 쉐이크(하루3회)'));
    expect(FoodRules.forDay(8).forbidden, contains('밀가루'));
    expect(FoodRules.forDay(28).allowed, contains('과일 하루1개'));
  });
}
