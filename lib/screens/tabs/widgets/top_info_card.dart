import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/core/utils/time_validator.dart';

/// The top information card shown after waking up.
/// Displays program info, wake time (with warning if late), and completion progress.
class TopInfoCard extends StatelessWidget {
  final DateTime wakeTime;
  final double score;
  final int dayIdx;
  final VoidCallback onWakeTimeEdit;

  const TopInfoCard({
    super.key,
    required this.wakeTime,
    required this.score,
    required this.dayIdx,
    required this.onWakeTimeEdit,
  });

  /// Title and one-line guide for the program phase of [dayIdx].
  static (String, String) phaseText(int dayIdx) {
    if (dayIdx <= 3) {
      return ('위장관 휴식 기간 🌿', '오늘은 단백질 쉐이크만\n하루 4번 먹는 날이에요.');
    }
    if (dayIdx <= 7) {
      return ('지방 대사 활성화 🔥', '점심에만 잡곡밥을 곁들이고\n나머지는 단백질 쉐이크예요.');
    }
    if (dayIdx <= 14) {
      return ('가속기 🚀', '점심은 잡곡밥 + 반찬, 저녁은\n저탄수화물 식사예요.');
    }
    if (dayIdx <= 21) {
      return ('체질 전환기 🌱', '이번 주는 24시간 단식을\n주 2회 실천해요.');
    }
    return ('완성기 🌳', '이번 주는 24시간 단식을\n주 3회 실천해요.');
  }

  @override
  Widget build(BuildContext context) {
    final wakeTimeOfDay = TimeOfDay.fromDateTime(wakeTime);
    final isWakeTimeAbnormal = TimeValidator.isWakeTimeLate(wakeTimeOfDay);
    final (phaseTitle, phaseGuide) = phaseText(dayIdx);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phaseTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: kDarkSlate,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  phaseGuide,
                  style: const TextStyle(
                    fontSize: 14,
                    color: kMidSlate,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onWakeTimeEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isWakeTimeAbnormal ? kRose50 : kLightSlate,
                      border: Border.all(
                        color: isWakeTimeAbnormal ? kRose200 : kBorder,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isWakeTimeAbnormal ? Icons.warning : Icons.wb_sunny,
                          size: 18,
                          color: isWakeTimeAbnormal ? kRose500 : kAmberText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '기상 ${Jst.hourMinute(wakeTime)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isWakeTimeAbnormal ? kRose700 : kDarkSlate,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 14,
                          color: isWakeTimeAbnormal ? kRose400 : kMidSlate,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Progress Circle
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: score,
                    strokeWidth: 3,
                    backgroundColor: kLightSlate,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPrimaryMint,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '달성률',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: kMidSlate,
                        ),
                      ),
                      Text(
                        '${(score * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: kDarkSlate,
                        ),
                      ),
                    ],
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
