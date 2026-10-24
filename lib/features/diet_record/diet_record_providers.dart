import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/data/repositories/hive_diet_record_repository.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';

/// Opened during bootstrap and injected with `overrideWithValue`.
final dietRecordBoxProvider = Provider<Box<DietRecordModel>>(
  (ref) => throw UnimplementedError('dietRecordBoxProvider is not opened'),
);

final dietRecordRepositoryProvider = Provider<DietRecordRepository>(
  (ref) => HiveDietRecordRepository(ref.watch(dietRecordBoxProvider)),
);

/// All day records, re-emitted whenever any of them changes.
///
/// Screens derive their state from this stream, so a write from anywhere
/// (a dialog, the coach, a background analysis) shows up everywhere.
final dietRecordsProvider = StreamProvider<Map<int, DietRecord>>(
  (ref) => ref.watch(dietRecordRepositoryProvider).watchAll(),
);
