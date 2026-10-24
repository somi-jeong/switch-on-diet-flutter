import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/ai_feedback_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/bedtime_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/daily_missions_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/fasting_timer_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/meal_card/meal_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/top_info_card.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/late_reason_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/missed_meal_time_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/skip_reason_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/skip_warning_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_screen.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';

/// The main view shown after the user has recorded their wake time.
/// Displays today's progress, daily missions, meals timeline, and bedtime tracking.
class TodayAfterWakeView extends ConsumerWidget {
  final DietRecord record;
  final int todayIdx;
  final String fastingText;
  final VoidCallback onRefresh;
  final VoidCallback onWakeTimeEdit;

  const TodayAfterWakeView({
    super.key,
    required this.record,
    required this.todayIdx,
    required this.fastingText,
    required this.onRefresh,
    required this.onWakeTimeEdit,
  });

  Future<void> _toggleDailyMission(WidgetRef ref, String mission) => ref
      .read(dietRecordRepositoryProvider)
      .save(todayIdx, record.toggleMission(mission));

  Future<void> _handleRecordMeal(BuildContext context, MealRecord meal) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecordMealScreen(
          mealType: meal.label,
          day: todayIdx,
          existingMeal: meal.checked ? meal : null,
          onBack: () {
            Navigator.of(context).pop();
            onRefresh();
          },
        ),
      ),
    );
  }

  Future<void> _handleSkipMeal(
    BuildContext context,
    WidgetRef ref,
    MealRecord meal,
  ) async {
    final result = await showSkipWarningDialog(context);

    if (result == true) {
      if (!context.mounted) return;

      // 스킵 이유 입력
      final reason = await showSkipReasonDialog(context, meal.label);
      if (!context.mounted) return;

      final updated = record.updateMeal(
        meal.label,
        (meal) => MealRecord(
          label: meal.label,
          skipped: true,
          guideText: meal.guideText,
          skipReason: reason,
        ),
      );
      await ref.read(dietRecordRepositoryProvider).save(todayIdx, updated);
    }
  }

  Future<void> _handleRecordMissedMeal(
    BuildContext context,
    int index,
    MealRecord meal,
  ) async {
    final recommendedTime = MealSchedule.recommendedTime(
      wakeTime: Jst.parse(record.wakeTime!),
      label: meal.label,
    );

    final selectedTime = await showMissedMealTimeDialog(
      context,
      mealLabel: meal.label,
      wakeTimeIso: record.wakeTime!,
      recommendedTime: recommendedTime,
    );

    debugPrint('[MissedMeal] Selected time: $selectedTime');

    if (selectedTime != null && context.mounted) {
      // 늦게 입력 이유 받기
      final reason = await showLateReasonDialog(context, meal.label);
      if (!context.mounted) return;

      debugPrint('[MissedMeal] Late reason: $reason');

      // Create updated meal with selected time and late reason
      final now = const JstClock().now();
      final timeParts = selectedTime.split(':');
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );

      final updatedMeal = MealRecord(
        label: meal.label,
        guideText: meal.guideText,
        eatenAt: selectedDateTime.toIso8601String(),
        lateReason: reason,
      );

      debugPrint('[MissedMeal] Updated meal with time: ${updatedMeal.eatenAt}');

      // Navigate to record meal screen with pre-filled data
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecordMealScreen(
            mealType: meal.label,
            day: todayIdx,
            existingMeal: updatedMeal,
            onBack: () {
              Navigator.of(context).pop();
              onRefresh();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wake = Jst.parse(record.wakeTime!);
    final wakeHour = wake.hour;

    // 17시 이후 기상: 다이어트 진행 불가
    if (wakeHour >= 17) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Info Card
            TopInfoCard(
              wakeTime: wake,
              score: record.score,
              dayIdx: todayIdx,
              onWakeTimeEdit: onWakeTimeEdit,
            ),
            const SizedBox(height: 24),
            // 경고 메시지
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                border: Border.all(color: const Color(0xFFFECACA), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.block, size: 48, color: Color(0xFFDC2626)),
                  const SizedBox(height: 16),
                  const Text(
                    '오늘은 다이어트 진행이 불가능합니다',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFDC2626),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '기상 시간: ${wake.hour.toString().padLeft(2, '0')}:${wake.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFB91C1C),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '오후 5시 이후 기상은 정상적인 식사 스케줄을 불가능하게 합니다.\n\n'
                    '스위치온 다이어트는 정상적인 생활 패턴을 전제로 하며:\n'
                    '• 0:00~4:00 무조건 수면\n'
                    '• 최소 7시간 수면\n'
                    '• 권장 기상: 05:00~09:00\n\n'
                    '내일은 정상적인 시간에 기상하여 다시 시작해보세요.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB91C1C),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // AI Coach Feedback Card
            AiFeedbackCard(record: record),
          ],
        ),
      );
    }

    // 다음 식사 찾기 (시간 지나지 않은 첫 번째 미완료 식사)
    int? nextMealIndex;
    for (int i = 0; i < record.meals.length; i++) {
      final meal = record.meals[i];
      if (meal.checked || meal.skipped) continue;

      // 시간이 지났는지 확인
      final isPassed = MealSchedule.isWindowPassed(
        wakeTime: wake,
        label: meal.label,
        now: const JstClock().now(),
      );

      if (!isPassed) {
        nextMealIndex = i;
        break;
      }
    }

    debugPrint(
      '[TodayAfterWake] Next meal index: $nextMealIndex, Current time: ${const JstClock().now()}',
    );

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
              // Top Info Card
              TopInfoCard(
                wakeTime: wake,
                score: record.score,
                dayIdx: todayIdx,
                onWakeTimeEdit: onWakeTimeEdit,
              ),
              const SizedBox(height: 16),
              // Daily Missions Checklist
              DailyMissionsCard(
                record: record,
                onToggleMission: (mission) => _toggleDailyMission(ref, mission),
              ),
              const SizedBox(height: 16),
              // Fasting Timer Card
              FastingTimerCard(fastingText: fastingText),
              const SizedBox(height: 24),
              // Meals Timeline (per-meal states)
              ...record.meals.asMap().entries.map((entry) {
                final index = entry.key;
                final meal = entry.value;

                // Check if meal time has passed
                final isMissed =
                    !meal.checked &&
                    !meal.skipped &&
                    MealSchedule.isWindowPassed(
                      wakeTime: wake,
                      label: meal.label,
                      now: const JstClock().now(),
                    );

                // isNext는 시간 안 지난 첫 번째 미완료 식사
                final isNext = index == nextMealIndex && !isMissed;

                debugPrint(
                  '[Meal ${meal.label}] isMissed=$isMissed, isNext=$isNext, checked=${meal.checked}, skipped=${meal.skipped}',
                );

                return MealCard(
                  meal: meal,
                  isNext: isNext,
                  isMissed: isMissed,
                  onRecord: isNext
                      ? () => _handleRecordMeal(context, meal)
                      : null,
                  onSkip: isNext
                      ? () => _handleSkipMeal(context, ref, meal)
                      : null,
                  onEdit: meal.checked
                      ? () => _handleRecordMeal(context, meal)
                      : null,
                  onRecordLate: isMissed
                      ? () => _handleRecordMissedMeal(context, index, meal)
                      : null,
                );
              }),
              // Bedtime Card
              BedtimeCard(
                record: record,
                todayIdx: todayIdx,
                onBedtimeRecorded: onRefresh,
              ),
              const SizedBox(height: 24),
              // AI Coach Feedback Card
              AiFeedbackCard(record: record),
            ],
          ),
        ),
      ],
    );
  }
}
