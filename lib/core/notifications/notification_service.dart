import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:switchon_diet/core/time/clock.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/program/domain/meal_schedule.dart';
import 'package:timezone/timezone.dart' as tz;

/// Local meal reminders (iOS).
///
/// Initialised at startup. Scheduling is implemented but not yet exposed in
/// the UI.
class NotificationService {
  NotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    Clock clock = const JstClock(),
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _clock = clock;

  final FlutterLocalNotificationsPlugin _plugin;
  final Clock _clock;

  static const _details = NotificationDetails(
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  Future<void> init() => _plugin.initialize(
    const InitializationSettings(iOS: DarwinInitializationSettings()),
  );

  Future<bool> requestPermissions() async {
    final granted = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return granted ?? false;
  }

  /// Replaces all pending reminders with two per meal: ten minutes before
  /// the window opens and when it opens. Reminders in the past are skipped.
  Future<void> scheduleMealReminders(DateTime wakeTime) async {
    await _plugin.cancelAll();
    final tokyo = tz.getLocation('Asia/Tokyo');
    final now = _clock.now();

    for (final (index, meal) in MealSchedule.slots.indexed) {
      final start = meal.startAfter(wakeTime);
      final heads = start.subtract(const Duration(minutes: 10));
      if (heads.isBefore(now)) continue;

      await _plugin.zonedSchedule(
        index * 2,
        '${meal.icon} ${meal.label} 시간이 곧 시작돼요',
        '10분 후 식사 시간입니다. 준비해주세요!',
        tz.TZDateTime.from(heads, tokyo),
        _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      await _plugin.zonedSchedule(
        index * 2 + 1,
        '${meal.icon} ${meal.label} 시간이에요!',
        '${Jst.hourMinute(start)} ~ ${Jst.hourMinute(meal.endAfter(wakeTime))} 사이에 식사해주세요',
        tz.TZDateTime.from(start, tokyo),
        _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
