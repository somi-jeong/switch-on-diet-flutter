import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/diet_data.dart';
import 'package:switchon_diet/models/chat_message.dart';
import 'package:switchon_diet/screens/chat_detail/widgets/chat_detail_widgets.dart';
import 'package:switchon_diet/services/claude_service.dart';
import 'package:switchon_diet/services/jst_service.dart';
import 'package:switchon_diet/services/storage_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final int day;
  final String date; // "2026-03-13"
  final List<ChatMessage> messages;
  final bool isToday;

  const ChatDetailScreen({
    super.key,
    required this.day,
    required this.date,
    required this.messages,
    required this.isToday,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late List<ChatMessage> _msgs;
  String? _daySummary;
  final TextEditingController _textController = TextEditingController();
  bool _sending = false;
  final List<String> _suggestionChips = [
    '샐러드 드레싱은 아예 안되나요?',
    '치팅데이는 언제쯤 가능한가요?',
    '운동은 몇 시에 하는 게 좋나요?',
  ];

  @override
  void initState() {
    super.initState();
    _msgs = List.from(widget.messages);
    _loadSummary();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadSummary() async {
    final s = await StorageService.getDaySummary(widget.date);
    if (mounted) setState(() => _daySummary = s);
  }

  // 시간대별 구분선 (오전/오후)
  String? _dividerLabel(int index) {
    if (index == 0) return null;
    try {
      final prev = DateTime.parse(
        _msgs[index - 1].timestamp,
      ).toUtc().add(const Duration(hours: 9));
      final curr = DateTime.parse(
        _msgs[index].timestamp,
      ).toUtc().add(const Duration(hours: 9));
      if (curr.difference(prev).inMinutes > 30) {
        final h = curr.hour;
        final period = h < 12
            ? '오전'
            : h < 18
            ? '오후'
            : '저녁';
        return '$period ${curr.hour.toString().padLeft(2, '0')}:${curr.minute.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return null;
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _sending) return;

    // Create user message
    final userMsg = ChatMessage(
      role: 'user',
      text: text,
      timestamp: JstService.toIso(JstService.now()),
    );

    setState(() {
      _msgs.add(userMsg);
      _sending = true;
      _textController.clear();
    });

    // Save user message
    await StorageService.saveChatMessage(widget.date, userMsg);

    try {
      // Get today's record for context
      final todayRecord = StorageService.getRecord(widget.day);

      // Prepare meal details
      final mealDetails =
          todayRecord?.meals
              .map(
                (m) => {
                  'label': m.label,
                  'checked': m.checked,
                  'skipped': m.skipped,
                  'aiStatus': m.aiStatus,
                  'aiFeedback': m.aiFeedback,
                },
              )
              .toList() ??
          [];

      // Calculate week and get diet plan
      final week = ((widget.day - 1) ~/ 7 + 1).clamp(1, 4);
      final weekAllowedKey = week <= 1
          ? (widget.day <= 3 ? '1-1' : '1-2')
          : week.toString();

      final allowed = weekAllowedMap[weekAllowedKey] ?? weekAllowedMap['1-2']!;
      final forbidden =
          weekForbiddenMap[weekAllowedKey] ?? weekForbiddenMap['1-2']!;

      // Prepare chat history
      final chatHistory = _msgs
          .sublist(0, _msgs.length)
          .map((m) => m.toMap())
          .toList();

      // Get AI response
      final claude = ClaudeService();
      final response = await claude.chatWithCoach(
        message: text,
        day: widget.day,
        week: week,
        wakeTime: todayRecord?.wakeTime,
        mealDetails: mealDetails,
        allowedFoods: allowed,
        forbiddenFoods: forbidden,
        chatHistory: chatHistory,
      );

      // Create AI message
      final aiMsg = ChatMessage(
        role: 'assistant',
        text: response,
        timestamp: JstService.toIso(JstService.now()),
      );

      setState(() => _msgs.add(aiMsg));

      // Save AI message
      await StorageService.saveChatMessage(widget.date, aiMsg);
    } catch (e) {
      // Show error message
      final errorMsg = ChatMessage(
        role: 'assistant',
        text: '죄송해요, 일시적인 오류가 발생했어요. 다시 시도해주세요.',
        timestamp: JstService.toIso(JstService.now()),
      );
      setState(() => _msgs.add(errorMsg));
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F5),
      body: Column(
        children: [
          ChatDetailWidgets.buildHeader(
            context: context,
            day: widget.day,
            date: widget.date,
            msgCount: _msgs.length,
            isToday: widget.isToday,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 100),
              itemCount:
                  _msgs.length +
                  1 +
                  (_sending ? 1 : 0), // +1 for summary, +1 for loading
              itemBuilder: (_, i) {
                if (i == 0) {
                  return ChatDetailWidgets.buildSummaryCard(_daySummary);
                }

                // Show loading indicator at the end if sending
                if (_sending && i == _msgs.length + 1) {
                  return ChatDetailWidgets.buildLoadingBubble();
                }

                final idx = i - 1;
                final divider = _dividerLabel(idx);
                final isLastAiMessage =
                    idx < _msgs.length &&
                    _msgs[idx].role == 'assistant' &&
                    (idx == _msgs.length - 1 || _msgs[idx + 1].role == 'user');

                return Column(
                  children: [
                    if (divider != null)
                      ChatDetailWidgets.buildDivider(divider),
                    ChatDetailWidgets.buildBubbleRow(_msgs[idx], context),
                    // 제안 칩 버튼
                    if (isLastAiMessage && widget.isToday && !_sending)
                      ChatDetailWidgets.buildSuggestionChips(
                        _suggestionChips,
                        _sendMessage,
                      ),
                  ],
                );
              },
            ),
          ),
          // 실시간 채팅 입력창
          if (widget.isToday)
            ChatDetailWidgets.buildInputBar(
              context: context,
              textController: _textController,
              sending: _sending,
              onSend: _sendMessage,
            ),
        ],
      ),
    );
  }
}
