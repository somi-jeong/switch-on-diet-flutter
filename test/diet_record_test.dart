import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/models/meal_record.dart';

void main() {
  group('DietRecord.score', () {
    test('is 0 with no meals', () {
      expect(DietRecord(date: '2026-01-01').score, 0);
    });

    test('ignores skipped meals', () {
      final record = DietRecord(
        date: '2026-01-01',
        meals: [
          MealRecord(label: '아침', checked: true),
          MealRecord(label: '점심', checked: true),
          MealRecord(label: '간식', skipped: true),
          MealRecord(label: '저녁'),
        ],
      );
      expect(record.score, closeTo(2 / 3, 1e-9));
    });
  });
}
