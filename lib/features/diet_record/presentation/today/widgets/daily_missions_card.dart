import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/daily_checklist_item.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/widgets/sleep_checklist_item.dart';
import 'package:switchon_diet/models/diet_record.dart';

/// A card that displays the daily missions checklist.
/// Includes water intake, supplements, workout, and sleep tracking.
class DailyMissionsCard extends StatelessWidget {
  final DietRecord? record;
  final Function(String mission) onToggleMission;

  const DailyMissionsCard({
    super.key,
    required this.record,
    required this.onToggleMission,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kBorder),
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
            '오늘의 데일리 미션',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kDarkSlate,
            ),
          ),
          const SizedBox(height: 12),
          DailyChecklistItem(
            icon: Icons.water_drop,
            iconColor: const Color(0xFF3B82F6),
            iconBg: const Color(0xFFDEF7EC),
            title: '물 2L 이상 마시기',
            subtitle: '충분한 수분 섭취는 대사를 높여요',
            completed: record?.dailyChecklist?['water'] ?? false,
            onToggle: () => onToggleMission('water'),
          ),
          const Divider(height: 32, color: kLightSlate),
          DailyChecklistItem(
            icon: Icons.medication,
            iconColor: const Color(0xFFF59E0B),
            iconBg: const Color(0xFFFEF3C7),
            title: '영양제 챙겨먹기',
            subtitle: '유산균, 오메가3, 비타민 등',
            completed: record?.dailyChecklist?['supplements'] ?? false,
            onToggle: () => onToggleMission('supplements'),
          ),
          const Divider(height: 32, color: kLightSlate),
          DailyChecklistItem(
            icon: Icons.fitness_center,
            iconColor: const Color(0xFF059669),
            iconBg: kPrimaryMint.withValues(alpha: 0.2),
            title: '고강도 운동하기',
            subtitle: '주 4회 이상, 숨이 찰 정도로!',
            completed: record?.dailyChecklist?['workout'] ?? false,
            onToggle: () => onToggleMission('workout'),
          ),
          const Divider(height: 32, color: kLightSlate),
          SleepChecklistItem(record: record),
        ],
      ),
    );
  }
}
