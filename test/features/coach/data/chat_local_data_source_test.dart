import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/features/coach/data/datasources/chat_local_data_source.dart';
import 'package:switchon_diet/features/coach/data/repositories/hive_chat_repository.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

import '../../../helpers/hive_test_utils.dart';

void main() {
  late Directory dir;
  late Box<String> chats;
  late HiveChatRepository repository;

  setUp(() async {
    dir = await setUpHive();
    chats = await Hive.openBox<String>(ChatLocalDataSource.chatsBoxName);
    repository = HiveChatRepository(
      ChatLocalDataSource(
        chats: chats,
        daySummaries: await Hive.openBox<String>(
          ChatLocalDataSource.daySummariesBoxName,
        ),
      ),
    );
  });

  tearDown(() => tearDownHive(dir));

  test('appends messages to the thread of their date', () async {
    const question = ChatMessage(
      role: ChatRole.user,
      text: '물 얼마나 마셔요?',
      timestamp: '2026-03-01T09:00:00.000',
    );
    const answer = ChatMessage(
      role: ChatRole.assistant,
      text: '2L 이상이요.',
      timestamp: '2026-03-01T09:00:05.000',
    );

    await repository.append('2026-03-01', question);
    await repository.append('2026-03-01', answer);

    expect(await repository.history('2026-03-01'), [question, answer]);
    expect(await repository.history('2026-03-02'), isEmpty);
  });

  test('reads threads that used the older `content` key', () async {
    await chats.put(
      'chat_2026-03-01',
      '[{"role":"assistant","content":"안녕하세요","timestamp":"t"}]',
    );

    expect(await repository.history('2026-03-01'), const [
      ChatMessage(role: ChatRole.assistant, text: '안녕하세요', timestamp: 't'),
    ]);
  });

  test('a corrupt thread reads as empty instead of throwing', () async {
    await chats.put('chat_2026-03-01', '{not json');

    expect(await repository.history('2026-03-01'), isEmpty);
  });
}
