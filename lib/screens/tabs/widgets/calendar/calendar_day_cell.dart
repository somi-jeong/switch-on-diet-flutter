import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class CalendarDayCell extends StatelessWidget {
  final int dayNum;
  final int? dateNum; // Actual calendar date number
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.dayNum,
    this.dateNum,
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color? borderColor;
    bool hasIndicator = false;
    Color? indicatorColor;

    if (status == 'done') {
      bg = kPrimaryMint;
    } else if (status == 'warning') {
      bg = const Color(0xFFFECDD3);
      borderColor = null;
      hasIndicator = true;
      indicatorColor = const Color(0xFFFB7185);
    } else if (status == 'incomplete') {
      bg = const Color(0xFFFEF3C7);
      borderColor = null;
      hasIndicator = true;
      indicatorColor = const Color(0xFFFBBF24);
    } else if (status == 'today') {
      bg = Colors.white;
      borderColor = kPrimaryMint;
    } else {
      bg = kLightSlate;
      borderColor = kBorder;
    }

    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: status == 'today' ? 1.1 : 1.0,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: kPrimaryMint, width: 2)
                    : (borderColor != null
                          ? Border.all(
                              color: borderColor,
                              width: status == 'today' ? 2 : 1,
                            )
                          : null),
                boxShadow: status == 'done' || status == 'today'
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (status == 'done')
                    const Icon(Icons.check, size: 18, color: kDarkSlate)
                  else
                    Text(
                      (dateNum ?? dayNum).toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: status == 'today'
                            ? FontWeight.w900
                            : FontWeight.w700,
                        color: status == 'warning'
                            ? const Color(0xFFE11D48)
                            : status == 'incomplete'
                            ? const Color(0xFFD97706)
                            : status == 'today'
                            ? kPrimaryMint
                            : kMidSlate,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Text(
                    '$dayNum일차',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: status == 'done'
                          ? kDarkSlate.withValues(alpha: 0.6)
                          : status == 'warning'
                          ? const Color(0xFFE11D48).withValues(alpha: 0.6)
                          : status == 'incomplete'
                          ? const Color(0xFFD97706).withValues(alpha: 0.6)
                          : status == 'today'
                          ? kPrimaryMint
                          : kMidSlate.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (hasIndicator && indicatorColor != null)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
