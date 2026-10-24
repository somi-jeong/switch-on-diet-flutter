import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class BedtimeWarningBox extends StatelessWidget {
  const BedtimeWarningBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: kIndigo50,
        border: Border.all(color: kIndigo100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, size: 16, color: kIndigo500),
              SizedBox(width: 8),
              Text(
                '지방 분해 골든타임 놓침',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kIndigo700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '자정~새벽 4시는 살이 빠지는 핵심 시간이에요. 너무 늦게 주무시면 식욕 억제 호르몬이 줄어들어요 😭',
            style: TextStyle(fontSize: 12, color: kIndigo500, height: 1.5),
          ),
        ],
      ),
    );
  }
}
