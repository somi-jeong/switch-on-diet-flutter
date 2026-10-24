import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: kMidGreen),
    scaffoldBackgroundColor: kBgColor,
    fontFamily: '-apple-system',
    useMaterial3: true,
  );
}
