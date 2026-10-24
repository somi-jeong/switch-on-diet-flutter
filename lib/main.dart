import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/app/app.dart';
import 'package:switchon_diet/app/bootstrap.dart';
import 'package:switchon_diet/app/init_error_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exception}\n${details.stack}');
  };

  try {
    final overrides = await bootstrap();
    runApp(ProviderScope(overrides: overrides, child: const SwitchOnDietApp()));
  } on BootstrapException catch (error) {
    runApp(InitErrorApp(message: error.message));
  }
}
