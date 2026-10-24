import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_day_cell.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/calendar_legend.dart';

class CalendarGrid extends StatelessWidget {
  final int todayIdx;
  final int selectedDay;
  final Function(int) onDaySelected;
  final Map<int, DietRecord>? records;
  final String? startDate;

  const CalendarGrid({
    super.key,
    required this.todayIdx,
    required this.selectedDay,
    required this.onDaySelected,
    this.records,
    this.startDate,
  });

  String _getDayStatus(int dayNum) {
    if (dayNum > todayIdx) return 'future';
    if (dayNum == todayIdx) return 'today';

    final record = records?[dayNum];
    if (record == null) return 'incomplete';

    // Check if all meals are skipped (late wake - 19:00+)
    final allSkipped = record.meals.every((m) => m.skipped);
    if (allSkipped) {
      return 'warning'; // Show as warning (red) for all meals skipped
    }

    // violation: FORBIDDEN meal exists
    final hasViolation = record.meals.any(
      (m) => m.verdict == MealVerdict.forbidden,
    );
    if (hasViolation) return 'warning';

    // incomplete: any unrecorded meal
    final hasUnrecorded = record.meals.any((m) => !m.checked && !m.skipped);
    if (hasUnrecorded) return 'incomplete';

    return 'done';
  }

  @override
  Widget build(BuildContext context) {
    // Calculate padding days based on start date
    int paddingDays = 0;
    if (startDate != null) {
      try {
        final start = DateTime.parse(startDate!);
        paddingDays = start.weekday % 7; // 0: Sun, 1: Mon, ..., 6: Sat
      } catch (_) {}
    }

    final totalCells = paddingDays + 28;

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
              final status = _getDayStatus(dayNum);
              final isSelected = selectedDay == dayNum;

              // Get actual calendar date
              DateTime? actualDate;
              if (startDate != null) {
                try {
                  final start = DateTime.parse(startDate!);
                  actualDate = start.add(Duration(days: dayNum - 1));
                } catch (_) {}
              }

              return CalendarDayCell(
                dayNum: dayNum,
                dateNum: actualDate?.day,
                status: status,
                isSelected: isSelected,
                onTap: () => onDaySelected(dayNum),
              );
            },
          ),
        ],
      ),
    );
  }
}
