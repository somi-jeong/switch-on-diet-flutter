import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/diet_record.dart';
import '../models/meal_record.dart';
import '../models/app_settings.dart';
import '../models/chat_message.dart';

class StorageService {
  static const String _recordsBoxName = 'records';
  static const String _settingsBoxName = 'settings';
  static const String _chatJsonBoxName = 'chat_json';
  static const String _daySummariesBoxName = 'day_summaries';

  static Box<DietRecord>? _recordsBox;
  static Box<AppSettings>? _settingsBox;
  static Box<String>? _chatJsonBox;
  static Box<String>? _daySummariesBox;

  // Initialize Hive with path_provider
  static Future<void> init() async {
    if (kIsWeb) {
      // On the web Hive persists to IndexedDB; no directory is needed.
      await Hive.initFlutter();
    } else {
      // Get application documents directory
      final appDocumentDir = await getApplicationDocumentsDirectory();

      // Initialize Hive with the path
      await Hive.initFlutter(appDocumentDir.path);
    }

    // Register adapters for custom types
    Hive.registerAdapter(DietRecordAdapter());
    Hive.registerAdapter(MealRecordAdapter());
    Hive.registerAdapter(AppSettingsAdapter());
    Hive.registerAdapter(ChatMessageAdapter());

    // Open boxes
    _recordsBox = await Hive.openBox<DietRecord>(_recordsBoxName);
    _settingsBox = await Hive.openBox<AppSettings>(_settingsBoxName);
    _chatJsonBox = await Hive.openBox<String>(_chatJsonBoxName);
    _daySummariesBox = await Hive.openBox<String>(_daySummariesBoxName);
  }

  // Get DietRecord by dayIdx
  static DietRecord? getRecord(int dayIdx) {
    return _recordsBox?.get(dayIdx);
  }

  // Save DietRecord by dayIdx
  static Future<void> saveRecord(DietRecord record, int dayIdx) async {
    await _recordsBox?.put(dayIdx, record);
  }

  // Get AppSettings
  static AppSettings? getSettings() {
    return _settingsBox?.get('settings');
  }

  // Save AppSettings
  static Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox?.put('settings', settings);
  }

  // Clear all data from all boxes
  static Future<void> clearAll() async {
    await _recordsBox?.clear();
    await _settingsBox?.clear();
    await _chatJsonBox?.clear(); // 채팅 기록 삭제
    await _daySummariesBox?.clear(); // 일일 요약 삭제
  }

  // Additional utility methods for convenience
  static Future<void> deleteRecord(int dayIdx) async {
    await _recordsBox?.delete(dayIdx);
  }

  static Future<void> clearSettings() async {
    await _settingsBox?.delete('settings');
  }

  static Map<int, DietRecord> getAllRecords() {
    final map = <int, DietRecord>{};
    _recordsBox?.toMap().forEach((key, value) {
      if (key is int) {
        map[key] = value;
      }
    });
    return map;
  }

  // ========== Chat Storage Methods ==========

  // 날짜별 채팅 key: "chat_2026-03-13"
  static String _chatKey(String date) => 'chat_$date';

  // 채팅 히스토리 불러오기
  static Future<List<ChatMessage>> getChatHistory(String date) async {
    final raw = _chatJsonBox?.get(_chatKey(date));
    if (raw == null || raw.isEmpty) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded
          .map((e) => ChatMessage.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // 채팅 메시지 저장
  static Future<void> saveChatMessage(String date, ChatMessage msg) async {
    final existing = await getChatHistory(date);
    existing.add(msg);
    final encoded = jsonEncode(
      existing
          .map(
            (m) => {'role': m.role, 'text': m.text, 'timestamp': m.timestamp},
          )
          .toList(),
    );
    await _chatJsonBox?.put(_chatKey(date), encoded);
  }

  // 하루 요약 불러오기
  static Future<String?> getDaySummary(String date) async {
    return _daySummariesBox?.get('summary_$date');
  }
}
