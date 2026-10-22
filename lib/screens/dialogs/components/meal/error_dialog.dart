import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String title,
  String message,
) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Text('⚠️'),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
      content: Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
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
