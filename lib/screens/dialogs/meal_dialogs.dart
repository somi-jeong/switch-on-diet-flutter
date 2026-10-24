import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

export 'package:switchon_diet/screens/dialogs/components/meal/error_dialog.dart';

/// Dialog builders for meal-related UI interactions
/// Re-export commonly used dialogs
export 'package:switchon_diet/screens/dialogs/components/meal/loading_dialog.dart';
export 'package:switchon_diet/screens/dialogs/components/meal/past_date_warning_dialog.dart';
export 'package:switchon_diet/screens/dialogs/components/meal/skip_warning_dialog.dart';

class MealDialogs {
  /// Shows a wake time confirmation dialog for unusual wake times
  static Future<bool?> showWakeTimeConfirmation(
    BuildContext context,
    int hour,
    int minute,
  ) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(children: [Text('🤔 기상 시간 확인')]),
        content: Text(
          '지금 ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}에 기상하신 게 맞나요?\n\n권장 기상 시간: 05:00 ~ 09:30',
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: kMidGreen),
            child: const Text('예, 맞아요'),
          ),
        ],
      ),
    );
  }

  /// Shows an AI feedback dialog
  static Future<void> showAiFeedbackDialog(
    BuildContext context,
    String title,
    String feedback,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(children: [Text(title)]),
        content: SingleChildScrollView(
          child: Text(
            feedback,
            style: const TextStyle(fontSize: 15, height: 1.5),
            softWrap: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(foregroundColor: kMidGreen),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// Shows a future time error dialog
  static Future<void> showFutureTimeError(
    BuildContext context,
    VoidCallback onRetry,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Text('⚠️'),
            SizedBox(width: 8),
            Text('미래 시간 입력 불가', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: const Text(
          '미래 시간은 입력할 수 없어요.\n\n현재 시간 이전의 식사 시간을 입력해주세요.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// Shows a time range confirmation dialog
  static Future<bool?> showTimeRangeConfirmation(
    BuildContext context,
    String mealLabel,
    String inputTime,
    String startTime,
    String endTime,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 시간대 확인'),
        content: Text(
          '입력하신 시간($inputTime)은\n$mealLabel 권장 시간($startTime~$endTime)과\n다릅니다. 그래도 저장할까요?',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('다시 입력'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: kMidGreen),
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  /// Shows a rejudge confirmation dialog
  static Future<bool?> showRejudgeConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI 재판정'),
        content: const Text('수정된 시간 기준으로 AI 재판정을 받으시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: kMidGreen),
            child: const Text('예'),
          ),
        ],
      ),
    );
  }

  /// Shows a food text input dialog
  static Future<String?> showFoodTextInputDialog(BuildContext context) async {
    final TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('먹은 음식 입력'),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: '예: 현미밥, 닭가슴살, 브로콜리',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(textController.text.trim()),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// Shows a meal time edit dialog
  static Future<DateTime?> showMealTimeEditDialog(
    BuildContext context,
    DateTime? currentTime,
  ) async {
    final TextEditingController hourController = TextEditingController(
      text: currentTime != null
          ? currentTime.hour.toString().padLeft(2, '0')
          : '',
    );
    final TextEditingController minuteController = TextEditingController(
      text: currentTime != null
          ? currentTime.minute.toString().padLeft(2, '0')
          : '',
    );

    return showDialog<DateTime>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('실제로 몇 시에 드셨나요?'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              child: TextField(
                controller: hourController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'HH',
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                ':',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              width: 60,
              child: TextField(
                controller: minuteController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'mm',
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              final h = int.tryParse(hourController.text);
              final m = int.tryParse(minuteController.text);
              if (h != null &&
                  m != null &&
                  h >= 0 &&
                  h <= 23 &&
                  m >= 0 &&
                  m <= 59) {
                final now = DateTime.now();
                final eatenTime = DateTime(now.year, now.month, now.day, h, m);
                Navigator.of(context).pop(eatenTime);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('올바른 시간을 입력해주세요 (00:00~23:59)')),
                );
              }
            },
            child: const Text('수정하기'),
          ),
        ],
      ),
    );
  }
}
