import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';

/// The AI coach. Every method throws an [AiFailure] when the request fails.
abstract interface class AiCoachRepository {
  Future<MealAnalysis> analyzeMeal({
    required String foodText,
    required int day,
    required int week,
    required FoodRules foodRules,
  });

  /// Answers [message]; [history] is the conversation so far, oldest first.
  Future<CoachReply> reply({
    required String message,
    required CoachContext context,
    required List<ChatMessage> history,
  });

  Future<String> dailyFeedback(DailyReport report);

  Future<String> weeklySummary({
    required int week,
    required List<WeeklyDayReport> days,
  });
}
