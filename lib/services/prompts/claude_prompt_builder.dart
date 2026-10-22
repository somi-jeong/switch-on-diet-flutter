/// ClaudePromptBuilder - Centralized prompt generation for Claude API
class ClaudePromptBuilder {
  // ── Text Analysis Prompt ─────────────────────────────────
  static String textAnalysisSystem() =>
      '당신은 스위치온 다이어트 식품 분석 AI입니다. STATUS와 FEEDBACK 두 줄만 출력하세요.';

  static String textAnalysisUser({
    required String foodText,
    required int week,
    required int day,
    required List<String> allowedFoods,
    required List<String> forbiddenFoods,
  }) =>
      '''스위치온 다이어트 $week주차 $day일차 판정

허용: ${allowedFoods.join(', ')}
금지: ${forbiddenFoods.join(', ')}
입력 음식: "$foodText"

STATUS: ALLOWED 또는 WARNING 또는 FORBIDDEN
FEEDBACK: 존댓말 30자 이내''';

  // ── Coach Chat Prompt ────────────────────────────────────
  static String coachChatSystem({
    required int day,
    required int week,
    required String? wakeTime,
    required String mealStatus,
    required List<String> allowedFoods,
    required List<String> forbiddenFoods,
    String? yesterdaySummary,
  }) =>
      '''당신은 스위치온 다이어트 전문 AI 코치입니다.

현재 상태: $day일차 / $week주차
기상 시간: ${wakeTime ?? '미기록'} JST
오늘 식사:
$mealStatus
${yesterdaySummary != null ? '\n어제 기록: $yesterdaySummary' : ''}

허용: ${allowedFoods.join(', ')}
금지: ${forbiddenFoods.join(', ')}

존댓말, 팩트 기반, 단호하게, 3-4문장으로 간결하게.
${yesterdaySummary != null ? '어제 기록을 참고해서 연속성 있는 조언을 해주세요.' : ''}

【자동 입력 기능】
사용자가 다음과 같은 정보를 말하면 응답 끝에 액션을 추가하세요:
- 기상 시간: "7시에 일어났어요" → <ACTION>WAKE:07:00</ACTION>
- 식사 기록: "아침에 계란이랑 샐러드 먹었어요" → <ACTION>MEAL:아침:계란, 샐러드</ACTION>
- 식사 스킵: "점심 스킵했어요" → <ACTION>SKIP:점심</ACTION>
- 취침 시간: "11시에 잤어요" → <ACTION>SLEEP:23:00</ACTION>

예시:
유저: "7시에 일어났어요"
AI: "7시 기상이시네요! 좋은 시작이에요. 아침 식사 시간을 놓치지 마세요! <ACTION>WAKE:07:00</ACTION>"

유저: "아침에 계란이랑 샐러드 먹었어요"
AI: "계란과 샐러드 좋은 선택이에요! 계속 이렇게 허용 식품 위주로 드세요. <ACTION>MEAL:아침:계란, 샐러드</ACTION>"

액션은 응답 맨 끝에 추가하고, 여러 개면 모두 포함하세요.''';

  // ── Daily Feedback Prompt ────────────────────────────────
  static String dailyFeedbackSystem() =>
      '당신은 스위치온 다이어트 전문 AI 코치입니다. 하루 마감 종합 피드백. 존댓말, 팩트 기반, 단호하게.';

  static String dailyFeedbackUser({
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
    required String mealSummary,
    double? weight,
    double? bodyFat,
    String? confession,
    String? bedTime,
    String? actualBedTime,
    Map<String, bool>? dailyChecklist,
    int? dailyMissionsCompleted,
    int? dailyMissionsTotal,
  }) {
    final wt =
        '${wakeTime.hour.toString().padLeft(2, '0')}:${wakeTime.minute.toString().padLeft(2, '0')}';

    // 기상 시간 평가
    final wakeHour = wakeTime.hour;
    final wakeTimeStatus = wakeHour >= 17
        ? '⛔ 완전 비정상 (오늘 다이어트 진행 불가)'
        : wakeHour >= 14
        ? '⚠️ 매우 늦음 (1끼만 가능)'
        : wakeHour >= 11
        ? '⚠️ 상당히 늦음 (2끼만 가능)'
        : wakeHour >= 9
        ? '⚠️ 약간 늦음 (3끼 가능)'
        : wakeHour >= 5
        ? '✅ 정상'
        : '⚠️ 너무 이름 (수면 부족 의심)';

    // 데일리 미션 체크
    final missionsText = dailyChecklist != null && dailyChecklist.isNotEmpty
        ? '\n데일리 미션: $dailyMissionsCompleted/$dailyMissionsTotal 완료\n${dailyChecklist.entries.map((e) => '  ${e.value ? '✅' : '❌'} ${e.key}').join('\n')}'
        : '';

    return '''$day일차 ($week주차) 하루 종합

기상: $wt $wakeTimeStatus / 공복: ${fastingHours}h / 달성: $score% ($completedMeals/$totalMeals)
${weight != null ? '체중: ${weight}kg${bodyFat != null ? ' / 체지방: $bodyFat%' : ''}' : ''}
$mealSummary$missionsText
판정 — 허용: $allowedCount / 주의: $warningCount / 금지: $forbiddenCount / 누적경고: $warningCountTotal/5
${confession != null && confession.isNotEmpty ? '고백: "$confession"' : ''}
${bedTime != null ? '취침: $bedTime' : ''}

【중요】기상 시간, 식사 기록, 데일리미션 완성도를 종합 평가하고:
- 기상 시간이 비정상이면 강력히 지적
- 식사 기록이 늦으면 실시간 기록 강조
- 데일리미션(운동) 못 지켰으면 주 4회 목표 상기
- 잘한 점 간단히 + 문제점 명확히 + 내일 개선 포인트 1-2개 + 5-6문장''';
  }

