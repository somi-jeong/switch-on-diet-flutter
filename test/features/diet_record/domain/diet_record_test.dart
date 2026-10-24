import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

void main() {
  group('DietRecord.score', () {
    test('is 0 with no meals', () {
      expect(const DietRecord(date: '2026-01-01').score, 0);
    });

    test('ignores skipped meals', () {
      const record = DietRecord(
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

  test('toggleMission flips one key and keeps the others', () {
    const record = DietRecord(
      date: '2026-01-01',
      dailyChecklist: {'water': true},
    );

    final toggled = record.toggleMission('workout');

    expect(toggled.dailyChecklist, {'water': true, 'workout': true});
    expect(toggled.toggleMission('water').dailyChecklist?['water'], isFalse);
  });

  test('updateMeal replaces only the matching meal', () {
    const record = DietRecord(
      date: '2026-01-01',
      meals: [
        MealRecord(label: '아침'),
        MealRecord(label: '점심'),
      ],
    );

    final updated = record.updateMeal(
      '점심',
      (meal) => meal.copyWith(checked: true, verdict: MealVerdict.allowed),
    );

    expect(updated.meals.first, record.meals.first);
    expect(updated.mealOf('점심')?.checked, isTrue);
    expect(record.updateMeal('야식', (m) => m), same(record));
  });

  test('cleared keeps only the slot information', () {
    const meal = MealRecord(
      label: '아침',
      guideText: '기상 후 30~90분',
      checked: true,
      foodText: '계란',
      verdict: MealVerdict.warning,
      lateReason: '회의',
    );

    expect(
      meal.cleared(),
      const MealRecord(label: '아침', guideText: '기상 후 30~90분'),
    );
  });

  test('MealVerdict round-trips through its stored code', () {
    for (final verdict in MealVerdict.values) {
      expect(MealVerdict.fromCode(verdict.code), verdict);
    }
    expect(MealVerdict.fromCode(null), isNull);
    expect(MealVerdict.fromCode('UNKNOWN'), isNull);
  });
}
