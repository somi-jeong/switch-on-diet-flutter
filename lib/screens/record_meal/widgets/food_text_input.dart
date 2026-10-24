import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

/// Food description text input field
class FoodTextInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const FoodTextInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          TextField(
            controller: controller,
            maxLength: 100,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '예: 아몬드 브리즈에 초코맛 쉐이크 타먹었어요',
              hintStyle: TextStyle(fontSize: 14, color: kMidSlate),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 14, color: kDarkSlate),
            onChanged: (_) => onChanged(),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kLightSlate)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${controller.text.length} / 100',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kMidSlate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
