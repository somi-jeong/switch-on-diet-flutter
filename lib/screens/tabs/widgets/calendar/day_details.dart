import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/daily_rules_section.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/ai_feedback_section.dart';
import 'package:switchon_diet/screens/tabs/widgets/calendar/meal_summary_card.dart';
import 'package:switchon_diet/screens/diet_history_screen.dart';

class DayDetails extends StatelessWidget {
  final int selectedDay;
  final int todayIdx;
  final String status;
  final Map<int, DietRecord> records;
  final List<Map<String, dynamic>> meals;
  final VoidCallback? onRecordMeal;
  final String startDate;

  const DayDetails({
    super.key,
    required this.selectedDay,
    required this.todayIdx,
    required this.status,
    required this.records,
    required this.meals,
    required this.startDate,
    this.onRecordMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${((selectedDay - 1) ~/ 7 + 1).clamp(1, 4)}주차 $selectedDay일째 식단',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: kDarkSlate,
              ),
            ),
            if (status == 'warning')
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
            if (status == 'incomplete')
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DietHistoryScreen(
                        startDate: startDate,
                        todayIdx: todayIdx,
                        initialSelectedDay: selectedDay,
                      ),
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
                    border: Border.all(
                      color: const Color(0xFFD97706),
                      width: 1,
                    ),
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
        ...meals.map(
          (meal) => MealSummaryCard(meal: meal, onRecordMeal: onRecordMeal),
        ),
        const SizedBox(height: 16),
        DailyRulesSection(record: records[selectedDay], dayIdx: selectedDay),
        const SizedBox(height: 16),
        AiFeedbackSection(
          record: records[selectedDay],
          dayIdx: selectedDay,
          todayIdx: todayIdx,
        ),
      ],
    );
  }
}
