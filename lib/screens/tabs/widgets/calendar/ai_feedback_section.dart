import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/jst_service.dart';

class AiFeedbackSection extends StatelessWidget {
  final DietRecord? record;
  final int dayIdx;
  final int todayIdx;

  const AiFeedbackSection({
    super.key,
    required this.record,
    required this.dayIdx,
    required this.todayIdx,
  });

  @override
  Widget build(BuildContext context) {
    // 오후 10시(22시) 이후에만 표시
    final now = JstService.now();
    final isAfter10PM = now.hour >= 22;

    // 과거 날짜는 항상 표시, 오늘 날짜는 22시 이후에만 표시
    final shouldShow =
        record != null &&
        record!.aiFeedback != null &&
        record!.aiFeedback!.isNotEmpty &&
        (dayIdx < todayIdx || (dayIdx == todayIdx && isAfter10PM));

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    final score = record!.score;
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color iconColor;
    final String statusText;
    final String statusEmoji;

    // perfect: 0.9+, normal: 0.7-0.89, worst: <0.7
    if (score >= 0.9) {
      bgColor = kPrimaryMint.withValues(alpha: 0.1);
      borderColor = kPrimaryMint.withValues(alpha: 0.3);
      textColor = kEmeraldText;
      iconColor = const Color(0xFF059669);
      statusText = '완벽 성공';
      statusEmoji = '🌟';
    } else if (score >= 0.7) {
      bgColor = const Color(0xFFDEEBFF);
      borderColor = const Color(0xFF93C5FD);
      textColor = const Color(0xFF1E40AF);
      iconColor = const Color(0xFF3B82F6);
      statusText = '보통 (일부 누락)';
      statusEmoji = '👍';
    } else {
      bgColor = const Color(0xFFFEE2E2);
      borderColor = const Color(0xFFFB7185);
      textColor = const Color(0xFFBE123C);
      iconColor = const Color(0xFFF43F5E);
      statusText = '최악 (다수 위반)';
      statusEmoji = '🚨';
    }

    // Get missed rules from record
    final List<String> missedRules = _getMissedRules();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: iconColor),
                  const SizedBox(width: 8),
                  Text(
                    '$dayIdx일차 데일리 총평',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: score >= 0.9
                      ? const Color(0xFFD1FAE5)
                      : score >= 0.7
                      ? const Color(0xFFBFDBFE)
                      : const Color(0xFFFECDD3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$statusText $statusEmoji',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            record!.aiFeedback!,
            style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
          ),
          if (missedRules.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0x0D000000), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '놓친 규칙',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: missedRules.map((rule) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          rule,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _getMissedRules() {
    if (record == null) return [];

    final List<String> missed = [];
    final checklist = record!.dailyChecklist;

    // Check for forbidden foods
    final hasForbidden = record!.meals.any((m) => m.aiStatus == 'FORBIDDEN');
    if (hasForbidden) {
      missed.add('식단 (금기식품 섭취)');
    }

    // Check daily checklist
    if (checklist?['water'] == false) {
      missed.add('물 2L');
    }
    if (checklist?['supplements'] == false) {
      missed.add('영양제');
    }
    if (checklist?['workout'] == false) {
      missed.add('운동');
    }

    // Check sleep (6+ hours)
    if (record!.actualBedTime != null && record!.wakeTime != null) {
      try {
        final bedTime = DateTime.parse(record!.actualBedTime!);
        final wakeTime = DateTime.parse(record!.wakeTime!);
        final sleepHours = wakeTime.difference(bedTime).inHours;
        if (sleepHours < 6) {
          missed.add('수면 (6시간 미만)');
        }
      } catch (_) {}
    }

    return missed;
  }
}
