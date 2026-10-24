import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';

/// Day records keyed by program day (1-28).
///
/// Reads are synchronous because the local store is fully loaded once it is
/// opened; writes are asynchronous.
abstract interface class DietRecordRepository {
  DietRecord? get(int day);

  Map<int, DietRecord> getAll();

  Future<void> save(int day, DietRecord record);

  /// Emits the current records, then again after every change.
  Stream<Map<int, DietRecord>> watchAll();

  Future<void> clear();
}
