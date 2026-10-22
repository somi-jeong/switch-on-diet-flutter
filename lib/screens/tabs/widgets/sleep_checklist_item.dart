import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/jst_service.dart';

/// A specialized checklist item for sleep tracking.
/// Calculates and displays sleep duration and checks if it meets the 6-hour goal.
class SleepChecklistItem extends StatelessWidget {
  final DietRecord? record;

  const SleepChecklistItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // Calculate sleep duration from bedTime to wakeTime
    String sleepDuration = '--';
    if (record?.bedTime != null && record?.wakeTime != null) {
      final bedTime = JstService.fromIso(record!.bedTime!);
      final wakeTime = JstService.fromIso(record!.wakeTime!);
      final duration = wakeTime.difference(bedTime);
      if (!duration.isNegative) {
        final hours = duration.inHours;
        final mins = duration.inMinutes % 60;
        sleepDuration = '${hours}h ${mins}m';
      }
    }

    final hasSlept = sleepDuration != '--';
    final sufficientSleep =
        hasSlept &&
        record != null &&
        record!.bedTime != null &&
        record!.wakeTime != null &&
        JstService.fromIso(
              record!.wakeTime!,
            ).difference(JstService.fromIso(record!.bedTime!)).inHours >=
            6;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.nightlight_round,
            size: 20,
            color: Color(0xFF6366F1),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '수면 6시간 이상',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hasSlept ? '오늘 수면: $sleepDuration' : '자정~새벽 4시 필수',
                style: const TextStyle(fontSize: 12, color: kMidSlate),
              ),
            ],
          ),
        ),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: sufficientSleep ? kPrimaryMint : kLightSlate,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sufficientSleep ? kPrimaryMint : const Color(0xFFCBD5E1),
              width: 2,
            ),
          ),
          child: sufficientSleep
              ? const Icon(Icons.check, size: 14, color: kDarkSlate)
              : null,
        ),
      ],
    );
  }
}
