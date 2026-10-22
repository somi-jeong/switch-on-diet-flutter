import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/utils/time_validator.dart';

void main() {
  group('TimeValidator', () {
    test('wake time outside 05:00-09:59 is late', () {
      expect(
        TimeValidator.isWakeTimeLate(const TimeOfDay(hour: 7, minute: 0)),
        isFalse,
      );
      expect(
        TimeValidator.isWakeTimeLate(const TimeOfDay(hour: 4, minute: 59)),
        isTrue,
      );
      expect(
        TimeValidator.isWakeTimeLate(const TimeOfDay(hour: 10, minute: 0)),
        isTrue,
      );
    });

    test('bedtime between midnight and 05:59 is late', () {
      expect(
        TimeValidator.isBedtimeLate(const TimeOfDay(hour: 23, minute: 30)),
        isFalse,
      );
      expect(
        TimeValidator.isBedtimeLate(const TimeOfDay(hour: 1, minute: 0)),
        isTrue,
      );
    });

    test('sleep duration wraps across midnight', () {
      final hours = TimeValidator.getSleepDuration(
        const TimeOfDay(hour: 23, minute: 0),
        const TimeOfDay(hour: 6, minute: 30),
      );
      expect(hours, closeTo(7.5, 1e-9));
      expect(
        TimeValidator.isSleepDeprived(
          const TimeOfDay(hour: 1, minute: 0),
          const TimeOfDay(hour: 6, minute: 0),
        ),
        isTrue,
      );
    });

    test('formats duration as hours and minutes', () {
      expect(TimeValidator.formatSleepDuration(7.5), '7시간 30분');
    });
  });
}
