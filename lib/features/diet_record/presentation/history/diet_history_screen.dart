import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/theme/app_colors.dart';
import 'package:switchon_diet/features/diet_record/presentation/history/diet_history_state.dart';
import 'package:switchon_diet/features/diet_record/presentation/history/widgets/diet_history_day_card.dart';
import 'package:switchon_diet/features/diet_record/presentation/past_day/past_date_meal_selection_screen.dart';

class DietHistoryScreen extends ConsumerStatefulWidget {
  /// Scrolled into view when the screen opens.
  final int? initialSelectedDay;

  const DietHistoryScreen({super.key, this.initialSelectedDay});

  @override
  ConsumerState<DietHistoryScreen> createState() => _DietHistoryScreenState();
}

class _DietHistoryScreenState extends ConsumerState<DietHistoryScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final day = widget.initialSelectedDay;
    if (day != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToDay(day));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDay(int dayIdx) {
    final index = ref
        .read(dietHistoryProvider)
        .indexWhere((h) => h.day == dayIdx);
    if (index != -1 && _scrollController.hasClients) {
      // Calculate more accurate position based on card index
      // Average card height is ~450-500px, use conservative estimate
      final position = index * 476.0; // card height (452) + margin (24)

      // Ensure we don't scroll past the end
      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetScroll = position > maxScroll ? maxScroll : position;

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(dietHistoryProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: kBorder)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.chevron_left,
                        size: 24,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      '식단 및 수면 기록',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kDarkSlate,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final dayHistory = history[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => PastDateMealSelectionScreen(
                            dayIdx: dayHistory.day,
                            dateStr: dayHistory.dateLabel,
                          ),
                        ),
                      );
                    },
                    child: DietHistoryDayCard(history: dayHistory),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
