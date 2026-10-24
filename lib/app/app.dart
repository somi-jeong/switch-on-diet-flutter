import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/app/main_screen.dart';
import 'package:switchon_diet/core/theme/app_theme.dart';
import 'package:switchon_diet/features/settings/presentation/onboarding_screen.dart';
import 'package:switchon_diet/features/settings/settings_providers.dart';

class SwitchOnDietApp extends StatelessWidget {
  const SwitchOnDietApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스위치온 다이어트',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      locale: const Locale('ko', 'KR'),
      home: const _AppRoot(),
    );
  }
}

/// Onboarding until the challenge has a start date, then the main shell.
class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasStarted = ref.watch(settingsProvider.select((s) => s != null));
    return hasStarted ? const MainScreen() : const OnboardingScreen();
  }
}
