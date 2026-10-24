import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/history/diet_history_state.dart';

import '../../../helpers/fakes.dart';

void main() {
  test('lists every day up to today, newest first', () async {
    final container = createContainer(
      records: InMemoryDietRecordRepository({
        2: const DietRecord(date: '2026-03-02', weight: 60),
      }),
      clock: FixedClock(DateTime(2026, 3, 3, 9)),
    );

    container.listen(dietHistoryProvider, (_, _) {});
    await container.read(dietRecordsProvider.future);

    final history = container.read(dietHistoryProvider);

    expect(history.map((h) => h.day), [3, 2, 1]);
    expect(history[1].record.weight, 60);
    expect(history.last.dateLabel, '2026.03.01 (일)');
  });

  test('fasting runs from the last meal to the wake-up, across midnight', () {
    final day = DayHistory.of(
      day: 2,
      date: DateTime(2026, 3, 2),
      record: const DietRecord(
        date: '2026-03-02',
        wakeTime: '2026-03-02T07:00:00.000',
        bedTime: '2026-03-02T23:30:00.000',
        meals: [
          MealRecord(
            label: '아침',
            checked: true,
            eatenAt: '2026-03-02T08:00:00.000',
          ),
          MealRecord(
            label: '저녁',
            checked: true,
            eatenAt: '2026-03-02T17:40:00.000',
          ),
        ],
      ),
    );

    expect(day.fastingText, '13h 20m');
    expect(day.sleepText, '7h 30m');
    final empty = DayHistory.of(day: 1, date: DateTime.parse('2026-03-01'));
    expect(empty.fastingText, '--');
  });
}
