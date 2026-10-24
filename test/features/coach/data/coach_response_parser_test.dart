import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/data/parsers/coach_response_parser.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

void main() {
  group('parseMealAnalysis', () {
    test('reads STATUS / FEEDBACK lines', () {
      final result = CoachResponseParser.parseMealAnalysis(
        'STATUS: warning\nFEEDBACK: 양을 조금 줄여보세요\n',
      );

      expect(
        result,
        const MealAnalysis(
          verdict: MealVerdict.warning,
          feedback: '양을 조금 줄여보세요',
        ),
      );
    });

    test('falls back to keyword detection', () {
      expect(
        CoachResponseParser.parseMealAnalysis('이건 금지 식품입니다').verdict,
        MealVerdict.forbidden,
      );
      expect(
        CoachResponseParser.parseMealAnalysis('괜찮아요').verdict,
        MealVerdict.allowed,
      );
    });
  });

  test(
    'buildWeeklyData lists violations, late records and missed missions',
    () {
      final data = CoachResponseParser.buildWeeklyData(const [
        WeeklyDayReport(
          day: 1,
          meals: [
            MealRecord(label: '아침', verdict: MealVerdict.forbidden),
            MealRecord(label: '점심', verdict: MealVerdict.allowed),
          ],
          score: 0.5,
          lateRecordings: ['아침 (3시간 차이)'],
          wakeTimeStatus: '약간늦음',
          missionsCompleted: 1,
          missionsTotal: 3,
        ),
        WeeklyDayReport(
          day: 2,
          meals: [],
          score: 1,
          lateRecordings: [],
          wakeTimeStatus: '정상',
          missionsCompleted: 3,
          missionsTotal: 3,
        ),
      ]);

      expect(data.summary, '1일차: 50% / 2일차: 100%');
      expect(data.violations, ['1일차 아침: FORBIDDEN']);
      expect(data.lateRecordingDays, ['1일차: 아침 (3시간 차이)']);
      expect(data.wakeTimeIssues, ['1일차: 약간늦음']);
      expect(data.missionIncomplete, ['1일차: 1/3']);
    },
  );

  test('buildChatMessages appends the new message to the history', () {
    final messages = CoachResponseParser.buildChatMessages(
      currentMessage: '오늘 뭐 먹을까요?',
      history: const [
        ChatMessage(role: ChatRole.assistant, text: '안녕하세요', timestamp: ''),
      ],
    );

    expect(messages.map((m) => m.toJson()), [
      {'role': 'assistant', 'content': '안녕하세요'},
      {'role': 'user', 'content': '오늘 뭐 먹을까요?'},
    ]);
  });
}
