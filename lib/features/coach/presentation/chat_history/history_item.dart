import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';

class HistoryItem {
  final String type; // 'daily' or 'weekly'
  final int dayIdx;
  final int weekNum;
  final String date;
  final String topic;
  final String preview;
  final List<String> tags;
  final DietRecord? record;
  final List<ChatMessage>? messages;

  HistoryItem({
    required this.type,
    required this.dayIdx,
    required this.weekNum,
    required this.date,
    required this.topic,
    required this.preview,
    required this.tags,
    this.record,
    this.messages,
  });
}
