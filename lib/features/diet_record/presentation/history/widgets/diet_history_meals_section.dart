import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/models/diet_record.dart';

/// Meals section for diet history day card
class DietHistoryMealsSection extends StatelessWidget {
  final DietRecord record;

  const DietHistoryMealsSection({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // If no wake time, show message to enter wake time first
    if (record.wakeTime == null || record.wakeTime!.isEmpty) {
      return Column(
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant, size: 14, color: kMidSlate),
              SizedBox(width: 6),
              Text(
                '식단 기록',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kMidSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFD97706)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Color(0xFFD97706),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '기상 시간을 먼저 입력해주세요',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // If no meals, show message
    if (record.meals.isEmpty) {
      return Column(
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant, size: 14, color: kMidSlate),
              SizedBox(width: 6),
              Text(
                '식단 기록',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kMidSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kLightSlate,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: kMidSlate),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '식단 기록이 없습니다',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kMidSlate,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.restaurant, size: 14, color: kMidSlate),
            SizedBox(width: 6),
            Text(
              '식단 기록',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: kMidSlate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...record.meals.map(_buildMealRow),
      ],
    );
  }

  Widget _buildMealRow(dynamic meal) {
    final isSkipped = meal.skipped == true;
    final isChecked = meal.checked == true;
    final isViolation =
        meal.aiStatus == 'FORBIDDEN' || meal.aiStatus == 'WARNING';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSkipped ? kLightSlate : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isViolation
              ? const Color(0xFFFECDD3)
              : (isSkipped ? const Color(0xFFE2E8F0) : kBorder),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.label ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSkipped ? kMidSlate : const Color(0xFF475569),
                    decoration: isSkipped ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meal.mealTime ?? '--',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: kMidSlate,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: const Color(0xFFE2E8F0),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.foodText ??
                      (isSkipped
                          ? '기상 지연으로 스킵'
                          : (meal.checked ? '식사 완료' : '미기록')),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isViolation
                        ? const Color(0xFFE11D48)
                        : (isSkipped
                              ? kMidSlate
                              : (meal.checked
                                    ? const Color(0xFF334155)
                                    : kMidSlate)),
                    decoration: isSkipped ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (isSkipped && meal.skipReason != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 10,
                        color: kMidSlate,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '스킵 이유: ${meal.skipReason}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: kMidSlate,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (meal.lateReason != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 10, color: kAmberText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '늦게 입력: ${meal.lateReason}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: kAmberText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isViolation
                ? Icons.warning_amber_rounded
                : isSkipped
                ? Icons.remove_circle_outline
                : isChecked
                ? Icons.check_circle
                : Icons.radio_button_unchecked,
            size: 16,
            color: isViolation
                ? const Color(0xFFFB7185)
                : isChecked && !isSkipped
                ? const Color(0xFF059669)
                : kMidSlate,
          ),
        ],
      ),
    );
  }
}
