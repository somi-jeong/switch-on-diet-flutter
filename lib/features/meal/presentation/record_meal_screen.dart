import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/meal/domain/usecases/record_meal.dart';
import 'package:switchon_diet/features/meal/meal_providers.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/error_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/dialogs/loading_dialog.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/ai_coach_message_card.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/food_text_input.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/meal_time_input.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/record_meal_actions.dart';
import 'package:switchon_diet/features/meal/presentation/widgets/record_meal_header.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

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
        final now = ref.read(clockProvider).now();
        _hour = now.hour;
        _minute = widget.isPastDate ? 0 : now.minute;
      }
    } else {
      final now = ref.read(clockProvider).now();
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

    final date = ref.read(challengeCalendarProvider)!.dateOf(widget.day);
    final eatenAt = DateTime(date.year, date.month, date.day, _hour, _minute);

    showLoadingDialog(context, 'AI가 식사를 분석 중이에요...');
    try {
      final analysis = await ref
          .read(recordMealProvider)
          .call(
            day: widget.day,
            label: widget.mealType,
            foodText: _textController.text.trim(),
            eatenAt: eatenAt,
            lateReason: widget.existingMeal?.lateReason,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      _showVerdict(analysis.verdict, analysis.feedback);
      widget.onBack();
    } on MealSlotNotFound {
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onBack();
    } on AiFailure catch (failure) {
      if (!mounted) return;
      Navigator.of(context).pop();
      final (title, message) = _analysisErrorText(failure);
      await showErrorDialog(context, title, message);
      widget.onBack();
    }
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

  (String, String) _analysisErrorText(AiFailure failure) => switch (failure) {
    RateLimitFailure() => (
      'AI 분석 한도 초과',
      '오늘 AI 분석 가능 횟수를 모두 사용했어요.\n\n식사 기록은 정상적으로 저장되었으니 걱정하지 마세요!\n\n내일 다시 AI 분석을 이용하실 수 있습니다.',
    ),
    UnexpectedAiFailure(statusCode: 404) => (
      'AI 서비스 오류',
      'AI 서비스에 일시적인 문제가 발생했어요.\n\n식사 기록은 정상적으로 저장되었습니다.',
    ),
    _ => ('AI 분석 실패', '식사 기록은 저장되었지만, AI 분석에 실패했어요.'),
  };

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

    final records = ref.read(dietRecordRepositoryProvider);
    final record = records.get(widget.day);
    if (record == null) return;
    await records.save(
      widget.day,
      record.updateMeal(widget.mealType, (meal) => meal.cleared()),
    );

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
