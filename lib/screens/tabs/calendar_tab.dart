import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/calendar_header.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/calendar_grid.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/day_details.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/future_day_message.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/week_status_card.dart';

class CalendarTab extends StatefulWidget {
  final String startDate;
  final int todayIdx;
  final Map<int, DietRecord> records;
  final Function(int dayIdx)? onDateTap;
  final VoidCallback? onRecordMeal;

  const CalendarTab({
    super.key,
    required this.startDate,
    required this.todayIdx,
    required this.records,
    this.onDateTap,
    this.onRecordMeal,
  });

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  int selectedDay = 4;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.todayIdx;
  }

  String _getDayStatus(int dayNum) {
    if (dayNum > widget.todayIdx) return 'future';
    if (dayNum == widget.todayIdx) return 'today';
    final record = widget.records[dayNum];
    if (record == null) return 'incomplete';

    // Check if all meals are skipped (late wake - 19:00+)
    final allSkipped = record.meals.every((m) => m.skipped);
    if (allSkipped) {
      return 'warning'; // Show as warning (red) for all meals skipped
    }

    // violation: FORBIDDEN meal exists
    final hasViolation = record.meals.any((m) => m.aiStatus == 'FORBIDDEN');
    if (hasViolation) return 'warning';

    // incomplete: any unrecorded meal
    final hasUnrecorded = record.meals.any((m) => !m.checked && !m.skipped);
    if (hasUnrecorded) return 'incomplete';

    return 'done';
  }

  List<Map<String, dynamic>> _getRealMeals(int day) {
    final record = widget.records[day];
    if (record == null || record.meals.isEmpty) return [];
    return record.meals.map((m) {
      String status;
      if (m.skipped) {
        status = 'skipped';
      } else if (m.aiStatus == 'FORBIDDEN') {
        status = 'violation';
      } else if (m.checked) {
        status = 'recorded';
      } else {
        status = 'unrecorded';
      }
      return {
        'type': m.label,
        'time': m.mealTime ?? (m.skipped ? '-' : ''),
        'status': status,
        'text': m.foodText ?? (m.skipped ? '기상 지연으로 스킵' : ''),
        'skipReason': m.skipReason,
        'lateReason': m.lateReason,
      };
    }).toList();
  }

  Map<String, dynamic> _calculateWeekProgress(int week) {
    // Week ranges: 1주차: 1-7, 2주차: 8-14, 3주차: 15-21, 4주차: 22-28
    final startDay = (week - 1) * 7 + 1;
    final endDay = week * 7;

    // Count completed days (score >= 0.8) in this week
    int completedDays = 0;
    int totalDaysInWeek = 0;

    for (int day = startDay; day <= endDay && day <= widget.todayIdx; day++) {
      totalDaysInWeek++;
      final record = widget.records[day];
      if (record != null && record.score >= 0.8) {
        completedDays++;
      }
    }

    // Determine if this week is active (current week)
    final currentWeek = ((widget.todayIdx - 1) ~/ 7) + 1;
    final isActive = week == currentWeek;

    // Calculate progress and status
    String status;
    double? progress;

    if (totalDaysInWeek == 0) {
      // Future week
      status = '예정';
      progress = null;
    } else if (totalDaysInWeek < 7) {
      // Week in progress
      final percentage = ((completedDays / totalDaysInWeek) * 100).round();
      status = '진행중 $percentage%';
      progress = completedDays / totalDaysInWeek;
    } else {
      // Week completed
      final percentage = ((completedDays / 7) * 100).round();
      status = '완료 $percentage%';
      progress = completedDays / 7;
    }

    return {'status': status, 'progress': progress, 'isActive': isActive};
  }

  @override
  Widget build(BuildContext context) {
    final days = List.generate(28, (i) => i + 1);
    final completed = days.where((d) {
      final r = widget.records[d];
      return r != null && r.score >= 0.8;
    }).length;

    return Container(
      color: kBgColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarHeader(
              completedDays: completed,
              totalDays: widget.todayIdx,
            ),
            const SizedBox(height: 32),
            CalendarGrid(
              todayIdx: widget.todayIdx,
              selectedDay: selectedDay,
              records: widget.records,
              startDate: widget.startDate,
              onDaySelected: (dayNum) {
                setState(() {
                  selectedDay = dayNum;
                });
              },
            ),
            const SizedBox(height: 32),
            if (selectedDay <= widget.todayIdx) ...[
              DayDetails(
                selectedDay: selectedDay,
                todayIdx: widget.todayIdx,
                status: _getDayStatus(selectedDay),
                records: widget.records,
                meals: _getRealMeals(selectedDay),
                startDate: widget.startDate,
                onRecordMeal: widget.onRecordMeal,
              ),
              const SizedBox(height: 32),
            ],
            if (selectedDay > widget.todayIdx) ...[
              const FutureDayMessage(),
              const SizedBox(height: 32),
            ],
            const Text(
              '주차별 현황',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 16),
            () {
              final week1 = _calculateWeekProgress(1);
              return WeekStatusCard(
                title: '1주차 (장 비우기)',
                status: week1['status'] as String,
                progress: week1['progress'] as double?,
                isActive: week1['isActive'] as bool,
              );
            }(),
            const SizedBox(height: 12),
            () {
              final week2 = _calculateWeekProgress(2);
              return WeekStatusCard(
                title: '2주차 (가속기)',
                status: week2['status'] as String,
                progress: week2['progress'] as double?,
                isActive: week2['isActive'] as bool,
              );
            }(),
            const SizedBox(height: 12),
            () {
              final week3 = _calculateWeekProgress(3);
              return WeekStatusCard(
                title: '3주차 (도약기)',
                status: week3['status'] as String,
                progress: week3['progress'] as double?,
                isActive: week3['isActive'] as bool,
              );
            }(),
            const SizedBox(height: 12),
            () {
              final week4 = _calculateWeekProgress(4);
              return WeekStatusCard(
                title: '4주차 (안정기)',
                status: week4['status'] as String,
                progress: week4['progress'] as double?,
                isActive: week4['isActive'] as bool,
              );
            }(),
          ],
        ),
      ),
    );
  }
}
