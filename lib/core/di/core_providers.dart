import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:switchon_diet/core/config/env.dart';
import 'package:switchon_diet/core/time/clock.dart';

final clockProvider = Provider<Clock>((ref) => const JstClock());

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final anthropicApiKeyProvider = Provider<String>((ref) => Env.anthropicApiKey);
