import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/diet_data.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/screens/dialogs/meal_dialogs.dart';
import 'package:switchon_diet/screens/record_meal/widgets/ai_coach_message_card.dart';
import 'package:switchon_diet/screens/record_meal/widgets/food_text_input.dart';
import 'package:switchon_diet/screens/record_meal/widgets/meal_time_input.dart';
import 'package:switchon_diet/screens/record_meal/widgets/record_meal_actions.dart';
import 'package:switchon_diet/screens/record_meal/widgets/record_meal_header.dart';
import 'package:switchon_diet/services/claude_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class RecordMealScreen extends StatefulWidget {
  final String mealType; // '아침', '점심', '간식', '저녁'
  final VoidCallback onBack;
  final int? todayIdx; // 오늘 인덱스 (optional for existing records)
  final MealRecord? existingMeal; // 수정할 기존 식사 (optional)
  final bool isPastDate; // 과거 날짜 여부 (시간만 입력)

  const RecordMealScreen({
    super.key,
    required this.mealType,
    required this.onBack,
    this.todayIdx,
    this.existingMeal,
    this.isPastDate = false,
  });

  @override
  State<RecordMealScreen> createState() => _RecordMealScreenState();
}

class _RecordMealScreenState extends State<RecordMealScreen> {
  final _textController = TextEditingController();
  late TextEditingController _timeController;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();

    // 기존 식사 수정인 경우 데이터 복원
    if (widget.existingMeal != null) {
      final meal = widget.existingMeal!;
      _textController.text = meal.foodText ?? '';

      if (meal.eatenAt != null) {
        final eatenTime = Jst.parse(meal.eatenAt!);
        _hour = eatenTime.hour;
        _minute = widget.isPastDate ? 0 : eatenTime.minute;
      } else {
        final now = const JstClock().now();
        _hour = now.hour;
        _minute = widget.isPastDate ? 0 : now.minute;
      }
    } else {
      final now = const JstClock().now();
      _hour = now.hour;
      _minute = widget.isPastDate ? 0 : now.minute;
    }

