import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/analysis/presentation/widgets/weekly_chart_widgets.dart';

/// Weight line chart widget
class WeightLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> weekData;

  const WeightLineChart({super.key, required this.weekData});

  @override
  Widget build(BuildContext context) {
    final weights = weekData
        .where((d) => d['weight'] != null)
        .map((d) => d['weight'] as double)
        .toList();

    if (weights.isEmpty) {
      return const SizedBox();
    }

    final minW = weights.reduce(math.min) - 0.3;
    final maxW = weights.reduce(math.max) + 0.3;

    return SizedBox(
      height: 100,
      child: CustomPaint(
        size: const Size(double.infinity, 100),
        painter: WeightLinePainter(
          weekData: weekData,
          minWeight: minW,
          maxWeight: maxW,
        ),
      ),
    );
  }
}

/// Custom painter for weight line chart
class WeightLinePainter extends CustomPainter {
  final List<Map<String, dynamic>> weekData;
  final double minWeight;
  final double maxWeight;

  WeightLinePainter({
    required this.weekData,
    required this.minWeight,
    required this.maxWeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kMidGreen
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final circlePaint = Paint()
      ..color = kMidGreen
      ..style = PaintingStyle.fill;

    final points = <Offset>[];
    final validData = weekData.where((d) => d['weight'] != null).toList();

    for (int i = 0; i < validData.length; i++) {
      final w = validData[i]['weight'] as double;
      final x = 20 + (i / (validData.length - 1)) * (size.width - 40);
      final y =
          size.height -
          20 -
          ((w - minWeight) / (maxWeight - minWeight)) * (size.height - 40);
      points.add(Offset(x, y));
    }

    // Draw line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    // Draw circles and text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 4, circlePaint);

      // Weight label
      final weight = validData[i]['weight'] as double;
      textPainter.text = TextSpan(
        text: weight.toStringAsFixed(1),
        style: const TextStyle(fontSize: 9, color: Color(0xFF999999)),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, points[i].dy - 18),
      );

      // Day label
      final label = validData[i]['label'] as String;
      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(fontSize: 9, color: Color(0xFFBBBBBB)),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(points[i].dx - textPainter.width / 2, size.height - 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Weight change chart card
class WeightChangeCard extends StatelessWidget {
  final List<Map<String, dynamic>> weekData;
  final String weightDiff;

  const WeightChangeCard({
    super.key,
    required this.weekData,
    required this.weightDiff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: simpleCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⚖️ 체중 변화',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2421),
                ),
              ),
              Text(
                '▼ $weightDiff kg 감량',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kMidGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          WeightLineChart(weekData: weekData),
        ],
      ),
    );
  }
}
