import 'package:switchon_diet/features/coach/domain/repositories/chat_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/settings/domain/repositories/settings_repository.dart';

/// Deletes every record, the settings and all coach conversations.
class ResetChallenge {
  const ResetChallenge({
    required DietRecordRepository records,
    required SettingsRepository settings,
    required ChatRepository chats,
  }) : _records = records,
       _settings = settings,
       _chats = chats;

  final DietRecordRepository _records;
  final SettingsRepository _settings;
  final ChatRepository _chats;

  Future<void> call() async {
    await _records.clear();
    await _settings.clear();
    await _chats.clear();
  }
}
