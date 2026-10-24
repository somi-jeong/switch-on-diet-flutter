import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_state.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  const thread = CoachThread(date: '2026-03-01', day: 1, greet: true);

  late InMemoryChatRepository chats;
  late FakeAiCoachRepository coach;
  late ProviderContainer container;

  setUp(() {
    chats = InMemoryChatRepository();
    coach = FakeAiCoachRepository();
    container = createContainer(
      records: InMemoryDietRecordRepository(),
      clock: FixedClock(DateTime(2026, 3, 1, 9)),
      coach: coach,
      chats: chats,
      overrides: [coachGreetingDelayProvider.overrideWithValue(Duration.zero)],
    );
    container.listen(coachChatViewModelProvider(thread), (_, _) {});
  });

  Future<CoachChatState> chat() =>
      container.read(coachChatViewModelProvider(thread).future);

  CoachChatViewModel viewModel() =>
      container.read(coachChatViewModelProvider(thread).notifier);

  Future<void> greeted() async {
    await chat();
    await Future<void>.delayed(Duration.zero);
  }

  test('greets an empty thread and stores the greeting', () async {
    expect((await chat()).messages, isEmpty);

    await greeted();

    final state = await chat();
    expect(state.messages.single.role, ChatRole.assistant);
    expect(chats.threads['2026-03-01'], state.messages);
  });

  test('a successful send stores the question and the reply', () async {
    coach.chatReply = const CoachReply(text: '물은 2L 이상이요.');
    await greeted();

    final failure = await viewModel().send('물 얼마나 마셔요?');

    expect(failure, isNull);
    final texts = (await chat()).messages.map((m) => m.text).toList();
    expect(texts.skip(1), ['물 얼마나 마셔요?', '물은 2L 이상이요.']);
    expect(
      chats.threads['2026-03-01']!.map((m) => m.text).skip(1),
      texts.skip(1),
    );
    expect(coach.replyCalls.single.history, hasLength(1));
  });

  test('a retryable failure withdraws the message and is returned', () async {
    coach.failure = const RateLimitFailure(statusCode: 429);
    await greeted();

    final failure = await viewModel().send('안녕하세요');

    expect(failure, isA<RateLimitFailure>());
    final state = await chat();
    expect(state.messages, hasLength(1));
    expect(state.isSending, isFalse);
    expect(chats.threads['2026-03-01'], hasLength(1));
  });
}
