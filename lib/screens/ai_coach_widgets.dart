import 'package:flutter/material.dart';
import 'package:switchon_diet/constants/colors.dart';
import 'package:switchon_diet/models/chat_message.dart';

/// Reusable widgets for AI coach bottom sheet
class AiCoachWidgets {
  static Widget buildHeader({
    required int todayIdx,
    required bool analyzing,
    required Animation<double> dotAnimation,
    required VoidCallback onClose,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kLightSlate,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.arrow_back, size: 22, color: kMidSlate),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: kPrimaryMint.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 15,
              color: kEmeraldText,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'AI 코치',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: kDarkSlate,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildBubbleRow(ChatMessage msg, BuildContext context) {
    final isUser = msg.role == 'user';
    final screenWidth = MediaQuery.of(context).size.width;

    // AI messages: max 70% width, User messages: max 75% width
    final maxBubbleWidth = isUser ? screenWidth * 0.75 : screenWidth * 0.70;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: kPrimaryMint,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 16,
                color: kDarkSlate,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF475569) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                border: isUser
                    ? null
                    : Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: isUser ? Colors.white : const Color(0xFF334155),
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildQuickQuestions(Function(String) onQuestionTap) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildQuickBtn('샐러드 드레싱은 아예 안되나요?', onQuestionTap),
            const SizedBox(width: 10),
            _buildQuickBtn('너무 어지러워요', onQuestionTap),
          ],
        ),
      ),
    );
  }

  static Widget buildInputArea({
    required TextEditingController controller,
    required bool sending,
    required VoidCallback onSend,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFF1F5F9))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  fontSize: 15,
                  color: kDarkSlate,
                  letterSpacing: -0.1,
                ),
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요...',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF94A3B8),
                    letterSpacing: -0.1,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: sending ? null : onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimaryMint,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryMint.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: sending
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kDarkSlate,
                        ),
                      ),
                    )
                  : const Icon(Icons.send_rounded, color: kDarkSlate, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildQuickBtn(String text, Function(String) onTap) =>
      GestureDetector(
        onTap: () => onTap(text),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF475569),
              letterSpacing: -0.2,
            ),
          ),
        ),
      );
}
