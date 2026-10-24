import 'package:flutter/material.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';

class DailyRulesSection extends StatelessWidget {
  final DietRecord? record;
  final DietRecord? previousRecord;

  const DailyRulesSection({
    super.key,
    required this.record,
    required this.previousRecord,
  });

  @override
  Widget build(BuildContext context) {
    // 항상 표시
    final checklist = record?.dailyChecklist ?? {};

    // 전날 취침시간과 오늘 기상시간으로 수면 체크
    bool sleepCompleted = false;
    int sleepHours = 0;
    int sleepMinutes = 0;

    final bedTimeIso = previousRecord?.actualBedTime;
    final wakeTimeIso = record?.wakeTime;
    if (bedTimeIso != null && wakeTimeIso != null) {
      try {
        final bedTime = DateTime.parse(bedTimeIso);
        final sleepDuration = DateTime.parse(wakeTimeIso).difference(bedTime);
        sleepHours = sleepDuration.inHours;
        sleepMinutes = sleepDuration.inMinutes % 60;
        // 6시간 이상이고, 자정~새벽4시 사이에 잤는지 체크
        sleepCompleted =
            sleepHours >= 6 && bedTime.hour >= 0 && bedTime.hour < 4;
      } on FormatException {
        // Leave the sleep rule unchecked for malformed timestamps.
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '데일리 규칙 달성도',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRuleIconWithWidget(
                Icons.water_drop_outlined,
                '물 2L',
                checklist['water'] ?? false,
                const Color(0xFF3B82F6),
                const Color(0xFFDEEBFF),
                const Color(0xFF93C5FD),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRuleIconWithWidget(
                Icons.medication_outlined,
                '영양제',
                checklist['supplements'] ?? false,
                const Color(0xFFF59E0B),
                const Color(0xFFFEF3C7),
                const Color(0xFFFBBF24),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRuleIconWithWidget(
                Icons.fitness_center_outlined,
                '운동',
                checklist['workout'] ?? false,
                const Color(0xFF059669),
                const Color(0xFFDCFCE7),
                const Color(0xFF13EC92),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildRuleIconWithWidget(
                Icons.nightlight_outlined,
                sleepHours > 0 ? '${sleepHours}h ${sleepMinutes}m' : '수면',
                sleepCompleted,
                sleepCompleted
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFEF4444),
                sleepCompleted
                    ? const Color(0xFFEEF2FF)
                    : const Color(0xFFFEE2E2),
                sleepCompleted
                    ? const Color(0xFFA5B4FC)
                    : const Color(0xFFFB7185),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRuleIconWithWidget(
    IconData icon,
    String label,
    bool completed,
    Color textColor,
    Color bgColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: completed ? bgColor : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed ? borderColor : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: completed ? textColor : const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: completed ? textColor : const Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
