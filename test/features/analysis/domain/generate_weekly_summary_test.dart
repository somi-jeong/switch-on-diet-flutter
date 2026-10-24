import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/analysis/domain/usecases/generate_weekly_summary.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryDietRecordRepository records;
  late FakeAiCoachRepository coach;

  setUp(() {
    records = InMemoryDietRecordRepository({
      2: const DietRecord(
        date: '2026-03-02',
        wakeTime: '2026-03-02T10:00:00.000',
      ),
      7: const DietRecord(
        date: '2026-03-07',
        wakeTime: '2026-03-07T06:00:00.000',
      ),
      8: const DietRecord(date: '2026-03-08'),
    });
    coach = FakeAiCoachRepository()..feedback = '1주차 수고하셨어요.';
  });

  GenerateWeeklySummary at(DateTime now) => GenerateWeeklySummary(
    records: records,
    coach: coach,
    clock: FixedClock(now),
  );

  test('runs on the last day of a week between 17:00 and 18:59', () async {
    expect(
      await at(DateTime(2026, 3, 7, 16, 59)).runIfDue(startDate: '2026-03-01'),
      isFalse,
    );
    expect(
      await at(DateTime(2026, 3, 6, 18)).runIfDue(startDate: '2026-03-01'),
      isFalse,
    );
    expect(
      await at(DateTime(2026, 3, 7, 18, 30)).runIfDue(startDate: '2026-03-01'),
      isTrue,
    );

    final call = coach.weeklyCalls.single;
    expect(call.week, 1);
    expect(call.days.map((d) => d.day), [2, 7]);
    expect(call.days.first.wakeTimeStatus, '약간늦음');
    expect(records.get(7)!.weeklySummary, '1주차 수고하셨어요.');
  });

  test('flags meals logged two or more hours after they were eaten', () {
    final report = GenerateWeeklySummary.buildDayReport(
      const DietRecord(
        date: '2026-03-02',
        meals: [
          MealRecord(
            label: '아침',
            eatenAt: '2026-03-02T08:00:00.000',
            recordedAt: '2026-03-02T09:59:00.000',
          ),
          MealRecord(
            label: '점심',
            eatenAt: '2026-03-02T12:00:00.000',
            recordedAt: '2026-03-02T15:10:00.000',
          ),
        ],
      ),
      day: 2,
    );

    expect(report.lateRecordings, ['점심 (3시간 차이)']);
    expect(report.wakeTimeStatus, '정상');
  });
}
