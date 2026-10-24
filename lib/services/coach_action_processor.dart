import 'package:flutter/foundation.dart';
import 'package:switchon_diet/constants/meal_offsets.dart';
import 'package:switchon_diet/models/coach_action.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/models/meal_record.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

/// Processes coach AI actions (wake, meal, skip, sleep)
class CoachActionProcessor {
  /// Process a list of actions
  static Future<void> processActions(
    List<CoachAction> actions,
    int todayIdx,
  ) async {
    for (final action in actions) {
      try {
        switch (action.type) {
          case CoachActionType.wake:
            await _processWakeAction(action.data, todayIdx);
            break;
          case CoachActionType.meal:
            await _processMealAction(action.data, todayIdx);
            break;
          case CoachActionType.skip:
            await _processSkipAction(action.data, todayIdx);
            break;
          case CoachActionType.sleep:
            await _processSleepAction(action.data, todayIdx);
            break;
        }
      } catch (e) {
        // Silently fail individual actions
        debugPrint('Action processing error: $e');
      }
    }
  }

  static Future<void> _processWakeAction(
    Map<String, dynamic> data,
    int todayIdx,
  ) async {
    final timeStr = data['time'] as String?;
    if (timeStr == null) return;

    try {
      // Parse time (format: "07:00" or "7:00")
      final parts = timeStr.split(':');
      if (parts.length != 2) return;

      final hour = int.tryParse(parts[0].trim());
      final minute = int.tryParse(parts[1].trim());
      if (hour == null || minute == null) return;

      final now = JstService.now();
      final wakeTime = DateTime(now.year, now.month, now.day, hour, minute);
      final wakeTimeIso = JstService.toIso(wakeTime);
      final dateStr = JstService.formatDate(wakeTime);

      // Get or create record
      var record = StorageService.getRecord(todayIdx);
      if (record == null) {
        record = DietRecord(
          date: dateStr,
          wakeTime: wakeTimeIso,
          meals: mealOffsets.map((m) => MealRecord(label: m.label)).toList(),
        );
      } else {
        record.wakeTime = wakeTimeIso;
      }

      await StorageService.saveRecord(record, todayIdx);
    } catch (e) {
      debugPrint('Wake action error: $e');
    }
  }

  static Future<void> _processMealAction(
    Map<String, dynamic> data,
    int todayIdx,
  ) async {
    final mealType = data['mealType'] as String?;
    final foods = data['foods'] as String?;
    if (mealType == null || foods == null) return;

    try {
      final record = StorageService.getRecord(todayIdx);
      if (record == null) return;

      final mealIndex = record.meals.indexWhere((m) => m.label == mealType);
      if (mealIndex == -1) return;

      // Simple meal recording without AI analysis
      record.meals[mealIndex].checked = true;
      record.meals[mealIndex].foodText = foods;
      record.meals[mealIndex].eatenAt = JstService.toIso(JstService.now());

      await StorageService.saveRecord(record, todayIdx);
    } catch (e) {
      debugPrint('Meal action error: $e');
    }
  }

  static Future<void> _processSkipAction(
    Map<String, dynamic> data,
    int todayIdx,
  ) async {
    final mealType = data['mealType'] as String?;
    if (mealType == null) return;

    try {
      final record = StorageService.getRecord(todayIdx);
      if (record == null) return;

      final mealIndex = record.meals.indexWhere((m) => m.label == mealType);
      if (mealIndex == -1) return;

      // Mark meal as skipped
      record.meals[mealIndex].skipped = true;
      record.meals[mealIndex].checked = false;
      await StorageService.saveRecord(record, todayIdx);
    } catch (e) {
      debugPrint('Skip action error: $e');
    }
  }

  static Future<void> _processSleepAction(
    Map<String, dynamic> data,
    int todayIdx,
  ) async {
    final timeStr = data['time'] as String?;
    if (timeStr == null) return;

    try {
      // Parse time (format: "23:00" or "11:00")
      final parts = timeStr.split(':');
      if (parts.length != 2) return;

      final hour = int.tryParse(parts[0].trim());
      final minute = int.tryParse(parts[1].trim());
      if (hour == null || minute == null) return;

      final now = JstService.now();
      final bedTime = DateTime(now.year, now.month, now.day, hour, minute);
      final bedTimeIso = JstService.toIso(bedTime);

      final record = StorageService.getRecord(todayIdx);
      if (record == null) return;

      record.bedTime = bedTimeIso;
      await StorageService.saveRecord(record, todayIdx);
    } catch (e) {
      debugPrint('Sleep action error: $e');
    }
  }
}
