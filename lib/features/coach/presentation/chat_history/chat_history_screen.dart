import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/coach/presentation/chat_detail/chat_detail_screen.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/chat_history_view_model.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/history_item.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/widgets/chat_history_header.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/widgets/chat_history_list.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/widgets/chat_history_search_bar.dart';

class ChatHistoryScreen extends ConsumerWidget {
  const ChatHistoryScreen({super.key});

  void _openConversation(BuildContext context, HistoryItem item, int today) {
    if (!item.hasConversation) return;
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChatDetailScreen(
          day: item.dayIdx,
          date: item.chatDate,
          isToday: item.dayIdx == today,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(chatHistoryViewModelProvider).valueOrNull;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            const ChatHistoryHeader(),
            ChatHistorySearchBar(
              onSearchChanged: (query) =>
                  ref.read(chatHistoryViewModelProvider.notifier).search(query),
            ),
            Expanded(
              child: history == null
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryMint),
                    )
                  : ChatHistoryList(
                      items: history.visibleItems,
                      onItemTap: (item) =>
                          _openConversation(context, item, history.today),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
