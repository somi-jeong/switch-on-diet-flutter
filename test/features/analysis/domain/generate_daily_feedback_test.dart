import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/analysis/domain/usecases/generate_daily_feedback.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

import '../../../helpers/fakes.dart';

void main() {
  const day3 = DietRecord(
    date: '2026-03-03',
    wakeTime: '2026-03-03T07:00:00.000',
    warningCount: 2,
    dailyChecklist: {'water': true, 'workout': false},
    meals: [
      MealRecord(label: '아침', checked: true, verdict: MealVerdict.allowed),
      MealRecord(label: '점심', checked: true, verdict: MealVerdict.forbidden),
      MealRecord(label: '간식', skipped: true),
      MealRecord(label: '저녁'),
    ],
  );

  late InMemoryDietRecordRepository records;
  late FakeAiCoachRepository coach;

  setUp(() {
    records = InMemoryDietRecordRepository({3: day3});
    coach = FakeAiCoachRepository()..feedback = '오늘은 점심이 아쉬웠어요.';
  });

  GenerateDailyFeedback at(DateTime now) => GenerateDailyFeedback(
    records: records,
    coach: coach,
    clock: FixedClock(now),
  );

  test('runs only during the 23:00 hour', () async {
    final ran = await at(
      DateTime(2026, 3, 3, 22, 59),
    ).runIfDue(startDate: '2026-03-01');

    expect(ran, isFalse);
    expect(coach.dailyReports, isEmpty);
  });

  test("writes today's review once", () async {
    final generate = at(DateTime(2026, 3, 3, 23, 10));

    expect(await generate.runIfDue(startDate: '2026-03-01'), isTrue);
    expect(await generate.runIfDue(startDate: '2026-03-01'), isFalse);

    expect(records.get(3)!.aiFeedback, '오늘은 점심이 아쉬웠어요.');
    expect(coach.dailyReports, hasLength(1));
  });

  test('builds the report from active meals and verdicts', () {
    final report = GenerateDailyFeedback.buildReport(
      day3,
      day: 3,
      now: DateTime(2026, 3, 3, 23),
    );

    expect(report.week, 1);
    expect(report.fastingHours, 16);
    expect(report.completedMeals, 2);
    expect(report.totalMeals, 3);
    expect(report.scorePercent, 67);
    expect(report.allowedCount, 1);
    expect(report.forbiddenCount, 1);
    expect(report.warningCountTotal, 2);
    expect(report.missionsCompleted, 1);
    expect(report.missionsTotal, 2);
  });
}
