/// Title and one-line guide for the program phase a day belongs to.
class ProgramPhase {
  const ProgramPhase._(this.title, this.guide);

  factory ProgramPhase.forDay(int day) {
    if (day <= 3) return _gutRest;
    if (day <= 7) return _fatBurn;
    if (day <= 14) return _acceleration;
    if (day <= 21) return _transition;
    return _completion;
  }

  final String title;
  final String guide;

  static const _gutRest = ProgramPhase._(
    '위장관 휴식 기간 🌿',
    '오늘은 단백질 쉐이크만\n하루 4번 먹는 날이에요.',
  );
  static const _fatBurn = ProgramPhase._(
    '지방 대사 활성화 🔥',
    '점심에만 잡곡밥을 곁들이고\n나머지는 단백질 쉐이크예요.',
  );
  static const _acceleration = ProgramPhase._(
    '가속기 🚀',
    '점심은 잡곡밥 + 반찬, 저녁은\n저탄수화물 식사예요.',
  );
  static const _transition = ProgramPhase._(
    '체질 전환기 🌱',
    '이번 주는 24시간 단식을\n주 2회 실천해요.',
  );
  static const _completion = ProgramPhase._(
    '완성기 🌳',
    '이번 주는 24시간 단식을\n주 3회 실천해요.',
  );
}
