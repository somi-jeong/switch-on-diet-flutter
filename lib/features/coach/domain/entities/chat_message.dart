import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

enum ChatRole { user, assistant }

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required ChatRole role,
    required String text,

    /// ISO-8601 timestamp in JST.
    required String timestamp,
  }) = _ChatMessage;

  const ChatMessage._();

  bool get isUser => role == ChatRole.user;
}
