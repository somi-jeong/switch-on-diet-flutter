import 'package:switchon_diet/core/time/jst.dart';

/// A meal and its time window, expressed as minutes after waking.
class MealSlot {
  const MealSlot({
    required this.label,
    required this.icon,
    required this.startMins,
    required this.endMins,
  });

  final String label;
  final String icon;
  final int startMins;
  final int endMins;

  DateTime startAfter(DateTime wakeTime) =>
      wakeTime.add(Duration(minutes: startMins));

  DateTime endAfter(DateTime wakeTime) =>
      wakeTime.add(Duration(minutes: endMins));

  /// The middle of the window, shown as the recommended meal time.
  DateTime recommendedAfter(DateTime wakeTime) =>
      wakeTime.add(Duration(minutes: (startMins + endMins) ~/ 2));
}

/// The four daily meals. Every timing rule in the app derives from this table.
abstract final class MealSchedule {
  static const breakfast = '아침';
  static const lunch = '점심';
  static const snack = '간식';
  static const dinner = '저녁';

  static const slots = [
    MealSlot(label: breakfast, icon: '🌅', startMins: 30, endMins: 90),
    MealSlot(label: lunch, icon: '☀️', startMins: 210, endMins: 270),
    MealSlot(label: snack, icon: '🌤', startMins: 390, endMins: 450),
    MealSlot(label: dinner, icon: '🌙', startMins: 570, endMins: 630),
  ];

  static MealSlot? slotFor(String label) {
    for (final slot in slots) {
      if (slot.label == label) return slot;
    }
    return null;
  }

  /// Meals that still fit into the day after waking at [wakeHour].
  static List<MealSlot> slotsForWakeHour(int wakeHour) =>
      slots.where(WakeCategory.ofHour(wakeHour).allows).toList();

  /// Whether the window for [label] closed before [now].
  static bool isWindowPassed({
    required DateTime wakeTime,
    required String label,
    required DateTime now,
  }) {
    final slot = slotFor(label);
    return slot != null && now.isAfter(slot.endAfter(wakeTime));
  }

  /// `HH:mm` in the middle of the window for [label], or empty if unknown.
  static String recommendedTime({
    required DateTime wakeTime,
    required String label,
  }) {
    final slot = slotFor(label);
    return slot == null ? '' : Jst.hourMinute(slot.recommendedAfter(wakeTime));
  }
}

/// How late the user woke up, which decides how many meals the day can hold.
enum WakeCategory {
  tooEarly('너무이름'),
  onTime('정상'),
  slightlyLate('약간늦음'),
  quiteLate('상당히늦음'),
  veryLate('매우늦음'),
  abnormal('완전비정상');

  const WakeCategory(this.label);

  /// Korean label used in analysis prompts.
  final String label;

  static WakeCategory ofHour(int hour) {
    if (hour >= 17) return abnormal;
    if (hour >= 14) return veryLate;
    if (hour >= 11) return quiteLate;
    if (hour >= 9) return slightlyLate;
    if (hour >= 5) return onTime;
    return tooEarly;
  }

  bool allows(MealSlot slot) => switch (this) {
    abnormal => false,
    veryLate => slot.label == MealSchedule.dinner,
    quiteLate =>
      slot.label == MealSchedule.lunch || slot.label == MealSchedule.dinner,
    slightlyLate => slot.label != MealSchedule.breakfast,
    onTime || tooEarly => true,
  };
}
