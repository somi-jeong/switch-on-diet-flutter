import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/coach_greeting.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_state.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';

/// Pause before the greeting appears, as if the coach were reading the
/// records; overridden in tests.
final coachGreetingDelayProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 1500),
);

final coachChatViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<CoachChatViewModel, CoachChatState, CoachThread>(
      CoachChatViewModel.new,
    );

/// Loads a conversation, sends messages and composes the opening greeting.
class CoachChatViewModel
    extends AutoDisposeFamilyAsyncNotifier<CoachChatState, CoachThread> {
  @override
  Future<CoachChatState> build(CoachThread thread) async {
    final chats = ref.watch(chatRepositoryProvider);
    final messages = await chats.history(thread.date);
    final daySummary = await chats.daySummary(thread.date);

    if (thread.greet) {
      final timer = Timer(ref.read(coachGreetingDelayProvider), _greet);
      ref.onDispose(timer.cancel);
    }
    return CoachChatState(messages: messages, daySummary: daySummary);
  }

  CoachChatState get _current => state.requireValue;

  /// Sends [text] to the coach.
  ///
  /// When the request fails for a reason the user can retry (network, rate
  /// limit, server), the message is withdrawn from the thread and the
  /// failure is returned so the view can offer to send it again.
  Future<AiFailure?> send(String text) async {
    final message = text.trim();
    if (message.isEmpty || _current.isSending) return null;

    final history = _current.messages;
    final userMessage = _message(ChatRole.user, message);
    state = AsyncData(
      _current.copyWith(messages: [...history, userMessage], isSending: true),
    );

    final chats = ref.read(chatRepositoryProvider);
    try {
      final reply = await ref
          .read(sendCoachMessageProvider)
          .call(day: arg.day, message: message, history: history);
      final replyMessage = _message(ChatRole.assistant, reply.text);
      await chats.append(arg.date, userMessage);
      await chats.append(arg.date, replyMessage);
      _setMessages([..._current.messages, replyMessage]);
      return null;
    } on MissingApiKeyFailure {
      await chats.append(arg.date, userMessage);
      _setMessages([
        ..._current.messages,
        _message(ChatRole.assistant, '죄송해요, 예기치 않은 오류가 발생했어요. 다시 시도해주세요.'),
      ]);
      return null;
    } on AiFailure catch (failure) {
      _setMessages([..._current.messages]..remove(userMessage));
      return failure;
    }
  }

  /// Adds a message from the coach that is shown but not stored.
  void addNotice(String text) => state = AsyncData(
    _current.copyWith(
      messages: [..._current.messages, _message(ChatRole.assistant, text)],
    ),
  );

  Future<void> _greet() async {
    if (!state.hasValue || _current.messages.isNotEmpty) return;
    final greeting = _message(
      ChatRole.assistant,
      CoachGreeting.compose(
        day: arg.day,
        records: ref.read(dietRecordRepositoryProvider).getAll(),
        now: ref.read(clockProvider).now(),
      ),
    );
    state = AsyncData(_current.copyWith(messages: [greeting]));
    await ref.read(chatRepositoryProvider).append(arg.date, greeting);
  }

  void _setMessages(List<ChatMessage> messages) => state = AsyncData(
    _current.copyWith(messages: messages, isSending: false),
  );

  ChatMessage _message(ChatRole role, String text) => ChatMessage(
    role: role,
    text: text,
    timestamp: ref.read(clockProvider).now().toIso8601String(),
  );
}
