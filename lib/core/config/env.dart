import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Values injected at build or run time.
abstract final class Env {
  /// `--dart-define=ANTHROPIC_API_KEY=...` takes precedence over the
  /// `ANTHROPIC_API_KEY` entry in `.env`. Empty when neither is set.
  static String get anthropicApiKey {
    const fromDefine = String.fromEnvironment('ANTHROPIC_API_KEY');
    if (fromDefine.isNotEmpty) return fromDefine;
    return dotenv.isInitialized ? dotenv.env['ANTHROPIC_API_KEY'] ?? '' : '';
  }
}
