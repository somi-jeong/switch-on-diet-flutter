import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/error_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/loading_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_state.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_view_model.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/ai_coach_message_card.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/food_text_input.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/meal_time_input.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/record_meal_actions.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/record_meal_header.dart';

class RecordMealScreen extends ConsumerStatefulWidget {
  final String mealType; // '아침', '점심', '간식', '저녁'
  final VoidCallback onBack;
  final int day;
  final MealRecord? existingMeal; // 수정할 기존 식사 (optional)
  final bool isPastDate; // 과거 날짜 여부 (시간만 입력)

  const RecordMealScreen({
    super.key,
    required this.mealType,
    required this.onBack,
    required this.day,
    this.existingMeal,
    this.isPastDate = false,
  });

  @override
  ConsumerState<RecordMealScreen> createState() => _RecordMealScreenState();
}

class _RecordMealScreenState extends ConsumerState<RecordMealScreen> {
  late final RecordMealTarget _target = RecordMealTarget(
    day: widget.day,
    mealType: widget.mealType,
    existingMeal: widget.existingMeal,
    isPastDate: widget.isPastDate,
  );
  late final TextEditingController _textController;
  late final TextEditingController _timeController;

  RecordMealViewModel get _viewModel =>
      ref.read(recordMealViewModelProvider(_target).notifier);

  @override
  void initState() {
    super.initState();
    final initial = ref.read(recordMealViewModelProvider(_target));
    _textController = TextEditingController(text: initial.foodText);
    _timeController = TextEditingController(text: initial.timeText);
  }

  @override
  void dispose() {
    _textController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    showLoadingDialog(context, 'AI가 식사를 분석 중이에요...');
    final outcome = await _viewModel.save();
    if (!mounted) return;
    Navigator.of(context).pop();

    switch (outcome) {
      case MealAnalyzed(:final analysis):
        _showVerdict(analysis.verdict, analysis.feedback);
      case MealAnalysisFailed(:final title, :final message):
        await showErrorDialog(context, title, message);
      case MealNotFound():
        break;
    }
    widget.onBack();
  }

  void _showVerdict(MealVerdict verdict, String feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(switch (verdict) {
              MealVerdict.allowed => '✅',
              MealVerdict.warning => '⚠️',
              MealVerdict.forbidden => '❌',
            }, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(feedback)),
          ],
        ),
        backgroundColor: switch (verdict) {
          MealVerdict.allowed => Colors.green,
          MealVerdict.warning => Colors.orange,
          MealVerdict.forbidden => Colors.red,
        },
      ),
    );
  }

  Future<void> _handleDelete() async {
    if (widget.existingMeal == null) {
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

    await _viewModel.delete();
    if (mounted) widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = ref.watch(
      recordMealViewModelProvider(_target).select((s) => s.canSave),
    );

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
                      onChanged: (text) => _viewModel.setTime(text),
                      isPastDate: widget.isPastDate,
                    ),
                    const SizedBox(height: 24),
                    FoodTextInput(
                      controller: _textController,
                      onChanged: () =>
                          _viewModel.setFoodText(_textController.text),
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
