import 'package:flutter/material.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/models/diet_record.dart';
import 'package:switchon_diet/screens/chat_detail/chat_detail_screen.dart';
import 'package:switchon_diet/screens/chat_history/widgets/chat_history_header.dart';
import 'package:switchon_diet/screens/chat_history/widgets/chat_history_list.dart';
import 'package:switchon_diet/screens/chat_history/widgets/chat_history_search_bar.dart';
import 'package:switchon_diet/screens/chat_history/widgets/history_item.dart';
import 'package:switchon_diet/services/storage_service.dart';

class ChatHistoryScreen extends StatefulWidget {
  final String startDate;
  final int todayIdx;

  const ChatHistoryScreen({
    super.key,
    required this.startDate,
    required this.todayIdx,
  });

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<HistoryItem> _history = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = <HistoryItem>[];

    // Load daily AI feedbacks from DietRecords
    for (int d = widget.todayIdx; d >= 1; d--) {
      final record = StorageService.getRecord(d);
      final date = _dayToDate(d);
      final msgs = await StorageService.getChatHistory(date);

      // Add weekly summaries at end of each week
      if (d % 7 == 0 && d > 0) {
        final weekNum = d ~/ 7;
        items.add(
          HistoryItem(
            type: 'weekly',
            dayIdx: d,
            weekNum: weekNum,
            date: _fmtDate(d),
            topic: '$weekNum주차 총평',
            preview: _getWeeklySummary(weekNum),
            tags: ['$weekNum주차완료', '주간리뷰'],
            record: record,
            messages: msgs,
          ),
        );
      }

      // Add daily feedback if exists
      if (record != null &&
          record.aiFeedback != null &&
          record.aiFeedback!.isNotEmpty) {
        items.add(
          HistoryItem(
            type: 'daily',
            dayIdx: d,
            weekNum: ((d - 1) ~/ 7) + 1,
            date: _fmtDate(d),
            topic: '$d일차 데일리 총평',
            preview: record.aiFeedback!,
            tags: _generateTags(record),
            record: record,
            messages: msgs,
          ),
        );
      }
    }

    setState(() {
      _history = items;
      _loading = false;
    });
  }

  String _getWeeklySummary(int weekNum) {
    // Generate weekly summary based on week number
    final weekTitles = {1: '장 비우기', 2: '가속기', 3: '도약기', 4: '안정기'};
    return '$weekNum주차 ${weekTitles[weekNum] ?? ''} 완료! 이번 주도 수고하셨습니다.';
  }

  List<String> _generateTags(DietRecord record) {
    final tags = <String>[];
    if (record.score >= 0.9) {
      tags.add('완벽');
    } else if (record.score < 0.7) {
      tags.add('주의필요');
    }
    if (record.warningCount > 0) {
      tags.add('경고${record.warningCount}회');
    }
    return tags;
  }

  String _dayToDate(int day) {
    final start = DateTime.parse(widget.startDate);
    final target = start.add(Duration(days: day - 1));
    return '${target.year}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}';
  }

  String _fmtDate(int day) {
    final start = DateTime.parse(widget.startDate);
    final d = start.add(Duration(days: day - 1));
    return '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
  }

  List<HistoryItem> get _filteredHistory {
    if (_searchQuery.isEmpty) return _history;
    return _history.where((item) {
      return item.topic.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.preview.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _navigateToDetail(HistoryItem item) {
    if (item.messages != null && item.messages!.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            day: item.dayIdx,
            date: _dayToDate(item.dayIdx),
            messages: item.messages!,
            isToday: item.dayIdx == widget.todayIdx,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Column(
          children: [
            const ChatHistoryHeader(),
            ChatHistorySearchBar(
              onSearchChanged: (value) => setState(() => _searchQuery = value),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: kPrimaryMint),
                    )
                  : ChatHistoryList(
                      items: _filteredHistory,
                      onItemTap: _navigateToDetail,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
