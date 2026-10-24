import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/chat_history_view_model.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/history_item.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';

import '../../../helpers/fakes.dart';

void main() {
  test(
    'lists week cards and daily reviews newest first, and filters them',
    () async {
      final chats = InMemoryChatRepository();
      await chats.append(
        '2026-03-06',
        const ChatMessage(role: ChatRole.user, text: '안녕', timestamp: ''),
      );
      final container = createContainer(
        records: InMemoryDietRecordRepository({
          6: const DietRecord(
            date: '2026-03-06',
            aiFeedback: '물을 더 드세요',
            warningCount: 1,
          ),
          8: const DietRecord(date: '2026-03-08', aiFeedback: '좋은 하루였어요'),
        }),
        clock: FixedClock(DateTime(2026, 3, 8, 20)),
        chats: chats,
      );
      container.listen(chatHistoryViewModelProvider, (_, _) {});

      final state = await container.read(chatHistoryViewModelProvider.future);

      expect(state.items.map((i) => (i.kind, i.dayIdx)), [
        (HistoryKind.daily, 8),
        (HistoryKind.weekly, 7),
        (HistoryKind.daily, 6),
      ]);
      final day6 = state.items.last;
      expect(day6.date, '2026.03.06');
      expect(day6.tags, ['주의필요', '경고1회']);
      expect(day6.hasConversation, isTrue);

      container.read(chatHistoryViewModelProvider.notifier).search('물을');
      final filtered = container
          .read(chatHistoryViewModelProvider)
          .requireValue;
      expect(filtered.visibleItems.single.dayIdx, 6);
    },
  );
}
