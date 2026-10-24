import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildLegendItem('완벽 성공', kPrimaryMint),
        const SizedBox(width: 12),
        _buildLegendItem('주의 필요', const Color(0xFFFB7185)),
        const SizedBox(width: 12),
        _buildLegendItem('미입력', const Color(0xFFFBBF24)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: kMidSlate,
          ),
        ),
      ],
    );
  }
}
