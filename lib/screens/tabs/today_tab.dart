import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/constants/meal_offsets.dart';
import 'package:switchon_diet/models/app_settings.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';
import 'package:switchon_diet/screens/tabs/widgets/today_header.dart';
import 'package:switchon_diet/screens/tabs/widgets/today_widgets.dart';
import 'package:switchon_diet/screens/tabs/widgets/today_before_wake_view.dart';
import 'package:switchon_diet/screens/tabs/widgets/today_after_wake_view.dart';
import 'package:switchon_diet/screens/ai_coach_bottom_sheet.dart';
import 'package:switchon_diet/screens/tabs/widgets/wake_time_sheet.dart';

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

  void _load() async {
    final settings = StorageService.getSettings();
    if (settings == null || settings.startDate.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    _settings = settings;
    final startDate = DateTime.parse(settings.startDate);
    final now = JstService.now();
    final diff = now.difference(startDate).inDays + 1;
    _todayIdx = diff.clamp(1, 28);
    _week = ((_todayIdx - 1) ~/ 7 + 1).clamp(1, 4);
    var record = StorageService.getRecord(_todayIdx);
    if (record == null) {
      record = DietRecord(date: JstService.formatDate(now), meals: []);
      await StorageService.saveRecord(record, _todayIdx);
    }
    setState(() {
      _record = record;
      _loading = false;
    });
  }

  Future<void> _saveWakeTime(DateTime wakeTime) async {
    if (_record == null) return;
    final meals = <MealRecord>[];
    final wakeHour = wakeTime.hour;

    // 기상 시간에 따라 현실적으로 가능한 식사만 표시
    // 정상 (05:00~09:00): 4끼 전부
    // 약간 늦음 (09:00~11:00): 3끼 (아침 제외)
    // 상당히 늦음 (11:00~14:00): 2끼 (점심, 저녁)
    // 매우 늦음 (14:00~17:00): 1끼 (저녁)
    // 완전 비정상 (17:00~): 식사 진행 불가

    for (final m in mealOffsets) {
      bool shouldInclude = true;

      if (wakeHour >= 17) {
        // 17시 이후: 모든 식사 불가
        shouldInclude = false;
      } else if (wakeHour >= 14) {
        // 14~17시: 저녁만 가능
        shouldInclude = m.label == '저녁';
      } else if (wakeHour >= 11) {
        // 11~14시: 점심, 저녁만 가능
        shouldInclude = m.label == '점심' || m.label == '저녁';
      } else if (wakeHour >= 9) {
        // 09~11시: 점심, 간식, 저녁 가능 (아침 제외)
        shouldInclude = m.label != '아침';
      }
      // else: 05~09시는 모든 식사 가능

      if (shouldInclude) {
        meals.add(MealRecord(label: m.label, checked: false));
      }
    }

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
          targetDate: JstService.now(),
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
    final wake = JstService.fromIso(_record!.wakeTime!);
    final now = JstService.now();
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
                              await _saveWakeTime(JstService.now()),
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
