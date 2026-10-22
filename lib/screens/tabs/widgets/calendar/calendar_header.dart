import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

class CalendarHeader extends StatelessWidget {
  final int completedDays;
  final int totalDays;

  const CalendarHeader({
    super.key,
    required this.completedDays,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    final pct = ((completedDays / totalDays) * 100).round().clamp(0, 100);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '28일 챌린지',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kDarkSlate,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 14, color: kMidSlate),
                  children: [
                    const TextSpan(text: '현재 진행률 '),
                    TextSpan(
                      text: '$pct%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kPrimaryMint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: kPrimaryMint.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: kPrimaryMint.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🌱', style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '새싹 다이어터',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: kEmeraldText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
