import 'package:flutter/material.dart';
import 'package:switchon_diet/screens/dialogs/components/bedtime/bedtime_modal.dart';

/// 취침 관련 다이얼로그 모음
/// 취침 관련 다이얼로그 모음

export 'package:switchon_diet/screens/dialogs/components/bedtime/late_bedtime_warning_dialog.dart';

/// 오늘 취침 기록 모달 (오늘 취침 시간 입력)
Future<TimeOfDay?> showTodayBedtimeModal(BuildContext context) async {
  return showBedtimeModal(
    context: context,
    title: '오늘 취침 시간 기록',
    normalPrompt: '오늘 밤 몇 시에 주무실 예정인가요?',
  );
}

/// 취침 누락 모달 (어제 취침 시간 입력)
Future<TimeOfDay?> showMissedBedtimeModal(BuildContext context) async {
  return showBedtimeModal(
    context: context,
    title: '어제 취침 시간 기록',
    normalPrompt: '어제 밤 몇 시에 주무셨나요?',
  );
}
