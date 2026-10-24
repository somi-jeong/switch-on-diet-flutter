import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item.freezed.dart';

enum HistoryKind { daily, weekly }

/// One card in the coach history list.
@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required HistoryKind kind,
    required int dayIdx,
    required int weekNum,

    /// Shown on the card, `yyyy.MM.dd`.
    required String date,

    /// The stored conversation key, `yyyy-MM-dd`.
    required String chatDate,
    required String topic,
    required String preview,
    required List<String> tags,

    /// Whether the day has a conversation to open.
    required bool hasConversation,
  }) = _HistoryItem;
}
