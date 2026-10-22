import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// AI Coach message card shown at the top of RecordMealScreen
class AiCoachMessageCard extends StatelessWidget {
  final String mealType;

  const AiCoachMessageCard({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorder),
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
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: kPrimaryMint.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: kEmeraldText,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'AI 코치',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$mealType 시간이네요! 어떤 쉐이크를 드셨나요?\n사진을 찍거나 텍스트로 자유롭게 남겨주세요.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
