import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switchon_diet/constants/colors.dart';

/// Time input field for meal recording
class MealTimeInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isPastDate; // 과거 날짜인 경우 시간만 입력 (HH:00)

  const MealTimeInput({
    super.key,
    required this.controller,
    required this.onChanged,
    this.isPastDate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '섭취 시간',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kDarkSlate,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.datetime,
          readOnly: isPastDate,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
            LengthLimitingTextInputFormatter(5),
          ],
          onChanged: onChanged,
          onTap: isPastDate ? () => _showHourPicker(context) : null,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkSlate,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(
              Icons.access_time,
              size: 20,
              color: kMidSlate,
            ),
            suffixIcon: isPastDate
                ? Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryMint.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '시간만',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kEmeraldText,
                      ),
                    ),
                  )
                : null,
            hintText: isPastDate ? 'HH:00' : 'HH:MM',
            hintStyle: const TextStyle(fontSize: 18, color: kMidSlate),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kPrimaryMint, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Future<void> _showHourPicker(BuildContext context) async {
    final currentHour = int.tryParse(controller.text.split(':')[0]) ?? 12;

    final selectedHour = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '몇 시에 드셨나요?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkSlate,
          ),
        ),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView.builder(
            itemCount: 24,
            itemBuilder: (context, index) {
              final isSelected = currentHour == index;
              return ListTile(
                title: Text(
                  '${index.toString().padLeft(2, '0')}:00',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? kPrimaryMint : kDarkSlate,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: kPrimaryMint.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () => Navigator.of(context).pop(index),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kMidSlate,
              ),
            ),
          ),
        ],
      ),
    );

    if (selectedHour != null) {
      controller.text = '${selectedHour.toString().padLeft(2, '0')}:00';
      onChanged(controller.text);
    }
  }
}
