import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// Header widget for RecordMealScreen
class RecordMealHeader extends StatelessWidget {
  final VoidCallback onBack;

  const RecordMealHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.chevron_left,
                size: 24,
                color: kDarkSlate,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              '식단 기록하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kDarkSlate,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
