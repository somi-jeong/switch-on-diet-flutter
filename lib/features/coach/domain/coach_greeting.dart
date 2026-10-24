import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/daily_mission.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

/// The coach's opening message, built locally from the records so the chat
/// is useful before (and without) any API call.
abstract final class CoachGreeting {
  static String compose({
    required int day,
    required Map<int, DietRecord> records,
    required DateTime now,
  }) {
    final today = records[day];
    final issues = [
      if (_missingDays(day, records) case final missing?) missing,
      if (today != null) ..._todayIssues(today, now),
    ];
    final positives = [
      if (today != null && today.meals.isNotEmpty) ...[
        if (!today.meals.any((m) => m.isPending)) '오늘 식사를 모두 기록하셨네요',
        if (today.countVerdict(MealVerdict.forbidden) == 0) '식단 규칙을 잘 지키고 계세요',
      ],
    ];
    final yesterday = _yesterdayLine(records[day - 1]);
    const hello = '안녕하세요! 스위치온 다이어트';

    if (issues.isEmpty && positives.isEmpty) {
      return '$hello $day일차입니다 😊\n\n'
          '오늘 순조롭게 잘 진행하고 계시네요! 궁금한 점이 있으면 언제든 물어보세요.$yesterday';
    }

    final issueText = issues.isEmpty ? '' : '⚠️ ${issues.join('\n⚠️ ')}';
    final positiveText = positives.isEmpty
        ? ''
        : '\n\n✅ ${positives.join('\n✅ ')}';
    final timeInfo = now.hour >= 20
        ? '\n\n지금 ${now.hour}시인데'
        : now.hour >= 18
        ? '\n\n저녁 시간이 다가오는데'
        : '';
    final ask = issues.isEmpty ? '' : '오늘 기록을 먼저 완성해주시면 좋겠어요! ';

    return '$hello $day일차입니다 😊\n\n그런데...$timeInfo 확인해보니:\n\n'
        '$issueText$positiveText\n\n$ask궁금한 점 있으시면 물어보세요.$yesterday';
  }

  /// Earlier days without a wake-up time.
  static String? _missingDays(int day, Map<int, DietRecord> records) {
    final missing = [
      for (var d = 1; d < day; d++)
        if (records[d]?.wakeTime == null) d,
    ];
    if (missing.isEmpty) return null;
    if (missing.length <= 3) return '${missing.join(", ")}일차 기록이 없어요';
    return '과거 ${missing.length}일 기록이 비어있어요';
  }

  static List<String> _todayIssues(DietRecord today, DateTime now) {
    final pending = today.meals.where((m) => m.isPending).length;
    final late = today.meals.where((m) => m.lateReason != null).length;
    final violations = today.countVerdict(MealVerdict.forbidden);
    final missedMissions = [
      for (final mission in DailyMission.values)
        if (!today.isMissionDone(mission)) mission.label,
    ];

    return [
      if (today.wakeTime == null)
        '오늘 기상 시간을 입력하지 않으셨네요'
      else if (Jst.parse(today.wakeTime!) case final wake when wake.hour >= 9)
        '${wake.hour}시 ${wake.minute}분 기상으로 늦은 편이에요',
      if (pending > 0) '아직 입력 안 한 식사가 $pending끼 있어요',
      if (late > 0) '실시간 기록이 아닌 늦은 입력이 $late건 있네요',
      if (violations > 0) '허용되지 않은 음식을 $violations번 드셨어요',
      if (missedMissions.isNotEmpty && now.hour >= 18)
        '오늘 데일리 미션 중 ${missedMissions.join(', ')}를 아직 안 하셨네요',
    ];
  }

  /// How yesterday went, shown once the daily review for it exists.
  static String _yesterdayLine(DietRecord? yesterday) {
    if (yesterday?.aiFeedback == null) return '';
    final score = yesterday!.score;
    final verdict = score >= 0.8
        ? '완벽했어요!'
        : score >= 0.6
        ? '잘하셨어요'
        : '조금 아쉬웠어요';
    return '\n\n💭 어제: $verdict (${(score * 100).round()}%)';
  }
}
