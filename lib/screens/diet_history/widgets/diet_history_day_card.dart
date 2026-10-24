import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/screens/diet_history/widgets/components/diet_history_meals_section.dart';

/// Individual day card in diet history showing sleep, meals, and missions
class DietHistoryDayCard extends StatelessWidget {
  final int dayIdx;
  final String date;
  final DietRecord record;
  final int Function(int) getWeek;
  final String Function(DietRecord) getFastingDuration;
  final String Function(DietRecord) getSleepDuration;

  const DietHistoryDayCard({
    super.key,
    required this.dayIdx,
    required this.date,
    required this.record,
    required this.getWeek,
    required this.getFastingDuration,
    required this.getSleepDuration,
  });

  @override
  Widget build(BuildContext context) {
    final wakeTime = record.wakeTime != null
        ? Jst.hourMinute(Jst.parse(record.wakeTime!))
        : '--';
    final bedTime = record.bedTime != null
        ? Jst.hourMinute(Jst.parse(record.bedTime!))
        : '--';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          // Header
          _buildHeader(),
          const SizedBox(height: 16),
          const Divider(color: kLightSlate),
          const SizedBox(height: 16),
          // Sleep & Wake
          _buildSleepWakeRow(wakeTime, bedTime),
          const SizedBox(height: 24),
          // Daily Missions
          _buildDailyMissions(),
          const SizedBox(height: 24),
          // Meals
          DietHistoryMealsSection(record: record),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${getWeek(dayIdx)}주차 $dayIdx일째',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kPrimaryMint,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '공복 유지',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: kMidSlate,
              ),
            ),
            Text(
              getFastingDuration(record),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepWakeRow(String wakeTime, String bedTime) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeBox(
            icon: Icons.wb_sunny,
            iconColor: kAmberText,
            iconBgColor: const Color(0xFFFEF3C7),
            label: '기상',
            time: wakeTime,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildTimeBox(
            icon: Icons.nightlight_round,
            iconColor: const Color(0xFF6366F1),
            iconBgColor: const Color(0xFFEEF2FF),
            label: '취침',
            time: bedTime,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kLightSlate,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: kMidSlate,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMissions() {
    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.check_circle, size: 14, color: kMidSlate),
            SizedBox(width: 6),
            Text(
              '데일리 미션 달성도',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: kMidSlate,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildMissionBox(
                Icons.water_drop,
                '물 2L',
                record.dailyChecklist?['water'] ?? false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMissionBox(
                Icons.medication,
                '영양제',
                record.dailyChecklist?['supplements'] ?? false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMissionBox(
                Icons.fitness_center,
                '운동',
                record.dailyChecklist?['exercise'] ?? false,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMissionBox(
                Icons.nightlight,
                getSleepDuration(record),
                record.dailyChecklist?['sleep'] ?? false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMissionBox(IconData icon, String label, bool completed) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: completed ? const Color(0xFFDCFCE7) : kLightSlate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed ? const Color(0xFF86EFAC) : kBorder,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: completed ? const Color(0xFF059669) : kMidSlate,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: completed ? const Color(0xFF059669) : kMidSlate,
            ),
          ),
        ],
      ),
    );
  }
}
