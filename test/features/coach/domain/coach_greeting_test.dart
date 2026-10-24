import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/coach_greeting.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

void main() {
  final morning = DateTime(2026, 3, 2, 8);

  test('a fresh first day gets the plain greeting', () {
    final text = CoachGreeting.compose(day: 1, records: {}, now: morning);

    expect(text, startsWith('안녕하세요! 스위치온 다이어트 1일차입니다'));
    expect(text, contains('순조롭게'));
  });

  test('lists what is missing today and on earlier days', () {
    final text = CoachGreeting.compose(
      day: 2,
      records: {
        2: const DietRecord(
          date: '2026-03-02',
          wakeTime: '2026-03-02T10:15:00.000',
          meals: [
            MealRecord(label: '점심'),
            MealRecord(
              label: '저녁',
              verdict: MealVerdict.forbidden,
              checked: true,
            ),
          ],
        ),
      },
      now: morning,
    );

    expect(text, contains('1일차 기록이 없어요'));
    expect(text, contains('10시 15분 기상으로 늦은 편이에요'));
    expect(text, contains('아직 입력 안 한 식사가 1끼 있어요'));
    expect(text, contains('허용되지 않은 음식을 1번 드셨어요'));
    expect(text, isNot(contains('데일리 미션')));
  });

  test('mentions unfinished missions only in the evening', () {
    final records = {
      1: const DietRecord(
        date: '2026-03-01',
        wakeTime: '2026-03-01T07:00:00.000',
        dailyChecklist: {'water': true},
      ),
    };

    final evening = CoachGreeting.compose(
      day: 1,
      records: records,
      now: DateTime(2026, 3, 1, 21),
    );

    expect(evening, contains('지금 21시인데'));
    expect(evening, contains('영양제, 운동를 아직 안 하셨네요'));
  });

  test('grades yesterday by its achievement rate', () {
    String yesterdayLine(double eaten) => CoachGreeting.compose(
      day: 2,
      records: {
        1: DietRecord(
          date: '2026-03-01',
          wakeTime: '2026-03-01T07:00:00.000',
          aiFeedback: '수고하셨어요',
          meals: [
            MealRecord(label: '아침', checked: eaten >= 1),
            MealRecord(label: '점심', checked: eaten >= 2),
          ],
        ),
      },
      now: morning,
    ).split('💭 어제: ').last;

    expect(yesterdayLine(2), '완벽했어요! (100%)');
    expect(yesterdayLine(1), '조금 아쉬웠어요 (50%)');
  });
}
