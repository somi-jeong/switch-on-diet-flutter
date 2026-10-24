import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:switchon_diet/core/di/core_providers.dart';
import 'package:switchon_diet/features/analysis/domain/usecases/generate_daily_feedback.dart';
import 'package:switchon_diet/features/analysis/domain/usecases/generate_weekly_summary.dart';
import 'package:switchon_diet/features/coach/coach_providers.dart';
import 'package:switchon_diet/features/diet_record/diet_record_providers.dart';

final generateDailyFeedbackProvider = Provider<GenerateDailyFeedback>(
  (ref) => GenerateDailyFeedback(
    records: ref.watch(dietRecordRepositoryProvider),
    coach: ref.watch(aiCoachRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);

final generateWeeklySummaryProvider = Provider<GenerateWeeklySummary>(
  (ref) => GenerateWeeklySummary(
    records: ref.watch(dietRecordRepositoryProvider),
    coach: ref.watch(aiCoachRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
