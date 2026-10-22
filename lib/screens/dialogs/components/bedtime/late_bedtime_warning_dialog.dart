import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// 늦은 취침 경고 다이얼로그
Future<bool?> showLateBedtimeWarning(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.warning,
                size: 28,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '정말 이 시간에 주무셨나요? 🚨',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '스위치온 다이어트에서 '),
                  TextSpan(
                    text: '수면은 식단만큼 중요',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: '합니다.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kLightSlate,
                borderRadius: BorderRadius.circular(16),
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(text: '자정부터 새벽 4시 사이에는 '),
                    TextSpan(
                      text: '지방 분해 호르몬',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: '이 가장 활발하게 분비됩니다.\n\n이 시간을 놓치면 다음 날 '),
                    TextSpan(
                      text: '가짜 배고픔',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: '이 심해지고 다이어트 효율이 급격히 떨어집니다. 내일은 꼭 자정 전에 주무셔야 해요!',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '네, 명심할게요 (기록 완료)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '시간 다시 입력하기',
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
