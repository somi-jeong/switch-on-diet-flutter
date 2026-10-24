import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_day_cell.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_legend.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

class CalendarGrid extends StatelessWidget {
  final CalendarState calendar;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const CalendarGrid({
    super.key,
    required this.calendar,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final paddingDays = calendar.leadingBlankDays;
    final totalCells = paddingDays + ChallengeCalendar.totalDays;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorder),
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
          const CalendarLegend(),
          const SizedBox(height: 16),
          Row(
            children: ['일', '월', '화', '수', '목', '금', '토']
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: kMidSlate,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              // Show empty cells for padding
              if (index < paddingDays) {
                return const SizedBox.shrink();
              }

              final dayNum = index - paddingDays + 1;
              return CalendarDayCell(
                dayNum: dayNum,
                dateNum: calendar.dateOf(dayNum).day,
                status: calendar.statusOf(dayNum),
                isSelected: selectedDay == dayNum,
                onTap: () => onDaySelected(dayNum),
              );
            },
          ),
        ],
      ),
    );
  }
}
