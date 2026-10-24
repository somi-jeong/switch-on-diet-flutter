import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/diet_record/data/mappers/diet_record_mapper.dart';
import 'package:switchon_diet/features/diet_record/data/models/meal_record_model.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

void main() {
  test('a record survives a round trip through the Hive model', () {
    const record = DietRecord(
      date: '2026-03-02',
      wakeTime: '2026-03-02T06:30:00.000',
      meals: [
        MealRecord(
          label: '아침',
          checked: true,
          foodText: '두부',
          verdict: MealVerdict.allowed,
          aiFeedback: '좋아요',
          eatenAt: '2026-03-02T07:30:00.000',
          photoPath: '/legacy/photo.jpg',
        ),
        MealRecord(label: '점심', skipped: true, skipReason: '외근'),
      ],
      weight: 60.2,
      bodyFat: 25,
      warningCount: 1,
      bedTime: '2026-03-02T23:00:00.000',
      dailyChecklist: {'water': true},
    );

    expect(record.toModel().toEntity(), record);
  });

  test('verdicts are stored as their API codes', () {
    const meal = MealRecord(label: '간식', verdict: MealVerdict.forbidden);

    expect(meal.toModel().aiStatus, 'FORBIDDEN');
  });

  test('an unknown stored status maps to no verdict', () {
    const model = MealRecordModel(label: '간식', aiStatus: 'MAYBE');

    expect(model.toEntity().verdict, isNull);
  });
}
