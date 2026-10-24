import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/ai_feedback_section.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/daily_rules_section.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/widgets/meal_summary_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/history/diet_history_screen.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

class DayDetails extends StatelessWidget {
  final CalendarState calendar;
  final int selectedDay;

  const DayDetails({
    super.key,
    required this.calendar,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final status = calendar.statusOf(selectedDay);
    final records = calendar.records;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${ChallengeCalendar.weekOf(selectedDay)}주차 $selectedDay일째 식단',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kDarkSlate,
              ),
            ),
            if (status == DayStatus.warning)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: Color(0xFFFB7185),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '주의가 필요한 날이에요',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFB7185),
                      ),
                    ),
                  ],
                ),
              ),
            if (status == DayStatus.incomplete)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DietHistoryScreen(initialSelectedDay: selectedDay),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFD97706)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 12,
                        color: Color(0xFFD97706),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '미입력 식단이 있어요',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: Color(0xFFD97706),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        for (final meal in calendar.mealsOf(selectedDay))
          MealSummaryCard(meal: meal),
        const SizedBox(height: 16),
        DailyRulesSection(
          record: records[selectedDay],
          previousRecord: records[selectedDay - 1],
        ),
        const SizedBox(height: 16),
        AiFeedbackSection(
          record: records[selectedDay],
          dayIdx: selectedDay,
          todayIdx: calendar.today,
          isTodayReviewVisible: calendar.isTodayReviewVisible,
        ),
      ],
    );
  }
}
