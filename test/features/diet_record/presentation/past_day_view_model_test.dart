import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/presentation/past_day/past_day_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  test(
    "a backfilled wake-up uses that day's date and plans all meals",
    () async {
      final records = InMemoryDietRecordRepository();
      final container = createContainer(
        records: records,
        clock: FixedClock(DateTime(2026, 3, 10, 9)),
      );
      container.listen(pastDayViewModelProvider(2), (_, _) {});

      expect(container.read(pastDayViewModelProvider(2)).date, '2026-03-02');

      await container
          .read(pastDayViewModelProvider(2).notifier)
          .recordWakeHour(7);

      final record = records.get(2)!;
      expect(record.date, '2026-03-02');
      expect(record.wakeTime, '2026-03-02T07:00:00.000');
      expect(record.meals.map((m) => m.guideText), [
        '07:30 ~ 08:30 예정',
        '10:30 ~ 11:30 예정',
        '13:30 ~ 14:30 예정',
        '16:30 ~ 17:30 예정',
      ]);
    },
  );
}
