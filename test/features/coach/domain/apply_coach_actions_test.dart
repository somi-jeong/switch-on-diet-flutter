import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/usecases/apply_coach_actions.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/usecases/record_wake_time.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryDietRecordRepository records;
  late ApplyCoachActions apply;

  setUp(() {
    records = InMemoryDietRecordRepository({
      5: const DietRecord(date: '2026-03-05', dailyChecklist: {'water': true}),
    });
    apply = ApplyCoachActions(
      records: records,
      recordWakeTime: RecordWakeTime(records),
      clock: FixedClock(DateTime(2026, 3, 5, 13)),
    );
  });

  test('applies wake, meal, skip and sleep in order', () async {
    await apply(const [
      CoachAction.wake(time: '7:30'),
      CoachAction.meal(mealType: '아침', foods: '계란, 샐러드'),
      CoachAction.skip(mealType: '간식'),
      CoachAction.sleep(time: '23:00'),
    ], day: 5);

    final record = records.get(5)!;
    expect(record.wakeTime, '2026-03-05T07:30:00.000');
    expect(record.meals.map((m) => m.label), ['아침', '점심', '간식', '저녁']);
    expect(
      record.mealOf('아침'),
      const MealRecord(
        label: '아침',
        checked: true,
        foodText: '계란, 샐러드',
        eatenAt: '2026-03-05T13:00:00.000',
      ),
    );
    expect(record.mealOf('간식')!.skipped, isTrue);
    expect(record.bedTime, '2026-03-05T23:00:00.000');
    expect(record.dailyChecklist, {'water': true});
  });

  test('skips actions that do not fit instead of failing', () async {
    await apply(const [
      CoachAction.wake(time: 'morning'),
      CoachAction.meal(mealType: '야식', foods: '라면'),
    ], day: 5);

    expect(
      records.get(5),
      const DietRecord(date: '2026-03-05', dailyChecklist: {'water': true}),
    );
  });
}
