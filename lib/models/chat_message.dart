import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 4)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String role; // 'user' | 'assistant'

  @HiveField(1)
  String text;

  @HiveField(2)
  String timestamp; // JST ISO string

  ChatMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, String> toMap() => {'role': role, 'content': text};

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
    role: map['role'] ?? 'user',
    text: map['content'] ?? map['text'] ?? '',
    timestamp: map['timestamp'] ?? DateTime.now().toIso8601String(),
  );
}
