import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/meal/domain/usecases/record_meal.dart';
import 'package:switchon_diet/features/meal/meal_providers.dart';
import 'package:switchon_diet/features/meal/presentation/record_meal_state.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

final recordMealViewModelProvider = NotifierProvider.autoDispose
    .family<RecordMealViewModel, RecordMealState, RecordMealTarget>(
      RecordMealViewModel.new,
    );

class RecordMealViewModel
    extends AutoDisposeFamilyNotifier<RecordMealState, RecordMealTarget> {
  @override
  RecordMealState build(RecordMealTarget target) {
    final meal = target.existingMeal;
    final time = meal?.eatenAt != null
        ? Jst.parse(meal!.eatenAt!)
        : ref.read(clockProvider).now();
    return RecordMealState(
      foodText: meal?.foodText ?? '',
      hour: time.hour,
      minute: target.isPastDate ? 0 : time.minute,
    );
  }

  void setFoodText(String text) => state = state.copyWith(foodText: text);

  /// Accepts `HH:mm`; anything else is ignored until it becomes valid.
  void setTime(String text) {
    final parts = text.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return;
    state = state.copyWith(hour: hour, minute: arg.isPastDate ? 0 : minute);
  }

  Future<RecordMealOutcome> save() async {
    final date = ref.read(challengeCalendarProvider)!.dateOf(arg.day);
    state = state.copyWith(isSaving: true);
    try {
      final analysis = await ref
          .read(recordMealProvider)
          .call(
            day: arg.day,
            label: arg.mealType,
            foodText: state.foodText.trim(),
            eatenAt: DateTime(
              date.year,
              date.month,
              date.day,
              state.hour,
              state.minute,
            ),
            lateReason: arg.existingMeal?.lateReason,
          );
      return RecordMealOutcome.analyzed(analysis);
    } on MealSlotNotFound {
      return const RecordMealOutcome.notFound();
    } on AiFailure catch (failure) {
      return _analysisFailed(failure);
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  /// Clears everything entered for this meal.
  Future<void> delete() async {
    final records = ref.read(dietRecordRepositoryProvider);
    final record = records.get(arg.day);
    if (record == null) return;
    await records.save(
      arg.day,
      record.updateMeal(arg.mealType, (meal) => meal.cleared()),
    );
  }

  static RecordMealOutcome _analysisFailed(AiFailure failure) =>
      switch (failure) {
        RateLimitFailure() => const RecordMealOutcome.analysisFailed(
          title: 'AI 분석 한도 초과',
          message:
              '오늘 AI 분석 가능 횟수를 모두 사용했어요.\n\n'
              '식사 기록은 정상적으로 저장되었으니 걱정하지 마세요!\n\n'
              '내일 다시 AI 분석을 이용하실 수 있습니다.',
        ),
        UnexpectedAiFailure(statusCode: 404) =>
          const RecordMealOutcome.analysisFailed(
            title: 'AI 서비스 오류',
            message:
                'AI 서비스에 일시적인 문제가 발생했어요.\n\n'
                '식사 기록은 정상적으로 저장되었습니다.',
          ),
        _ => const RecordMealOutcome.analysisFailed(
          title: 'AI 분석 실패',
          message: '식사 기록은 저장되었지만, AI 분석에 실패했어요.',
        ),
      };
}
