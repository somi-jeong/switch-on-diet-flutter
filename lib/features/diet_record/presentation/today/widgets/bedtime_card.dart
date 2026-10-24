import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/dialogs/bedtime_dialogs.dart';

/// A card for recording bedtime.
/// Encourages users to sleep before midnight for optimal health.
class BedtimeCard extends StatelessWidget {
  final ValueChanged<TimeOfDay> onBedtimeSelected;

  const BedtimeCard({super.key, required this.onBedtimeSelected});

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
                            if (selectedTime != null) {
                              onBedtimeSelected(selectedTime);
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
