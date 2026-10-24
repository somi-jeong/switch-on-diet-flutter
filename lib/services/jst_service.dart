import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class JstService {
  // Initialize timezone data (should be called once at app startup)
  static bool _initialized = false;

  static void _ensureInitialized() {
    if (!_initialized) {
      // Timezone data should be initialized in main.dart with:
      // await tz.initializeTimeZones();
      // For now, we'll use a fallback approach
      _initialized = true;
    }
  }

  // Get current time in JST (Japan Standard Time, UTC+9)
  static DateTime now() {
    _ensureInitialized();
    try {
      final tokyo = tz.getLocation('Asia/Tokyo');
      return tz.TZDateTime.now(tokyo);
    } catch (e) {
      // Fallback: manually calculate JST from UTC
      return DateTime.now().toUtc().add(const Duration(hours: 9));
    }
  }

  // Parse ISO string to JST DateTime
  static DateTime fromIso(String iso) {
    _ensureInitialized();
    try {
      final tokyo = tz.getLocation('Asia/Tokyo');
      final utcDateTime = DateTime.parse(iso);
      return tz.TZDateTime.from(utcDateTime, tokyo);
    } catch (e) {
      // Fallback: parse as regular DateTime
      return DateTime.parse(iso);
    }
  }

  // Format DateTime as "HH:mm" string
  static String format(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  // Additional utility methods for convenience
  static String formatDate(DateTime jst) {
    return DateFormat('yyyy-MM-dd').format(jst);
  }

  static DateTime addMinutes(DateTime baseDate, int mins) {
    return baseDate.add(Duration(minutes: mins));
  }

  static String toIso(DateTime jst) {
    return jst.toIso8601String();
  }
}
