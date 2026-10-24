import 'package:switchon_diet/constants/meal_offsets.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';

/// Service to check if meal times have passed and determine meal status
class MealTimingService {
  /// Get meal offset by label
  static MealOffset? _getMealOffset(String mealLabel) {
    try {
      return mealOffsets.firstWhere((offset) => offset.label == mealLabel);
    } catch (e) {
      return null;
    }
  }

  /// Check if the meal time window has passed
  /// Returns true if current JST time is past the end of the meal window
  static bool isMealTimePassed({
    required String wakeTimeIso,
    required String mealLabel,
  }) {
    final wakeTime = Jst.parse(wakeTimeIso);
    final currentTime = const JstClock().now();

    // Get meal window offsets
    final offset = _getMealOffset(mealLabel);
    if (offset == null) return false;

    // Calculate meal end time
    final mealEndTime = wakeTime.add(Duration(minutes: offset.endMins));

    // Check if current time is past meal end time
    return currentTime.isAfter(mealEndTime);
  }

  /// Get the meal time window as a formatted string
  static String getMealTimeWindow({
    required String wakeTimeIso,
    required String mealLabel,
  }) {
    final wakeTime = Jst.parse(wakeTimeIso);
    final offset = _getMealOffset(mealLabel);
    if (offset == null) return '';

    final startTime = wakeTime.add(Duration(minutes: offset.startMins));
    final endTime = wakeTime.add(Duration(minutes: offset.endMins));

    return '${Jst.hourMinute(startTime)} ~ ${Jst.hourMinute(endTime)}';
  }

  /// Get recommended meal time (middle of the window)
  static String getRecommendedMealTime({
    required String wakeTimeIso,
    required String mealLabel,
  }) {
    final wakeTime = Jst.parse(wakeTimeIso);
    final offset = _getMealOffset(mealLabel);
    if (offset == null) return '';

    final middleMins = (offset.startMins + offset.endMins) ~/ 2;
    final recommendedTime = wakeTime.add(Duration(minutes: middleMins));

    return Jst.hourMinute(recommendedTime);
  }
}
