import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/app_settings.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/daily_analysis_service.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';
import 'package:switchon_diet/services/weekly_analysis_service.dart';
import 'package:switchon_diet/screens/tabs/calendar_tab.dart';
import 'package:switchon_diet/screens/tabs/today_tab.dart';
import 'package:switchon_diet/screens/tabs/diet_tab.dart';
import 'package:switchon_diet/screens/tabs/my_tab.dart';
import 'package:switchon_diet/screens/weekly_feedback_screen.dart';
import 'package:switchon_diet/screens/dialogs/meal_dialogs.dart';
import 'package:switchon_diet/screens/past_date_meal_selection_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _currentTab = 0; // Default to today tab
  late AppSettings _settings;
  Map<int, DietRecord> _records = {};
  int _todayIdx = 1;
  int _week = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Reload data when app resumes from background
    if (state == AppLifecycleState.resumed) {
      debugPrint('App resumed - reloading data from Hive');
      _loadData();
    } else if (state == AppLifecycleState.paused) {
      debugPrint('App paused - data should be saved in Hive');
    }
  }

  void _checkWeeklyAnalysis() async {
    if (_settings.startDate.isNotEmpty) {
      await WeeklyAnalysisService.checkAndGenerateWeeklySummary(
        startDate: _settings.startDate,
      );
    }
  }

  void _checkDailyAnalysis() async {
    if (_settings.startDate.isNotEmpty) {
      await DailyAnalysisService.checkAndGenerateDailyFeedback(
        startDate: _settings.startDate,
      );
    }
  }

  void _loadData() {
    debugPrint('[_loadData] Starting data load...');
    final settings = StorageService.getSettings();
    if (settings == null) {
      debugPrint('[_loadData] No settings found');
      return;
    }

    _settings = settings;

    // Check for weekly and daily analysis after settings are loaded
    _checkWeeklyAnalysis();
    _checkDailyAnalysis();

    // Calculate today's day index
    final startDate = DateTime.parse(_settings.startDate);
    final now = JstService.now();
    final diff = now.difference(startDate).inDays + 1;
    _todayIdx = diff.clamp(1, 28);
    _week = ((_todayIdx - 1) ~/ 7 + 1).clamp(1, 4);

    debugPrint('[_loadData] Today is day $_todayIdx, week $_week');

    // Load records
    _records = StorageService.getAllRecords();
    debugPrint('[_loadData] Loaded ${_records.length} records');
    debugPrint(
      '[_loadData] Today\'s record exists: ${_records[_todayIdx] != null}',
    );
    if (_records[_todayIdx] != null) {
      debugPrint(
        '[_loadData] Today\'s wakeTime: ${_records[_todayIdx]!.wakeTime}',
      );
    }

    setState(() {});
  }

  void _handleEnterWeekly() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WeeklyFeedbackScreen(startDate: _settings.startDate, week: _week),
      ),
    );
  }

  void _handleDateTap(int dayIdx) async {
    // Show past date meal input dialog
    await _showPastDateMealDialog(dayIdx);
  }

  Future<void> _showPastDateMealDialog(int dayIdx) async {
    final startDateTime = DateTime.parse(_settings.startDate);
    final dateObj = startDateTime.add(Duration(days: dayIdx - 1));
    final dateStr = '${dateObj.month}월 ${dateObj.day}일';

    final result = await showPastDateMealWarning(context, dateStr);

    if (result != true) return;
    if (!mounted) return;

    // Create record if it doesn't exist
    var record = _records[dayIdx];
    if (record == null) {
      record = DietRecord(
        date:
            '${dateObj.year}-${dateObj.month.toString().padLeft(2, '0')}-${dateObj.day.toString().padLeft(2, '0')}',
        meals: [],
      );
      await StorageService.saveRecord(record, dayIdx);
      _loadData();
    }

    if (!mounted) return;

    // Navigate to past date meal selection screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PastDateMealSelectionScreen(dayIdx: dayIdx, dateStr: dateStr),
      ),
    );

    // Reload data after returning from the screen
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Stack(
        children: [
          // Tab content
          Positioned.fill(
            child: IndexedStack(
              index: _currentTab,
              children: [
                TodayTab(
                  key: ValueKey('today_$_todayIdx'),
                  onDataChanged: _loadData,
                ),
                CalendarTab(
                  key: ValueKey('calendar_${_todayIdx}_${_records.length}'),
                  startDate: _settings.startDate,
                  todayIdx: _todayIdx,
                  records: _records,
                  onDateTap: _handleDateTap,
                ),
                DietTab(
                  key: ValueKey('diet_$_todayIdx'),
                  week: _week,
                  todayIdx: _todayIdx,
                ),
                MyTab(
                  key: ValueKey('my_$_todayIdx'),
                  startDate: _settings.startDate,
                  onEnterWeekly: _handleEnterWeekly,
                ),
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
                border: const Border(top: BorderSide(color: kBorder, width: 1)),
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
