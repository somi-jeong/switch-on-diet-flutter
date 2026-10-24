import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

// Wake button widget
class WakeButton extends StatelessWidget {
  final String text;
  final String? subtitle;
  final VoidCallback onPressed;

  const WakeButton({
    super.key,
    required this.text,
    this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1A2421),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        child: subtitle != null
            ? Column(
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
      ),
    );
  }
}

// Locked meal card widget
class LockedMealCard extends StatelessWidget {
  final String label;
  final String icon;

  const LockedMealCard({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2421),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                '기상 후 설정돼요',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '대기',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// FAB button widget (dark with mint icon)
class TodayFabButton extends StatelessWidget {
  final VoidCallback onTap;

  const TodayFabButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: kDarkSlate,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28,
                color: kPrimaryMint,
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: kRoseText,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kDarkSlate, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
