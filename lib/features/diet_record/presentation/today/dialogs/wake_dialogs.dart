import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

/// 기상 관련 다이얼로그 모음
/// 기상 관련 다이얼로그 모음

/// 불규칙 기상 경고 다이얼로그 (늦게 일어났을 때)
Future<String?> showAbnormalWakeTimeDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 경고 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: kRose50,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.warning, size: 28, color: kRose500),
            ),
            const SizedBox(height: 16),
            // 제목
            const Text(
              '기상 시간이 불규칙해요 🚨',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 12),
            // 설명
            const Text(
              '스위치온 다이어트에서는 생체 리듬을 되찾는 것이 핵심입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // 교육 메시지 박스
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kLightSlate,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '늦게 일어나거나 수면이 불규칙하면 스트레스 호르몬(코르티솔)이 분비되어 지방을 축적하고, 식욕 조절 호르몬(렙틴)이 감소해 폭식을 유발할 수 있어요.\n\n내일은 밤 12시~새벽 4시를 포함해 6시간 이상 푹 자고, 아침 5시~9시 사이에 일어나보세요!',
                style: TextStyle(fontSize: 12, color: kMidSlate, height: 1.5),
              ),
            ),
            const SizedBox(height: 24),
            // 버튼들
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, 'confirm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryMint,
                      foregroundColor: kDarkSlate,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '네, 내일은 일찍 일어날게요!',
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
                    onPressed: () => Navigator.pop(context, 'edit'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '실수로 잘못 눌렀어요 (시간 수정)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

/// 깜빡했어요 다이얼로그 (기록을 늦게 했을 때)
Future<bool?> showForgotRecordDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 경고 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: kAmber50,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.warning, size: 28, color: kAmber500),
            ),
            const SizedBox(height: 16),
            // 제목
            const Text(
              '알림 타이밍이 어긋날 수 있어요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 12),
            // 설명
            const Text(
              '기상 기록이 늦어지면 오늘 하루의 식단 알림(아침, 점심, 간식, 저녁) 시간이 모두 밀리게 됩니다.\n\n정확한 다이어트 스케줄 관리를 위해 다음부터는 일어나자마자 스위치온 앱을 켜주세요!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kMidSlate, height: 1.5),
            ),
            const SizedBox(height: 24),
            // 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryMint,
                  foregroundColor: kDarkSlate,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '실제 일어난 시간 입력하기',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
