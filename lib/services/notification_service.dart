import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:switchon_diet/constants/meal_offsets.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// 초기화
  static Future<void> init() async {
    if (_initialized) return;

    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
    _initialized = true;
  }

  /// 권한 요청
  static Future<bool> requestPermissions() async {
    final result = await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result ?? false;
  }

  /// 식사 시간 알림 스케줄링
  /// wakeTime: 기상 시간 (ISO 8601 형식)
  static Future<void> scheduleMealNotifications(String wakeTime) async {
    await _notifications.cancelAll(); // 기존 알림 모두 취소

    final wake = JstService.fromIso(wakeTime);

    for (int i = 0; i < mealOffsets.length; i++) {
      final meal = mealOffsets[i];

      // 식사 시작 10분 전 알림
      final startTime = wake.add(Duration(minutes: meal.startMins));
      final notifyTime = startTime.subtract(const Duration(minutes: 10));

      // 과거 시간이면 스킵
      if (notifyTime.isBefore(JstService.now())) continue;

      // JST 타임존으로 변환
      final tzNotifyTime = tz.TZDateTime.from(
        notifyTime,
        tz.getLocation('Asia/Tokyo'),
      );

      await _notifications.zonedSchedule(
        i * 2, // ID: 0, 2, 4, 6 (시작 10분 전)
        '${meal.icon} ${meal.label} 시간이 곧 시작돼요',
        '10분 후 식사 시간입니다. 준비해주세요!',
        tzNotifyTime,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      // 식사 시작 시간 알림
      final tzStartTime = tz.TZDateTime.from(
        startTime,
        tz.getLocation('Asia/Tokyo'),
      );

      await _notifications.zonedSchedule(
        i * 2 + 1, // ID: 1, 3, 5, 7 (시작 시간)
        '${meal.icon} ${meal.label} 시간이에요!',
        '${JstService.format(startTime)} ~ ${JstService.format(wake.add(Duration(minutes: meal.endMins)))} 사이에 식사해주세요',
        tzStartTime,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  /// 모든 알림 취소
  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// 특정 알림 취소
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  /// 예약된 알림 목록 확인 (디버깅용)
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
