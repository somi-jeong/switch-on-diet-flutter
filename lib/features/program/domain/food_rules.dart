import 'package:switchon_diet/features/program/domain/challenge_calendar.dart';

/// Foods allowed and forbidden on a given program day.
class FoodRules {
  const FoodRules._({required this.allowed, required this.forbidden});

  factory FoodRules.forDay(int day) {
    final week = ChallengeCalendar.weekOf(day);
    final key = week == 1 ? (day <= 3 ? '1-1' : '1-2') : '$week';
    return FoodRules._(
      allowed: _allowed[key] ?? _allowed['1-2']!,
      forbidden: _forbidden[key] ?? _forbidden['1-2']!,
    );
  }

  final List<String> allowed;
  final List<String> forbidden;

  static const _allowed = {
    '1-1': ['단백질 쉐이크(하루4회)', '녹황색 채소', '두부·연두부', '무가당 플레인 요거트', '코코넛오일', '오이'],
    '1-2': [
      '단백질 쉐이크(하루3회)',
      '잡곡밥 ½공기(점심만)',
      '생선·해산물',
      '닭고기(껍질제거)',
      '달걀',
      '해조류·버섯',
    ],
    '2': [
      '단백질 쉐이크(하루2회)',
      '콩류·견과류',
      '블랙커피 오전1잔',
      '우유 2잔',
      '천연치즈',
      '저탄수 점심',
      '무탄수 저녁',
    ],
    '3': ['단호박·토마토', '방울토마토', '밤·바나나(운동후)', '베리류', '2주차 허용식품 전체'],
    '4': ['과일 하루1개', '저탄수 점심', '무탄수 저녁', '3주차 허용식품 전체'],
  };

  static const _forbidden = {
    '1-1': ['모든 탄수화물', '과일', '커피', '유제품', '술'],
    '1-2': ['과일', '커피', '술', '가공식품'],
    '2': ['과일', '술', '밀가루', '가공식품'],
    '3': ['술', '밀가루', '가공식품', '과도한 과일'],
    '4': ['술', '밀가루', '가공식품'],
  };
}
