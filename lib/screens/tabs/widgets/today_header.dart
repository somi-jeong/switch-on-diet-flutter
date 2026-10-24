import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class TodayHeader extends StatelessWidget {
  final int todayIdx;
  final int week;
  final bool hasWoken;
  final double score;
  final String fastingText;

  const TodayHeader({
    super.key,
    required this.todayIdx,
    required this.week,
    required this.hasWoken,
    required this.score,
    required this.fastingText,
  });

  @override
  Widget build(BuildContext context) {
    final dayInWeek = ((todayIdx - 1) % 7) + 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
      decoration: BoxDecoration(color: kBgColor.withValues(alpha: 0.8)),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '스위치온',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: kEmeraldText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$week주차 • $dayInWeek일째',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kEmeraldText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
