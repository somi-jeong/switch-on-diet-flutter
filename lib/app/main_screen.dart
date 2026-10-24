import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/analysis/analysis_providers.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/calendar/calendar_tab.dart';
import 'package:switchon_diet/features/diet_record/presentation/past_day/past_date_meal_selection_screen.dart';
import 'package:switchon_diet/features/diet_record/presentation/past_day/past_date_warning_dialog.dart';
import 'package:switchon_diet/features/diet_record/presentation/today/today_tab.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/presentation/diet_tab.dart';
import 'package:switchon_diet/features/settings/presentation/my_page/my_tab.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

/// The tab shell shown once the challenge has started.
///
/// Besides hosting the tabs it owns two app-level duties: picking up a new
/// program day when the app resumes, and triggering the scheduled daily and
/// weekly reviews (there is no backend to run them).
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with WidgetsBindingObserver {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runScheduledReviews());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(currentDayProvider);
      _runScheduledReviews();
    }
  }

  Future<void> _runScheduledReviews() async {
    final startDate = ref.read(settingsProvider)?.startDate;
    if (startDate == null) return;
    final reviews = [
      ref.read(generateWeeklySummaryProvider).runIfDue,
      ref.read(generateDailyFeedbackProvider).runIfDue,
    ];
    for (final runIfDue in reviews) {
      try {
        await runIfDue(startDate: startDate);
      } on AiFailure catch (failure) {
        debugPrint('Scheduled review failed: $failure');
      }
    }
  }

  Future<void> _openPastDay(ChallengeCalendar calendar, int day) async {
    final date = calendar.dateOf(day);
    final dateLabel = '${date.month}월 ${date.day}일';
    final confirmed = await showPastDateMealWarning(context, dateLabel);
    if (confirmed != true || !mounted) return;

    final records = ref.read(dietRecordRepositoryProvider);
    if (records.get(day) == null) {
      await records.save(day, DietRecord(date: Jst.isoDate(date)));
    }
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PastDateMealSelectionScreen(dayIdx: day, dateStr: dateLabel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calendar = ref.watch(challengeCalendarProvider);
    final today = ref.watch(currentDayProvider);
    if (calendar == null || today == null) return const SizedBox.shrink();
    final week = ChallengeCalendar.weekOf(today);
    final startDate = ref.watch(settingsProvider)!.startDate;
    final records = ref.watch(dietRecordsProvider).valueOrNull ?? const {};

    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          // Tab content
          Positioned.fill(
            child: IndexedStack(
              index: _currentTab,
              children: [
                TodayTab(key: ValueKey('today_$today')),
                CalendarTab(
                  key: ValueKey('calendar_$today'),
                  startDate: startDate,
                  todayIdx: today,
                  records: records,
                  onDateTap: (day) => _openPastDay(calendar, day),
                ),
                DietTab(
                  key: ValueKey('diet_$today'),
                  week: week,
                  todayIdx: today,
                ),
                MyTab(key: ValueKey('my_$today'), startDate: startDate),
              ],
            ),
          ),

          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: kBorder)),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavButton(0, Icons.home, '오늘'),
                    _buildNavButton(1, Icons.calendar_today, '캘린더'),
                    _buildNavButton(2, Icons.restaurant_menu, '식단'),
                    _buildNavButton(3, Icons.person, '마이'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;

    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? kPrimaryMint.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? kEmeraldText : kMidSlate,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? kDarkSlate : kMidSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