    _timeController = TextEditingController(
      text: widget.isPastDate
          ? '${_hour.toString().padLeft(2, '0')}:00'
          : '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _onTimeChanged(String value) {
    final parts = value.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null && h >= 0 && h < 24 && m >= 0 && m < 60) {
        setState(() {
          _hour = h;
          _minute = widget.isPastDate ? 0 : m;
        });
      }
    }
  }

  Future<void> _handleSave() async {
    if (_textController.text.isEmpty) return;
    if (widget.todayIdx == null) {
      debugPrint('[RecordMeal] Error: todayIdx is null');
      return;
    }

    final foodText = _textController.text.trim();
    final mealTime = DateTime(
      const JstClock().now().year,
      const JstClock().now().month,
      const JstClock().now().day,
      _hour,
      _minute,
    );

    debugPrint(
      '[RecordMeal] Saving ${widget.mealType} at ${mealTime.toIso8601String()}',
    );
    debugPrint('[RecordMeal] Food text: $foodText');

    // Show loading dialog
    if (!mounted) return;
    showLoadingDialog(context, 'AI가 식사를 분석 중이에요...');

    try {
      // Get current record
      final todayIdx = widget.todayIdx!;
      final record = StorageService.getRecord(todayIdx);
      if (record == null) {
        debugPrint('[RecordMeal] No record found for day $todayIdx');
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading
        widget.onBack();
        return;
      }

      // Find meal by label
      final mealIndex = record.meals.indexWhere(
        (m) => m.label == widget.mealType,
      );
      if (mealIndex == -1) {
        debugPrint('[RecordMeal] Meal ${widget.mealType} not found');
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading
        widget.onBack();
        return;
      }

      final meal = record.meals[mealIndex];

      // Update meal record
      meal.foodText = foodText;
      meal.eatenAt = mealTime.toIso8601String();
      meal.recordedAt = const JstClock().now().toIso8601String();
      meal.checked = true;
      meal.skipped = false;

      // Save first (before AI call)
      await StorageService.saveRecord(record, todayIdx);

      // Calculate week and get allowed/forbidden foods
      final settings = StorageService.getSettings();
      if (settings == null) {
        debugPrint('[RecordMeal] No settings found');
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading
        widget.onBack();
        return;
      }

      final startDate = DateTime.parse(settings.startDate);
      final now = const JstClock().now();
      final daysSinceStart = now.difference(startDate).inDays + 1;
      final week = ((daysSinceStart - 1) ~/ 7 + 1).clamp(1, 4);

      final weekAllowedKey = week <= 1
          ? (todayIdx <= 3 ? '1-1' : '1-2')
          : week.toString();
      final allowed = weekAllowedMap[weekAllowedKey] ?? weekAllowedMap['1-2']!;
      final forbidden =
          weekForbiddenMap[weekAllowedKey] ?? weekForbiddenMap['1-2']!;

      // Call AI analysis
      final claude = ClaudeService();
      final analysisResult = await claude.analyzeFoodText(
        foodText: foodText,
        week: week,
        day: todayIdx,
        allowedFoods: allowed,
        forbiddenFoods: forbidden,
      );

      // Save AI feedback
      meal.aiStatus = analysisResult['status'] as String?;
      meal.aiFeedback = analysisResult['feedback'] as String?;

      await StorageService.saveRecord(record, todayIdx);

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading

      // Show AI feedback
      final status = meal.aiStatus ?? 'ALLOWED';
      final feedback = meal.aiFeedback ?? '분석 완료!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(
                status == 'ALLOWED'
                    ? '✅'
                    : status == 'WARNING'
                    ? '⚠️'
                    : '❌',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(feedback)),
            ],
          ),
          backgroundColor: status == 'ALLOWED'
              ? Colors.green
              : status == 'WARNING'
              ? Colors.orange
              : Colors.red,
        ),
      );

      debugPrint('[RecordMeal] Saved with AI status: $status');
      widget.onBack();
    } catch (e) {
      debugPrint('[RecordMeal] Error: $e');
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading

      // Show error dialog
      String errorTitle = 'AI 분석 실패';
      String errorMessage = '식사 기록은 저장되었지만, AI 분석에 실패했어요.';

      if (e.toString().contains('RESOURCE_EXHAUSTED') ||
          e.toString().contains('Quota exceeded') ||
          e.toString().contains('429')) {
        errorTitle = 'AI 분석 한도 초과';
        errorMessage =
            '오늘 AI 분석 가능 횟수를 모두 사용했어요.\n\n식사 기록은 정상적으로 저장되었으니 걱정하지 마세요!\n\n내일 다시 AI 분석을 이용하실 수 있습니다.';
      } else if (e.toString().contains('404') ||
          e.toString().contains('not found')) {
        errorTitle = 'AI 서비스 오류';
        errorMessage = 'AI 서비스에 일시적인 문제가 발생했어요.\n\n식사 기록은 정상적으로 저장되었습니다.';
      }

      await showErrorDialog(context, errorTitle, errorMessage);
      widget.onBack();
    }
  }

  Future<void> _handleDelete() async {
    if (widget.todayIdx == null || widget.existingMeal == null) {
      // 새로운 기록인 경우 그냥 닫기
      widget.onBack();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          '기록을 삭제할까요?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kDarkSlate,
          ),
        ),
        content: const Text(
          '삭제된 기록은 복구할 수 없습니다.',
          style: TextStyle(fontSize: 14, color: kMidSlate),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kMidSlate,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: kRose500),
            child: const Text(
              '삭제',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Delete meal record
    final todayIdx = widget.todayIdx!;
    final record = StorageService.getRecord(todayIdx);
    if (record == null) return;

    final mealIndex = record.meals.indexWhere(
      (m) => m.label == widget.mealType,
    );
    if (mealIndex == -1) return;

    // Reset meal to unchecked state
    final meal = record.meals[mealIndex];
    meal.checked = false;
    meal.skipped = false;
    meal.foodText = null;
    meal.eatenAt = null;
    meal.recordedAt = null;
    meal.photoPath = null;
    meal.photoTimestamp = null;
    meal.aiStatus = null;
    meal.aiFeedback = null;
    meal.skipReason = null;
    meal.lateReason = null;

    await StorageService.saveRecord(record, todayIdx);
    debugPrint('[RecordMeal] Deleted meal record for ${widget.mealType}');

    if (!mounted) return;
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _textController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            RecordMealHeader(onBack: widget.onBack),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AiCoachMessageCard(mealType: widget.mealType),
                    const SizedBox(height: 24),
                    MealTimeInput(
                      controller: _timeController,
                      onChanged: _onTimeChanged,
                      isPastDate: widget.isPastDate,
                    ),
                    const SizedBox(height: 24),
                    FoodTextInput(
                      controller: _textController,
                      onChanged: () => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
            RecordMealActions(
              canSave: canSave,
              onSave: _handleSave,
              onDelete: _handleDelete,
            ),
          ],
        ),
      ),
    );
  }
}
