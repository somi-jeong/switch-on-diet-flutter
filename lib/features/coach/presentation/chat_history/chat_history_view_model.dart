import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/coach/presentation/chat_history/history_item.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

part 'chat_history_view_model.freezed.dart';

@freezed
class ChatHistoryState with _$ChatHistoryState {
  const factory ChatHistoryState({
    required int today,
    required List<HistoryItem> items,
    @Default('') String query,
  }) = _ChatHistoryState;

  const ChatHistoryState._();

  List<HistoryItem> get visibleItems {
    if (query.isEmpty) return items;
    final needle = query.toLowerCase();
    return items
        .where(
          (item) =>
              item.topic.toLowerCase().contains(needle) ||
              item.preview.toLowerCase().contains(needle),
        )
        .toList();
  }
}

final chatHistoryViewModelProvider =
    AsyncNotifierProvider.autoDispose<ChatHistoryViewModel, ChatHistoryState>(
      ChatHistoryViewModel.new,
    );

/// Daily reviews and week-end cards, newest first.
class ChatHistoryViewModel extends AutoDisposeAsyncNotifier<ChatHistoryState> {
  static final _cardDate = DateFormat('yyyy.MM.dd');
  static const _weekTitles = {1: '장 비우기', 2: '가속기', 3: '도약기', 4: '안정기'};

  @override
  Future<ChatHistoryState> build() async {
    final calendar = ref.watch(challengeCalendarProvider);
    final today = ref.watch(currentDayProvider);
    if (calendar == null || today == null) {
      throw StateError('The challenge has not started.');
    }
    final records = ref.watch(dietRecordRepositoryProvider);
    final chats = ref.watch(chatRepositoryProvider);

    final items = <HistoryItem>[];
    for (var day = today; day >= 1; day--) {
      final date = calendar.dateOf(day);
      final chatDate = Jst.isoDate(date);
      final hasConversation = (await chats.history(chatDate)).isNotEmpty;
      final record = records.get(day);

      if (ChallengeCalendar.isLastDayOfWeek(day)) {
        final week = ChallengeCalendar.weekOf(day);
        items.add(
          HistoryItem(
            kind: HistoryKind.weekly,
            dayIdx: day,
            weekNum: week,
            date: _cardDate.format(date),
            chatDate: chatDate,
            topic: '$week주차 총평',
            preview: '$week주차 ${_weekTitles[week] ?? ''} 완료! 이번 주도 수고하셨습니다.',
            tags: ['$week주차완료', '주간리뷰'],
            hasConversation: hasConversation,
          ),
        );
      }

      final feedback = record?.aiFeedback;
      if (record != null && feedback != null && feedback.isNotEmpty) {
        items.add(
          HistoryItem(
            kind: HistoryKind.daily,
            dayIdx: day,
            weekNum: ChallengeCalendar.weekOf(day),
            date: _cardDate.format(date),
            chatDate: chatDate,
            topic: '$day일차 데일리 총평',
            preview: feedback,
            tags: _tags(record),
            hasConversation: hasConversation,
          ),
        );
      }
    }
    return ChatHistoryState(today: today, items: items);
  }

  void search(String query) =>
      state = AsyncData(state.requireValue.copyWith(query: query));

  static List<String> _tags(DietRecord record) => [
    if (record.score >= 0.9) '완벽' else if (record.score < 0.7) '주의필요',
    if (record.warningCount > 0) '경고${record.warningCount}회',
  ];
}
