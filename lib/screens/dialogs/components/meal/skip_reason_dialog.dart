import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// 스킵 이유 입력 다이얼로그
Future<String?> showSkipReasonDialog(
  BuildContext context,
  String mealLabel,
) async {
  final controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$mealLabel 스킵 이유',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '스킵하신 이유를 간단히 적어주세요.\nAI 코치가 이를 기억하고 더 나은 피드백을 드려요.',
              style: TextStyle(fontSize: 14, color: kMidSlate, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: 3,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '예: 배가 안 고파서, 시간이 없어서...',
                hintStyle: const TextStyle(color: kMidSlate),
                filled: true,
                fillColor: kBgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kPrimaryMint, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: kBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kMidSlate,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final text = controller.text.trim();
                      Navigator.of(context).pop(text.isEmpty ? null : text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryMint,
                      foregroundColor: kDarkSlate,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
