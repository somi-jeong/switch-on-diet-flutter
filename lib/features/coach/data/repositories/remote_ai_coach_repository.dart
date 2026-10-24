import 'package:switchon_diet/features/coach/data/datasources/anthropic_remote_data_source.dart';
import 'package:switchon_diet/features/coach/data/parsers/coach_action_parser.dart';
import 'package:switchon_diet/features/coach/data/parsers/coach_response_parser.dart';
import 'package:switchon_diet/features/coach/data/prompts/coach_prompt_builder.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';

/// [AiCoachRepository] backed by the Anthropic Messages API.
///
/// Each feature gets its own token budget: a meal verdict needs two short
/// lines, a weekly summary several paragraphs.
class RemoteAiCoachRepository implements AiCoachRepository {
  RemoteAiCoachRepository(this._remote);

  static const mealAnalysisMaxTokens = 500;
  static const chatMaxTokens = 2000;
  static const dailyFeedbackMaxTokens = 2500;
  static const weeklySummaryMaxTokens = 3500;

  final AnthropicRemoteDataSource _remote;

  @override
  Future<MealAnalysis> analyzeMeal({
    required String foodText,
    required int day,
    required int week,
    required FoodRules foodRules,
  }) async {
    final text = await _remote.createMessage(
      system: CoachPromptBuilder.textAnalysisSystem(),
      messages: [
        AnthropicMessage.user(
          CoachPromptBuilder.textAnalysisUser(
            foodText: foodText,
            week: week,
            day: day,
            allowedFoods: foodRules.allowed,
            forbiddenFoods: foodRules.forbidden,
          ),
        ),
      ],
      maxTokens: mealAnalysisMaxTokens,
      temperature: 0.2,
    );
    return CoachResponseParser.parseMealAnalysis(text);
  }

  @override
  Future<CoachReply> reply({
    required String message,
    required CoachContext context,
    required List<ChatMessage> history,
  }) async {
    final text = await _remote.createMessage(
      system: CoachPromptBuilder.coachChatSystem(context),
      messages: CoachResponseParser.buildChatMessages(
        currentMessage: message,
        history: history,
      ),
      maxTokens: chatMaxTokens,
    );
    return CoachActionParser.parse(text);
  }

  @override
  Future<String> dailyFeedback(DailyReport report) => _remote.createMessage(
    system: CoachPromptBuilder.dailyFeedbackSystem(),
    messages: [
      AnthropicMessage.user(CoachPromptBuilder.dailyFeedbackUser(report)),
    ],
    maxTokens: dailyFeedbackMaxTokens,
  );

  @override
  Future<String> weeklySummary({
    required int week,
    required List<WeeklyDayReport> days,
  }) {
    final data = CoachResponseParser.buildWeeklyData(days);
    return _remote.createMessage(
      system: CoachPromptBuilder.weeklySummarySystem(week: week),
      messages: [
        AnthropicMessage.user(
          CoachPromptBuilder.weeklySummaryUser(
            week: week,
            summary: data.summary,
            violations: data.violations,
            lateRecordingDays: data.lateRecordingDays,
            wakeTimeIssues: data.wakeTimeIssues,
            missionIncomplete: data.missionIncomplete,
          ),
        ),
      ],
      maxTokens: weeklySummaryMaxTokens,
    );
  }
}
