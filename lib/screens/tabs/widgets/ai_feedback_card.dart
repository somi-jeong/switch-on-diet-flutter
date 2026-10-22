import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/jst_service.dart';

/// A card that displays AI coach feedback and missed rules.
/// Shows a status badge (perfect, normal, worst) based on score and lists
/// any missed rules like late wake time, insufficient sleep, etc.
class AiFeedbackCard extends StatelessWidget {
  final DietRecord record;

  const AiFeedbackCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    if (record.aiFeedback == null || record.aiFeedback!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Determine status: perfect, normal, worst
    final score = record.score;
    final Color bgColor;
    final Color borderColor;
    final Color textColor;

    String statusBadge;
    if (score >= 0.9) {
      statusBadge = 'perfect 🎉';
      bgColor = const Color(0xFFDCFCE7);
      borderColor = kPrimaryMint;
      textColor = kEmeraldText;
    } else if (score >= 0.7) {
      statusBadge = '보통 (일부 누락) 👍';
      bgColor = const Color(0xFFDEF7EC);
      borderColor = const Color(0xFF3B82F6);
      textColor = const Color(0xFF1E40AF);
    } else {
      statusBadge = 'worst ⚠️';
      bgColor = const Color(0xFFFEE2E2);
      borderColor = kRose500;
      textColor = const Color(0xFF991B1B);
    }

    // 놓친 규칙 체크
    final missedRules = <String>[];

    // 늦은 기상 체크
    if (record.wakeTime != null) {
      final wakeTime = JstService.fromIso(record.wakeTime!);
      final wakeTimeOfDay = TimeOfDay.fromDateTime(wakeTime);
      if (wakeTimeOfDay.hour > 9 ||
          (wakeTimeOfDay.hour == 9 && wakeTimeOfDay.minute > 0)) {
        missedRules.add('기상 시간 지연');
      }
    }

    // 수면 부족 체크 (6시간 미만)
    if (record.bedTime != null && record.wakeTime != null) {
      final bedTime = JstService.fromIso(record.bedTime!);
      final wakeTime = JstService.fromIso(record.wakeTime!);
      final sleepDuration = wakeTime.difference(bedTime);
      if (sleepDuration.inHours < 6) {
        missedRules.add('수면 부족');
      }
    }

    // 물 부족 체크
    if (record.dailyChecklist != null &&
        record.dailyChecklist!['water'] == false) {
      missedRules.add('물 2L 미달성');
    }

    // 영양제 누락 체크
    if (record.dailyChecklist != null &&
        record.dailyChecklist!['supplements'] == false) {
      missedRules.add('영양제 누락');
    }

    // 운동 누락 체크
    if (record.dailyChecklist != null &&
        record.dailyChecklist!['workout'] == false) {
      missedRules.add('운동 누락');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI 코치 오늘의 총평',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: borderColor.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  statusBadge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            record.aiFeedback!,
            style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
          ),
          // 놓친 규칙 섹션
          if (missedRules.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              '현재 놓치고 있는 규칙',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: missedRules.map((rule) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: textColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    rule,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
