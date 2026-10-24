import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

/// Conversions and formatting for Japan Standard Time (Asia/Tokyo).
///
/// Uses the `timezone` database when it has been initialised and falls back
/// to a fixed UTC+9 offset otherwise.
abstract final class Jst {
  static const _utcOffset = Duration(hours: 9);
  static final _hourMinute = DateFormat('HH:mm');
  static final _isoDate = DateFormat('yyyy-MM-dd');

  static tz.Location? get _tokyo {
    try {
      return tz.getLocation('Asia/Tokyo');
    } on tz.LocationNotFoundException {
      return null;
    }
  }

  /// Converts [instant] to Tokyo wall-clock time.
  static DateTime from(DateTime instant) {
    final tokyo = _tokyo;
    return tokyo == null
        ? instant.toUtc().add(_utcOffset)
        : tz.TZDateTime.from(instant, tokyo);
  }

  /// Parses a stored ISO-8601 timestamp into Tokyo time.
  static DateTime parse(String iso) {
    final parsed = DateTime.parse(iso);
    final tokyo = _tokyo;
    return tokyo == null ? parsed : tz.TZDateTime.from(parsed, tokyo);
  }

  /// `HH:mm`
  static String hourMinute(DateTime time) => _hourMinute.format(time);

  /// `yyyy-MM-dd`
  static String isoDate(DateTime time) => _isoDate.format(time);
}
