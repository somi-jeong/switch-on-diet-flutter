import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';

/// One turn of a Messages API conversation.
class AnthropicMessage {
  const AnthropicMessage({required this.role, required this.content});

  const AnthropicMessage.user(String content)
    : this(role: 'user', content: content);

  final String role;
  final String content;

  Map<String, String> toJson() => {'role': role, 'content': content};
}

/// Thin client for the Anthropic Messages API.
///
/// Translates transport and HTTP errors into [AiFailure]s so that nothing
/// above the data layer has to know about status codes.
class AnthropicRemoteDataSource {
  AnthropicRemoteDataSource({
    required http.Client client,
    required String apiKey,
  }) : _client = client,
       _apiKey = apiKey;

  static final _endpoint = Uri.parse('https://api.anthropic.com/v1/messages');
  static const model = 'claude-haiku-4-5-20251001';
  static const apiVersion = '2023-06-01';

  final http.Client _client;
  final String _apiKey;

  /// Returns the text of the first content block of the reply.
  Future<String> createMessage({
    required String system,
    required List<AnthropicMessage> messages,
    required int maxTokens,
    double temperature = 0.7,
  }) async {
    if (_apiKey.isEmpty) throw const MissingApiKeyFailure();

    final http.Response response;
    try {
      response = await _client.post(
        _endpoint,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': apiVersion,
        },
        body: jsonEncode({
          'model': model,
          'max_tokens': maxTokens,
          'temperature': temperature,
          'system': system,
          'messages': [for (final m in messages) m.toJson()],
        }),
      );
    } on http.ClientException {
      throw const NetworkFailure();
    }

    if (response.statusCode != 200) {
      throw failureFor(response.statusCode, response.body);
    }
    return _firstText(utf8.decode(response.bodyBytes));
  }

  static String _firstText(String body) {
    try {
      final json = jsonDecode(body) as Map<String, Object?>;
      final content = json['content']! as List<Object?>;
      final block = content.first! as Map<String, Object?>;
      return block['text']! as String;
    } on Object catch (e) {
      throw UnexpectedAiFailure(statusCode: 200, message: '$e');
    }
  }

  static AiFailure failureFor(int statusCode, String body) {
    final message = body.toLowerCase();
    if (statusCode == 429 ||
        message.contains('rate limit') ||
        message.contains('too many requests')) {
      return const RateLimitFailure();
    }
    if (statusCode == 402 ||
        statusCode == 403 ||
        message.contains('credit') ||
        message.contains('quota') ||
        message.contains('insufficient')) {
      return const CreditFailure();
    }
    if (statusCode >= 500 && statusCode < 600) return ServerFailure(statusCode);
    return UnexpectedAiFailure(statusCode: statusCode, message: body);
  }
}
