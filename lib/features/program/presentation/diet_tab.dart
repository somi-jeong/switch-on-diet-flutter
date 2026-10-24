import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class DietTab extends StatelessWidget {
  final int week;
  final int todayIdx;

  const DietTab({super.key, required this.week, required this.todayIdx});

  @override
  Widget build(BuildContext context) {
    final isPhase1 = todayIdx <= 3;
    final isPhase2 = todayIdx >= 4 && todayIdx <= 7;
    return Container(
      color: kBgColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              '주차별 식단 가이드',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: kDarkSlate,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '스위치온 다이어트 4주 플랜',
              style: TextStyle(fontSize: 14, color: kMidSlate),
            ),
            const SizedBox(height: 24),

            // Week 1 (1-3 days)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isPhase1
                    ? kPrimaryMint.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isPhase1
                      ? kPrimaryMint.withValues(alpha: 0.3)
                      : kBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1주차 (1~3일)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isPhase1 ? kEmeraldText : kDarkSlate,
                        ),
                      ),
                      if (isPhase1) _buildCurrentBadge(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '장 비우기 (위장관 휴식)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isPhase1 ? kEmeraldText : const Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '탄수화물을 제한하고 단백질 쉐이크로 섭취하며 위장관에 휴식을 주는 기간입니다.',
                    style: TextStyle(
                      fontSize: 11,
                      color: isPhase1 ? kEmeraldText : const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPhase1
                          ? Colors.white.withValues(alpha: 0.6)
                          : kLightSlate,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '식단표',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kDarkSlate,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF475569),
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: '아침/점심/간식/저녁 모두 '),
                              TextSpan(
                                text: '단백질 쉐이크 1컵',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: kEmeraldText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '허용 식품 (배고플 때)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kDarkSlate,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '플레인 요거트, 두부, 양배추, 무, 당근, 오이, 브로콜리, 파프리카 등 채소류',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF475569),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Week 1 (4-7 days)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isPhase2
                    ? kPrimaryMint.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isPhase2
                      ? kPrimaryMint.withValues(alpha: 0.3)
                      : kBorder,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '1주차 (4~7일)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kDarkSlate,
                        ),
                      ),
                      if (isPhase2) _buildCurrentBadge(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '지방 대사 활성화',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kLightSlate,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '식단 변경점',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: '점심에 한해 '),
                              TextSpan(
                                text: '현미잡곡밥 2/3공기',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              TextSpan(text: ' 또는 흰쌀밥 1/2공기 + 채소/단백질 반찬 허용'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Week 2 (8-14 days)
            _buildWeekCard(
              title: '2주차 (8~14일)',
              subtitle: '가속기 (렙틴 저항성 개선)',
              description: '점심 탄수화물을 추가하여 에너지를 공급하면서 지방 대사를 가속화하는 기간입니다.',
              diet: '점심: 현미잡곡밥 2/3공기 + 채소/단백질\n나머지 끼니: 단백질 쉐이크',
              isCurrent: week == 2,
            ),
            const SizedBox(height: 16),

            // Week 3 (15-21 days)
            _buildWeekCard(
              title: '3주차 (15~21일)',
              subtitle: '진행기 (지방 대사 최적화)',
              description: '식단을 점진적으로 정상화하며 지방 대사를 최적화하는 기간입니다.',
              diet: '아침: 현미잡곡밥 1/2공기 + 반찬\n점심: 일반식\n간식/저녁: 단백질 쉐이크',
              isCurrent: week == 3,
            ),
            const SizedBox(height: 16),

            // Week 4 (22-28 days)
            _buildWeekCard(
              title: '4주차 (22~28일)',
              subtitle: '안정기 (유지 및 정착)',
              description: '정상 식단으로 복귀하며 새로운 식습관을 정착시키는 기간입니다.',
              diet: '아침/점심: 일반식 (탄수화물 적정량)\n저녁: 가볍게 또는 쉐이크',
              isCurrent: week == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: kPrimaryMint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        '현재 단계',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: kDarkSlate,
        ),
      ),
    );
  }

  Widget _buildWeekCard({
    required String title,
    required String subtitle,
    required String description,
    required String diet,
    required bool isCurrent,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCurrent
            ? kPrimaryMint.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCurrent ? kPrimaryMint.withValues(alpha: 0.3) : kBorder,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isCurrent ? kEmeraldText : kDarkSlate,
                ),
              ),
              if (isCurrent) _buildCurrentBadge(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isCurrent ? kEmeraldText : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              color: isCurrent ? kEmeraldText : const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCurrent
                  ? Colors.white.withValues(alpha: 0.6)
                  : kLightSlate,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '식단 가이드',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isCurrent ? kDarkSlate : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  diet,
                  style: TextStyle(
                    fontSize: 11,
                    color: isCurrent
                        ? const Color(0xFF475569)
                        : const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
