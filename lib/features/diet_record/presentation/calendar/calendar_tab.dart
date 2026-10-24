import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_grid.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_header.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/day_details.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/future_day_message.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/week_status_card.dart';

class CalendarTab extends ConsumerStatefulWidget {
  const CalendarTab({super.key});

  @override
  ConsumerState<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends ConsumerState<CalendarTab> {
  static const _weekTitles = [
    '1주차 (장 비우기)',
    '2주차 (가속기)',
    '3주차 (도약기)',
    '4주차 (안정기)',
  ];

  late int _selectedDay = ref.read(calendarProvider).today;

  @override
  Widget build(BuildContext context) {
    final calendar = ref.watch(calendarProvider);

    return Container(
      color: kBgColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CalendarHeader(
              completedDays: calendar.achievedDays,
              totalDays: calendar.today,
            ),
            const SizedBox(height: 32),
            CalendarGrid(
              calendar: calendar,
              selectedDay: _selectedDay,
              onDaySelected: (day) => setState(() => _selectedDay = day),
            ),
            const SizedBox(height: 32),
            if (_selectedDay <= calendar.today) ...[
              DayDetails(calendar: calendar, selectedDay: _selectedDay),
              const SizedBox(height: 32),
            ],
            if (_selectedDay > calendar.today) ...[
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
            for (final (index, title) in _weekTitles.indexed) ...[
              if (index > 0) const SizedBox(height: 12),
              _weekCard(title, calendar.progressOf(index + 1)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _weekCard(String title, WeekProgress week) => WeekStatusCard(
    title: title,
    status: week.status,
    progress: week.progress,
    isActive: week.isActive,
  );
}
