import 'package:flutter/material.dart';

// 메인 컬러 (#13ec92 Mint Green Theme)
const kBgColor = Color(0xFFF6F8F7); // 앱 배경 (bg-[#f6f8f7])
const kPrimaryMint = Color(0xFF13EC92); // 메인 민트 (#13ec92)
const kDarkSlate = Color(0xFF1E293B); // 다크 슬레이트 (text-slate-900)
const kMidSlate = Color(0xFF64748B); // 미드 슬레이트 (text-slate-500)
const kLightSlate = Color(0xFFF1F5F9); // 라이트 슬레이트 (bg-slate-50)
const kCardBg = Color(0xFFFFFFFF); // 카드 배경 (bg-white)
const kBorder = Color(0xFFF1F5F9); // 카드 테두리 (border-slate-100)

// 기존 색상 호환성 (alias)
const kDarkGreen = kPrimaryMint; // 기존 kDarkGreen → kPrimaryMint
const kMidGreen = kPrimaryMint; // 기존 kMidGreen → kPrimaryMint
const kLightGreen = kPrimaryMint; // 기존 kLightGreen → kPrimaryMint

// 식사 시간 알림 컬러
const kMealActive = Color(0xFFFFF8F0); // 식사중 카드 배경
const kMealActiveBdr = Color(0xFFFF9F0A); // 식사중 테두리 (주황)
const kMealLate = Color(0xFFFFF5F5); // 지남 카드 배경
const kMealLateBdr = Color(0xFFFF5252); // 지남 테두리 (빨강)

// Emerald/Mint 강조 (허용, 완료)
const kEmeraldBg = Color(0xFFECFDF5); // bg-emerald-50
const kEmeraldText = Color(0xFF047857); // text-emerald-600/700
const kEmeraldBdr = Color(0xFFD1FAE5); // border-emerald-100

// Amber 주의 (식사중, 주의 태그) - 기존 호환
const kAmberBg = kAmber50; // bg-amber-50
const kAmberText = kAmber600; // text-amber-600
const kAmberBdr = Color(0xFFFDE68A); // border-amber-100
const kAmberProgress = Color(0xFFFBBF24); // bg-amber-400

// Rose/Red 경고 (금지식품, 지남, 늦은 기상)
const kRose50 = Color(0xFFFEF2F2); // bg-rose-50
const kRose100 = Color(0xFFFEE2E2); // bg-rose-100
const kRose200 = Color(0xFFFECACA); // border-rose-200
const kRose400 = Color(0xFFFB7185); // text-rose-400
const kRose500 = Color(0xFFEF4444); // bg-rose-500, text-rose-500
const kRose600 = Color(0xFFDC2626); // bg-rose-600
const kRose700 = Color(0xFFB91C1C); // text-rose-700
const kRoseBg = Color(0xFFFFF1F2); // bg-rose-50 (기존 호환)
const kRoseText = Color(0xFFE11D48); // text-rose-600
const kRoseBdr = Color(0xFFFFE4E6); // border-rose-100

// Amber 주의 추가 (수면 부족, 알림 타이밍)
const kAmber50 = Color(0xFFFFFBEB); // bg-amber-50
const kAmber100 = Color(0xFFFEF3C7); // bg-amber-100
const kAmber500 = Color(0xFFF59E0B); // bg-amber-500, text-amber-500
const kAmber600 = Color(0xFFD97706); // text-amber-600
const kAmber700 = Color(0xFFB45309); // text-amber-700

// Indigo 취침 관련
const kIndigo50 = Color(0xFFEEF2FF); // bg-indigo-50
const kIndigo100 = Color(0xFFE0E7FF); // bg-indigo-100, border-indigo-100
const kIndigo500 = Color(0xFF6366F1); // bg-indigo-500, text-indigo-500
const kIndigo600 = Color(0xFF4F46E5); // bg-indigo-600
const kIndigo700 = Color(0xFF4338CA); // text-indigo-700
const kIndigo900 = Color(0xFF312E81); // text-indigo-900

// 기존 색상 호환성 (allowed/forbid)
const kAllowedBg = kEmeraldBg;
const kAllowedText = kEmeraldText;
const kAllowedBdr = kEmeraldBdr;
const kForbidBg = kRoseBg;
const kForbidText = kRoseText;
const kForbidBdr = kRoseBdr;

// 캘린더
const kCalDone = Color(0xFF13EC92); // 완벽 80%+
const kCalPartial = Color(0xFFD1FAE5); // 양호 50%+
const kCalBad = Color(0xFFFFE4E6); // 아쉬움
const kCalFuture = Color(0xFFF5F5F5); // 예정
const kCalToday = Color(0xFF13EC92); // 오늘

// 공통 카드 스타일
BoxDecoration cardDecoration({Color? backgroundColor, Color? borderColor}) {
  return BoxDecoration(
    color: backgroundColor ?? kCardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: borderColor ?? kBorder),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 12,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
