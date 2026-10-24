import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_state.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_view_model.dart';
import 'package:switchon_diet/features/coach/presentation/chat_detail/widgets/chat_detail_widgets.dart';

/// A past (or today's) conversation opened from the coach history.
class ChatDetailScreen extends ConsumerStatefulWidget {
  final int day;
  final String date; // "2026-03-13"
  final bool isToday;

  const ChatDetailScreen({
    super.key,
    required this.day,
    required this.date,
    required this.isToday,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  late final CoachThread _thread = CoachThread(
    date: widget.date,
    day: widget.day,
  );
  static const _suggestionChips = [
    '샐러드 드레싱은 아예 안되나요?',
    '치팅데이는 언제쯤 가능한가요?',
    '운동은 몇 시에 하는 게 좋나요?',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    _textController.clear();
    final viewModel = ref.read(coachChatViewModelProvider(_thread).notifier);
    final failure = await viewModel.send(text);
    if (failure == null || !mounted) return;

    // Give the text back so it can be sent again.
    _textController.text = text;
    viewModel.addNotice('죄송해요, 일시적인 오류가 발생했어요. 다시 시도해주세요.');
  }

  // 시간대별 구분선 (오전/오후)
  String? _dividerLabel(List<ChatMessage> messages, int index) {
    if (index == 0) return null;
    try {
      final prev = DateTime.parse(
        messages[index - 1].timestamp,
      ).toUtc().add(const Duration(hours: 9));
      final curr = DateTime.parse(
        messages[index].timestamp,
      ).toUtc().add(const Duration(hours: 9));
      if (curr.difference(prev).inMinutes > 30) {
        final h = curr.hour;
        final period = h < 12
            ? '오전'
            : h < 18
            ? '오후'
            : '저녁';
        return '$period ${curr.hour.toString().padLeft(2, '0')}:${curr.minute.toString().padLeft(2, '0')}';
      }
    } on FormatException {
      // No divider around messages with malformed timestamps.
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(coachChatViewModelProvider(_thread)).valueOrNull;
    final messages = chat?.messages ?? const <ChatMessage>[];
    final sending = chat?.isSending ?? false;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: Column(
        children: [
          ChatDetailHeader(
            day: widget.day,
            date: widget.date,
            messageCount: messages.length,
            isToday: widget.isToday,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              itemCount:
                  messages.length +
                  1 +
                  (sending ? 1 : 0), // +1 for summary, +1 for loading
              itemBuilder: (_, i) {
                if (i == 0) {
                  return DaySummaryCard(summary: chat?.daySummary);
                }

                // Show loading indicator at the end if sending
                if (sending && i == messages.length + 1) {
                  return const TypingBubble();
                }

                final idx = i - 1;
                final divider = _dividerLabel(messages, idx);
                final isLastAiMessage =
                    idx < messages.length &&
                    !messages[idx].isUser &&
                    (idx == messages.length - 1 || messages[idx + 1].isUser);

                return Column(
                  children: [
                    if (divider != null) TimeDivider(divider),
                    ChatBubble(message: messages[idx]),
                    // 제안 칩 버튼
                    if (isLastAiMessage && widget.isToday && !sending)
                      SuggestionChips(
                        suggestions: _suggestionChips,
                        onSelected: _sendMessage,
                      ),
                  ],
                );
              },
            ),
          ),
          // 실시간 채팅 입력창
          if (widget.isToday)
            ChatInputBar(
              textController: _textController,
              sending: sending,
              onSend: _sendMessage,
            ),
        ],
      ),
    );
  }
}
