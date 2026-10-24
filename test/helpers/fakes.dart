import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_action.dart';
import 'package:switchon_diet/features/coach/domain/entities/coach_requests.dart';
import 'package:switchon_diet/features/coach/domain/repositories/ai_coach_repository.dart';
import 'package:switchon_diet/features/coach/domain/repositories/chat_repository.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';
import 'package:switchon_diet/features/program/domain/food_rules.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';
import 'package:switchon_diet/features/settings/domain/repositories/settings_repository.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

class FixedClock implements Clock {
  FixedClock(this.current);

  DateTime current;

  @override
  DateTime now() => current;
}

class InMemoryDietRecordRepository implements DietRecordRepository {
  InMemoryDietRecordRepository([Map<int, DietRecord>? records])
    : _records = {...?records};

  final Map<int, DietRecord> _records;
  final _changes = StreamController<void>.broadcast();

  @override
  DietRecord? get(int day) => _records[day];

  @override
  Map<int, DietRecord> getAll() => Map.unmodifiable(_records);

  @override
  Future<void> save(int day, DietRecord record) async {
    _records[day] = record;
    _changes.add(null);
  }

  @override
  Stream<Map<int, DietRecord>> watchAll() async* {
    yield getAll();
    yield* _changes.stream.map((_) => getAll());
  }

  @override
  Future<void> clear() async {
    _records.clear();
    _changes.add(null);
  }
}

class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._settings]);

  AppSettings? _settings;

  @override
  AppSettings? get() => _settings;

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;

  @override
  Future<void> clear() async => _settings = null;
}

class InMemoryChatRepository implements ChatRepository {
  final threads = <String, List<ChatMessage>>{};

  @override
  Future<List<ChatMessage>> history(String date) async => [...?threads[date]];

  @override
  Future<void> append(String date, ChatMessage message) async =>
      (threads[date] ??= []).add(message);

  @override
  Future<String?> daySummary(String date) async => null;

  @override
  Future<void> clear() async => threads.clear();
}

/// Answers with canned values and records what it was asked.
class FakeAiCoachRepository implements AiCoachRepository {
  MealAnalysis mealAnalysis = const MealAnalysis(
    verdict: MealVerdict.allowed,
    feedback: '좋아요',
  );
  CoachReply chatReply = const CoachReply(text: '네, 알겠어요.');
  String feedback = '오늘도 수고하셨어요.';

  /// Thrown instead of answering when set.
  Object? failure;

  final replyCalls =
      <({String message, CoachContext context, List<ChatMessage> history})>[];
  final dailyReports = <DailyReport>[];
  final weeklyCalls = <({int week, List<WeeklyDayReport> days})>[];

  @override
  Future<MealAnalysis> analyzeMeal({
    required String foodText,
    required int day,
    required int week,
    required FoodRules foodRules,
  }) async {
    if (failure case final failure?) throw failure;
    return mealAnalysis;
  }

  @override
  Future<CoachReply> reply({
    required String message,
    required CoachContext context,
    required List<ChatMessage> history,
  }) async {
    replyCalls.add((message: message, context: context, history: history));
    if (failure case final failure?) throw failure;
    return chatReply;
  }

  @override
  Future<String> dailyFeedback(DailyReport report) async {
    dailyReports.add(report);
    if (failure case final failure?) throw failure;
    return feedback;
  }

  @override
  Future<String> weeklySummary({
    required int week,
    required List<WeeklyDayReport> days,
  }) async {
    weeklyCalls.add((week: week, days: days));
    if (failure case final failure?) throw failure;
    return feedback;
  }
}

/// A container wired to in-memory fakes; disposed after the test.
ProviderContainer createContainer({
  required DietRecordRepository records,
  required Clock clock,
  AppSettings? settings = const AppSettings(startDate: '2026-03-01'),
  AiCoachRepository? coach,
  ChatRepository? chats,
}) {
  final container = ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(clock),
      dietRecordRepositoryProvider.overrideWithValue(records),
      settingsRepositoryProvider.overrideWithValue(
        InMemorySettingsRepository(settings),
      ),
      aiCoachRepositoryProvider.overrideWithValue(
        coach ?? FakeAiCoachRepository(),
      ),
      chatRepositoryProvider.overrideWithValue(
        chats ?? InMemoryChatRepository(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}
