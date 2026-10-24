import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_state.dart';

void main() {
  const eaten = MealRecord(label: '아침', checked: true);

  final calendar = CalendarState(
    today: 9,
    now: DateTime(2026, 3, 9, 21),
    // A Sunday, so the grid has no leading blanks.
    startDate: DateTime.parse('2026-03-01'),
    records: const {
      1: DietRecord(date: '2026-03-01', meals: [eaten]),
      2: DietRecord(
        date: '2026-03-02',
        meals: [
          eaten,
          MealRecord(label: '점심', verdict: MealVerdict.forbidden),
        ],
      ),
      3: DietRecord(
        date: '2026-03-03',
        meals: [
          eaten,
          MealRecord(label: '점심'),
        ],
      ),
      4: DietRecord(
        date: '2026-03-04',
        meals: [MealRecord(label: '점심', skipped: true)],
      ),
    },
  );

  test('classifies each day for the grid', () {
    expect(
      [for (var day = 1; day <= 6; day++) calendar.statusOf(day)],
      [
        DayStatus.done,
        DayStatus.warning,
        DayStatus.incomplete,
        DayStatus.warning,
        DayStatus.incomplete,
        DayStatus.incomplete,
      ],
    );
    expect(calendar.statusOf(9), DayStatus.today);
    expect(calendar.statusOf(10), DayStatus.future);
    expect(calendar.leadingBlankDays, 0);
  });

  test('summarises the meals of a day', () {
    expect(calendar.mealsOf(2).map((m) => m.status), [
      MealSummaryStatus.recorded,
      MealSummaryStatus.violation,
    ]);
    expect(calendar.mealsOf(4).single.text, '기상 지연으로 스킵');
    expect(calendar.mealsOf(5), isEmpty);
  });

  test('reports weekly progress against the 80% threshold', () {
    expect(
      calendar.progressOf(1),
      const WeekProgress(status: '완료 14%', progress: 1 / 7, isActive: false),
    );
    expect(calendar.progressOf(2).status, '진행중 0%');
    expect(calendar.progressOf(2).isActive, isTrue);
    expect(
      calendar.progressOf(3),
      const WeekProgress(status: '예정', isActive: false),
    );
    expect(calendar.achievedDays, 1);
  });
}
