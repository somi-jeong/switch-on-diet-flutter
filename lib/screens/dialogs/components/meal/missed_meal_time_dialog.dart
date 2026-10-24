import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/clock.dart';

/// Dialog for selecting the time when a missed meal was actually eaten
/// Shows when user wants to record a meal after its recommended time window
class MissedMealTimeDialog extends StatefulWidget {
  final String mealLabel;
  final String wakeTimeIso;
  final String recommendedTime;

  const MissedMealTimeDialog({
    super.key,
    required this.mealLabel,
    required this.wakeTimeIso,
    required this.recommendedTime,
  });

  @override
  State<MissedMealTimeDialog> createState() => _MissedMealTimeDialogState();
}

class _MissedMealTimeDialogState extends State<MissedMealTimeDialog> {
  int selectedHour = 12;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with recommended time
    try {
      final parts = widget.recommendedTime.split(':');
      if (parts.length == 2) {
        selectedHour = int.parse(parts[0]);
        selectedMinute = int.parse(parts[1]);
      }
    } catch (e) {
      // Use current time if recommended time parsing fails
      final now = const JstClock().now();
      selectedHour = now.hour;
      selectedMinute = now.minute;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.access_time, size: 48, color: kPrimaryMint),
            const SizedBox(height: 16),
            Text(
              '${widget.mealLabel} 몇 시에 드셨나요?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '권장 시간: ${widget.recommendedTime}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kMidSlate,
              ),
            ),
            const SizedBox(height: 24),
            // Time picker
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hour picker
                  Expanded(
                    child: _buildTimePicker(
                      value: selectedHour,
                      maxValue: 23,
                      onChanged: (value) {
                        setState(() {
                          selectedHour = value;
                        });
                      },
                      label: '시',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  // Minute picker (in 10-minute intervals)
                  Expanded(
                    child: _buildTimePicker(
                      value: selectedMinute ~/ 10,
                      maxValue: 5,
                      onChanged: (value) {
                        setState(() {
                          selectedMinute = value * 10;
                        });
                      },
                      label: '분',
                      formatter: (value) =>
                          (value * 10).toString().padLeft(2, '0'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: kLightSlate,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kBorder),
                      ),
                      child: const Center(
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kMidSlate,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final timeString =
                          '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';
                      Navigator.pop(context, timeString);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: kPrimaryMint,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryMint.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: kDarkSlate,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker({
    required int value,
    required int maxValue,
    required ValueChanged<int> onChanged,
    required String label,
    String Function(int)? formatter,
  }) {
    final displayFormatter =
        formatter ?? (val) => val.toString().padLeft(2, '0');

    return Column(
      children: [
        Expanded(
          child: ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: value),
            itemExtent: 50,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index > maxValue) return null;
                final isSelected = index == value;
                return Center(
                  child: Text(
                    displayFormatter(index),
                    style: TextStyle(
                      fontSize: isSelected ? 28 : 20,
                      fontWeight: isSelected
                          ? FontWeight.w900
                          : FontWeight.w500,
                      color: isSelected ? kPrimaryMint : kMidSlate,
                    ),
                  ),
                );
              },
              childCount: maxValue + 1,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kMidSlate,
          ),
        ),
      ],
    );
  }
}

/// Show the missed meal time dialog
Future<String?> showMissedMealTimeDialog(
  BuildContext context, {
  required String mealLabel,
  required String wakeTimeIso,
  required String recommendedTime,
}) async {
  return showDialog<String>(
    context: context,
    builder: (context) => MissedMealTimeDialog(
      mealLabel: mealLabel,
      wakeTimeIso: wakeTimeIso,
      recommendedTime: recommendedTime,
    ),
  );
}
