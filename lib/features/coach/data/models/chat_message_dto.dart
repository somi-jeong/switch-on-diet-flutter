import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

/// JSON shape of a stored chat message.
///
/// Older entries used `content` instead of `text`; both are accepted.
abstract final class ChatMessageDto {
  static ChatMessage fromJson(Map<String, Object?> json) => ChatMessage(
    role: switch (json['role']) {
      'assistant' => ChatRole.assistant,
      _ => ChatRole.user,
    },
    text: (json['text'] ?? json['content'] ?? '') as String,
    timestamp: (json['timestamp'] ?? '') as String,
  );

  static Map<String, Object?> toJson(ChatMessage message) => {
    'role': message.role.name,
    'text': message.text,
    'timestamp': message.timestamp,
  };
}
