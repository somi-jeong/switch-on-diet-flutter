import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/domain/usecases/apply_coach_actions.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';

/// Sends a chat message to the coach with the context of the current day,
/// then saves any records the coach extracted from the conversation.
class SendCoachMessage {
  const SendCoachMessage({
    required DietRecordRepository records,
    required AiCoachRepository coach,
    required ApplyCoachActions applyActions,
  }) : _records = records,
       _coach = coach,
       _applyActions = applyActions;

  /// Only the last three exchanges are sent, to keep requests small.
  static const historyLimit = 6;

  final DietRecordRepository _records;
  final AiCoachRepository _coach;
  final ApplyCoachActions _applyActions;

  /// [history] is the conversation before [message], oldest first.
  Future<CoachReply> call({
    required int day,
    required String message,
    required List<ChatMessage> history,
  }) async {
    final today = _records.get(day);
    final context = CoachContext(
      day: day,
      week: ChallengeCalendar.weekOf(day),
      wakeTime: today?.wakeTime,
      meals: today?.meals ?? const [],
      foodRules: FoodRules.forDay(day),
      yesterdaySummary: day > 1 ? summarize(_records.get(day - 1)) : null,
    );
    final recent = history.length > historyLimit
        ? history.sublist(history.length - historyLimit)
        : history;

    final reply = await _coach.reply(
      message: message,
      context: context,
      history: recent,
    );
    if (reply.actions.isNotEmpty) {
      await _applyActions(reply.actions, day: day);
    }
    return reply;
  }

  /// One line about [record], e.g. `양호 (66%), 위반: 1건, 미입력: 0끼`.
  static String? summarize(DietRecord? record) {
    if (record == null) return null;
    final score = (record.score * 100).round();
    final grade = score >= 80
        ? '완벽'
        : score >= 60
        ? '양호'
        : '미흡';
    final violations = record.countVerdict(MealVerdict.forbidden);
    final missed = record.meals.where((m) => m.isPending).length;
    return '$grade ($score%), 위반: $violations건, 미입력: $missed끼';
  }
}
