import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_action.freezed.dart';

/// A record the coach asked to be saved while chatting, e.g. "I woke up at 7".
@freezed
sealed class CoachAction with _$CoachAction {
  /// [time] is `HH:mm` as written by the model.
  const factory CoachAction.wake({required String time}) = WakeAction;

  const factory CoachAction.meal({
    required String mealType,
    required String foods,
  }) = MealAction;

  const factory CoachAction.skip({required String mealType}) = SkipAction;

  /// [time] is `HH:mm` as written by the model.
  const factory CoachAction.sleep({required String time}) = SleepAction;
}

/// The coach's visible reply plus the actions embedded in it.
@freezed
class CoachReply with _$CoachReply {
  const factory CoachReply({
    required String text,
    @Default(<CoachAction>[]) List<CoachAction> actions,
  }) = _CoachReply;
}
