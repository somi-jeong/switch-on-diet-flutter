import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_state.dart';
import 'package:switchon_diet/features/coach/presentation/chat/coach_chat_view_model.dart';
import 'package:switchon_diet/features/coach/presentation/coach_sheet/ai_coach_widgets.dart';
import 'package:switchon_diet/features/coach/presentation/widgets/api_error_dialog.dart';

/// Today's conversation with the coach, opened from the Today tab.
class AiCoachBottomSheet extends ConsumerStatefulWidget {
  final String todayDate;
  final int todayIdx;

  const AiCoachBottomSheet({
    super.key,
    required this.todayDate,
    required this.todayIdx,
  });

  @override
  ConsumerState<AiCoachBottomSheet> createState() => _AiCoachBottomSheetState();
}

class _AiCoachBottomSheetState extends ConsumerState<AiCoachBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final CoachThread _thread = CoachThread(
    date: widget.todayDate,
    day: widget.todayIdx,
    greet: true,
  );

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    _controller.clear();
    final failure = await ref
        .read(coachChatViewModelProvider(_thread).notifier)
        .send(text);
    if (failure == null || !mounted) return;

    await showApiErrorDialog(
      context,
      errorType: ApiErrorType.of(failure),
      errorMessage: failure.statusCode == null
          ? null
          : 'HTTP ${failure.statusCode}',
      onRetry: () => _send(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      coachChatViewModelProvider(
        _thread,
      ).select((chat) => chat.valueOrNull?.messages.length),
      (_, _) => _scrollToBottom(),
    );
    final chat = ref.watch(coachChatViewModelProvider(_thread)).valueOrNull;
    final messages = chat?.messages ?? const [];
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          // Top safe area spacer
          Container(height: topPadding, color: Colors.white),
          CoachSheetHeader(onClose: () => Navigator.pop(context)),
          Expanded(
            child: Container(
              color: kBgColor,
              child: chat == null
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryMint),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      itemCount: messages.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 24,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '오늘',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return CoachMessageBubble(message: messages[i - 1]);
                      },
                    ),
            ),
          ),
          CoachQuickQuestions(onSelected: _send),
          CoachInputBar(
            controller: _controller,
            sending: chat?.isSending ?? false,
            onSend: () => _send(_controller.text),
          ),
          // Bottom safe area spacer
          Container(height: bottomPadding, color: Colors.white),
        ],
      ),
    );
  }
}
