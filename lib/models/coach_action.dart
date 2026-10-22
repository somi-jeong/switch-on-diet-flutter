/// Model for coach AI actions extracted from responses
class CoachAction {
  final CoachActionType type;
  final Map<String, dynamic> data;

  const CoachAction({required this.type, required this.data});

  /// Parse actions from AI response text
  /// Returns list of actions and cleaned text (without action tags)
  static ParsedResponse parseActions(String response) {
    final actions = <CoachAction>[];
    var cleanedText = response;

    // Extract all <ACTION>...</ACTION> tags
    final actionRegex = RegExp(r'<ACTION>(.*?)</ACTION>', caseSensitive: false);
    final matches = actionRegex.allMatches(response);

    for (final match in matches) {
      final actionText = match.group(1)?.trim();
      if (actionText == null || actionText.isEmpty) continue;

      // Remove the action tag from the text
      cleanedText = cleanedText.replaceAll(match.group(0)!, '').trim();

      // Parse action format: TYPE:DATA
      final parts = actionText.split(':');
      if (parts.isEmpty) continue;

      final typeStr = parts[0].trim().toUpperCase();
      CoachAction? action;

      switch (typeStr) {
        case 'WAKE':
          // Format: WAKE:07:00
          if (parts.length >= 2) {
            final time = parts.sublist(1).join(':').trim();
            action = CoachAction(
              type: CoachActionType.wake,
              data: {'time': time},
            );
          }
          break;

        case 'MEAL':
          // Format: MEAL:아침:계란, 샐러드
          if (parts.length >= 3) {
            final mealType = parts[1].trim();
            final foods = parts.sublist(2).join(':').trim();
            action = CoachAction(
              type: CoachActionType.meal,
              data: {'mealType': mealType, 'foods': foods},
            );
          }
          break;

        case 'SKIP':
          // Format: SKIP:점심
          if (parts.length >= 2) {
            final mealType = parts[1].trim();
            action = CoachAction(
              type: CoachActionType.skip,
              data: {'mealType': mealType},
            );
          }
          break;

        case 'SLEEP':
          // Format: SLEEP:23:00
          if (parts.length >= 2) {
            final time = parts.sublist(1).join(':').trim();
            action = CoachAction(
              type: CoachActionType.sleep,
              data: {'time': time},
            );
          }
          break;
      }

      if (action != null) {
        actions.add(action);
      }
    }

    return ParsedResponse(cleanedText: cleanedText, actions: actions);
  }
}

enum CoachActionType { wake, meal, skip, sleep }

class ParsedResponse {
  final String cleanedText;
  final List<CoachAction> actions;

  const ParsedResponse({required this.cleanedText, required this.actions});
}
