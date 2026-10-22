class MealOffset {
  final String label;
  final String icon;
  final int startMins;
  final int endMins;

  const MealOffset({
    required this.label,
    required this.icon,
    required this.startMins,
    required this.endMins,
  });
}

const mealOffsets = [
  MealOffset(label: '아침', icon: '🌅', startMins: 30, endMins: 90),
  MealOffset(label: '점심', icon: '☀️', startMins: 210, endMins: 270),
  MealOffset(label: '간식', icon: '🌤', startMins: 390, endMins: 450),
  MealOffset(label: '저녁', icon: '🌙', startMins: 570, endMins: 630),
];
