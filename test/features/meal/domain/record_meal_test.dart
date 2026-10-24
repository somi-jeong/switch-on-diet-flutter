import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/meal/domain/usecases/record_meal.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryDietRecordRepository records;
  late FakeAiCoachRepository coach;
  late RecordMeal recordMeal;

  setUp(() {
    records = InMemoryDietRecordRepository({
      2: const DietRecord(
        date: '2026-03-02',
        meals: [MealRecord(label: '점심', lateReason: '회의')],
      ),
    });
    coach = FakeAiCoachRepository()
      ..mealAnalysis = const MealAnalysis(
        verdict: MealVerdict.warning,
        feedback: '양을 줄여보세요',
      );
    recordMeal = RecordMeal(
      records: records,
      coach: coach,
      clock: FixedClock(DateTime(2026, 3, 2, 13)),
    );
  });

  Future<MealAnalysis> record() => recordMeal(
    day: 2,
    label: '점심',
    foodText: '현미밥, 닭가슴살',
    eatenAt: DateTime(2026, 3, 2, 12, 15),
  );

  test('stores the meal together with the verdict', () async {
    final analysis = await record();

    expect(analysis.verdict, MealVerdict.warning);
    expect(
      records.get(2)!.mealOf('점심'),
      const MealRecord(
        label: '점심',
        checked: true,
        foodText: '현미밥, 닭가슴살',
        eatenAt: '2026-03-02T12:15:00.000',
        recordedAt: '2026-03-02T13:00:00.000',
        verdict: MealVerdict.warning,
        aiFeedback: '양을 줄여보세요',
        lateReason: '회의',
      ),
    );
  });

  test('keeps the meal when the analysis fails', () async {
    coach.failure = const RateLimitFailure();

    await expectLater(record(), throwsA(isA<RateLimitFailure>()));

    final meal = records.get(2)!.mealOf('점심')!;
    expect(meal.checked, isTrue);
    expect(meal.foodText, '현미밥, 닭가슴살');
    expect(meal.verdict, isNull);
  });

  test('refuses a meal the day does not have', () {
    expect(
      recordMeal(
        day: 2,
        label: '아침',
        foodText: '계란',
        eatenAt: DateTime(2026, 3, 2, 8),
      ),
      throwsA(isA<MealSlotNotFound>()),
    );
  });
}
