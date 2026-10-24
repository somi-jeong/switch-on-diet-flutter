import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/coach/data/datasources/anthropic_remote_data_source.dart';
import 'package:switchon_diet/features/coach/data/datasources/chat_local_data_source.dart';
import 'package:switchon_diet/features/coach/data/repositories/claude_ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/data/repositories/hive_chat_repository.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/domain/repositories/chat_repository.dart';

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
  (ref) => ClaudeAiCoachRepository(
    AnthropicRemoteDataSource(
      client: ref.watch(httpClientProvider),
      apiKey: ref.watch(anthropicApiKeyProvider),
    ),
  ),
);
