import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/screens/dialogs/bedtime_dialogs.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

/// A card for recording bedtime.
/// Encourages users to sleep before midnight for optimal health.
class BedtimeCard extends StatelessWidget {
  final DietRecord record;
  final int todayIdx;
  final VoidCallback onBedtimeRecorded;

  const BedtimeCard({
    super.key,
    required this.record,
    required this.todayIdx,
    required this.onBedtimeRecorded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 취침 아이콘
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.nightlight_round,
                size: 20,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 콘텐츠
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      '취침',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkSlate,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '23:00 목표',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEEF2FF), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE0E7FF)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '충분한 수면은 필수!\n밤 12시 이전 취침을 권장해요.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kDarkSlate,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final selectedTime = await showTodayBedtimeModal(
                              context,
                            );
                            if (selectedTime != null && context.mounted) {
                              // 오늘 날짜의 bedTime 저장
                              final now = JstService.now();
                              final bedtimeDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                selectedTime.hour,
                                selectedTime.minute,
                              );
                              final updated = DietRecord(
                                date: record.date,
                                wakeTime: record.wakeTime,
                                meals: record.meals,
                                weight: record.weight,
                                bodyFat: record.bodyFat,
                                diary: record.diary,
                                aiFeedback: record.aiFeedback,
                                weeklySummary: record.weeklySummary,
                                confession: record.confession,
                                confessionFeedback: record.confessionFeedback,
                                bedTime: bedtimeDateTime.toIso8601String(),
                                warningCount: record.warningCount,
                                actualBedTime: record.actualBedTime,
                                bedTimeFeedback: record.bedTimeFeedback,
                                dailyChecklist: record.dailyChecklist,
                              );
                              await StorageService.saveRecord(
                                updated,
                                todayIdx,
                              );
                              onBedtimeRecorded();
                            }
                          },
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('취침 기록하기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEEF2FF),
                            foregroundColor: const Color(0xFF6366F1),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
