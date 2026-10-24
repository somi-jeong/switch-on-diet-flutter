import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/presentation/coach_sheet/ai_coach_bottom_sheet.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_after_wake_view.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_before_wake_view.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_header.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/today_widgets.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/wake_time_sheet.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:switchon_diet/models/app_settings.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/services/storage_service.dart';

class TodayTab extends ConsumerStatefulWidget {
  final VoidCallback? onDataChanged;

  const TodayTab({super.key, this.onDataChanged});

  @override
  ConsumerState<TodayTab> createState() => _TodayTabState();
}

class _TodayTabState extends ConsumerState<TodayTab> {
  DietRecord? _record;
  AppSettings? _settings;
  bool _loading = true;
  int _todayIdx = 1;
  int _week = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = StorageService.getSettings();
    if (settings == null || settings.startDate.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    _settings = settings;
    final now = const JstClock().now();
    _todayIdx = ChallengeCalendar.fromIsoDate(settings.startDate).dayAt(now);
    _week = ChallengeCalendar.weekOf(_todayIdx);
    var record = StorageService.getRecord(_todayIdx);
    if (record == null) {
      record = DietRecord(date: Jst.isoDate(now), meals: []);
      await StorageService.saveRecord(record, _todayIdx);
    }
    setState(() {
      _record = record;
      _loading = false;
    });
  }

  Future<void> _saveWakeTime(DateTime wakeTime) async {
    if (_record == null) return;
    final meals = [
      for (final slot in MealSchedule.slotsForWakeHour(wakeTime.hour))
        MealRecord(label: slot.label),
    ];

    final updated = DietRecord(
      date: _record!.date,
      wakeTime: wakeTime.toIso8601String(),
      meals: meals,
      weight: _record!.weight,
      bodyFat: _record!.bodyFat,
      diary: _record!.diary,
      aiFeedback: _record!.aiFeedback,
      weeklySummary: _record!.weeklySummary,
      confession: _record!.confession,
      confessionFeedback: _record!.confessionFeedback,
      bedTime: _record!.bedTime,
      warningCount: _record!.warningCount,
      actualBedTime: _record!.actualBedTime,
      bedTimeFeedback: _record!.bedTimeFeedback,
    );
    await StorageService.saveRecord(updated, _todayIdx);
    setState(() {
      _record = updated;
    });
    widget.onDataChanged?.call(); // Notify parent
  }

  Future<void> _showWakeTimeEditSheet() async {
    final result = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: WakeTimeSheet(
          targetDate: const JstClock().now(),
          currentDayIdx: _todayIdx,
        ),
      ),
    );

    if (result != null && mounted) {
      await _saveWakeTime(result);
    }
  }

  String _fastingText() {
    if (_record?.wakeTime == null) return '--';
    final wake = Jst.parse(_record!.wakeTime!);
    final now = const JstClock().now();
    final diff = now.difference(wake);
    if (diff.isNegative) return '--';
    final hours = diff.inHours;
    final mins = diff.inMinutes % 60;
    return '${hours}h ${mins}m';
  }

  bool _checkMissedBedtime() {
    final yesterdayIdx = _todayIdx - 1;
    if (yesterdayIdx < 1) return false;

    final yesterdayRecord = StorageService.getRecord(yesterdayIdx);
    return yesterdayRecord != null &&
        yesterdayRecord.wakeTime != null &&
        (yesterdayRecord.bedTime == null || yesterdayRecord.bedTime!.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_settings == null || _record == null) {
      return const Center(child: Text('데이터를 불러올 수 없습니다'));
    }
    final hasWoken = _record!.wakeTime != null && _record!.wakeTime!.isNotEmpty;
    final score = _record!.score;

    // Calculate bottom navigation bar height including safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navBarHeight = 80 + bottomPadding; // 80 is the nav bar content height
    final fabBottomPosition = navBarHeight + 24; // 24px margin above nav bar

    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              TodayHeader(
                todayIdx: _todayIdx,
                week: _week,
                hasWoken: hasWoken,
                score: score,
                fastingText: _fastingText(),
              ),
              Expanded(
                child: Container(
                  color: kBgColor,
                  child: hasWoken
                      ? TodayAfterWakeView(
                          record: _record!,
                          todayIdx: _todayIdx,
                          fastingText: _fastingText(),
                          onRefresh: () {
                            _load();
                            widget.onDataChanged?.call();
                          },
                          onWakeTimeEdit: _showWakeTimeEditSheet,
                        )
                      : TodayBeforeWakeView(
                          todayIdx: _todayIdx,
                          hasMissedBedtime: _checkMissedBedtime(),
                          yesterdayIdx: _todayIdx - 1,
                          onWakeTimeRecorded: () async =>
                              await _saveWakeTime(const JstClock().now()),
                          onMissedBedtimeRecorded: () {
                            setState(() {});
                            widget.onDataChanged?.call();
                          },
                          onShowWakeTimeEditSheet: _showWakeTimeEditSheet,
                        ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: fabBottomPosition,
          right: 20,
          child: TodayFabButton(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => AiCoachBottomSheet(
                todayDate: _record!.date,
                todayIdx: _todayIdx,
                startDate: _settings!.startDate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
