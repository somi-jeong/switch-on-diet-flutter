import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:switchon_diet/features/coach/data/models/chat_message_dto.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

/// Chat threads stored as one JSON array per date in a `Box<String>`.
class ChatLocalDataSource {
  ChatLocalDataSource({
    required Box<String> chats,
    required Box<String> daySummaries,
  }) : _chats = chats,
       _daySummaries = daySummaries;

  static const chatsBoxName = 'chat_json';
  static const daySummariesBoxName = 'day_summaries';

  final Box<String> _chats;
  final Box<String> _daySummaries;

  List<ChatMessage> read(String date) {
    final raw = _chats.get(_chatKey(date));
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<Object?>;
      return [
        for (final item in decoded.whereType<Map<String, Object?>>())
          ChatMessageDto.fromJson(item),
      ];
    } on FormatException {
      return [];
    } on TypeError {
      return [];
    }
  }

  Future<void> write(String date, List<ChatMessage> messages) => _chats.put(
    _chatKey(date),
    jsonEncode([for (final m in messages) ChatMessageDto.toJson(m)]),
  );

  String? readDaySummary(String date) => _daySummaries.get('summary_$date');

  Future<void> clear() async {
    await _chats.clear();
    await _daySummaries.clear();
  }

  static String _chatKey(String date) => 'chat_$date';
}
