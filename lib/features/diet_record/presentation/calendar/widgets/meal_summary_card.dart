import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_state.dart';

class MealSummaryCard extends StatelessWidget {
  final MealSummary meal;

  const MealSummaryCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final status = meal.status;

    if (status == MealSummaryStatus.unrecorded) {
      return _buildUnrecordedMeal();
    }

    final isViolation = status == MealSummaryStatus.violation;
    final isSkipped = status == MealSummaryStatus.skipped;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSkipped ? kLightSlate : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isViolation
                ? const Color(0xFFFECDD3)
                : (isSkipped ? const Color(0xFFE2E8F0) : kBorder),
          ),
          boxShadow: isSkipped
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    meal.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSkipped ? kMidSlate : const Color(0xFF475569),
                      decoration: isSkipped ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meal.time,
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
                    meal.text,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isViolation
                          ? const Color(0xFFE11D48)
                          : (isSkipped ? kMidSlate : const Color(0xFF334155)),
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
                  if (isViolation) ...[
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 10,
                          color: Color(0xFFFB7185),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '허용식품 아님',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFB7185),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isViolation
                    ? const Color(0xFFFEE2E2)
                    : (isSkipped
                          ? const Color(0xFFE2E8F0)
                          : kPrimaryMint.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isViolation
                    ? Icons.warning_amber_rounded
                    : (isSkipped ? Icons.remove_circle_outline : Icons.check),
                size: 16,
                color: isViolation
                    ? const Color(0xFFFB7185)
                    : (isSkipped ? kMidSlate : const Color(0xFF059669)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnrecordedMeal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kLightSlate,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Column(
                children: [
                  Text(
                    meal.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
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
              child: Text(
                '${meal.label} 식단 기록하기',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kMidSlate,
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(Icons.add, size: 16, color: kMidSlate),
            ),
          ],
        ),
      ),
    );
  }
}
