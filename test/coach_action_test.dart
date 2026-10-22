import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/models/coach_action.dart';

void main() {
  group('CoachAction.parseActions', () {
    test('extracts every action tag and strips it from the reply', () {
      const reply =
          '좋아요! 기록해 둘게요.'
          '<ACTION>WAKE:07:00</ACTION>'
          '<ACTION>MEAL:아침:계란, 샐러드</ACTION>'
          '<ACTION>SKIP:간식</ACTION>'
          '<ACTION>SLEEP:23:30</ACTION>';

      final parsed = CoachAction.parseActions(reply);

      expect(parsed.cleanedText, '좋아요! 기록해 둘게요.');
      expect(parsed.actions.map((a) => a.type), [
        CoachActionType.wake,
        CoachActionType.meal,
        CoachActionType.skip,
        CoachActionType.sleep,
      ]);
      expect(parsed.actions[0].data['time'], '07:00');
      expect(parsed.actions[1].data, {'mealType': '아침', 'foods': '계란, 샐러드'});
      expect(parsed.actions[2].data['mealType'], '간식');
      expect(parsed.actions[3].data['time'], '23:30');
    });

    test('ignores unknown or malformed actions', () {
      final parsed = CoachAction.parseActions(
        'hi<ACTION>DANCE:now</ACTION><ACTION>MEAL:아침</ACTION>',
      );
      expect(parsed.actions, isEmpty);
      expect(parsed.cleanedText, 'hi');
    });

    test('returns text unchanged when there are no actions', () {
      final parsed = CoachAction.parseActions('그냥 대화');
      expect(parsed.actions, isEmpty);
      expect(parsed.cleanedText, '그냥 대화');
    });
  });
}
