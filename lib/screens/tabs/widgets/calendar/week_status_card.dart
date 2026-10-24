import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

class WeekStatusCard extends StatelessWidget {
  final String title;
  final String status;
  final double? progress;
  final bool isActive;

  const WeekStatusCard({
    super.key,
    required this.title,
    required this.status,
    this.progress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : kLightSlate,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? kPrimaryMint.withValues(alpha: 0.3) : kBorder,
            ),
            boxShadow: isActive
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? kDarkSlate : kMidSlate,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? kPrimaryMint : kMidSlate,
                    ),
                  ),
                ],
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: kLightSlate,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPrimaryMint,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isActive)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: const BoxDecoration(
                color: kPrimaryMint,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