  // ── Weekly Summary Prompt ────────────────────────────────
  static String weeklySummarySystem({required int week}) =>
      '당신은 스위치온 다이어트 전문 AI 코치입니다. $week주차 주간 종합 피드백. 존댓말, 팩트 기반.';

  static String weeklySummaryUser({
    required int week,
    required String summary,
    required List<String> violations,
    required List<String> lateRecordingDays,
    List<String>? wakeTimeIssues,
    List<String>? missionIncomplete,
  }) =>
      '''$week주차 종합: $summary

📋 식사 위반(${violations.length}건): ${violations.isEmpty ? '없음 (완벽!)' : violations.join(', ')}
${lateRecordingDays.isNotEmpty ? '⏰ 소급 입력: ${lateRecordingDays.join(', ')}' : ''}
${wakeTimeIssues != null && wakeTimeIssues.isNotEmpty ? '🌅 기상 시간 문제: ${wakeTimeIssues.join(', ')}' : ''}
${missionIncomplete != null && missionIncomplete.isNotEmpty ? '🏋️ 운동 미완료: ${missionIncomplete.join(', ')}' : ''}

【중요】주간 패턴을 종합 분석하고:
- 기상 시간이 불규칙하거나 늦으면 수면 패턴 개선 강조
- 운동(데일리미션) 주 4회 못 지켰으면 다음 주 목표 설정 요구
- 식사 위반이 반복되면 허용 식품 목록 다시 확인 권장
- 소급 입력 패턴 있으면 실시간 기록 습관화 강조
- 잘한 점 + 구체적 문제점 + 다음 주 개선 포인트 2-3개 + 6-7문장''';

  // ── Meal Status Helper ───────────────────────────────────
  static String buildMealStatus(List<Map<String, dynamic>> mealDetails) {
    return mealDetails
        .map((m) {
          final s = m['checked'] ? '✅ 완료' : '❌ 미완료';
          final ai = m['aiStatus'] != null
              ? ' (AI: ${m['aiStatus']}${m['aiFeedback'] != null ? ' - ${m['aiFeedback']}' : ''})'
              : '';
          final skipReason = m['skipped'] == true && m['skipReason'] != null
              ? ' [스킵 이유: ${m['skipReason']}]'
              : '';
          final lateReason = m['lateReason'] != null
              ? ' [늦게 입력 이유: ${m['lateReason']}]'
              : '';
          final eatenAt = m['eatenAt'] != null ? ' (섭취: ${m['eatenAt']})' : '';
          return '${m['label']}: $s$ai$skipReason$lateReason$eatenAt';
        })
        .join('\n');
  }

  static String buildMealSummary(List<Map<String, dynamic>> mealDetails) {
    return mealDetails
        .map((m) {
          if (m['skipped'] == true) {
            final skipReason = m['skipReason'] != null
                ? ' (이유: ${m['skipReason']})'
                : '';
            return '- ${m['label']}: 스킵$skipReason';
          }
          final s = m['checked'] ? '✅' : '❌';
          final ai = m['aiStatus'] != null
              ? ' → ${m['aiStatus']}${m['aiFeedback'] != null ? ' "${m['aiFeedback']}"' : ''}'
              : '';
          final lateReason = m['lateReason'] != null
              ? ' [늦게 입력 이유: ${m['lateReason']}]'
              : '';
          final eatenAt = m['eatenAt'] != null ? ' (섭취: ${m['eatenAt']})' : '';
          return '- ${m['label']}: $s$ai$lateReason$eatenAt';
        })
        .join('\n');
  }
}
