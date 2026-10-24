import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_state.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryDietRecordRepository records;
  late FakeAiCoachRepository coach;
  late ProviderContainer container;

  setUp(() {
    records = InMemoryDietRecordRepository({
      3: const DietRecord(
        date: '2026-03-03',
        meals: [MealRecord(label: '아침')],
      ),
    });
    coach = FakeAiCoachRepository();
    container = createContainer(
      records: records,
      clock: FixedClock(DateTime(2026, 3, 3, 8, 40)),
      coach: coach,
    );
  });

  const today = RecordMealTarget(day: 3, mealType: '아침');

  RecordMealViewModel viewModel(RecordMealTarget target) {
    container.listen(recordMealViewModelProvider(target), (_, _) {});
    return container.read(recordMealViewModelProvider(target).notifier);
  }

  RecordMealState stateOf(RecordMealTarget target) =>
      container.read(recordMealViewModelProvider(target));

  test('a new entry starts at the current time with nothing to save', () {
    viewModel(today);

    expect(stateOf(today).timeText, '08:40');
    expect(stateOf(today).canSave, isFalse);
  });

  test('an edit starts from the stored entry; past days round to the hour', () {
    const target = RecordMealTarget(
      day: 1,
      mealType: '점심',
      isPastDate: true,
      existingMeal: MealRecord(
        label: '점심',
        foodText: '두부',
        eatenAt: '2026-03-01T12:35:00.000',
      ),
    );
    viewModel(target);

    expect(stateOf(target).foodText, '두부');
    expect(stateOf(target).timeText, '12:00');
  });

  test('setTime ignores input until it is a valid HH:mm', () {
    final vm = viewModel(today)..setTime('25:00');
    expect(stateOf(today).timeText, '08:40');

    vm.setTime('7:05');
    expect(stateOf(today).timeText, '07:05');
  });

  test('save reports the verdict and stores the meal on that day', () async {
    final vm = viewModel(today)
      ..setFoodText('계란, 샐러드')
      ..setTime('08:10');

    final outcome = await vm.save();

    expect(outcome, isA<MealAnalyzed>());
    final meal = records.get(3)!.mealOf('아침')!;
    expect(meal.foodText, '계란, 샐러드');
    expect(meal.eatenAt, '2026-03-03T08:10:00.000');
    expect(stateOf(today).isSaving, isFalse);
  });

  test('a rate limit is reported as a saved-but-unanalysed meal', () async {
    coach.failure = const RateLimitFailure();
    final vm = viewModel(today)..setFoodText('계란');

    final outcome = await vm.save();

    expect(
      outcome,
      isA<MealAnalysisFailed>().having((o) => o.title, 'title', 'AI 분석 한도 초과'),
    );
    expect(records.get(3)!.mealOf('아침')!.checked, isTrue);
  });

  test('delete clears the entry', () async {
    await records.save(
      3,
      const DietRecord(
        date: '2026-03-03',
        meals: [MealRecord(label: '아침', checked: true, foodText: '계란')],
      ),
    );

    await viewModel(today).delete();

    expect(records.get(3)!.mealOf('아침'), const MealRecord(label: '아침'));
  });
}
