import 'package:switchon_diet/features/coach/data/datasources/chat_local_data_source.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/repositories/chat_repository.dart';

class HiveChatRepository implements ChatRepository {
  HiveChatRepository(this._local);

  final ChatLocalDataSource _local;

  @override
  Future<List<ChatMessage>> history(String date) async => _local.read(date);

  @override
  Future<void> append(String date, ChatMessage message) =>
      _local.write(date, [..._local.read(date), message]);

  @override
  Future<String?> daySummary(String date) async => _local.readDaySummary(date);

  @override
  Future<void> clear() => _local.clear();
}
