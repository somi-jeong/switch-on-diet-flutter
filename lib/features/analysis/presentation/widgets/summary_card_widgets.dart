import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/analysis/presentation/widgets/weekly_chart_widgets.dart';

/// Meal compliance card
class MealComplianceCard extends StatelessWidget {
  final int allowedCount;
  final int forbiddenCount;
  final int notRecordedCount;
  final int totalMeals;

  const MealComplianceCard({
    super.key,
    required this.allowedCount,
    required this.forbiddenCount,
    required this.notRecordedCount,
    required this.totalMeals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: simpleCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🍽 식사 준수 현황',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2421),
            ),
          ),
          const SizedBox(height: 12),
          ComplianceBar(
            label: '허용 식품 준수',
            count: allowedCount,
            total: totalMeals,
            color: kMidGreen,
          ),
          const SizedBox(height: 10),
          ComplianceBar(
            label: '금지 식품 위반',
            count: forbiddenCount,
            total: totalMeals,
            color: const Color(0xFFC62828),
          ),
          const SizedBox(height: 10),
          ComplianceBar(
            label: '미기록 끼니',
            count: notRecordedCount,
            total: totalMeals,
            color: const Color(0xFFBBBBBB),
          ),
        ],
      ),
    );
  }
}

/// Weekly AI summary card
class WeeklyAISummaryCard extends StatelessWidget {
  final int week;
  final int avgScore;
  final int warnings;
  final String weightDiff;

  const WeeklyAISummaryCard({
    super.key,
    required this.week,
    required this.avgScore,
    required this.warnings,
    required this.weightDiff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              const Text(
                '주간 AI 총평',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2421),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: kLightGreen,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$week주차',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: kDarkGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F9F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$week주차 평균 달성률 $avgScore%로 ${avgScore >= 80
                  ? "훌륭한"
                  : avgScore >= 50
                  ? "양호한"
                  : "아쉬운"} 출발입니다. '
              '${warnings > 0 ? "경고 $warnings회가 발생했습니다. " : "경고 없이 잘 진행하고 계십니다. "}'
              '체중은 7일간 $weightDiff kg 감량되어 ${double.parse(weightDiff) >= 1.0 ? "순조롭" : "진행 중"}습니다. '
              '${week < 4 ? "${week + 1}주차에는 위반 0회를 목표로 도전해보세요! 💪" : "마지막까지 완주하세요! 💪"}',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF444444),
                height: 1.75,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Next week goals card
class NextWeekGoalsCard extends StatelessWidget {
  final int week;

  const NextWeekGoalsCard({super.key, required this.week});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1F2A24), Color(0xFF2F5A3A)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 ${week + 1}주차 목표',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kLightGreen,
            ),
          ),
          const SizedBox(height: 10),
          ...[
            '위반 0회 달성',
            '취침 전 4시간 식사 금지 완벽 준수',
            '체중 감량 목표 달성',
          ].asMap().entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                border: entry.key < 2
                    ? const Border(bottom: BorderSide(color: Color(0x14FFFFFF)))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: kLightGreen, width: 1.5),
                    ),
                    child: const Center(
                      child: Text(
                        '○',
                        style: TextStyle(fontSize: 10, color: kLightGreen),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xD9FFFFFF),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
