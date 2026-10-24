import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/screens/widgets/score_chart_widgets.dart';
import 'package:switchon_diet/screens/widgets/summary_card_widgets.dart';
import 'package:switchon_diet/screens/widgets/weekly_chart_widgets.dart';
import 'package:switchon_diet/screens/widgets/weight_chart_widgets.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class WeeklyFeedbackScreen extends StatelessWidget {
  final String startDate;
  final int week;

  const WeeklyFeedbackScreen({
    super.key,
    required this.startDate,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate week data
    final allRecords = StorageService.getAllRecords();
    final startDay = (week - 1) * 7 + 1;
    final endDay = week * 7;

    final weekData = <Map<String, dynamic>>[];
    double totalScore = 0;
    int warnings = 0;
    double? startWeight;
    double? endWeight;

    for (int i = startDay; i <= endDay; i++) {
      final record = allRecords[i];

      if (record != null) {
        weekData.add({
          'day': i,
          'label': ['월', '화', '수', '목', '금', '토', '일'][(i - 1) % 7],
          'score': record.score,
          'weight': record.weight,
        });
        totalScore += record.score;
        warnings += record.warningCount;

        if (startWeight == null && record.weight != null) {
          startWeight = record.weight;
        }
        if (record.weight != null) {
          endWeight = record.weight;
        }
      } else {
        weekData.add({
          'day': i,
          'label': ['월', '화', '수', '목', '금', '토', '일'][(i - 1) % 7],
          'score': 0.0,
          'weight': null,
        });
      }
    }

    final avgScore = weekData.isNotEmpty
        ? (totalScore / weekData.length * 100).round()
        : 0;
    final weightDiff = (startWeight != null && endWeight != null)
        ? (startWeight - endWeight).toStringAsFixed(1)
        : '0.0';

    // Calculate meal compliance stats
    int allowedCount = 0;
    int forbiddenCount = 0;
    int notRecordedCount = 0;
    const totalMeals = 28; // 7 days × 4 meals

    for (int i = startDay; i <= endDay; i++) {
      final record = allRecords[i];

      if (record != null) {
        for (final meal in record.meals) {
          if (meal.skipped) {
            continue; // Don't count skipped meals
          }
          if (meal.aiStatus == 'ALLOWED') {
            allowedCount++;
          } else if (meal.aiStatus == 'FORBIDDEN') {
            forbiddenCount++;
          } else if (!meal.checked) {
            notRecordedCount++;
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // 상단바
            Container(
              height: 40,
              color: kDarkGreen,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '스위치온',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0x80FFFFFF),
                    ),
                  ),
                  Text(
                    '${JstService.formatDate(JstService.now())} JST',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0x66FFFFFF),
                    ),
                  ),
                ],
              ),
            ),

            // 헤더
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F2A24), Color(0xFF2F4A38)],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$week주차 리포트 · Day $startDay–$endDay',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0x80FFFFFF),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '📊 주간 피드백',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      StatChip(label: '평균 달성', value: '$avgScore%'),
                      const SizedBox(width: 8),
                      StatChip(label: '경고', value: '$warnings회'),
                      const SizedBox(width: 8),
                      StatChip(label: '체중 감량', value: '-$weightDiff kg'),
                    ],
                  ),
                ],
              ),
            ),

            // 스크롤 가능한 컨텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                child: Column(
                  children: [
                    DailyAchievementCard(weekData: weekData),
                    const SizedBox(height: 12),
                    if (weekData.any((d) => d['weight'] != null))
                      WeightChangeCard(
                        weekData: weekData,
                        weightDiff: weightDiff,
                      ),
                    if (weekData.any((d) => d['weight'] != null))
                      const SizedBox(height: 12),
                    MealComplianceCard(
                      allowedCount: allowedCount,
                      forbiddenCount: forbiddenCount,
                      notRecordedCount: notRecordedCount,
                      totalMeals: totalMeals,
                    ),
                    const SizedBox(height: 12),
                    WeeklyAISummaryCard(
                      week: week,
                      avgScore: avgScore,
                      warnings: warnings,
                      weightDiff: weightDiff,
                    ),
                    const SizedBox(height: 12),
                    if (week < 4) NextWeekGoalsCard(week: week),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
