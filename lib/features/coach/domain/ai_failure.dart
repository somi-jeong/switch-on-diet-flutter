/// Why a request to the AI coach failed. Thrown by [AiCoachRepository].
sealed class AiFailure implements Exception {
  const AiFailure();

  /// The HTTP status of the failed response, if there was one.
  int? get statusCode => null;
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
  const RateLimitFailure({this.statusCode});

  @override
  final int? statusCode;
}

final class CreditFailure extends AiFailure {
  const CreditFailure({this.statusCode});

  @override
  final int? statusCode;
}

final class ServerFailure extends AiFailure {
  const ServerFailure(this.statusCode);

  @override
  final int statusCode;
}

final class UnexpectedAiFailure extends AiFailure {
  const UnexpectedAiFailure({this.statusCode, this.message});

  @override
  final int? statusCode;
  final String? message;

  @override
  String toString() => 'UnexpectedAiFailure($statusCode): $message';
}
