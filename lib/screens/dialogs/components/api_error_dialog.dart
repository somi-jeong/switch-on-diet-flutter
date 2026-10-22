import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';

/// API 오류 타입
enum ApiErrorType {
  rateLimitExceeded, // API 한도 초과 (429)
  insufficientCredits, // 크레딧 부족
  serverError, // 서버 오류 (500+)
  networkError, // 네트워크 오류
  unknown, // 기타 오류
}

class ApiErrorDialog extends StatelessWidget {
  final ApiErrorType errorType;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const ApiErrorDialog({
    super.key,
    required this.errorType,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: errorInfo.iconBgColor,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  errorInfo.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 제목
            Text(
              errorInfo.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kDarkSlate,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 설명
            Text(
              errorInfo.message,
              style: const TextStyle(
                fontSize: 14,
                color: kMidSlate,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),

            // 기술적 에러 메시지 (있을 경우)
            if (errorMessage != null && errorMessage!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kLightSlate,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kMidSlate,
                    fontFamily: 'monospace',
                    height: 1.4,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 버튼
            Row(
              children: [
                if (onRetry != null) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kMidSlate,
                        side: const BorderSide(color: kBorder, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRetry?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryMint,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '다시 시도',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryMint,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo() {
    switch (errorType) {
      case ApiErrorType.rateLimitExceeded:
        return const _ErrorInfo(
          icon: '⏱️',
          iconBgColor: kAmber50,
          title: 'API 요청 한도 초과',
          message: '잠시 후 다시 시도해주세요.\n\n요청이 너무 많아서 일시적으로\n제한되었습니다.',
        );

      case ApiErrorType.insufficientCredits:
        return const _ErrorInfo(
          icon: '💳',
          iconBgColor: kRose50,
          title: 'API 크레딧 부족',
          message: 'Claude API 사용량이 부족합니다.\n\nAPI 키 계정을 확인해주세요.',
        );

      case ApiErrorType.serverError:
        return const _ErrorInfo(
          icon: '🔧',
          iconBgColor: kAmber50,
          title: '일시적인 시스템 오류',
          message: 'Claude 서버에 일시적인 문제가\n발생했습니다.\n\n잠시 후 다시 시도해주세요.',
        );

      case ApiErrorType.networkError:
        return const _ErrorInfo(
          icon: '📡',
          iconBgColor: kIndigo50,
          title: '네트워크 연결 오류',
          message: '인터넷 연결을 확인해주세요.\n\n네트워크가 불안정합니다.',
        );

      case ApiErrorType.unknown:
        return const _ErrorInfo(
          icon: '⚠️',
          iconBgColor: kRose50,
          title: '알 수 없는 오류',
          message: '죄송해요, 예기치 않은 오류가\n발생했습니다.\n\n잠시 후 다시 시도해주세요.',
        );
    }
  }

  /// 에러 타입을 HTTP 상태 코드로부터 추론
  static ApiErrorType fromStatusCode(int statusCode) {
    if (statusCode == 429) {
      return ApiErrorType.rateLimitExceeded;
    } else if (statusCode == 402 || statusCode == 403) {
      return ApiErrorType.insufficientCredits;
    } else if (statusCode >= 500) {
      return ApiErrorType.serverError;
    } else {
      return ApiErrorType.unknown;
    }
  }

  /// 에러 메시지로부터 타입 추론
  static ApiErrorType fromErrorMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('rate limit') ||
        lowerMessage.contains('too many requests') ||
        lowerMessage.contains('429')) {
      return ApiErrorType.rateLimitExceeded;
    } else if (lowerMessage.contains('credit') ||
        lowerMessage.contains('insufficient') ||
        lowerMessage.contains('quota') ||
        lowerMessage.contains('402') ||
        lowerMessage.contains('403')) {
      return ApiErrorType.insufficientCredits;
    } else if (lowerMessage.contains('network') ||
        lowerMessage.contains('connection') ||
        lowerMessage.contains('timeout')) {
      return ApiErrorType.networkError;
    } else if (lowerMessage.contains('500') ||
        lowerMessage.contains('502') ||
        lowerMessage.contains('503') ||
        lowerMessage.contains('server')) {
      return ApiErrorType.serverError;
    } else {
      return ApiErrorType.unknown;
    }
  }
}

class _ErrorInfo {
  final String icon;
  final Color iconBgColor;
  final String title;
  final String message;

  const _ErrorInfo({
    required this.icon,
    required this.iconBgColor,
    required this.title,
    required this.message,
  });
}

/// Helper function to show API error dialog
Future<void> showApiErrorDialog(
  BuildContext context, {
  required ApiErrorType errorType,
  String? errorMessage,
  VoidCallback? onRetry,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => ApiErrorDialog(
      errorType: errorType,
      errorMessage: errorMessage,
      onRetry: onRetry,
    ),
  );
}
