import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

part 'coach_chat_state.freezed.dart';

/// A conversation with the coach for one date.
@freezed
class CoachThread with _$CoachThread {
  const factory CoachThread({
    /// `yyyy-MM-dd`, the key the conversation is stored under.
    required String date,
    required int day,

    /// Open an empty thread with a locally composed greeting.
    @Default(false) bool greet,
  }) = _CoachThread;
}

@freezed
class CoachChatState with _$CoachChatState {
  const factory CoachChatState({
    required List<ChatMessage> messages,
    String? daySummary,
    @Default(false) bool isSending,
  }) = _CoachChatState;
}
