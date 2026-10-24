import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_view_model.dart';
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

/// The view shown after the wake-up time is logged: progress, daily missions,
/// the meal timeline and bedtime.
class TodayAfterWakeView extends ConsumerWidget {
  final TodayState state;
  final VoidCallback onWakeTimeEdit;

  const TodayAfterWakeView({
    super.key,
    required this.state,
    required this.onWakeTimeEdit,
  });

  /// [existing] pre-fills the form and enables deleting the entry.
  void _openRecordMeal(
    BuildContext context,
    String label, {
    MealRecord? existing,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RecordMealScreen(
          mealType: label,
          day: state.day,
          existingMeal: existing,
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Future<void> _skipMeal(
    BuildContext context,
    WidgetRef ref,
    MealRecord meal,
  ) async {
    final viewModel = ref.read(todayViewModelProvider.notifier);
    final confirmed = await showSkipWarningDialog(context);
    if (confirmed != true || !context.mounted) return;

    final reason = await showSkipReasonDialog(context, meal.label);
    await viewModel.skipMeal(meal.label, reason: reason);
  }

  Future<void> _recordLateMeal(
    BuildContext context,
    WidgetRef ref,
    MealRecord meal,
  ) async {
    final viewModel = ref.read(todayViewModelProvider.notifier);
    final selectedTime = await showMissedMealTimeDialog(
      context,
      mealLabel: meal.label,
      wakeTimeIso: state.record.wakeTime!,
      recommendedTime: viewModel.recommendedTimeFor(meal.label),
    );
    if (selectedTime == null || !context.mounted) return;

    final reason = await showLateReasonDialog(context, meal.label);
    if (!context.mounted) return;

    final [hour, minute] = selectedTime.split(':').map(int.parse).toList();
    _openRecordMeal(
      context,
      meal.label,
      existing: viewModel.lateEntryFor(
        meal,
        eatenAt: TimeOfDay(hour: hour, minute: minute),
        reason: reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wake = state.wakeTime!;
    final record = state.record;

    if (state.isDayLost) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Info Card
            TopInfoCard(
              wakeTime: wake,
              score: record.score,
              dayIdx: state.day,
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
                dayIdx: state.day,
                onWakeTimeEdit: onWakeTimeEdit,
              ),
              const SizedBox(height: 16),
              // Daily Missions Checklist
              DailyMissionsCard(
                record: record,
                onToggleMission: (value) => ref
                    .read(todayViewModelProvider.notifier)
                    .toggleMission(value),
              ),
              const SizedBox(height: 16),
              // Fasting Timer Card
              FastingTimerCard(fastingText: state.fastingText),
              const SizedBox(height: 24),
              // Meals Timeline (per-meal states)
              for (final item in state.timeline)
                MealCard(
                  meal: item.meal,
                  isNext: item.isNext,
                  isMissed: item.isMissed,
                  onRecord: item.isNext
                      ? () => _openRecordMeal(context, item.meal.label)
                      : null,
                  onSkip: item.isNext
                      ? () => _skipMeal(context, ref, item.meal)
                      : null,
                  onEdit: item.meal.checked
                      ? () => _openRecordMeal(
                          context,
                          item.meal.label,
                          existing: item.meal,
                        )
                      : null,
                  onRecordLate: item.isMissed
                      ? () => _recordLateMeal(context, ref, item.meal)
                      : null,
                ),
              // Bedtime Card
              BedtimeCard(
                onBedtimeSelected: (value) => ref
                    .read(todayViewModelProvider.notifier)
                    .recordBedtime(value),
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
