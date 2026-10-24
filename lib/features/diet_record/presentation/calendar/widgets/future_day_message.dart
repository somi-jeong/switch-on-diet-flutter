import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class FutureDayMessage extends StatelessWidget {
  const FutureDayMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: kLightSlate,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.restaurant, size: 20, color: kMidSlate),
          ),
          const SizedBox(height: 12),
          const Text(
            '아직 기록할 수 없는 날짜예요',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kMidSlate,
            ),
          ),
        ],
      ),
    );
  }
}
