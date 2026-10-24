import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

part 'diet_history_state.freezed.dart';

/// Every day up to today, newest first, including days with no record.
final dietHistoryProvider = Provider.autoDispose<List<DayHistory>>((ref) {
  final calendar = ref.watch(challengeCalendarProvider);
  final today = ref.watch(currentDayProvider);
  if (calendar == null || today == null) return const [];
  final records = ref.watch(dietRecordsProvider).valueOrNull ?? const {};

  return [
    for (var day = today; day >= 1; day--)
      DayHistory.of(day: day, date: calendar.dateOf(day), record: records[day]),
  ];
});

@freezed
class DayHistory with _$DayHistory {
  const factory DayHistory({
    required int day,

    /// e.g. `2026.03.01 (일)`.
    required String dateLabel,
    required DietRecord record,
  }) = _DayHistory;

  const DayHistory._();

  factory DayHistory.of({
    required int day,
    required DateTime date,
    DietRecord? record,
  }) {
    final dateLabel = '${_date.format(date)} (${_weekdays[date.weekday - 1]})';
    return DayHistory(
      day: day,
      dateLabel: dateLabel,
      record: record ?? DietRecord(date: dateLabel),
    );
  }

  static final _date = DateFormat('yyyy.MM.dd');
  static const _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  int get week => ChallengeCalendar.weekOf(day);

  /// From the last recorded meal to this day's wake-up, e.g. `13h 20m`.
  String get fastingText {
    final meals = record.meals.where((m) => m.checked && m.eatenAt != null);
    if (record.wakeTime == null || meals.isEmpty) return '--';
    return _between(meals.last.eatenAt!, record.wakeTime!);
  }

  String get sleepText {
    if (record.bedTime == null || record.wakeTime == null) return '--';
    return _between(record.bedTime!, record.wakeTime!);
  }

  /// Time from [from] to [to], wrapping past midnight.
  static String _between(String from, String to) {
    try {
      var duration = Jst.parse(to).difference(Jst.parse(from));
      if (duration.isNegative) duration += const Duration(hours: 24);
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } on FormatException {
      return '--';
    }
  }
}
