class DietPhase {
  final String days;
  final String label;
  final List<String> allowed;
  final List<String> forbidden;

  const DietPhase({
    required this.days,
    required this.label,
    required this.allowed,
    required this.forbidden,
  });
}

class WeekData {
  final String title;
  final List<DietPhase> phases;

  const WeekData({required this.title, required this.phases});
}

const weekAllowedMap = {
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

const weekForbiddenMap = {
  '1-1': ['모든 탄수화물', '과일', '커피', '유제품', '술'],
  '1-2': ['과일', '커피', '술', '가공식품'],
  '2': ['과일', '술', '밀가루', '가공식품'],
  '3': ['술', '밀가루', '가공식품', '과도한 과일'],
  '4': ['술', '밀가루', '가공식품'],
};

const weekDataMap = {
  1: WeekData(
    title: '1주차 — 장 해독 & 스위치 ON',
    phases: [
      DietPhase(
        days: '1~3일',
        label: '장 휴식기',
        allowed: [
          '단백질 쉐이크 (하루4회)',
          '녹황색 채소',
          '두부·연두부',
          '무가당 플레인 요거트',
          '코코넛오일',
          '오이',
        ],
        forbidden: ['모든 탄수화물', '과일', '커피', '유제품', '술'],
      ),
      DietPhase(
        days: '4~7일',
        label: '렙틴 저항성 개선',
        allowed: [
          '단백질 쉐이크 (하루3회)',
          '잡곡밥 ½공기 (점심만)',
          '생선·해산물',
          '닭고기(껍질제거)',
          '달걀',
          '해조류·버섯',
        ],
        forbidden: ['과일', '커피', '술', '가공식품'],
      ),
    ],
  ),
  2: WeekData(
    title: '2주차 — 인슐린 저항성 개선',
    phases: [
      DietPhase(
        days: '8~14일',
        label: '체지방 감량 시작',
        allowed: [
          '단백질 쉐이크 (하루2회)',
          '콩류·견과류',
          '블랙커피 오전1잔',
          '우유 2잔',
          '천연치즈',
          '저탄수 점심',
          '무탄수 저녁',
        ],
        forbidden: ['과일', '술', '밀가루', '가공식품'],
      ),
    ],
  ),
  3: WeekData(
    title: '3주차 — 체질 전환',
    phases: [
      DietPhase(
        days: '15~21일',
        label: '24시간 단식 주2회',
        allowed: ['단호박·토마토', '방울토마토', '밤·바나나(운동 후)', '베리류', '2주차 허용식품 전체'],
        forbidden: ['술', '밀가루', '가공식품', '과도한 과일'],
      ),
    ],
  ),
  4: WeekData(
    title: '4주차 — 완성',
    phases: [
      DietPhase(
        days: '22~28일',
        label: '체질 완성 + 24h 단식 주3회',
        allowed: ['과일 하루1개', '4주차 저탄수 점심', '4주차 무탄수 저녁', '3주차 허용식품 전체'],
        forbidden: ['술', '밀가루', '가공식품'],
      ),
    ],
  ),
};
