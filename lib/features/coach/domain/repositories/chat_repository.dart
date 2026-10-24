import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

/// Coach conversations, one thread per calendar date (`yyyy-MM-dd`).
abstract interface class ChatRepository {
  Future<List<ChatMessage>> history(String date);

  Future<void> append(String date, ChatMessage message);

  Future<String?> daySummary(String date);

  Future<void> clear();
}
