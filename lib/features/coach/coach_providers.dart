import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/coach/data/datasources/anthropic_remote_data_source.dart';
import 'package:switchon_diet/features/coach/data/datasources/chat_local_data_source.dart';
import 'package:switchon_diet/features/coach/data/repositories/hive_chat_repository.dart';
import 'package:switchon_diet/features/coach/data/repositories/remote_ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/domain/repositories/chat_repository.dart';
import 'package:switchon_diet/features/coach/domain/usecases/apply_coach_actions.dart';
import 'package:switchon_diet/features/coach/domain/usecases/send_coach_message.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';

/// Opened during bootstrap and injected with `overrideWithValue`.
final chatBoxProvider = Provider<Box<String>>(
  (ref) => throw UnimplementedError('chatBoxProvider is not opened'),
);

/// Opened during bootstrap and injected with `overrideWithValue`.
final daySummaryBoxProvider = Provider<Box<String>>(
  (ref) => throw UnimplementedError('daySummaryBoxProvider is not opened'),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => HiveChatRepository(
    ChatLocalDataSource(
      chats: ref.watch(chatBoxProvider),
      daySummaries: ref.watch(daySummaryBoxProvider),
    ),
  ),
);

final aiCoachRepositoryProvider = Provider<AiCoachRepository>(
  (ref) => RemoteAiCoachRepository(
    AnthropicRemoteDataSource(
      client: ref.watch(httpClientProvider),
      apiKey: ref.watch(anthropicApiKeyProvider),
    ),
  ),
);

final applyCoachActionsProvider = Provider<ApplyCoachActions>(
  (ref) => ApplyCoachActions(
    records: ref.watch(dietRecordRepositoryProvider),
    recordWakeTime: ref.watch(recordWakeTimeProvider),
    clock: ref.watch(clockProvider),
  ),
);

final sendCoachMessageProvider = Provider<SendCoachMessage>(
  (ref) => SendCoachMessage(
    records: ref.watch(dietRecordRepositoryProvider),
    coach: ref.watch(aiCoachRepositoryProvider),
    applyActions: ref.watch(applyCoachActionsProvider),
  ),
);
