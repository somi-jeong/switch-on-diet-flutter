import 'package:hive/hive.dart';
import 'package:switchon_diet/features/settings/data/mappers/app_settings_mapper.dart';
import 'package:switchon_diet/features/settings/data/models/app_settings_model.dart';
import 'package:switchon_diet/features/settings/domain/entities/app_settings.dart';
import 'package:switchon_diet/features/settings/domain/repositories/settings_repository.dart';

class HiveSettingsRepository implements SettingsRepository {
  HiveSettingsRepository(this._box);

  static const boxName = 'settings';
  static const _key = 'settings';

  final Box<AppSettingsModel> _box;

  @override
  AppSettings? get() => _box.get(_key)?.toEntity();

  @override
  Future<void> save(AppSettings settings) => _box.put(
    _key,
    settings.toModel(legacyApiKey: _box.get(_key)?.legacyApiKey),
  );

  @override
  Future<void> clear() => _box.clear();
}
