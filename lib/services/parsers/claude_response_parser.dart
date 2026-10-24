/// ClaudeResponseParser - Centralized response parsing for Claude API
class ClaudeResponseParser {
  // ── Text Analysis Response Parser ───────────────────────
  static Map<String, dynamic> parseTextAnalysis(String text) {
    final statusMatch = RegExp(
      r'STATUS:\s*(ALLOWED|WARNING|FORBIDDEN)',
      caseSensitive: false,
    ).firstMatch(text);
    final feedbackMatch = RegExp(
      r'FEEDBACK:\s*(.+?)(?:\n|$)',
      caseSensitive: false,
    ).firstMatch(text);

    if (statusMatch != null && feedbackMatch != null) {
      return {
        'status': statusMatch.group(1)!.toUpperCase(),
        'feedback': feedbackMatch.group(1)!.trim(),
      };
    }

    // Fallback parsing
    if (text.contains('FORBIDDEN') || text.contains('금지')) {
      return {'status': 'FORBIDDEN', 'feedback': '금지 식품이에요'};
    }
    if (text.contains('WARNING') || text.contains('주의')) {
      return {'status': 'WARNING', 'feedback': '주의가 필요해요'};
    }
    return {'status': 'ALLOWED', 'feedback': '허용 범위예요'};
  }

  // ── Weekly Summary Data Builder ─────────────────────────
  static Map<String, dynamic> buildWeeklyData({
    required Map<int, Map<String, dynamic>> weekRecords,
  }) {
    final violations = <String>[];
    final lateRecordingDays = <String>[];
    final wakeTimeIssues = <String>[];
    final missionIncomplete = <String>[];

    weekRecords.forEach((day, record) {
      final meals = record['meals'] as List?;
      if (meals != null) {
        for (final m in meals) {
          if (m['aiStatus'] == 'FORBIDDEN') {
            violations.add('$day일차 ${m['label']}: FORBIDDEN');
          }
          if (m['aiStatus'] == 'WARNING') {
            violations.add('$day일차 ${m['label']}: WARNING');
          }
        }
      }
      final late = record['lateRecordings'] as List?;
      if (late != null && late.isNotEmpty) {
        lateRecordingDays.add('$day일차: ${late.join(', ')}');
      }

      // Check wake time
      final wakeTimeStatus = record['wakeTimeStatus'] as String?;
      if (wakeTimeStatus != null && wakeTimeStatus != '정상') {
        wakeTimeIssues.add('$day일차: $wakeTimeStatus');
      }

      // Check daily missions
      final missionsCompleted = record['missionsCompleted'] as int? ?? 0;
      final missionsTotal = record['missionsTotal'] as int? ?? 0;
      if (missionsTotal > 0 && missionsCompleted < missionsTotal) {
        missionIncomplete.add('$day일차: $missionsCompleted/$missionsTotal');
      }
    });

    final summary = weekRecords.entries
        .map((e) => '${e.key}일차: ${((e.value['score'] ?? 0) * 100).round()}%')
        .join(' / ');

    return {
      'violations': violations,
      'lateRecordingDays': lateRecordingDays,
      'wakeTimeIssues': wakeTimeIssues,
      'missionIncomplete': missionIncomplete,
      'summary': summary,
    };
  }

  // ── Chat History Builder ────────────────────────────────
  static List<Map<String, dynamic>> buildChatMessages({
    required String currentMessage,
    List<Map<String, String>>? chatHistory,
  }) {
    final messages = <Map<String, dynamic>>[];
    if (chatHistory != null) {
      for (final msg in chatHistory) {
        messages.add({
          'role': msg['role'] == 'user' ? 'user' : 'assistant',
          'content': msg['content'],
        });
      }
    }
    messages.add({'role': 'user', 'content': currentMessage});
    return messages;
  }
}
