import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import 'history_item.dart';
import 'weekly_summary_card.dart';
import 'daily_feedback_card.dart';

class ChatHistoryList extends StatelessWidget {
  final List<HistoryItem> items;
  final Function(HistoryItem) onItemTap;

  const ChatHistoryList({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          '아직 피드백이 없습니다',
          style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length + 1,
      itemBuilder: (_, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                '더 이상 이전 기록이 없습니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final item = items[index];

        if (index == 0 ||
            items[index - 1].type != item.type ||
            (item.type == 'daily' && index == 0)) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) ...[
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, size: 16, color: kPrimaryMint),
                    SizedBox(width: 8),
                    Text(
                      '일차별 AI 총평',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              item.type == 'weekly'
                  ? WeeklySummaryCard(item: item, onTap: () => onItemTap(item))
                  : DailyFeedbackCard(item: item, onTap: () => onItemTap(item)),
            ],
          );
        }

        return item.type == 'weekly'
            ? WeeklySummaryCard(item: item, onTap: () => onItemTap(item))
            : DailyFeedbackCard(item: item, onTap: () => onItemTap(item));
      },
    );
  }
}
