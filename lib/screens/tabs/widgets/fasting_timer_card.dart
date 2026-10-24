import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// A card that displays the current fasting duration and progress.
/// Shows time elapsed since wake time with a visual progress bar.
class FastingTimerCard extends StatelessWidget {
  final String fastingText;

  const FastingTimerCard({super.key, required this.fastingText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: kAmberBdr),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14, color: kAmberText),
                      SizedBox(width: 6),
                      Text(
                        '공복 유지 중',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: kAmberText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fastingText,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: kDarkSlate,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '목표 시간',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: kMidSlate,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '14시간 00분',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kDarkSlate,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.89,
              minHeight: 10,
              backgroundColor: kLightSlate,
              valueColor: AlwaysStoppedAnimation<Color>(kAmberProgress),
            ),
          ),
        ],
      ),
    );
  }
}
