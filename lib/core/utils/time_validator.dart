import 'package:flutter/material.dart';

/// 기상/취침 시간 검증 헬퍼 클래스
class TimeValidator {
  /// 기상 시간이 늦은지 확인 (05:00~09:00 범위 벗어남)
  static bool isWakeTimeLate(TimeOfDay time) {
    return time.hour < 5 || time.hour > 9;
  }

  /// 취침 시간이 늦은지 확인 (00:00~05:00)
  /// 지방 분해 골든타임(자정~새벽 4시) 체크용
  static bool isBedtimeLate(TimeOfDay time) {
    return time.hour >= 0 && time.hour <= 5;
  }

  /// 수면 시간 계산 (시간 단위)
  static double getSleepDuration(TimeOfDay bedtime, TimeOfDay wakeTime) {
    final bedMinutes = bedtime.hour * 60 + bedtime.minute;
    final wakeMinutes = wakeTime.hour * 60 + wakeTime.minute;

    var duration = (wakeMinutes - bedMinutes) / 60.0;
    // 자정 넘어가는 경우 처리
    if (duration < 0) duration += 24;

    return duration;
  }

  /// 수면 시간이 부족한지 확인 (6시간 미만)
  static bool isSleepDeprived(TimeOfDay bedtime, TimeOfDay wakeTime) {
    return getSleepDuration(bedtime, wakeTime) < 6;
  }

  /// 수면 시간을 "N시간 M분" 형식으로 포맷
  static String formatSleepDuration(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '$h시간 $m분';
  }
}
