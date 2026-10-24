import 'package:flutter_test/flutter_test.dart';
import 'package:switchon_diet/services/parsers/claude_response_parser.dart';

void main() {
  group('ClaudeResponseParser.parseTextAnalysis', () {
    test('reads STATUS / FEEDBACK lines', () {
      final result = ClaudeResponseParser.parseTextAnalysis(
        'STATUS: warning\nFEEDBACK: 양을 조금 줄여보세요\n',
      );
      expect(result['status'], 'WARNING');
      expect(result['feedback'], '양을 조금 줄여보세요');
    });

    test('falls back to keyword detection', () {
      expect(
        ClaudeResponseParser.parseTextAnalysis('이건 금지 식품입니다')['status'],
        'FORBIDDEN',
      );
      expect(
        ClaudeResponseParser.parseTextAnalysis('괜찮아요')['status'],
        'ALLOWED',
      );
    });
  });
}
