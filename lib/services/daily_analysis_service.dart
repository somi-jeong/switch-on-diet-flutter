import 'package:flutter/material.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';
import 'package:switchon_diet/services/claude_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class DailyAnalysisService {
  /// Checks if current time is 23:00-23:59 JST and generates daily feedback
  /// if not already generated for today
  static Future<void> checkAndGenerateDailyFeedback({
    required String startDate,
  }) async {
    try {
      final now = const JstClock().now();
      final currentHour = now.hour;

      // Check if current time is between 23:00-23:59 JST
      if (currentHour != 23) {
        debugPrint('Not daily analysis time (current: $currentHour시)');
        return;
      }

      // Calculate today's day index
      final todayIdx = ChallengeCalendar.fromIsoDate(startDate).dayAt(now);

      // Get today's record
      final allRecords = StorageService.getAllRecords();
      final todayRecord = allRecords[todayIdx];

      // Check if already generated
      if (todayRecord?.aiFeedback != null &&
          todayRecord!.aiFeedback!.isNotEmpty) {
        debugPrint('Daily feedback already generated for day $todayIdx');
        return;
      }

      // If no record exists or no wake time recorded, skip
      if (todayRecord == null ||
          todayRecord.wakeTime == null ||
          todayRecord.wakeTime!.isEmpty) {
        debugPrint(
          'No wake time recorded for day $todayIdx, skipping daily feedback',
        );
        return;
      }

      // Calculate statistics
      final wakeTime = Jst.parse(todayRecord.wakeTime!);
      final fastingHours = now.difference(wakeTime).inHours;

      final activeMeals = todayRecord.meals.where((m) => !m.skipped).toList();
      final completedMeals = activeMeals.where((m) => m.checked).length;
      final totalMeals = activeMeals.length;
      final score = totalMeals > 0
          ? (completedMeals / totalMeals * 100).round()
          : 0;

      // Count meals by status
      final allowedCount = todayRecord.meals
          .where((m) => m.aiStatus == 'ALLOWED')
          .length;
      final warningCount = todayRecord.meals
          .where((m) => m.aiStatus == 'WARNING')
          .length;
      final forbiddenCount = todayRecord.meals
          .where((m) => m.aiStatus == 'FORBIDDEN')
          .length;

      // Build meal details for AI
      final mealDetails = todayRecord.meals.map((meal) {
        return {
          'label': meal.label,
          'checked': meal.checked,
          'skipped': meal.skipped,
          'foodText': meal.foodText,
          'aiStatus': meal.aiStatus,
          'aiFeedback': meal.aiFeedback,
          'recordedAt': meal.recordedAt,
        };
      }).toList();

      // Calculate week
      final week = ChallengeCalendar.weekOf(todayIdx);

      // Collect daily missions completion status
      final dailyChecklist = todayRecord.dailyChecklist ?? {};
      final dailyMissionsCompleted = dailyChecklist.values
          .where((v) => v)
          .length;
      final dailyMissionsTotal = dailyChecklist.length;

      // Generate daily feedback using Gemini
      final claude = ClaudeService();
      final feedback = await claude.getDailyFeedback(
        day: todayIdx,
        week: week,
        wakeTime: wakeTime,
        fastingHours: fastingHours,
        score: score,
        completedMeals: completedMeals,
        totalMeals: totalMeals,
        allowedCount: allowedCount,
        warningCount: warningCount,
        forbiddenCount: forbiddenCount,
        warningCountTotal: todayRecord.warningCount,
        mealDetails: mealDetails,
        weight: todayRecord.weight,
        bodyFat: todayRecord.bodyFat,
        confession: todayRecord.confession,
        bedTime: todayRecord.bedTime,
        actualBedTime: todayRecord.actualBedTime,
        dailyChecklist: dailyChecklist,
        dailyMissionsCompleted: dailyMissionsCompleted,
        dailyMissionsTotal: dailyMissionsTotal,
      );

      // Save feedback
      todayRecord.aiFeedback = feedback;
      await StorageService.saveRecord(todayRecord, todayIdx);

      debugPrint('Daily feedback generated for day $todayIdx');
    } catch (e) {
      debugPrint('Failed to generate daily feedback: $e');
    }
  }
}
