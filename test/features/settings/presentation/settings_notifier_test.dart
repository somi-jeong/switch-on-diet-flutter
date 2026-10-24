import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

import '../../../helpers/fakes.dart';

void main() {
  test('start saves the settings and derives the current day', () async {
    final container = createContainer(
      records: InMemoryDietRecordRepository(),
      clock: FixedClock(DateTime(2026, 3, 5, 9)),
      settings: null,
    );
    expect(container.read(currentDayProvider), isNull);

    await container
        .read(settingsProvider.notifier)
        .start(startDate: DateTime.parse('2026-03-01'), userName: '  ');

    expect(
      container.read(settingsProvider),
      const AppSettings(startDate: '2026-03-01'),
    );
    expect(container.read(currentDayProvider), 5);
  });

  test('rename ignores blank names', () async {
    final container = createContainer(
      records: InMemoryDietRecordRepository(),
      clock: FixedClock(DateTime(2026, 3, 5)),
    );
    final settings = container.read(settingsProvider.notifier);

    await settings.rename('소미');
    await settings.rename('   ');

    expect(container.read(settingsProvider)!.userName, '소미');
  });

  test('reset clears records, chats and settings', () async {
    final records = InMemoryDietRecordRepository({
      1: const DietRecord(date: '2026-03-01'),
    });
    final chats = InMemoryChatRepository();
    await chats.append(
      '2026-03-01',
      const ChatMessage(role: ChatRole.user, text: 'hi', timestamp: ''),
    );
    final container = createContainer(
      records: records,
      chats: chats,
      clock: FixedClock(DateTime(2026, 3, 5)),
    );

    await container.read(settingsProvider.notifier).reset();

    expect(container.read(settingsProvider), isNull);
    expect(records.getAll(), isEmpty);
    expect(chats.threads, isEmpty);
  });
}
