import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/data/parsers/coach_action_parser.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';

void main() {
  test('extracts every action tag and strips it from the reply', () {
    const reply =
        '좋아요! 기록해 둘게요.'
        '<ACTION>WAKE:07:00</ACTION>'
        '<ACTION>MEAL:아침:계란, 샐러드</ACTION>'
        '<ACTION>SKIP:간식</ACTION>'
        '<ACTION>SLEEP:23:30</ACTION>';

    final parsed = CoachActionParser.parse(reply);

    expect(parsed.text, '좋아요! 기록해 둘게요.');
    expect(parsed.actions, const [
      CoachAction.wake(time: '07:00'),
      CoachAction.meal(mealType: '아침', foods: '계란, 샐러드'),
      CoachAction.skip(mealType: '간식'),
      CoachAction.sleep(time: '23:30'),
    ]);
  });

  test('ignores unknown or malformed actions', () {
    final parsed = CoachActionParser.parse(
      'hi<ACTION>DANCE:now</ACTION><ACTION>MEAL:아침</ACTION>',
    );

    expect(parsed.actions, isEmpty);
    expect(parsed.text, 'hi');
  });

  test('returns text unchanged when there are no actions', () {
    final parsed = CoachActionParser.parse('그냥 대화');

    expect(parsed.actions, isEmpty);
    expect(parsed.text, '그냥 대화');
  });
}
