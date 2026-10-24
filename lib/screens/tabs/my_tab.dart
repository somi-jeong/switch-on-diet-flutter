import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/screens/chat_history_screen.dart';
import 'package:switchon_diet/screens/dialogs/settings_dialogs.dart';
import 'package:switchon_diet/screens/diet_history_screen.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class MyTab extends StatefulWidget {
  final String startDate;
  final VoidCallback? onEnterWeekly;

  const MyTab({super.key, required this.startDate, this.onEnterWeekly});

  @override
  State<MyTab> createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> with RouteAware {
  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();
    final userName = StorageService.getSettings()?.userName ?? '다이어터';
    final week = ((stats.todayIdx - 1) ~/ 7 + 1).clamp(1, 4);

    return Container(
      color: kBgColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // User Profile Card
            Container(
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
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: kPrimaryMint.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 32,
                      color: kEmeraldText,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$userName 님',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kDarkSlate,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: kMidSlate,
                            ),
                            children: [
                              const TextSpan(text: '스위치온 '),
                              TextSpan(
                                text: '$week주차 • ${stats.todayIdx}일째',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryMint,
                                ),
                              ),
                              const TextSpan(text: ' 진행 중 🔥'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Basic Rules Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                  const Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: kPrimaryMint),
                      SizedBox(width: 6),
                      Text(
                        '스위치온 기본 수칙',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kDarkSlate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRuleItem('💧', '물 2L 이상', '충분히 마시기'),
                  const SizedBox(height: 10),
                  _buildRuleItem('🌙', '수면 6시간 이상', '(자정~새벽 4시 필수)'),
                  const SizedBox(height: 10),
                  _buildRuleItem('⏳', '저녁 식사 후', '14시간 공복 유지'),
                  const SizedBox(height: 10),
                  _buildRuleItem('🍽️', '저녁은', '취침 4시간 전에 마무리'),
                  const SizedBox(height: 10),
                  _buildRuleItem('🏃‍♀️', '주 4회 이상', '규칙적인 고강도 운동'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Card
            Container(
              padding: const EdgeInsets.all(8),
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
                children: [
                  _buildSettingItem(context, '챌린지 기간', '총 28일', null),
                  _buildSettingItem(
                    context,
                    '식단 및 수면 기록 보기',
                    null,
                    () => _navigateToDietHistory(context, stats.todayIdx),
                    icon: Icons.calendar_today,
                  ),
                  _buildSettingItem(
                    context,
                    'AI 코치 히스토리',
                    null,
                    () => _navigateToChatHistory(context, stats.todayIdx),
                    icon: Icons.history,
                  ),
                  _buildSettingItem(
                    context,
                    '식사 알림 설정',
                    null,
                    () {},
                    icon: Icons.notifications_outlined,
                  ),
                  _buildSettingItem(
                    context,
                    '이름 변경',
                    userName,
                    () => SettingsDialogs.showEditNameDialog(context, userName),
                    icon: Icons.person_outline,
                  ),
                  _buildSettingItem(
                    context,
                    '다이어트 시작일 변경',
                    widget.startDate.replaceAll('-', '.'),
                    () => SettingsDialogs.showEditStartDateDialog(
                      context,
                      widget.startDate,
                    ),
                    icon: Icons.calendar_today,
                    showBorder: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reset Button
            Center(
              child: TextButton.icon(
                onPressed: () => SettingsDialogs.showResetDialog(context),
                icon: const Icon(Icons.refresh, size: 16, color: kMidSlate),
                label: const Text(
                  '데이터 초기화',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kMidSlate,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String emoji, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: ' $subtitle'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String? trailing,
    VoidCallback? onTap, {
    IconData? icon,
    bool showBorder = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(bottom: BorderSide(color: kLightSlate))
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: kMidSlate),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF334155),
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
              ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0xFFCBD5E1),
              ),
          ],
        ),
      ),
    );
  }

  _ChallengeStats _calculateStats() {
    final endDate = DateTime.parse(
      widget.startDate,
    ).add(const Duration(days: 27));
    final endDateStr =
        '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

    final now = JstService.now();
    final start = DateTime.parse(widget.startDate);
    final currentDay = now.difference(start).inDays + 1;
    final todayIdx = currentDay.clamp(1, 28);

    final allRecords = StorageService.getAllRecords();
    int totalWarnings = 0;
    double totalScore = 0;
    int recordedDays = 0;
    int completedDays = 0;

    for (var i = 1; i <= todayIdx; i++) {
      final record = allRecords[i];
      if (record != null) {
        totalWarnings += record.warningCount;
        totalScore += record.score;
        recordedDays++;

        if (record.wakeTime != null && record.wakeTime!.isNotEmpty) {
          completedDays++;
        }
      }
    }

    final avgScore = recordedDays > 0
        ? (totalScore / recordedDays * 100).round()
        : 0;

    return _ChallengeStats(
      endDateStr: endDateStr,
      todayIdx: todayIdx,
      totalWarnings: totalWarnings,
      avgScore: avgScore,
      completedDays: completedDays,
    );
  }

  void _navigateToChatHistory(BuildContext context, int todayIdx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatHistoryScreen(startDate: widget.startDate, todayIdx: todayIdx),
      ),
    );
  }

  void _navigateToDietHistory(BuildContext context, int todayIdx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DietHistoryScreen(startDate: widget.startDate, todayIdx: todayIdx),
      ),
    );
  }
}

class _ChallengeStats {
  final String endDateStr;
  final int todayIdx, totalWarnings, avgScore, completedDays;

  _ChallengeStats({
    required this.endDateStr,
    required this.todayIdx,
    required this.totalWarnings,
    required this.avgScore,
    required this.completedDays,
  });
}
