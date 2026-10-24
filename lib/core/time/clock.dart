import 'package:switchon_diet/core/time/jst.dart';

/// Source of the current time.
///
/// Anything that depends on "now" receives a [Clock] instead of calling
/// `DateTime.now()`, so time-window rules can be tested with a fixed instant.
abstract interface class Clock {
  DateTime now();
}

/// The production clock. The whole app reasons in Japan Standard Time.
class JstClock implements Clock {
  const JstClock();

  @override
  DateTime now() => Jst.from(DateTime.now());
}
