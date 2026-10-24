import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:switchon_diet/features/coach/data/datasources/anthropic_remote_data_source.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';

void main() {
  AnthropicRemoteDataSource dataSource(
    MockClientHandler handler, {
    String apiKey = 'test-key',
  }) => AnthropicRemoteDataSource(client: MockClient(handler), apiKey: apiKey);

  Future<String> send(AnthropicRemoteDataSource source) => source.createMessage(
    system: 'system',
    messages: const [AnthropicMessage.user('hi')],
    maxTokens: 100,
  );

  test(
    'posts a Messages API request and returns the first text block',
    () async {
      late http.Request sent;
      final source = dataSource((request) async {
        sent = request;
        return http.Response.bytes(
          utf8.encode('{"content":[{"type":"text","text":"안녕하세요"}]}'),
          200,
        );
      });

      expect(await send(source), '안녕하세요');
      expect(sent.headers['x-api-key'], 'test-key');
      expect(
        sent.headers['anthropic-version'],
        AnthropicRemoteDataSource.apiVersion,
      );
      final body = jsonDecode(sent.body) as Map<String, Object?>;
      expect(body['model'], AnthropicRemoteDataSource.model);
      expect(body['max_tokens'], 100);
      expect(body['system'], 'system');
      expect(body['messages'], [
        {'role': 'user', 'content': 'hi'},
      ]);
    },
  );

  test('fails fast without an API key', () {
    final source = dataSource((_) => fail('no request expected'), apiKey: '');

    expect(send(source), throwsA(isA<MissingApiKeyFailure>()));
  });

  test('maps HTTP errors to failures', () async {
    Future<Object?> failureFor(int status, [String body = '']) async {
      try {
        await send(dataSource((_) async => http.Response(body, status)));
      } on AiFailure catch (failure) {
        return failure;
      }
      return null;
    }

    expect(await failureFor(429), isA<RateLimitFailure>());
    expect(
      await failureFor(400, 'credit balance is too low'),
      isA<CreditFailure>(),
    );
    expect(await failureFor(503), isA<ServerFailure>());
    expect(
      await failureFor(404),
      isA<UnexpectedAiFailure>().having((f) => f.statusCode, 'statusCode', 404),
    );
  });

  test('maps transport errors to a network failure', () {
    final source = dataSource((_) => throw http.ClientException('offline'));

    expect(send(source), throwsA(isA<NetworkFailure>()));
  });
}
