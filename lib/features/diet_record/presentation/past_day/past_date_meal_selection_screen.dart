import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_screen.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/services/storage_service.dart';

/// Screen for selecting which meal to record for a past date.
/// Allows users to navigate to RecordMealScreen for any meal in a past date's record.
class PastDateMealSelectionScreen extends StatefulWidget {
  final int dayIdx;
  final String dateStr; // Formatted date string like "3월 15일"

  const PastDateMealSelectionScreen({
    super.key,
    required this.dayIdx,
    required this.dateStr,
  });

  @override
  State<PastDateMealSelectionScreen> createState() =>
      _PastDateMealSelectionScreenState();
}

class _PastDateMealSelectionScreenState
    extends State<PastDateMealSelectionScreen> {
  DietRecord? _record;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    var record = StorageService.getRecord(widget.dayIdx);

    // If no record exists, create an empty one (don't save yet, just for display)
    record ??= DietRecord(
      date: widget.dateStr,
      meals: [], // Empty meals until wake time is entered
    );

    setState(() {
      _record = record;
      _loading = false;
    });
  }

  Future<void> _showWakeTimeDialog() async {
    final selectedHour = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      '몇 시에 일어나셨나요?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: kLightSlate,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: kMidSlate,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Time list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 24,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(index),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kPrimaryMint.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.wb_sunny,
                              size: 20,
                              color: kEmeraldText,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${index.toString().padLeft(2, '0')}:00',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: kDarkSlate,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: kMidSlate,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedHour != null && mounted) {
      // Create wake time with selected hour
      final now = const JstClock().now();
      final wakeTime = DateTime(now.year, now.month, now.day, selectedHour);
      final wakeTimeIso = wakeTime.toIso8601String();

      // Generate meals based on wake time (like today_tab does)
      final meals = <MealRecord>[];
      for (final slot in MealSchedule.slots) {
        final start = Jst.hourMinute(slot.startAfter(wakeTime));
        final end = Jst.hourMinute(slot.endAfter(wakeTime));
        meals.add(MealRecord(label: slot.label, guideText: '$start ~ $end 예정'));
      }

      // Create or update record
      final updatedRecord = DietRecord(
        date: _record!.date,
        wakeTime: wakeTimeIso,
        meals: meals,
      );

      await StorageService.saveRecord(updatedRecord, widget.dayIdx);
      await _loadRecord();
    }
  }

  Future<void> _navigateToRecordMeal(String mealType) async {
    if (_record == null) return;

    // Find the meal in the record
    final meal = _record!.meals.firstWhere(
      (m) => m.label == mealType,
      orElse: () => throw Exception('Meal $mealType not found'),
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecordMealScreen(
          mealType: mealType,
          todayIdx: widget.dayIdx,
          existingMeal: meal.checked ? meal : null,
          isPastDate: true, // Always true for PastDateMealSelectionScreen
          onBack: () {
            Navigator.of(context).pop();
            _loadRecord(); // Reload the record after returning
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: kDarkSlate),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.dateStr} 식사 입력',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkSlate,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: kBorder),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildMealSelectionView(),
    );
  }

  Widget _buildMealSelectionView() {
    if (_record!.wakeTime == null || _record!.wakeTime!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.wb_sunny,
                  size: 32,
                  color: Color(0xFFD97706),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '기상 시간을 입력하세요',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: kDarkSlate,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '식사를 입력하려면\n먼저 기상 시간을 등록해야 합니다.',
                style: TextStyle(fontSize: 14, color: kMidSlate, height: 1.5),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _showWakeTimeDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryMint,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  '기상 시간 입력',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_record!.meals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 64, color: kMidSlate),
              const SizedBox(height: 16),
              const Text(
                '식사 기록이 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kDarkSlate,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.dateStr}에는 등록된 식사가 없습니다.',
                style: const TextStyle(fontSize: 14, color: kMidSlate),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kPrimaryMint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kPrimaryMint.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: kPrimaryMint.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 18,
                    color: kEmeraldText,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '수정하거나 입력할 식사를 선택하세요',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kDarkSlate,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '식사 목록',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kDarkSlate,
            ),
          ),
          const SizedBox(height: 12),
          ...(_record!.meals.map(_buildMealCard)),
        ],
      ),
    );
  }

  Widget _buildMealCard(meal) {
    final isChecked = meal.checked;
    final isSkipped = meal.skipped;

    String statusText;
    Color statusColor;
    IconData statusIcon;

    if (isChecked) {
      statusText = '기록됨';
      statusColor = kPrimaryMint;
      statusIcon = Icons.check_circle;
    } else if (isSkipped) {
      statusText = '스킵됨';
      statusColor = kMidSlate;
      statusIcon = Icons.cancel;
    } else {
      statusText = '미기록';
      statusColor = kLightSlate;
      statusIcon = Icons.radio_button_unchecked;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _navigateToRecordMeal(meal.label),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: kBorder),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kDarkSlate,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 14,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isChecked && meal.foodText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          meal.foodText!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: kMidSlate,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: kMidSlate, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
