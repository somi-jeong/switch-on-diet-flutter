import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:switchon_diet/services/prompts/claude_prompt_builder.dart';
import 'package:switchon_diet/services/parsers/claude_response_parser.dart';
import 'package:switchon_diet/services/parsers/claude_api_client.dart';

class ClaudeService {
  /// Resolves the API key: `--dart-define=ANTHROPIC_API_KEY=...` takes
  /// precedence, then the `ANTHROPIC_API_KEY` entry in `.env`.
  static String get _defaultApiKey {
    const fromDefine = String.fromEnvironment('ANTHROPIC_API_KEY');
    final apiKey = fromDefine.isNotEmpty
        ? fromDefine
        : (dotenv.env['ANTHROPIC_API_KEY'] ?? '');
    if (apiKey.isEmpty) {
      throw Exception(
        'ANTHROPIC_API_KEY is not set (use --dart-define or .env)',
      );
    }
    return apiKey;
  }

  static const int kTokensMealText = 500;
  static const int kTokensCoach = 2000;
  static const int kTokensDailySummary = 2500;
  static const int kTokensWeeklySummary = 3500;

  late final ClaudeApiClient _client;

  ClaudeService({String? apiKey}) {
    _client = ClaudeApiClient(apiKey ?? _defaultApiKey);
  }

  // ── 1. Meal Text Analysis ───────────────────────────────────
  Future<Map<String, dynamic>> analyzeFoodText({
    required String foodText,
    required int week,
    required int day,
    required List<String> allowedFoods,
    required List<String> forbiddenFoods,
  }) async {
    final text = await _client.sendSimpleRequest(
      system: ClaudePromptBuilder.textAnalysisSystem(),
      userContent: ClaudePromptBuilder.textAnalysisUser(
        foodText: foodText,
        week: week,
        day: day,
        allowedFoods: allowedFoods,
        forbiddenFoods: forbiddenFoods,
      ),
      maxTokens: kTokensMealText,
      temperature: 0.2,
    );
    debugPrint('Claude analyzeFoodText: $text');
    return ClaudeResponseParser.parseTextAnalysis(text);
  }

  // ── 2. AI Coach Chat ───────────────────────────────────
  Future<String> chatWithCoach({
    required String message,
    required int day,
    required int week,
    required String? wakeTime,
    required List<Map<String, dynamic>> mealDetails,
    required List<String> allowedFoods,
    required List<String> forbiddenFoods,
    List<Map<String, String>>? chatHistory,
    String? yesterdaySummary,
  }) => _client.sendRequest(
    system: ClaudePromptBuilder.coachChatSystem(
      day: day,
      week: week,
      wakeTime: wakeTime,
      mealStatus: ClaudePromptBuilder.buildMealStatus(mealDetails),
      allowedFoods: allowedFoods,
      forbiddenFoods: forbiddenFoods,
      yesterdaySummary: yesterdaySummary,
    ),
    messages: ClaudeResponseParser.buildChatMessages(
      currentMessage: message,
      chatHistory: chatHistory,
    ),
    maxTokens: kTokensCoach,
  );

  // ── 3. Daily Feedback ──────────────────────────────────
  Future<String> getDailyFeedback({
    required int day,
    required int week,
    required DateTime wakeTime,
    required int fastingHours,
    required int score,
    required int completedMeals,
    required int totalMeals,
    required int allowedCount,
    required int warningCount,
    required int forbiddenCount,
    required int warningCountTotal,
    required List<Map<String, dynamic>> mealDetails,
    double? weight,
    double? bodyFat,
    String? confession,
    String? bedTime,
    String? actualBedTime,
    Map<String, bool>? dailyChecklist,
    int? dailyMissionsCompleted,
    int? dailyMissionsTotal,
  }) => _client.sendSimpleRequest(
    system: ClaudePromptBuilder.dailyFeedbackSystem(),
    userContent: ClaudePromptBuilder.dailyFeedbackUser(
      day: day,
      week: week,
      wakeTime: wakeTime,
      fastingHours: fastingHours,
      score: score,
      completedMeals: completedMeals,
      totalMeals: totalMeals,
      allowedCount: allowedCount,
      warningCount: warningCount,
      forbiddenCount: forbiddenCount,
      warningCountTotal: warningCountTotal,
      mealSummary: ClaudePromptBuilder.buildMealSummary(mealDetails),
      weight: weight,
      bodyFat: bodyFat,
      confession: confession,
      bedTime: bedTime,
      actualBedTime: actualBedTime,
      dailyChecklist: dailyChecklist,
      dailyMissionsCompleted: dailyMissionsCompleted,
      dailyMissionsTotal: dailyMissionsTotal,
    ),
    maxTokens: kTokensDailySummary,
  );

  // ── 4. Weekly Summary ──────────────────────────────────
  Future<String> getWeeklySummary({
    required int week,
    required Map<int, Map<String, dynamic>> weekRecords,
  }) async {
    final data = ClaudeResponseParser.buildWeeklyData(weekRecords: weekRecords);
    return _client.sendSimpleRequest(
      system: ClaudePromptBuilder.weeklySummarySystem(week: week),
      userContent: ClaudePromptBuilder.weeklySummaryUser(
        week: week,
        summary: data['summary'],
        violations: data['violations'],
        lateRecordingDays: data['lateRecordingDays'],
        wakeTimeIssues: data['wakeTimeIssues'],
        missionIncomplete: data['missionIncomplete'],
      ),
      maxTokens: kTokensWeeklySummary,
    );
  }
}
