import 'package:hive/hive.dart';
import 'package:switchon_diet/features/diet_record/data/mappers/diet_record_mapper.dart';
import 'package:switchon_diet/features/diet_record/data/models/diet_record_model.dart';
import 'package:switchon_diet/features/diet_record/domain/entities/diet_record.dart';
import 'package:switchon_diet/features/diet_record/domain/repositories/diet_record_repository.dart';

/// Stores each day under its program day index (an `int` key).
class HiveDietRecordRepository implements DietRecordRepository {
  HiveDietRecordRepository(this._box);

  static const boxName = 'records';

  final Box<DietRecordModel> _box;

  @override
  DietRecord? get(int day) => _box.get(day)?.toEntity();

  @override
  Map<int, DietRecord> getAll() => {
    for (final key in _box.keys.whereType<int>())
      key: _box.get(key)!.toEntity(),
  };

  @override
  Future<void> save(int day, DietRecord record) =>
      _box.put(day, record.toModel());

  @override
  Stream<Map<int, DietRecord>> watchAll() async* {
    yield getAll();
    await for (final _ in _box.watch()) {
      yield getAll();
    }
  }

  @override
  Future<void> clear() => _box.clear();
}
