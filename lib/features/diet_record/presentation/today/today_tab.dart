import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/coach/presentation/coach_sheet/ai_coach_bottom_sheet.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_view_model.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_after_wake_view.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_before_wake_view.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_header.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_widgets.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/wake_time_sheet.dart';

class TodayTab extends ConsumerWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(todayViewModelProvider)
        .when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const Center(child: Text('데이터를 불러올 수 없습니다')),
          data: (state) => _TodayContent(state: state),
        );
  }
}

class _TodayContent extends ConsumerWidget {
  const _TodayContent({required this.state});

  final TodayState state;

  Future<void> _editWakeTime(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(todayViewModelProvider.notifier);
    final wakeTime = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: WakeTimeSheet(
          now: state.now,
          previousBedTime: state.yesterday?.bedTime,
        ),
      ),
    );
    if (wakeTime != null) await viewModel.recordWakeTime(wakeTime);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep the coach button above the bottom navigation bar (80pt + inset).
    final fabBottom = 80 + MediaQuery.of(context).padding.bottom + 24;

    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              TodayHeader(
                todayIdx: state.day,
                week: state.week,
                hasWoken: state.hasWoken,
                score: state.record.score,
                fastingText: state.fastingText,
              ),
              Expanded(
                child: Container(
                  color: kBgColor,
                  child: state.hasWoken
                      ? TodayAfterWakeView(
                          state: state,
                          onWakeTimeEdit: () => _editWakeTime(context, ref),
                        )
                      : TodayBeforeWakeView(
                          state: state,
                          onShowWakeTimeEditSheet: () =>
                              _editWakeTime(context, ref),
                        ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: fabBottom,
          right: 20,
          child: TodayFabButton(
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AiCoachBottomSheet(
                todayDate: state.record.date,
                todayIdx: state.day,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
