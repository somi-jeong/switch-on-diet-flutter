import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/usecases/apply_coach_actions.dart';
import 'package:switchon_diet/features/coach/domain/usecases/send_coach_message.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/domain/usecases/record_wake_time.dart';

import '../../../helpers/fakes.dart';

void main() {
  late InMemoryDietRecordRepository records;
  late FakeAiCoachRepository coach;
  late SendCoachMessage send;

  setUp(() {
    records = InMemoryDietRecordRepository({
      8: const DietRecord(
        date: '2026-03-08',
        meals: [
          MealRecord(label: '아침', checked: true),
          MealRecord(
            label: '점심',
            checked: true,
            verdict: MealVerdict.forbidden,
          ),
          MealRecord(label: '저녁'),
        ],
      ),
      9: const DietRecord(
        date: '2026-03-09',
        wakeTime: '2026-03-09T07:00:00.000',
      ),
    });
    coach = FakeAiCoachRepository();
    send = SendCoachMessage(
      records: records,
      coach: coach,
      applyActions: ApplyCoachActions(
        records: records,
        recordWakeTime: RecordWakeTime(records),
        clock: FixedClock(DateTime(2026, 3, 9, 9)),
      ),
    );
  });

  test('sends the day context and only the last three exchanges', () async {
    final history = [
      for (var i = 0; i < 8; i++)
        ChatMessage(
          role: i.isEven ? ChatRole.user : ChatRole.assistant,
          text: 'm$i',
          timestamp: '',
        ),
    ];

    await send(day: 9, message: '점심 뭐 먹을까요?', history: history);

    final call = coach.replyCalls.single;
    expect(call.message, '점심 뭐 먹을까요?');
    expect(call.history.map((m) => m.text), [
      'm2',
      'm3',
      'm4',
      'm5',
      'm6',
      'm7',
    ]);
    expect(call.context.day, 9);
    expect(call.context.week, 2);
    expect(call.context.wakeTime, '2026-03-09T07:00:00.000');
    expect(call.context.yesterdaySummary, '양호 (67%), 위반: 1건, 미입력: 1끼');
  });

  test('saves the records the coach extracted', () async {
    coach.chatReply = const CoachReply(
      text: '기록했어요',
      actions: [CoachAction.sleep(time: '22:30')],
    );

    final reply = await send(day: 9, message: '10시 반에 잘게요', history: const []);

    expect(reply.text, '기록했어요');
    expect(records.get(9)!.bedTime, '2026-03-09T22:30:00.000');
  });
}
