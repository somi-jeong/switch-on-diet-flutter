import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/core/time/jst.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/coach/domain/ai_failure.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';
import 'package:switchon_diet/features/coach/presentation/coach_sheet/ai_coach_widgets.dart';
import 'package:switchon_diet/features/coach/presentation/widgets/api_error_dialog.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/daily_mission.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/meal_verdict.dart';

class AiCoachBottomSheet extends ConsumerStatefulWidget {
  final String todayDate;
  final int todayIdx;
  final String startDate;

  const AiCoachBottomSheet({
    super.key,
    required this.todayDate,
    required this.todayIdx,
    required this.startDate,
  });

  @override
  ConsumerState<AiCoachBottomSheet> createState() => _AiCoachBottomSheetState();
}

class _AiCoachBottomSheetState extends ConsumerState<AiCoachBottomSheet>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _loading = false;
  bool _sending = false;
  bool _analyzing = true;

  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    _loadHistory();
    _sendInitialMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    final msgs = await ref
        .read(chatRepositoryProvider)
        .history(widget.todayDate);
    setState(() {
      _messages = [...msgs];
      _loading = false;
    });
    _scrollToBottom();
  }

  Future<void> _sendInitialMessage() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _analyzing = false);

    if (_messages.isEmpty) {
      // 현재 상태 분석
      final records = ref.read(dietRecordRepositoryProvider);
      final todayRecord = records.get(widget.todayIdx);
      final yesterdayRecord = widget.todayIdx > 1
          ? records.get(widget.todayIdx - 1)
          : null;

      final now = ref.read(clockProvider).now();
      final currentHour = now.hour;

      // 상태 분석
      final List<String> issues = [];
      final List<String> positives = [];

      // 0. 과거 미입력 일자 체크 (오늘 이전)
      final List<int> pastMissingDays = [];
      for (int i = 1; i < widget.todayIdx; i++) {
        final pastRecord = records.get(i);
        if (pastRecord == null || pastRecord.wakeTime == null) {
          pastMissingDays.add(i);
        }
      }

      if (pastMissingDays.isNotEmpty) {
        if (pastMissingDays.length == 1) {
          issues.add('${pastMissingDays[0]}일차 기록이 없어요');
        } else if (pastMissingDays.length <= 3) {
          issues.add('${pastMissingDays.join(", ")}일차 기록이 없어요');
        } else {
          issues.add('과거 ${pastMissingDays.length}일 기록이 비어있어요');
        }
      }

      if (todayRecord != null) {
        // 1. 기상 시간 체크
        if (todayRecord.wakeTime == null) {
          issues.add('오늘 기상 시간을 입력하지 않으셨네요');
        } else {
          final wake = Jst.parse(todayRecord.wakeTime!);
          if (wake.hour >= 9) {
            issues.add('${wake.hour}시 ${wake.minute}분 기상으로 늦은 편이에요');
          }
        }

        // 2. 식사 기록 체크
        int uncheckedCount = 0;
        int lateCount = 0;
        int violationCount = 0;

        for (final meal in todayRecord.meals) {
          if (!meal.checked && !meal.skipped) {
            uncheckedCount++;
          }
          if (meal.lateReason != null) {
            lateCount++;
          }
          if (meal.verdict == MealVerdict.forbidden) {
            violationCount++;
          }
        }

        if (uncheckedCount > 0) {
          issues.add('아직 입력 안 한 식사가 $uncheckedCount끼 있어요');
        }
        if (lateCount > 0) {
          issues.add('실시간 기록이 아닌 늦은 입력이 $lateCount건 있네요');
        }
        if (violationCount > 0) {
          issues.add('허용되지 않은 음식을 $violationCount번 드셨어요');
        }

        // 3. 데일리 미션 체크
        final missedMissions = [
          for (final mission in DailyMission.values)
            if (!todayRecord.isMissionDone(mission)) mission.label,
        ];

        if (missedMissions.isNotEmpty && currentHour >= 18) {
          issues.add('오늘 데일리 미션 중 ${missedMissions.join(', ')}를 아직 안 하셨네요');
        }

        // 긍정적인 부분
        if (uncheckedCount == 0 && todayRecord.meals.isNotEmpty) {
          positives.add('오늘 식사를 모두 기록하셨네요');
        }
        if (violationCount == 0 && todayRecord.meals.isNotEmpty) {
          positives.add('식단 규칙을 잘 지키고 계세요');
        }
      }

      // 어제 기록이 있으면 추가
      String yesterdaySummary = '';
      if (yesterdayRecord != null && yesterdayRecord.aiFeedback != null) {
        yesterdaySummary =
            '\n\n💭 어제: ${yesterdayRecord.score >= 80
                ? '완벽했어요!'
                : yesterdayRecord.score >= 60
                ? '잘하셨어요'
                : '조금 아쉬웠어요'} (${(yesterdayRecord.score * 100).round()}%)';
      }

      // 메시지 생성 - 자연스러운 2단계 대화
      String greeting;
      if (issues.isEmpty && positives.isEmpty) {
        // 문제 없을 때
        greeting =
            '안녕하세요! 스위치온 다이어트 ${widget.todayIdx}일차입니다 😊\n\n오늘 순조롭게 잘 진행하고 계시네요! 궁금한 점이 있으면 언제든 물어보세요.$yesterdaySummary';
      } else {
        // 문제 있을 때 - 인사 후 "그런데..."로 자연스럽게 연결
        final issueText = issues.isNotEmpty ? '⚠️ ${issues.join('\n⚠️ ')}' : '';
        final positiveText = positives.isNotEmpty
            ? '\n\n✅ ${positives.join('\n✅ ')}'
            : '';

        // 현재 시간 정보 추가
        final timeInfo = currentHour >= 20
            ? '\n\n지금 $currentHour시인데'
            : currentHour >= 18
            ? '\n\n저녁 시간이 다가오는데'
            : '';

        greeting =
            '안녕하세요! 스위치온 다이어트 ${widget.todayIdx}일차입니다 😊\n\n그런데...$timeInfo 확인해보니:\n\n$issueText$positiveText\n\n${issues.isNotEmpty ? '오늘 기록을 먼저 완성해주시면 좋겠어요! ' : ''}궁금한 점 있으시면 물어보세요.$yesterdaySummary';
      }

      final message = ChatMessage(
        role: ChatRole.assistant,
        text: greeting,
        timestamp: ref.read(clockProvider).now().toIso8601String(),
      );

      setState(() {
        _messages.add(message);
      });

      await ref.read(chatRepositoryProvider).append(widget.todayDate, message);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? quickQuestion]) async {
    final text = quickQuestion ?? _controller.text.trim();
    if (text.isEmpty || _sending) return;

    final userMsg = ChatMessage(
      role: ChatRole.user,
      text: text,
      timestamp: ref.read(clockProvider).now().toIso8601String(),
    );

    setState(() {
      _messages.add(userMsg);
      _sending = true;
      _controller.clear();
    });
    _scrollToBottom();

    final history = _messages.sublist(0, _messages.length - 1);
    final chats = ref.read(chatRepositoryProvider);
    await chats.append(widget.todayDate, userMsg);

    try {
      final reply = await ref
          .read(sendCoachMessageProvider)
          .call(day: widget.todayIdx, message: text, history: history);

      final aiMsg = ChatMessage(
        role: ChatRole.assistant,
        text: reply.text,
        timestamp: ref.read(clockProvider).now().toIso8601String(),
      );

      setState(() => _messages.add(aiMsg));
      await chats.append(widget.todayDate, aiMsg);
      _scrollToBottom();
    } on MissingApiKeyFailure {
      _showUnexpectedError();
    } on AiFailure catch (failure) {
      // Remove user message from UI (will retry on button press)
      setState(() => _messages.removeLast());

      if (mounted) {
        await showApiErrorDialog(
          context,
          errorType: ApiErrorType.of(failure),
          errorMessage: switch (failure) {
            ServerFailure(:final statusCode) => 'HTTP $statusCode',
            UnexpectedAiFailure(:final statusCode?) => 'HTTP $statusCode',
            _ => null,
          },
          onRetry: () {
            // Re-add user message and retry
            setState(() => _messages.add(userMsg));
            _sendMessage();
          },
        );
      }
    } finally {
      setState(() => _sending = false);
    }
  }

  void _showUnexpectedError() {
    final errorMsg = ChatMessage(
      role: ChatRole.assistant,
      text: '죄송해요, 예기치 않은 오류가 발생했어요. 다시 시도해주세요.',
      timestamp: ref.read(clockProvider).now().toIso8601String(),
    );
    setState(() => _messages.add(errorMsg));
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          // Top safe area spacer
          Container(height: topPadding, color: Colors.white),
          AiCoachWidgets.buildHeader(
            todayIdx: widget.todayIdx,
            analyzing: _analyzing,
            dotAnimation: _dotController,
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              color: kBgColor,
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryMint),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      itemCount: _messages.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                                bottom: 24,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '오늘',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return AiCoachWidgets.buildBubbleRow(
                          _messages[i - 1],
                          context,
                        );
                      },
                    ),
            ),
          ),
          AiCoachWidgets.buildQuickQuestions(_sendMessage),
          AiCoachWidgets.buildInputArea(
            controller: _controller,
            sending: _sending,
            onSend: _sendMessage,
          ),
          // Bottom safe area spacer
          Container(height: bottomPadding, color: Colors.white),
        ],
      ),
    );
  }
}
