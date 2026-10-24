import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

/// Bottom action buttons for RecordMealScreen
class RecordMealActions extends StatelessWidget {
  final bool canSave;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const RecordMealActions({
    super.key,
    required this.canSave,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canSave ? onSave : null,
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: const Text(
                  'AI 분석 및 기록하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: canSave ? kPrimaryMint : kLightSlate,
                  foregroundColor: canSave ? kDarkSlate : kMidSlate,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, size: 16),
              label: const Text(
                '이 기록 삭제하기',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              style: TextButton.styleFrom(
                foregroundColor: kMidSlate,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
