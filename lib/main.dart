import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_theme.dart';
import 'package:switchon_diet/screens/main_screen.dart';
import 'package:switchon_diet/screens/onboarding_screen.dart';
import 'package:switchon_diet/services/notification_service.dart';
import 'package:switchon_diet/services/storage_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  String? initError;

  try {
    debugPrint('Step 0: Loading environment variables...');
    await dotenv.load();
    debugPrint('Step 0: SUCCESS');
  } catch (e) {
    debugPrint('Step 0 FAILED: $e');
    initError = '.env file not found or invalid: $e';
  }

  try {
    debugPrint('Step 1: Initializing timezone...');
    tz.initializeTimeZones();
    debugPrint('Step 1: SUCCESS');
  } catch (e) {
    debugPrint('Step 1 FAILED: $e');
    initError = 'Timezone init failed: $e';
  }

  try {
    debugPrint('Step 2: Initializing Hive...');
    await StorageService.init();
    debugPrint('Step 2: SUCCESS');
  } catch (e, stack) {
    debugPrint('Step 2 FAILED: $e\n$stack');
    initError = 'Storage init failed: $e';
  }

  try {
    debugPrint('Step 3: Initializing Notifications...');
    await NotificationService.init();
    debugPrint('Step 3: SUCCESS');
  } catch (e, stack) {
    debugPrint('Step 3 FAILED: $e\n$stack');
    // 알림 실패는 치명적이지 않으므로 앱을 계속 실행
  }

  if (initError != null) {
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    '앱 초기화 오류',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    initError,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  } else {
    debugPrint('Step 3: Running app...');
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = StorageService.getSettings();

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
      home: settings == null ? const OnboardingScreen() : const MainScreen(),
    );
  }
}
