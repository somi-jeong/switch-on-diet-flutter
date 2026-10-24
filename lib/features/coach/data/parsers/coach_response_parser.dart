import 'package:switchon_diet/features/coach/data/datasources/anthropic_remote_data_source.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

/// Weekly statistics in the shape the weekly summary prompt expects.
typedef WeeklyPromptData = ({
  String summary,
  List<String> violations,
  List<String> lateRecordingDays,
  List<String> wakeTimeIssues,
  List<String> missionIncomplete,
});

/// Turns model output into domain values and domain values into prompt input.
///
/// Parsing is deliberately forgiving: a reply that ignores the requested
/// format degrades to a keyword match and then to a safe default instead of
/// failing the request.
abstract final class CoachResponseParser {
  static final _status = RegExp(
    r'STATUS:\s*(ALLOWED|WARNING|FORBIDDEN)',
    caseSensitive: false,
  );
  static final _feedback = RegExp(
    r'FEEDBACK:\s*(.+?)(?:\n|$)',
    caseSensitive: false,
  );

  static MealAnalysis parseMealAnalysis(String text) {
    final status = _status.firstMatch(text)?.group(1);
    final feedback = _feedback.firstMatch(text)?.group(1);
    if (status != null && feedback != null) {
      return MealAnalysis(
        verdict: MealVerdict.fromCode(status.toUpperCase())!,
        feedback: feedback.trim(),
      );
    }

    if (text.contains('FORBIDDEN') || text.contains('금지')) {
      return const MealAnalysis(
        verdict: MealVerdict.forbidden,
        feedback: '금지 식품이에요',
      );
    }
    if (text.contains('WARNING') || text.contains('주의')) {
      return const MealAnalysis(
        verdict: MealVerdict.warning,
        feedback: '주의가 필요해요',
      );
    }
    return const MealAnalysis(
      verdict: MealVerdict.allowed,
      feedback: '허용 범위예요',
    );
  }

  static WeeklyPromptData buildWeeklyData(List<WeeklyDayReport> days) {
    final violations = <String>[];
    final lateRecordingDays = <String>[];
    final wakeTimeIssues = <String>[];
    final missionIncomplete = <String>[];

    for (final report in days) {
      final day = report.day;
      for (final meal in report.meals) {
        if (meal.verdict == MealVerdict.forbidden ||
            meal.verdict == MealVerdict.warning) {
          violations.add('$day일차 ${meal.label}: ${meal.verdict!.code}');
        }
      }
      if (report.lateRecordings.isNotEmpty) {
        lateRecordingDays.add('$day일차: ${report.lateRecordings.join(', ')}');
      }
      if (report.wakeTimeStatus != WakeCategory.onTime.label) {
        wakeTimeIssues.add('$day일차: ${report.wakeTimeStatus}');
      }
      if (report.missionsTotal > 0 &&
          report.missionsCompleted < report.missionsTotal) {
        missionIncomplete.add(
          '$day일차: ${report.missionsCompleted}/${report.missionsTotal}',
        );
      }
    }

    final summary = days
        .map((d) => '${d.day}일차: ${(d.score * 100).round()}%')
        .join(' / ');

    return (
      summary: summary,
      violations: violations,
      lateRecordingDays: lateRecordingDays,
      wakeTimeIssues: wakeTimeIssues,
      missionIncomplete: missionIncomplete,
    );
  }

  static List<AnthropicMessage> buildChatMessages({
    required String currentMessage,
    required List<ChatMessage> history,
  }) => [
    for (final message in history)
      AnthropicMessage(
        role: message.isUser ? 'user' : 'assistant',
        content: message.text,
      ),
    AnthropicMessage.user(currentMessage),
  ];
}
