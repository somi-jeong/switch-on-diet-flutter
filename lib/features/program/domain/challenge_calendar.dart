/// Maps calendar dates onto the 28-day program.
///
/// Days are 1-based: the start date is day 1 and the last day is
/// [totalDays]. Weeks are 1-based as well and run for seven days each.
class ChallengeCalendar {
  ChallengeCalendar(this.startDate);

  /// [startDate] is stored as `yyyy-MM-dd`.
  factory ChallengeCalendar.fromIsoDate(String startDate) =>
      ChallengeCalendar(DateTime.parse(startDate));

  static const totalDays = 28;
  static const daysPerWeek = 7;
  static const totalWeeks = totalDays ~/ daysPerWeek;

  final DateTime startDate;

  /// The program day for [now], clamped to `1..totalDays`.
  int dayAt(DateTime now) =>
      (now.difference(startDate).inDays + 1).clamp(1, totalDays);

  DateTime dateOf(int day) => startDate.add(Duration(days: day - 1));

  DateTime get endDate => dateOf(totalDays);

  static int weekOf(int day) =>
      ((day - 1) ~/ daysPerWeek + 1).clamp(1, totalWeeks);

  static bool isLastDayOfWeek(int day) => day % daysPerWeek == 0;

  static Iterable<int> daysOfWeek(int week) sync* {
    final first = (week - 1) * daysPerWeek + 1;
    for (var day = first; day < first + daysPerWeek; day++) {
      yield day;
    }
  }
}
