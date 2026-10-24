import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';

class WakeTimeSheet extends StatefulWidget {
  /// The sheet starts at this time, and the picked time is on its date.
  final DateTime now;

  /// Last night's bedtime (ISO-8601), used to show how long the user slept.
  final String? previousBedTime;

  const WakeTimeSheet({super.key, required this.now, this.previousBedTime});

  @override
  State<WakeTimeSheet> createState() => _WakeTimeSheetState();
}

class _WakeTimeSheetState extends State<WakeTimeSheet> {
  late TextEditingController _timeController;
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    _hour = widget.now.hour;
    _minute = widget.now.minute;
    _timeController = TextEditingController(
      text:
          '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  DateTime _toJst() {
    final baseDate = widget.now;
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      _hour,
      _minute,
    );
  }

  bool get _isWakeTimeLate {
    final totalMinutes = _hour * 60 + _minute;
    // 05:00~09:00 범위를 벗어난 경우 경고
    return totalMinutes < 5 * 60 || totalMinutes > 9 * 60;
  }

  bool get _isAbnormalWakeTime {
    final totalMinutes = _hour * 60 + _minute;
    // 새벽 4시 이전 또는 정오(12:00) 이후는 비정상
    return totalMinutes < 4 * 60 || totalMinutes >= 12 * 60;
  }

  ({int sleepHours, int sleepMinutes})? _getSleepDuration() {
    final bedTime = widget.previousBedTime;
    if (bedTime == null || bedTime.isEmpty) return null;

    try {
      final bedDateTime = DateTime.parse(bedTime);
      final wakeDateTime = _toJst();

      int sleepMinutes = wakeDateTime.difference(bedDateTime).inMinutes;
      if (sleepMinutes < 0) sleepMinutes += 24 * 60;

      return (sleepHours: sleepMinutes ~/ 60, sleepMinutes: sleepMinutes % 60);
    } catch (e) {
      return null;
    }
  }

  void _onTimeChanged(String value) {
    // HH:MM 형식 파싱
    final parts = value.split(':');
    if (parts.length == 2) {
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h != null && m != null && h >= 0 && h < 24 && m >= 0 && m < 60) {
        setState(() {
          _hour = h;
          _minute = m;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sleepDuration = _getSleepDuration();
    final hasLowSleep = sleepDuration != null && sleepDuration.sleepHours < 6;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 드래그 핸들
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),

              // 제목
              const Text(
                '기상 시간 수정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kDarkSlate,
                ),
              ),
              const SizedBox(height: 8),

              // 경고 메시지 (비정상 기상 - 심각)
              if (_isAbnormalWakeTime)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    border: Border.all(
                      color: const Color(0xFFFECACA),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error, size: 20, color: Color(0xFFDC2626)),
                          SizedBox(width: 8),
                          Text(
                            '비정상적인 기상 시간',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '스위치온 다이어트는 정상적인 생활 패턴을 전제로 합니다.\n\n'
                        '• 0:00~4:00 무조건 수면\n'
                        '• 최소 7시간 이상 수면\n'
                        '• 권장 기상: 05:00~09:00\n\n'
                        '정상적인 수면 패턴 없이는 다이어트 효과를 기대하기 어렵습니다.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFB91C1C),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                )
              // 경고 메시지 (늦은 기상 - 주의)
              else if (_isWakeTimeLate)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kRose50,
                    border: Border.all(color: kRose100),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, size: 16, color: kRose500),
                          SizedBox(width: 8),
                          Text(
                            '권장 기상 시간(05:00~09:00) 초과',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kRose700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '늦게 일어나면 스트레스 호르몬이 분비되어 지방이 축적되기 쉬워요. 내일은 일찍 일어나보세요!',
                        style: TextStyle(
                          fontSize: 12,
                          color: kRose600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // 경고 메시지 (수면 부족)
              if (hasLowSleep)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kAmber50,
                    border: Border.all(color: kAmber100),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning, size: 16, color: kAmber500),
                          const SizedBox(width: 8),
                          Text(
                            '수면 부족 (${sleepDuration.sleepHours}시간 ${sleepDuration.sleepMinutes}분)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: kAmber700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '최소 6시간 이상 푹 자야 가짜 배고픔을 막을 수 있어요. 오늘은 꼭 일찍 주무세요!',
                        style: TextStyle(
                          fontSize: 12,
                          color: kAmber600,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

              // 정상 메시지
              if (!_isWakeTimeLate && !hasLowSleep)
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    '기상 시간에 맞춰 오늘의 식단 알림이 재조정됩니다.',
                    style: TextStyle(fontSize: 14, color: kMidSlate),
                  ),
                ),

              // 시간 입력 필드
              TextField(
                controller: _timeController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                  LengthLimitingTextInputFormatter(5),
                ],
                onChanged: _onTimeChanged,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _isWakeTimeLate ? kRose600 : const Color(0xFF334155),
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _isWakeTimeLate
                          ? const Color(0xFFFECACA)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _isWakeTimeLate
                          ? const Color(0xFFFECACA)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _isWakeTimeLate ? kRose500 : kPrimaryMint,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),

              const SizedBox(height: 24),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        foregroundColor: const Color(0xFF64748B),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, _toJst()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryMint,
                        foregroundColor: kDarkSlate,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        '수정 완료',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
