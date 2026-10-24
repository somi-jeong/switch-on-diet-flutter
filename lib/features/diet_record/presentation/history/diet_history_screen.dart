import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/presentation/history/widgets/diet_history_day_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/past_day/past_date_meal_selection_screen.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

class DietHistoryScreen extends ConsumerStatefulWidget {
  final String startDate;
  final int todayIdx;
  final int? initialSelectedDay;

  const DietHistoryScreen({
    super.key,
    required this.startDate,
    required this.todayIdx,
    this.initialSelectedDay,
  });

  @override
  ConsumerState<DietHistoryScreen> createState() => _DietHistoryScreenState();
}

class _DietHistoryScreenState extends ConsumerState<DietHistoryScreen> {
  List<_DayHistory> _history = [];
  bool _loading = true;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    final records = ref.read(dietRecordRepositoryProvider).getAll();
    final history = <_DayHistory>[];

    // Show ALL days from 1 to todayIdx, even if no record exists
    for (int i = widget.todayIdx; i >= 1; i--) {
      final record = records[i] ?? DietRecord(date: _getDateForDay(i));

      final date = _getDateForDay(i);
      history.add(_DayHistory(dayIdx: i, date: date, record: record));
    }

    setState(() {
      _history = history;
      _loading = false;
    });

    // Scroll to initial selected day if specified
    if (widget.initialSelectedDay != null && _history.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToDay(widget.initialSelectedDay!);
      });
    }
  }

  void _scrollToDay(int dayIdx) {
    final index = _history.indexWhere((h) => h.dayIdx == dayIdx);
    if (index != -1 && _scrollController.hasClients) {
      // Calculate more accurate position based on card index
      // Average card height is ~450-500px, use conservative estimate
      final position = index * 476.0; // card height (452) + margin (24)

      // Ensure we don't scroll past the end
      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetScroll = position > maxScroll ? maxScroll : position;

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _getDateForDay(int dayIdx) {
    final start = DateTime.parse(widget.startDate);
    final target = start.add(Duration(days: dayIdx - 1));
    final weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final wd = weekdays[target.weekday - 1];
    return '${target.year}.${target.month.toString().padLeft(2, '0')}.${target.day.toString().padLeft(2, '0')} ($wd)';
  }

  String _getFastingDuration(DietRecord record) {
    if (record.wakeTime == null) return '--';

    try {
      // Find last checked meal
      final checkedMeals = record.meals
          .where((m) => m.checked && m.eatenAt != null)
          .toList();

      if (checkedMeals.isEmpty) return '--';

      // Get the last meal's eatenAt time
      final lastMeal = checkedMeals.last;
      final lastMealTime = Jst.parse(lastMeal.eatenAt!);
      final wakeTime = Jst.parse(record.wakeTime!);

      var duration = wakeTime.difference(lastMealTime);

      // If wake time is before last meal time, add 24 hours
      if (duration.isNegative) {
        duration = duration + const Duration(hours: 24);
      }

      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return '--';
    }
  }

  String _getSleepDuration(DietRecord record) {
    if (record.bedTime == null || record.wakeTime == null) return '--';
    try {
      final bedTime = Jst.parse(record.bedTime!);
      final wakeTime = Jst.parse(record.wakeTime!);
      var duration = wakeTime.difference(bedTime);

      // If wake time is before bed time, add 24 hours
      if (duration.isNegative) {
        duration = duration + const Duration(hours: 24);
      }

      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } catch (e) {
      return '--';
    }
  }

  int _getWeek(int dayIdx) {
    return ChallengeCalendar.weekOf(dayIdx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '식단 및 수면 기록',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final dayHistory = _history[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PastDateMealSelectionScreen(
                                      dayIdx: dayHistory.dayIdx,
                                      dateStr: dayHistory.date,
                                    ),
                              ),
                            );
                            // Reload history after returning
                            await _loadHistory();
                          },
                          child: DietHistoryDayCard(
                            dayIdx: dayHistory.dayIdx,
                            date: dayHistory.date,
                            record: dayHistory.record,
                            getWeek: _getWeek,
                            getFastingDuration: _getFastingDuration,
                            getSleepDuration: _getSleepDuration,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHistory {
  final int dayIdx;
  final String date;
  final DietRecord record;

  _DayHistory({required this.dayIdx, required this.date, required this.record});
}
