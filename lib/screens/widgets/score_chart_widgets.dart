import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/screens/widgets/weekly_chart_widgets.dart';

/// Day column widget for score chart
class ScoreDayColumn extends StatelessWidget {
  final int day;
  final String label;
  final double score;

  const ScoreDayColumn({
    super.key,
    required this.day,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final h = (score * 80).round();
    final color = score >= 0.8
        ? kMidGreen
        : score >= 0.5
        ? const Color(0xFFA8D5B5)
        : const Color(0xFFF5A9A2);
    final textColor = score >= 0.8
        ? kMidGreen
        : score >= 0.5
        ? const Color(0xFF555555)
        : const Color(0xFFC62828);

    return Column(
      children: [
        Text(
          '${(score * 100).round()}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            height: h.toDouble(),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFFBBBBBB)),
        ),
        Text(
          'D$day',
          style: const TextStyle(fontSize: 10, color: Color(0xFFCCCCCC)),
        ),
      ],
    );
  }
}

/// Daily achievement chart card
class DailyAchievementCard extends StatelessWidget {
  final List<Map<String, dynamic>> weekData;

  const DailyAchievementCard({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: simpleCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📅 일별 달성률',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2421),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: weekData.map((d) {
              return ScoreDayColumn(
                day: d['day'],
                label: d['label'],
                score: d['score'] as double,
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 10,
            children: [
              ChartLegend(color: kMidGreen, label: '완벽 80%+'),
              ChartLegend(color: Color(0xFFA8D5B5), label: '양호 50%+'),
              ChartLegend(color: Color(0xFFF5A9A2), label: '아쉬움'),
            ],
          ),
        ],
      ),
    );
  }
}
