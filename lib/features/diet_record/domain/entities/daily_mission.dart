/// Checklist items on the Today tab. [key] is the stored checklist key.
enum DailyMission {
  water('water', '물 2L'),
  supplements('supplements', '영양제'),
  workout('workout', '운동');

  const DailyMission(this.key, this.label);

  final String key;
  final String label;
}
