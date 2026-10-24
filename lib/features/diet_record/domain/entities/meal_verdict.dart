/// The AI coach's judgement of a meal against the current week's food rules.
enum MealVerdict {
  allowed('ALLOWED'),
  warning('WARNING'),
  forbidden('FORBIDDEN');

  const MealVerdict(this.code);

  /// Stable identifier used in storage and in model output.
  final String code;

  static MealVerdict? fromCode(String? code) {
    for (final verdict in values) {
      if (verdict.code == code) return verdict;
    }
    return null;
  }
}
