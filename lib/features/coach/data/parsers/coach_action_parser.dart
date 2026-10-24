import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';

/// Extracts `<ACTION>TYPE:DATA</ACTION>` tags from a coach reply.
///
/// Supported tags: `WAKE:07:00`, `MEAL:아침:계란, 샐러드`, `SKIP:점심` and
/// `SLEEP:23:00`. Unknown or malformed tags are dropped; every tag is removed
/// from the visible text.
abstract final class CoachActionParser {
  static final _tag = RegExp(r'<ACTION>(.*?)</ACTION>', caseSensitive: false);

  static CoachReply parse(String response) {
    final actions = <CoachAction>[];
    var text = response;

    for (final match in _tag.allMatches(response)) {
      final body = match.group(1)?.trim();
      if (body == null || body.isEmpty) continue;
      text = text.replaceAll(match.group(0)!, '').trim();

      final action = _parseAction(body.split(':'));
      if (action != null) actions.add(action);
    }

    return CoachReply(text: text, actions: actions);
  }

  static CoachAction? _parseAction(List<String> parts) {
    String rest(int from) => parts.sublist(from).join(':').trim();

    return switch (parts.first.trim().toUpperCase()) {
      'WAKE' when parts.length >= 2 => CoachAction.wake(time: rest(1)),
      'SLEEP' when parts.length >= 2 => CoachAction.sleep(time: rest(1)),
      'SKIP' when parts.length >= 2 => CoachAction.skip(
        mealType: parts[1].trim(),
      ),
      'MEAL' when parts.length >= 3 => CoachAction.meal(
        mealType: parts[1].trim(),
        foods: rest(2),
      ),
      _ => null,
    };
  }
}
