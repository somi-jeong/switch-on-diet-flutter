import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/screens/diary/widgets/meal_card.dart';
import 'package:switchon_diet/utils/time_validator.dart';
import 'package:switchon_diet/screens/dialogs/wake_dialogs.dart';
import 'package:switchon_diet/screens/tabs/widgets/missed_bedtime_banner.dart';

/// The view shown before the user records their wake time.
/// Displays a wake-up card with late time warnings and locked meal placeholders.
class TodayBeforeWakeView extends StatelessWidget {
  final int todayIdx;
  final bool hasMissedBedtime;
  final int yesterdayIdx;
  final VoidCallback onWakeTimeRecorded;
  final VoidCallback onMissedBedtimeRecorded;
  final Future<void> Function() onShowWakeTimeEditSheet;

  const TodayBeforeWakeView({
    super.key,
    required this.todayIdx,
    required this.hasMissedBedtime,
    required this.yesterdayIdx,
    required this.onWakeTimeRecorded,
    required this.onMissedBedtimeRecorded,
    required this.onShowWakeTimeEditSheet,
  });

  @override
  Widget build(BuildContext context) {
    // 기상 전에도 빈 식사 목록 생성 (guideText 포함)
    final placeholderMeals = [
      MealRecord(label: '아침', guideText: '기상 후 30~90분'),
      MealRecord(label: '점심', guideText: '기상 후 3.5~4.5시간'),
      MealRecord(label: '간식', guideText: '기상 후 6.5~7.5시간'),
      MealRecord(label: '저녁', guideText: '기상 후 9.5~10.5시간'),
    ];

    // 기상 시간이 늦었는지 체크
    final now = JstService.now();
    final currentTime = TimeOfDay.fromDateTime(now);
    final isCurrentLate = TimeValidator.isWakeTimeLate(currentTime);

    return Stack(
      children: [
        // 타임라인 연결선
        Positioned(
          left: 39,
          top: 10,
          bottom: 100,
          child: Container(
            width: 2,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        // 스크롤 가능한 콘텐츠
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 어제 취침 누락 배너
              if (hasMissedBedtime)
                MissedBedtimeBanner(
                  yesterdayIdx: yesterdayIdx,
                  onRecorded: onMissedBedtimeRecorded,
                ),
              // Wake Up Card (with late-time check)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isCurrentLate ? kRose200 : kBorder,
                    width: isCurrentLate ? 1.5 : 1,
                  ),
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
                    Icon(
                      isCurrentLate ? Icons.warning : Icons.wb_sunny_outlined,
                      size: 48,
                      color: isCurrentLate
                          ? kRose500
                          : kMidSlate.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isCurrentLate ? '기상 시간 미입력' : '좋은 아침입니다!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isCurrentLate ? kRose500 : kDarkSlate,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCurrentLate
                          ? '권장 기상 시간은 05:00~09:00입니다.\n지금이라도 기록해주세요!'
                          : '기상 시간을 기록하고\n오늘의 식단 플랜을 시작해보세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isCurrentLate
                            ? const Color(0xFF475569)
                            : kMidSlate,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 늦은 시간이면 버튼 2개, 정상이면 1개
                    if (isCurrentLate)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                onWakeTimeRecorded();
                                if (context.mounted) {
                                  final result =
                                      await showAbnormalWakeTimeDialog(context);
                                  if (result == 'edit' && context.mounted) {
                                    await onShowWakeTimeEditSheet();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kRose500,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                '늦잠 잤어요',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () async {
                                final shouldEdit = await showForgotRecordDialog(
                                  context,
                                );
                                if (shouldEdit == true && context.mounted) {
                                  await onShowWakeTimeEditSheet();
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: kRose500,
                                side: const BorderSide(color: kRose500),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                '기록을 깜빡했어요',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onWakeTimeRecorded,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryMint,
                            foregroundColor: kDarkSlate,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            '지금 일어났어요',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 잠긴 식사들
              ...placeholderMeals.map((meal) {
                return MealCard(meal: meal, isLocked: true);
              }),
              // 잠긴 취침 카드
              MealCard(
                meal: MealRecord(label: '취침', guideText: '저녁 식사 후 4시간 뒤'),
                isLocked: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
