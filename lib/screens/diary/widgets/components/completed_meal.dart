import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/screens/diary/widgets/components/status_badge.dart';
import 'package:switchon_diet/services/jst_service.dart';

class CompletedMeal extends StatelessWidget {
  final MealRecord meal;
  final VoidCallback? onEdit;

  const CompletedMeal({super.key, required this.meal, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo();
    final isSkipped = meal.skipped;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSkipped ? kLightSlate : kPrimaryMint,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                isSkipped ? Icons.remove_circle_outline : Icons.check,
                size: 20,
                color: isSkipped ? kMidSlate : kDarkSlate,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          meal.label,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isSkipped ? kMidSlate : kDarkSlate,
                            decoration: isSkipped
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        if (meal.recordedAt != null &&
                            meal.recordedAt!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            JstService.format(
                              JstService.fromIso(meal.recordedAt!),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSkipped ? kMidSlate : kPrimaryMint,
                              decoration: isSkipped
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        if (onEdit != null && !isSkipped)
                          GestureDetector(
                            onTap: onEdit,
                            child: const Text(
                              '수정',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFBBBBBB),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFBBBBBB),
                              ),
                            ),
                          ),
                        if (onEdit != null && !isSkipped)
                          const SizedBox(width: 8),
                        isSkipped
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: kLightSlate,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFCBD5E1),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.remove_circle_outline,
                                      size: 12,
                                      color: kMidSlate,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '스킵됨',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: kMidSlate,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : StatusBadge(
                                label: statusInfo.badgeLabel,
                                icon: statusInfo.badgeIcon,
                                textColor: statusInfo.badgeTextColor,
                                bgColor: statusInfo.badgeBgColor,
                                borderColor: statusInfo.badgeBorderColor,
                              ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: isSkipped ? 0.7 : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSkipped ? kLightSlate : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: kBorder),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isSkipped
                                    ? const Color(0xFFE0E0E0)
                                    : statusInfo.iconBgColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                isSkipped
                                    ? Icons.remove_circle_outline
                                    : statusInfo.icon,
                                size: 24,
                                color: isSkipped
                                    ? kMidSlate
                                    : statusInfo.iconColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isSkipped
                                        ? '이 끼니를 스킵했어요'
                                        : (meal.foodText ?? '단백질 쉐이크 1컵'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isSkipped ? kMidSlate : kDarkSlate,
                                      decoration: isSkipped
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    isSkipped
                                        ? '스킵 사유 기록됨'
                                        : (meal.foodText != null &&
                                                  meal.foodText!.isNotEmpty
                                              ? '텍스트 입력됨'
                                              : '물 또는 무가당 두유'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: kMidSlate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (!isSkipped &&
                            meal.aiFeedback != null &&
                            meal.aiFeedback!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: statusInfo.feedbackBgColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              border: Border.all(
                                color: statusInfo.feedbackBorderColor,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 14,
                                      color: statusInfo.feedbackTextColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AI 코치',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: statusInfo.feedbackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meal.aiFeedback!,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: kDarkSlate,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusInfo _getStatusInfo() {
    if (meal.aiStatus == 'ALLOWED') {
      return _StatusInfo(
        badgeLabel: '허용',
        badgeIcon: Icons.check_circle,
        badgeTextColor: const Color(0xFF059669),
        badgeBgColor: const Color(0xFFECFDF5),
        badgeBorderColor: const Color(0xFFA7F3D0),
        icon: Icons.water_drop,
        iconColor: const Color(0xFF059669),
        iconBgColor: kPrimaryMint.withValues(alpha: 0.1),
        feedbackBgColor: kPrimaryMint.withValues(alpha: 0.1),
        feedbackBorderColor: Colors.transparent,
        feedbackTextColor: const Color(0xFF059669),
      );
    } else if (meal.aiStatus == 'WARNING') {
      return _StatusInfo(
        badgeLabel: '주의',
        badgeIcon: Icons.warning,
        badgeTextColor: const Color(0xFFD97706),
        badgeBgColor: const Color(0xFFFFFBEB),
        badgeBorderColor: const Color(0xFFFDE68A),
        icon: Icons.restaurant,
        iconColor: const Color(0xFFD97706),
        iconBgColor: const Color(0xFFFEF3C7).withValues(alpha: 0.5),
        feedbackBgColor: const Color(0xFFFFFBEB),
        feedbackBorderColor: const Color(0xFFFDE68A).withValues(alpha: 0.5),
        feedbackTextColor: const Color(0xFFD97706),
      );
    } else if (meal.aiStatus == 'FORBIDDEN') {
      return _StatusInfo(
        badgeLabel: '금지',
        badgeIcon: Icons.cancel,
        badgeTextColor: const Color(0xFFDC2626),
        badgeBgColor: const Color(0xFFFEF2F2),
        badgeBorderColor: const Color(0xFFFECACA),
        icon: Icons.block,
        iconColor: const Color(0xFFDC2626),
        iconBgColor: const Color(0xFFFEE2E2),
        feedbackBgColor: const Color(0xFFFEF2F2),
        feedbackBorderColor: const Color(0xFFFECACA).withValues(alpha: 0.5),
        feedbackTextColor: const Color(0xFFDC2626),
      );
    } else {
      return _StatusInfo(
        badgeLabel: null,
        badgeIcon: Icons.circle,
        badgeTextColor: kMidSlate,
        badgeBgColor: kLightSlate,
        badgeBorderColor: kBorder,
        icon: Icons.water_drop,
        iconColor: kMidSlate,
        iconBgColor: kLightSlate,
        feedbackBgColor: kLightSlate,
        feedbackBorderColor: kBorder,
        feedbackTextColor: kMidSlate,
      );
    }
  }
}

class _StatusInfo {
  final String? badgeLabel;
  final IconData badgeIcon;
  final Color badgeTextColor;
  final Color badgeBgColor;
  final Color badgeBorderColor;

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  final Color feedbackBgColor;
  final Color feedbackBorderColor;
  final Color feedbackTextColor;

  _StatusInfo({
    required this.badgeLabel,
    required this.badgeIcon,
    required this.badgeTextColor,
    required this.badgeBgColor,
    required this.badgeBorderColor,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.feedbackBgColor,
    required this.feedbackBorderColor,
    required this.feedbackTextColor,
  });
}
