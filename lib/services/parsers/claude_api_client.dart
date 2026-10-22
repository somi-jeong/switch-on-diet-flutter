import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// ClaudeApiClient - Low-level HTTP client for Claude API
class ClaudeApiClient {
  static const String apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String model = 'claude-haiku-4-5-20251001';
  static const String apiVersion = '2023-06-01';

  final String apiKey;

  ClaudeApiClient(this.apiKey);

  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'x-api-key': apiKey,
    'anthropic-version': apiVersion,
  };

  Future<String> sendRequest({
    required String system,
    required List<Map<String, dynamic>> messages,
    required int maxTokens,
    double temperature = 0.7,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({
          'model': model,
          'max_tokens': maxTokens,
          'temperature': temperature,
          'system': system,
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['content'][0]['text'] as String;
      } else {
        throw ClaudeApiException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } on SocketException {
      throw ClaudeApiException(
        statusCode: 0,
        message: 'Network connection error',
        isNetworkError: true,
      );
    } on HttpException {
      throw ClaudeApiException(
        statusCode: 0,
        message: 'HTTP error occurred',
        isNetworkError: true,
      );
    } catch (e) {
      if (e is ClaudeApiException) rethrow;
      throw ClaudeApiException(statusCode: 0, message: e.toString());
    }
  }

  Future<String> sendSimpleRequest({
    required String system,
    required String userContent,
    required int maxTokens,
    double temperature = 0.7,
  }) => sendRequest(
    system: system,
    messages: [
      {'role': 'user', 'content': userContent},
    ],
    maxTokens: maxTokens,
    temperature: temperature,
  );
}

/// Custom exception for Claude API errors
class ClaudeApiException implements Exception {
  final int statusCode;
  final String message;
  final bool isNetworkError;

  ClaudeApiException({
    required this.statusCode,
    required this.message,
    this.isNetworkError = false,
  });

  @override
  String toString() => 'ClaudeApiException: [$statusCode] $message';

  /// Check if this is a rate limit error
  bool get isRateLimitError =>
      statusCode == 429 ||
      message.toLowerCase().contains('rate limit') ||
      message.toLowerCase().contains('too many requests');

  /// Check if this is a credit/quota error
  bool get isCreditError =>
      statusCode == 402 ||
      statusCode == 403 ||
      message.toLowerCase().contains('credit') ||
      message.toLowerCase().contains('quota') ||
      message.toLowerCase().contains('insufficient');

  /// Check if this is a server error
  bool get isServerError => statusCode >= 500 && statusCode < 600;
}
