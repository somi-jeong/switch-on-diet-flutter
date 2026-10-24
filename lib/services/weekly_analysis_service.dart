import 'package:flutter/material.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/services/claude_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class WeeklyAnalysisService {
  /// Checks if today is the last day of a week (7, 14, 21, or 28)
  /// and the current time is between 17:00-19:00 JST
  /// If so, generates weekly summary and stores it
  static Future<void> checkAndGenerateWeeklySummary({
    required String startDate,
  }) async {
    try {
      final now = const JstClock().now();
      final currentHour = now.hour;

      // Check if current time is between 17:00-19:00 JST
      if (currentHour < 17 || currentHour >= 19) {
        debugPrint('Not weekly analysis time (current: $currentHour시)');
        return;
      }

      // Calculate today's day index
      final todayIdx = ChallengeCalendar.fromIsoDate(startDate).dayAt(now);

      // Check if today is end of week (7, 14, 21, or 28)
      if (!ChallengeCalendar.isLastDayOfWeek(todayIdx)) {
        debugPrint('Not end of week day (today: $todayIdx일차)');
        return;
      }

      // Get all records
      final allRecords = StorageService.getAllRecords();

      // Find today's record
      final todayRecord = allRecords[todayIdx];

      if (todayRecord?.weeklySummary != null &&
          todayRecord!.weeklySummary!.isNotEmpty) {
        debugPrint('Weekly summary already generated for day $todayIdx');
        return;
      }

      // Get records for the past 7 days
      final week = (todayIdx - 1) ~/ 7 + 1;
      final weekRecords = <int, Map<String, dynamic>>{};

      for (int i = todayIdx - 6; i <= todayIdx; i++) {
        final record = allRecords[i];

        if (record != null) {
          // Detect late recording pattern (recordedAt and eatenAt differ by 2+ hours)
          final lateRecordings = <String>[];
          for (final meal in record.meals) {
            if (meal.recordedAt != null &&
                meal.recordedAt!.isNotEmpty &&
                meal.eatenAt != null &&
                meal.eatenAt!.isNotEmpty) {
              final recordedTime = Jst.parse(meal.recordedAt!);
              final eatenTime = Jst.parse(meal.eatenAt!);
              final diffHours = recordedTime
                  .difference(eatenTime)
                  .inHours
                  .abs();

              if (diffHours >= 2) {
                lateRecordings.add('${meal.label} ($diffHours시간 차이)');
              }
            }
          }

          // Count daily missions
          final dailyChecklist = record.dailyChecklist ?? {};
          final missionsCompleted = dailyChecklist.values
              .where((v) => v)
              .length;
          final missionsTotal = dailyChecklist.length;

          // Calculate wake time status
          var wakeTimeStatus = WakeCategory.onTime.label;
          if (record.wakeTime != null && record.wakeTime!.isNotEmpty) {
            final wakeHour = Jst.parse(record.wakeTime!).hour;
            wakeTimeStatus = WakeCategory.ofHour(wakeHour).label;
          }

          weekRecords[i] = {
            'meals': record.meals
                .map(
                  (m) => {
                    'label': m.label,
                    'checked': m.checked,
                    'aiStatus': m.aiStatus,
                    'aiFeedback': m.aiFeedback,
                  },
                )
                .toList(),
            'score': record.score,
            'weight': record.weight,
            'bodyFat': record.bodyFat,
            'lateRecordings': lateRecordings,
            'wakeTime': record.wakeTime,
            'wakeTimeStatus': wakeTimeStatus,
            'missionsCompleted': missionsCompleted,
            'missionsTotal': missionsTotal,
            'dailyChecklist': dailyChecklist,
          };
        }
      }

      if (weekRecords.isEmpty) {
        debugPrint('No records found for week $week');
        return;
      }

      // Generate weekly summary using Gemini
      final claude = ClaudeService();
      final summary = await claude.getWeeklySummary(
        week: week,
        weekRecords: weekRecords,
      );

      // Store summary in today's record
      var record = todayRecord;
      if (record == null) {
        final todayDate = Jst.isoDate(now);
        record = DietRecord(date: todayDate, weeklySummary: summary);
      } else {
        record.weeklySummary = summary;
      }

      await StorageService.saveRecord(record, todayIdx);
      debugPrint('Weekly summary generated for week $week (day $todayIdx)');
    } catch (e) {
      debugPrint('Failed to generate weekly summary: $e');
    }
  }
}
