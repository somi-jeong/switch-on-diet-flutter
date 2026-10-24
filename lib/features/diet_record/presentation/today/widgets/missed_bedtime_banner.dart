import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/dialogs/bedtime_dialogs.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/storage_service.dart';

/// Banner that appears when the user missed recording bedtime yesterday.
/// Allows recording missed bedtime to maintain accurate sleep tracking.
class MissedBedtimeBanner extends StatelessWidget {
  final int yesterdayIdx;
  final VoidCallback onRecorded;

  const MissedBedtimeBanner({
    super.key,
    required this.yesterdayIdx,
    required this.onRecorded,
  });

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
              if (selectedTime != null && context.mounted) {
                // 어제 날짜의 bedTime 저장
                final yesterdayRecord = StorageService.getRecord(yesterdayIdx);
                if (yesterdayRecord != null) {
                  final now = const JstClock().now();
                  final yesterday = now.subtract(const Duration(days: 1));
                  final bedtimeDateTime = DateTime(
                    yesterday.year,
                    yesterday.month,
                    yesterday.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  final updated = DietRecord(
                    date: yesterdayRecord.date,
                    wakeTime: yesterdayRecord.wakeTime,
                    meals: yesterdayRecord.meals,
                    weight: yesterdayRecord.weight,
                    bodyFat: yesterdayRecord.bodyFat,
                    diary: yesterdayRecord.diary,
                    aiFeedback: yesterdayRecord.aiFeedback,
                    weeklySummary: yesterdayRecord.weeklySummary,
                    confession: yesterdayRecord.confession,
                    confessionFeedback: yesterdayRecord.confessionFeedback,
                    bedTime: bedtimeDateTime.toIso8601String(),
                    warningCount: yesterdayRecord.warningCount,
                    actualBedTime: yesterdayRecord.actualBedTime,
                    bedTimeFeedback: yesterdayRecord.bedTimeFeedback,
                  );
                  await StorageService.saveRecord(updated, yesterdayIdx);
                  onRecorded();
                }
              }
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
