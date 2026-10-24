import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/screens/dialogs/components/bedtime/bedtime_warning_box.dart';
import 'package:switchon_diet/screens/dialogs/components/bedtime/late_bedtime_warning_dialog.dart';

/// 취침 시간 입력 모달 (공통)
Future<TimeOfDay?> showBedtimeModal({
  required BuildContext context,
  required String title,
  required String normalPrompt,
}) async {
  TimeOfDay selectedTime = const TimeOfDay(hour: 23, minute: 0);

  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final isBedtimeLate = selectedTime.hour >= 0 && selectedTime.hour <= 5;

        return Container(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: kIndigo50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.nightlight_round,
                      size: 20,
                      color: kIndigo500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: kDarkSlate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (isBedtimeLate)
                const BedtimeWarningBox()
              else
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    normalPrompt,
                    style: const TextStyle(fontSize: 14, color: kMidSlate),
                  ),
                ),
              GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: kIndigo500,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: kLightSlate,
                    border: Border.all(
                      color: isBedtimeLate
                          ? const Color(0xFFC7D2FE)
                          : const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      selectedTime.format(context),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: isBedtimeLate ? kIndigo500 : kDarkSlate,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (isBedtimeLate) {
                          final confirmed = await showLateBedtimeWarning(
                            context,
                          );
                          if (confirmed == true && context.mounted) {
                            Navigator.pop(context, selectedTime);
                          }
                        } else {
                          Navigator.pop(context, selectedTime);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kIndigo500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '기록 완료',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}
