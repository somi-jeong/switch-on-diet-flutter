import 'package:flutter/material.dart';
import 'package:switchon_diet/features/coach/domain/entities/chat_message.dart';

const _darkGreen = Color(0xFF1F2A24);
const _midGreen = Color(0xFF2F8F63);
const _bubbleBg = Color(0xFFF0F5EF);
const _bubbleBorder = Color(0xFFE0EAD0);

/// `HH:mm` in JST for a stored timestamp, or empty if it cannot be parsed.
String _formatTime(String iso) {
  try {
    final d = DateTime.parse(iso).toUtc().add(const Duration(hours: 9));
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  } on FormatException {
    return '';
  }
}

class ChatDetailHeader extends StatelessWidget {
  const ChatDetailHeader({
    super.key,
    required this.day,
    required this.date,
    required this.messageCount,
    required this.isToday,
  });

  final int day;
  final String date;
  final int messageCount;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_darkGreen, Color(0xFF2F4A38)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chevron_left,
                      color: Color(0x88FFFFFF),
                      size: 18,
                    ),
                    Text(
                      '히스토리',
                      style: TextStyle(fontSize: 13, color: Color(0x88FFFFFF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Day $day · $date',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.02,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '대화 $messageCount개',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _midGreen,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        '오늘',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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

class DaySummaryCard extends StatelessWidget {
  const DaySummaryCard({super.key, required this.summary});

  final String? summary;

  @override
  Widget build(BuildContext context) {
    final summary = this.summary ?? '';
    final hasSummary = summary.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasSummary ? const Color(0xFFF3F7F0) : const Color(0xFFFFF8F0),
        border: Border.all(
          color: hasSummary ? const Color(0xFFD8EAD8) : const Color(0xFFFFD0A0),
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🤖 하루 요약',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: hasSummary ? _midGreen : const Color(0xFFE65100),
                  letterSpacing: 0.03,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                hasSummary ? '(코치 메모리)' : '(마감 후 생성)',
                style: TextStyle(
                  fontSize: 10,
                  color: hasSummary
                      ? _midGreen.withValues(alpha: 0.6)
                      : const Color(0xFFE65100).withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            hasSummary ? summary : '아직 진행 중이에요. 하루 마감 시 요약이 생성됩니다.',
            style: TextStyle(
              fontSize: 12,
              height: 1.55,
              color: hasSummary
                  ? const Color(0xFF444444)
                  : const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeDivider extends StatelessWidget {
  const TimeDivider(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Color(0xFFBBBBBB)),
            ),
          ),
          Expanded(child: Container(height: 1, color: const Color(0xFFEEEEEE))),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[const _AiAvatar(), const SizedBox(width: 7)],
          Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: isUser ? _darkGreen : _bubbleBg,
                  border: isUser ? null : Border.all(color: _bubbleBorder),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(14),
                    topRight: const Radius.circular(14),
                    bottomLeft: Radius.circular(isUser ? 14 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 14),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.55,
                    color: isUser ? Colors.white : const Color(0xFF222222),
                  ),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(message.timestamp),
                style: const TextStyle(fontSize: 9, color: Color(0xFFBBBBBB)),
              ),
            ],
          ),
          if (isUser) const SizedBox(width: 7),
        ],
      ),
    );
  }
}

class TypingBubble extends StatelessWidget {
  const TypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AiAvatar(),
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
            decoration: BoxDecoration(
              color: _bubbleBg,
              border: Border.all(color: _bubbleBorder),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_midGreen),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '답변 생성 중...',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuggestionChips extends StatelessWidget {
  const SuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, top: 8, bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((chip) {
          return GestureDetector(
            onTap: () => onSelected(chip),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFD1D5DB)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                chip,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required this.textController,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController textController;
  final bool sending;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 14),
                onSubmitted: onSend,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, child) {
              final hasText = value.text.isNotEmpty;
              final canSend = hasText && !sending;
              return GestureDetector(
                onTap: canSend ? () => onSend(textController.text) : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: canSend ? _darkGreen : const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send,
                          size: 20,
                          color: canSend
                              ? Colors.white
                              : const Color(0xFF9CA3AF),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_darkGreen, _midGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Center(child: Text('🤖', style: TextStyle(fontSize: 10))),
    );
  }
}
