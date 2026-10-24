import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/dialogs/bedtime_dialogs.dart';

/// Banner that appears when the user missed recording bedtime yesterday.
/// Allows recording missed bedtime to maintain accurate sleep tracking.
class MissedBedtimeBanner extends StatelessWidget {
  final ValueChanged<TimeOfDay> onBedtimeSelected;

  const MissedBedtimeBanner({super.key, required this.onBedtimeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kIndigo50,
        border: Border.all(color: kIndigo100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kIndigo100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.nightlight_round,
              size: 20,
              color: kIndigo500,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '어제 취침 기록이 없어요!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kIndigo900,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '정확한 분석을 위해 기록해주세요.',
                  style: TextStyle(fontSize: 12, color: kIndigo500),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final selectedTime = await showMissedBedtimeModal(context);
              if (selectedTime != null) onBedtimeSelected(selectedTime);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kIndigo500,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '기록하기',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
