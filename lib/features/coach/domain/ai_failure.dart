/// Why a request to the AI coach failed. Thrown by [AiCoachRepository].
sealed class AiFailure implements Exception {
  const AiFailure();
}

final class MissingApiKeyFailure extends AiFailure {
  const MissingApiKeyFailure();

  @override
  String toString() =>
      'ANTHROPIC_API_KEY is not set (use --dart-define or .env)';
}

final class NetworkFailure extends AiFailure {
  const NetworkFailure();
}

final class RateLimitFailure extends AiFailure {
  const RateLimitFailure();
}

final class CreditFailure extends AiFailure {
  const CreditFailure();
}

final class ServerFailure extends AiFailure {
  const ServerFailure(this.statusCode);

  final int statusCode;
}

final class UnexpectedAiFailure extends AiFailure {
  const UnexpectedAiFailure({this.statusCode, this.message});

  final int? statusCode;
  final String? message;

  @override
  String toString() => 'UnexpectedAiFailure($statusCode): $message';
}
