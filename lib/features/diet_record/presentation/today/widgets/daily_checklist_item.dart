import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

/// A single checklist item widget used in the daily missions card.
/// Displays an icon, title, subtitle, and checkbox that can be toggled.
class DailyChecklistItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool completed;
  final VoidCallback onToggle;

  const DailyChecklistItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: completed ? kMidSlate : kDarkSlate,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: kMidSlate),
                ),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: completed ? kPrimaryMint : kLightSlate,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: completed ? kPrimaryMint : const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: completed
                ? const Icon(Icons.check, size: 14, color: kDarkSlate)
                : null,
          ),
        ],
      ),
    );
  }
}
