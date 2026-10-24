import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

void main() {
  final calendar = ChallengeCalendar.fromIsoDate('2026-03-01');

  test('the start date is day 1 and later dates count up', () {
    expect(calendar.dayAt(DateTime(2026, 3, 1, 7)), 1);
    expect(calendar.dayAt(DateTime(2026, 3, 8, 23, 59)), 8);
  });

  test('day index is clamped to the 28-day program', () {
    expect(calendar.dayAt(DateTime(2026, 2, 20)), 1);
    expect(calendar.dayAt(DateTime(2026, 5, 10)), ChallengeCalendar.totalDays);
  });

  test('weeks are seven days long and capped at four', () {
    expect(ChallengeCalendar.weekOf(1), 1);
    expect(ChallengeCalendar.weekOf(7), 1);
    expect(ChallengeCalendar.weekOf(8), 2);
    expect(ChallengeCalendar.weekOf(28), 4);
    expect(ChallengeCalendar.daysOfWeek(2), [8, 9, 10, 11, 12, 13, 14]);
  });

  test('dateOf is the inverse of dayAt', () {
    expect(calendar.dateOf(2), DateTime(2026, 3, 2));
    expect(calendar.endDate, DateTime(2026, 3, 28));
  });
}
