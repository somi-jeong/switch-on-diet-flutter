// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_requests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoachContext {
  int get day => throw _privateConstructorUsedError;
  int get week => throw _privateConstructorUsedError;
  String? get wakeTime => throw _privateConstructorUsedError;
  List<MealRecord> get meals => throw _privateConstructorUsedError;
  FoodRules get foodRules => throw _privateConstructorUsedError;
  String? get yesterdaySummary => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CoachContextCopyWith<CoachContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachContextCopyWith<$Res> {
  factory $CoachContextCopyWith(
    CoachContext value,
    $Res Function(CoachContext) then,
  ) = _$CoachContextCopyWithImpl<$Res, CoachContext>;
  @useResult
  $Res call({
    int day,
    int week,
    String? wakeTime,
    List<MealRecord> meals,
    FoodRules foodRules,
    String? yesterdaySummary,
  });
}

/// @nodoc
class _$CoachContextCopyWithImpl<$Res, $Val extends CoachContext>
    implements $CoachContextCopyWith<$Res> {
  _$CoachContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? week = null,
    Object? wakeTime = freezed,
    Object? meals = null,
    Object? foodRules = null,
    Object? yesterdaySummary = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            week: null == week
                ? _value.week
                : week // ignore: cast_nullable_to_non_nullable
                      as int,
            wakeTime: freezed == wakeTime
                ? _value.wakeTime
                : wakeTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<MealRecord>,
            foodRules: null == foodRules
                ? _value.foodRules
                : foodRules // ignore: cast_nullable_to_non_nullable
                      as FoodRules,
            yesterdaySummary: freezed == yesterdaySummary
                ? _value.yesterdaySummary
                : yesterdaySummary // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachContextImplCopyWith<$Res>
    implements $CoachContextCopyWith<$Res> {
  factory _$$CoachContextImplCopyWith(
    _$CoachContextImpl value,
    $Res Function(_$CoachContextImpl) then,
  ) = __$$CoachContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    int week,
    String? wakeTime,
    List<MealRecord> meals,
    FoodRules foodRules,
    String? yesterdaySummary,
  });
}

/// @nodoc
class __$$CoachContextImplCopyWithImpl<$Res>
    extends _$CoachContextCopyWithImpl<$Res, _$CoachContextImpl>
    implements _$$CoachContextImplCopyWith<$Res> {
  __$$CoachContextImplCopyWithImpl(
    _$CoachContextImpl _value,
    $Res Function(_$CoachContextImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? week = null,
    Object? wakeTime = freezed,
    Object? meals = null,
    Object? foodRules = null,
    Object? yesterdaySummary = freezed,
  }) {
    return _then(
      _$CoachContextImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        week: null == week
            ? _value.week
            : week // ignore: cast_nullable_to_non_nullable
                  as int,
        wakeTime: freezed == wakeTime
            ? _value.wakeTime
            : wakeTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<MealRecord>,
        foodRules: null == foodRules
            ? _value.foodRules
            : foodRules // ignore: cast_nullable_to_non_nullable
                  as FoodRules,
        yesterdaySummary: freezed == yesterdaySummary
            ? _value.yesterdaySummary
            : yesterdaySummary // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$CoachContextImpl implements _CoachContext {
  const _$CoachContextImpl({
    required this.day,
    required this.week,
    required this.wakeTime,
    required final List<MealRecord> meals,
    required this.foodRules,
    this.yesterdaySummary,
  }) : _meals = meals;

  @override
  final int day;
  @override
  final int week;
  @override
  final String? wakeTime;
  final List<MealRecord> _meals;
  @override
  List<MealRecord> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  final FoodRules foodRules;
  @override
  final String? yesterdaySummary;

  @override
  String toString() {
    return 'CoachContext(day: $day, week: $week, wakeTime: $wakeTime, meals: $meals, foodRules: $foodRules, yesterdaySummary: $yesterdaySummary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachContextImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.wakeTime, wakeTime) ||
                other.wakeTime == wakeTime) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.foodRules, foodRules) ||
                other.foodRules == foodRules) &&
            (identical(other.yesterdaySummary, yesterdaySummary) ||
                other.yesterdaySummary == yesterdaySummary));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    week,
    wakeTime,
    const DeepCollectionEquality().hash(_meals),
    foodRules,
    yesterdaySummary,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachContextImplCopyWith<_$CoachContextImpl> get copyWith =>
      __$$CoachContextImplCopyWithImpl<_$CoachContextImpl>(this, _$identity);
}

abstract class _CoachContext implements CoachContext {
  const factory _CoachContext({
    required final int day,
    required final int week,
    required final String? wakeTime,
    required final List<MealRecord> meals,
    required final FoodRules foodRules,
    final String? yesterdaySummary,
  }) = _$CoachContextImpl;

  @override
  int get day;
  @override
  int get week;
  @override
  String? get wakeTime;
  @override
  List<MealRecord> get meals;
  @override
  FoodRules get foodRules;
  @override
  String? get yesterdaySummary;
  @override
  @JsonKey(ignore: true)
  _$$CoachContextImplCopyWith<_$CoachContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MealAnalysis {
  MealVerdict get verdict => throw _privateConstructorUsedError;
  String get feedback => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealAnalysisCopyWith<MealAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealAnalysisCopyWith<$Res> {
  factory $MealAnalysisCopyWith(
    MealAnalysis value,
    $Res Function(MealAnalysis) then,
  ) = _$MealAnalysisCopyWithImpl<$Res, MealAnalysis>;
  @useResult
  $Res call({MealVerdict verdict, String feedback});
}

/// @nodoc
class _$MealAnalysisCopyWithImpl<$Res, $Val extends MealAnalysis>
    implements $MealAnalysisCopyWith<$Res> {
  _$MealAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? verdict = null, Object? feedback = null}) {
    return _then(
      _value.copyWith(
            verdict: null == verdict
                ? _value.verdict
                : verdict // ignore: cast_nullable_to_non_nullable
                      as MealVerdict,
            feedback: null == feedback
                ? _value.feedback
                : feedback // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealAnalysisImplCopyWith<$Res>
    implements $MealAnalysisCopyWith<$Res> {
  factory _$$MealAnalysisImplCopyWith(
    _$MealAnalysisImpl value,
    $Res Function(_$MealAnalysisImpl) then,
  ) = __$$MealAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MealVerdict verdict, String feedback});
}

/// @nodoc
class __$$MealAnalysisImplCopyWithImpl<$Res>
    extends _$MealAnalysisCopyWithImpl<$Res, _$MealAnalysisImpl>
    implements _$$MealAnalysisImplCopyWith<$Res> {
  __$$MealAnalysisImplCopyWithImpl(
    _$MealAnalysisImpl _value,
    $Res Function(_$MealAnalysisImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? verdict = null, Object? feedback = null}) {
    return _then(
      _$MealAnalysisImpl(
        verdict: null == verdict
            ? _value.verdict
            : verdict // ignore: cast_nullable_to_non_nullable
                  as MealVerdict,
        feedback: null == feedback
            ? _value.feedback
            : feedback // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MealAnalysisImpl implements _MealAnalysis {
  const _$MealAnalysisImpl({required this.verdict, required this.feedback});

  @override
  final MealVerdict verdict;
  @override
  final String feedback;

  @override
  String toString() {
    return 'MealAnalysis(verdict: $verdict, feedback: $feedback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealAnalysisImpl &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @override
  int get hashCode => Object.hash(runtimeType, verdict, feedback);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealAnalysisImplCopyWith<_$MealAnalysisImpl> get copyWith =>
      __$$MealAnalysisImplCopyWithImpl<_$MealAnalysisImpl>(this, _$identity);
}

abstract class _MealAnalysis implements MealAnalysis {
  const factory _MealAnalysis({
    required final MealVerdict verdict,
    required final String feedback,
  }) = _$MealAnalysisImpl;

  @override
  MealVerdict get verdict;
  @override
  String get feedback;
  @override
  @JsonKey(ignore: true)
  _$$MealAnalysisImplCopyWith<_$MealAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyReport {
  int get day => throw _privateConstructorUsedError;
  int get week => throw _privateConstructorUsedError;
  DateTime get wakeTime => throw _privateConstructorUsedError;
  int get fastingHours => throw _privateConstructorUsedError;
  int get scorePercent => throw _privateConstructorUsedError;
  int get completedMeals => throw _privateConstructorUsedError;
  int get totalMeals => throw _privateConstructorUsedError;
  int get allowedCount => throw _privateConstructorUsedError;
  int get warningCount => throw _privateConstructorUsedError;
  int get forbiddenCount => throw _privateConstructorUsedError;
  int get warningCountTotal => throw _privateConstructorUsedError;
  List<MealRecord> get meals => throw _privateConstructorUsedError;
  Map<String, bool> get dailyChecklist => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get bodyFat => throw _privateConstructorUsedError;
  String? get confession => throw _privateConstructorUsedError;
  String? get bedTime => throw _privateConstructorUsedError;
  String? get actualBedTime => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DailyReportCopyWith<DailyReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyReportCopyWith<$Res> {
  factory $DailyReportCopyWith(
    DailyReport value,
    $Res Function(DailyReport) then,
  ) = _$DailyReportCopyWithImpl<$Res, DailyReport>;
  @useResult
  $Res call({
    int day,
    int week,
    DateTime wakeTime,
    int fastingHours,
    int scorePercent,
    int completedMeals,
    int totalMeals,
    int allowedCount,
    int warningCount,
    int forbiddenCount,
    int warningCountTotal,
    List<MealRecord> meals,
    Map<String, bool> dailyChecklist,
    double? weight,
    double? bodyFat,
    String? confession,
    String? bedTime,
    String? actualBedTime,
  });
}

/// @nodoc
class _$DailyReportCopyWithImpl<$Res, $Val extends DailyReport>
    implements $DailyReportCopyWith<$Res> {
  _$DailyReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? week = null,
    Object? wakeTime = null,
    Object? fastingHours = null,
    Object? scorePercent = null,
    Object? completedMeals = null,
    Object? totalMeals = null,
    Object? allowedCount = null,
    Object? warningCount = null,
    Object? forbiddenCount = null,
    Object? warningCountTotal = null,
    Object? meals = null,
    Object? dailyChecklist = null,
    Object? weight = freezed,
    Object? bodyFat = freezed,
    Object? confession = freezed,
    Object? bedTime = freezed,
    Object? actualBedTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            week: null == week
                ? _value.week
                : week // ignore: cast_nullable_to_non_nullable
                      as int,
            wakeTime: null == wakeTime
                ? _value.wakeTime
                : wakeTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            fastingHours: null == fastingHours
                ? _value.fastingHours
                : fastingHours // ignore: cast_nullable_to_non_nullable
                      as int,
            scorePercent: null == scorePercent
                ? _value.scorePercent
                : scorePercent // ignore: cast_nullable_to_non_nullable
                      as int,
            completedMeals: null == completedMeals
                ? _value.completedMeals
                : completedMeals // ignore: cast_nullable_to_non_nullable
                      as int,
            totalMeals: null == totalMeals
                ? _value.totalMeals
                : totalMeals // ignore: cast_nullable_to_non_nullable
                      as int,
            allowedCount: null == allowedCount
                ? _value.allowedCount
                : allowedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            warningCount: null == warningCount
                ? _value.warningCount
                : warningCount // ignore: cast_nullable_to_non_nullable
                      as int,
            forbiddenCount: null == forbiddenCount
                ? _value.forbiddenCount
                : forbiddenCount // ignore: cast_nullable_to_non_nullable
                      as int,
            warningCountTotal: null == warningCountTotal
                ? _value.warningCountTotal
                : warningCountTotal // ignore: cast_nullable_to_non_nullable
                      as int,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<MealRecord>,
            dailyChecklist: null == dailyChecklist
                ? _value.dailyChecklist
                : dailyChecklist // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
            weight: freezed == weight
                ? _value.weight
                : weight // ignore: cast_nullable_to_non_nullable
                      as double?,
            bodyFat: freezed == bodyFat
                ? _value.bodyFat
                : bodyFat // ignore: cast_nullable_to_non_nullable
                      as double?,
            confession: freezed == confession
                ? _value.confession
                : confession // ignore: cast_nullable_to_non_nullable
                      as String?,
            bedTime: freezed == bedTime
                ? _value.bedTime
                : bedTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualBedTime: freezed == actualBedTime
                ? _value.actualBedTime
                : actualBedTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyReportImplCopyWith<$Res>
    implements $DailyReportCopyWith<$Res> {
  factory _$$DailyReportImplCopyWith(
    _$DailyReportImpl value,
    $Res Function(_$DailyReportImpl) then,
  ) = __$$DailyReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    int week,
    DateTime wakeTime,
    int fastingHours,
    int scorePercent,
    int completedMeals,
    int totalMeals,
    int allowedCount,
    int warningCount,
    int forbiddenCount,
    int warningCountTotal,
    List<MealRecord> meals,
    Map<String, bool> dailyChecklist,
    double? weight,
    double? bodyFat,
    String? confession,
    String? bedTime,
    String? actualBedTime,
  });
}

/// @nodoc
class __$$DailyReportImplCopyWithImpl<$Res>
    extends _$DailyReportCopyWithImpl<$Res, _$DailyReportImpl>
    implements _$$DailyReportImplCopyWith<$Res> {
  __$$DailyReportImplCopyWithImpl(
    _$DailyReportImpl _value,
    $Res Function(_$DailyReportImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? week = null,
    Object? wakeTime = null,
    Object? fastingHours = null,
    Object? scorePercent = null,
    Object? completedMeals = null,
    Object? totalMeals = null,
    Object? allowedCount = null,
    Object? warningCount = null,
    Object? forbiddenCount = null,
    Object? warningCountTotal = null,
    Object? meals = null,
    Object? dailyChecklist = null,
    Object? weight = freezed,
    Object? bodyFat = freezed,
    Object? confession = freezed,
    Object? bedTime = freezed,
    Object? actualBedTime = freezed,
  }) {
    return _then(
      _$DailyReportImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        week: null == week
            ? _value.week
            : week // ignore: cast_nullable_to_non_nullable
                  as int,
        wakeTime: null == wakeTime
            ? _value.wakeTime
            : wakeTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        fastingHours: null == fastingHours
            ? _value.fastingHours
            : fastingHours // ignore: cast_nullable_to_non_nullable
                  as int,
        scorePercent: null == scorePercent
            ? _value.scorePercent
            : scorePercent // ignore: cast_nullable_to_non_nullable
                  as int,
        completedMeals: null == completedMeals
            ? _value.completedMeals
            : completedMeals // ignore: cast_nullable_to_non_nullable
                  as int,
        totalMeals: null == totalMeals
            ? _value.totalMeals
            : totalMeals // ignore: cast_nullable_to_non_nullable
                  as int,
        allowedCount: null == allowedCount
            ? _value.allowedCount
            : allowedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        warningCount: null == warningCount
            ? _value.warningCount
            : warningCount // ignore: cast_nullable_to_non_nullable
                  as int,
        forbiddenCount: null == forbiddenCount
            ? _value.forbiddenCount
            : forbiddenCount // ignore: cast_nullable_to_non_nullable
                  as int,
        warningCountTotal: null == warningCountTotal
            ? _value.warningCountTotal
            : warningCountTotal // ignore: cast_nullable_to_non_nullable
                  as int,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<MealRecord>,
        dailyChecklist: null == dailyChecklist
            ? _value._dailyChecklist
            : dailyChecklist // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
        weight: freezed == weight
            ? _value.weight
            : weight // ignore: cast_nullable_to_non_nullable
                  as double?,
        bodyFat: freezed == bodyFat
            ? _value.bodyFat
            : bodyFat // ignore: cast_nullable_to_non_nullable
                  as double?,
        confession: freezed == confession
            ? _value.confession
            : confession // ignore: cast_nullable_to_non_nullable
                  as String?,
        bedTime: freezed == bedTime
            ? _value.bedTime
            : bedTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualBedTime: freezed == actualBedTime
            ? _value.actualBedTime
            : actualBedTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$DailyReportImpl extends _DailyReport {
  const _$DailyReportImpl({
    required this.day,
    required this.week,
    required this.wakeTime,
    required this.fastingHours,
    required this.scorePercent,
    required this.completedMeals,
    required this.totalMeals,
    required this.allowedCount,
    required this.warningCount,
    required this.forbiddenCount,
    required this.warningCountTotal,
    required final List<MealRecord> meals,
    required final Map<String, bool> dailyChecklist,
    this.weight,
    this.bodyFat,
    this.confession,
    this.bedTime,
    this.actualBedTime,
  }) : _meals = meals,
       _dailyChecklist = dailyChecklist,
       super._();

  @override
  final int day;
  @override
  final int week;
  @override
  final DateTime wakeTime;
  @override
  final int fastingHours;
  @override
  final int scorePercent;
  @override
  final int completedMeals;
  @override
  final int totalMeals;
  @override
  final int allowedCount;
  @override
  final int warningCount;
  @override
  final int forbiddenCount;
  @override
  final int warningCountTotal;
  final List<MealRecord> _meals;
  @override
  List<MealRecord> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  final Map<String, bool> _dailyChecklist;
  @override
  Map<String, bool> get dailyChecklist {
    if (_dailyChecklist is EqualUnmodifiableMapView) return _dailyChecklist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_dailyChecklist);
  }

  @override
  final double? weight;
  @override
  final double? bodyFat;
  @override
  final String? confession;
  @override
  final String? bedTime;
  @override
  final String? actualBedTime;

  @override
  String toString() {
    return 'DailyReport(day: $day, week: $week, wakeTime: $wakeTime, fastingHours: $fastingHours, scorePercent: $scorePercent, completedMeals: $completedMeals, totalMeals: $totalMeals, allowedCount: $allowedCount, warningCount: $warningCount, forbiddenCount: $forbiddenCount, warningCountTotal: $warningCountTotal, meals: $meals, dailyChecklist: $dailyChecklist, weight: $weight, bodyFat: $bodyFat, confession: $confession, bedTime: $bedTime, actualBedTime: $actualBedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyReportImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.week, week) || other.week == week) &&
            (identical(other.wakeTime, wakeTime) ||
                other.wakeTime == wakeTime) &&
            (identical(other.fastingHours, fastingHours) ||
                other.fastingHours == fastingHours) &&
            (identical(other.scorePercent, scorePercent) ||
                other.scorePercent == scorePercent) &&
            (identical(other.completedMeals, completedMeals) ||
                other.completedMeals == completedMeals) &&
            (identical(other.totalMeals, totalMeals) ||
                other.totalMeals == totalMeals) &&
            (identical(other.allowedCount, allowedCount) ||
                other.allowedCount == allowedCount) &&
            (identical(other.warningCount, warningCount) ||
                other.warningCount == warningCount) &&
            (identical(other.forbiddenCount, forbiddenCount) ||
                other.forbiddenCount == forbiddenCount) &&
            (identical(other.warningCountTotal, warningCountTotal) ||
                other.warningCountTotal == warningCountTotal) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            const DeepCollectionEquality().equals(
              other._dailyChecklist,
              _dailyChecklist,
            ) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFat, bodyFat) || other.bodyFat == bodyFat) &&
            (identical(other.confession, confession) ||
                other.confession == confession) &&
            (identical(other.bedTime, bedTime) || other.bedTime == bedTime) &&
            (identical(other.actualBedTime, actualBedTime) ||
                other.actualBedTime == actualBedTime));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    week,
    wakeTime,
    fastingHours,
    scorePercent,
    completedMeals,
    totalMeals,
    allowedCount,
    warningCount,
    forbiddenCount,
    warningCountTotal,
    const DeepCollectionEquality().hash(_meals),
    const DeepCollectionEquality().hash(_dailyChecklist),
    weight,
    bodyFat,
    confession,
    bedTime,
    actualBedTime,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyReportImplCopyWith<_$DailyReportImpl> get copyWith =>
      __$$DailyReportImplCopyWithImpl<_$DailyReportImpl>(this, _$identity);
}

abstract class _DailyReport extends DailyReport {
  const factory _DailyReport({
    required final int day,
    required final int week,
    required final DateTime wakeTime,
    required final int fastingHours,
    required final int scorePercent,
    required final int completedMeals,
    required final int totalMeals,
    required final int allowedCount,
    required final int warningCount,
    required final int forbiddenCount,
    required final int warningCountTotal,
    required final List<MealRecord> meals,
    required final Map<String, bool> dailyChecklist,
    final double? weight,
    final double? bodyFat,
    final String? confession,
    final String? bedTime,
    final String? actualBedTime,
  }) = _$DailyReportImpl;
  const _DailyReport._() : super._();

  @override
  int get day;
  @override
  int get week;
  @override
  DateTime get wakeTime;
  @override
  int get fastingHours;
  @override
  int get scorePercent;
  @override
  int get completedMeals;
  @override
  int get totalMeals;
  @override
  int get allowedCount;
  @override
  int get warningCount;
  @override
  int get forbiddenCount;
  @override
  int get warningCountTotal;
  @override
  List<MealRecord> get meals;
  @override
  Map<String, bool> get dailyChecklist;
  @override
  double? get weight;
  @override
  double? get bodyFat;
  @override
  String? get confession;
  @override
  String? get bedTime;
  @override
  String? get actualBedTime;
  @override
  @JsonKey(ignore: true)
  _$$DailyReportImplCopyWith<_$DailyReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeeklyDayReport {
  int get day => throw _privateConstructorUsedError;
  List<MealRecord> get meals => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  List<String> get lateRecordings => throw _privateConstructorUsedError;
  String get wakeTimeStatus => throw _privateConstructorUsedError;
  int get missionsCompleted => throw _privateConstructorUsedError;
  int get missionsTotal => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WeeklyDayReportCopyWith<WeeklyDayReport> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyDayReportCopyWith<$Res> {
  factory $WeeklyDayReportCopyWith(
    WeeklyDayReport value,
    $Res Function(WeeklyDayReport) then,
  ) = _$WeeklyDayReportCopyWithImpl<$Res, WeeklyDayReport>;
  @useResult
  $Res call({
    int day,
    List<MealRecord> meals,
    double score,
    List<String> lateRecordings,
    String wakeTimeStatus,
    int missionsCompleted,
    int missionsTotal,
  });
}

/// @nodoc
class _$WeeklyDayReportCopyWithImpl<$Res, $Val extends WeeklyDayReport>
    implements $WeeklyDayReportCopyWith<$Res> {
  _$WeeklyDayReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? meals = null,
    Object? score = null,
    Object? lateRecordings = null,
    Object? wakeTimeStatus = null,
    Object? missionsCompleted = null,
    Object? missionsTotal = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<MealRecord>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            lateRecordings: null == lateRecordings
                ? _value.lateRecordings
                : lateRecordings // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            wakeTimeStatus: null == wakeTimeStatus
                ? _value.wakeTimeStatus
                : wakeTimeStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            missionsCompleted: null == missionsCompleted
                ? _value.missionsCompleted
                : missionsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            missionsTotal: null == missionsTotal
                ? _value.missionsTotal
                : missionsTotal // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeeklyDayReportImplCopyWith<$Res>
    implements $WeeklyDayReportCopyWith<$Res> {
  factory _$$WeeklyDayReportImplCopyWith(
    _$WeeklyDayReportImpl value,
    $Res Function(_$WeeklyDayReportImpl) then,
  ) = __$$WeeklyDayReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    List<MealRecord> meals,
    double score,
    List<String> lateRecordings,
    String wakeTimeStatus,
    int missionsCompleted,
    int missionsTotal,
  });
}

/// @nodoc
class __$$WeeklyDayReportImplCopyWithImpl<$Res>
    extends _$WeeklyDayReportCopyWithImpl<$Res, _$WeeklyDayReportImpl>
    implements _$$WeeklyDayReportImplCopyWith<$Res> {
  __$$WeeklyDayReportImplCopyWithImpl(
    _$WeeklyDayReportImpl _value,
    $Res Function(_$WeeklyDayReportImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? meals = null,
    Object? score = null,
    Object? lateRecordings = null,
    Object? wakeTimeStatus = null,
    Object? missionsCompleted = null,
    Object? missionsTotal = null,
  }) {
    return _then(
      _$WeeklyDayReportImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<MealRecord>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        lateRecordings: null == lateRecordings
            ? _value._lateRecordings
            : lateRecordings // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        wakeTimeStatus: null == wakeTimeStatus
            ? _value.wakeTimeStatus
            : wakeTimeStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        missionsCompleted: null == missionsCompleted
            ? _value.missionsCompleted
            : missionsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        missionsTotal: null == missionsTotal
            ? _value.missionsTotal
            : missionsTotal // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$WeeklyDayReportImpl implements _WeeklyDayReport {
  const _$WeeklyDayReportImpl({
    required this.day,
    required final List<MealRecord> meals,
    required this.score,
    required final List<String> lateRecordings,
    required this.wakeTimeStatus,
    required this.missionsCompleted,
    required this.missionsTotal,
  }) : _meals = meals,
       _lateRecordings = lateRecordings;

  @override
  final int day;
  final List<MealRecord> _meals;
  @override
  List<MealRecord> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  @override
  final double score;
  final List<String> _lateRecordings;
  @override
  List<String> get lateRecordings {
    if (_lateRecordings is EqualUnmodifiableListView) return _lateRecordings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lateRecordings);
  }

  @override
  final String wakeTimeStatus;
  @override
  final int missionsCompleted;
  @override
  final int missionsTotal;

  @override
  String toString() {
    return 'WeeklyDayReport(day: $day, meals: $meals, score: $score, lateRecordings: $lateRecordings, wakeTimeStatus: $wakeTimeStatus, missionsCompleted: $missionsCompleted, missionsTotal: $missionsTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyDayReportImpl &&
            (identical(other.day, day) || other.day == day) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            (identical(other.score, score) || other.score == score) &&
            const DeepCollectionEquality().equals(
              other._lateRecordings,
              _lateRecordings,
            ) &&
            (identical(other.wakeTimeStatus, wakeTimeStatus) ||
                other.wakeTimeStatus == wakeTimeStatus) &&
            (identical(other.missionsCompleted, missionsCompleted) ||
                other.missionsCompleted == missionsCompleted) &&
            (identical(other.missionsTotal, missionsTotal) ||
                other.missionsTotal == missionsTotal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    day,
    const DeepCollectionEquality().hash(_meals),
    score,
    const DeepCollectionEquality().hash(_lateRecordings),
    wakeTimeStatus,
    missionsCompleted,
    missionsTotal,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyDayReportImplCopyWith<_$WeeklyDayReportImpl> get copyWith =>
      __$$WeeklyDayReportImplCopyWithImpl<_$WeeklyDayReportImpl>(
        this,
        _$identity,
      );
}

abstract class _WeeklyDayReport implements WeeklyDayReport {
  const factory _WeeklyDayReport({
    required final int day,
    required final List<MealRecord> meals,
    required final double score,
    required final List<String> lateRecordings,
    required final String wakeTimeStatus,
    required final int missionsCompleted,
    required final int missionsTotal,
  }) = _$WeeklyDayReportImpl;

  @override
  int get day;
  @override
  List<MealRecord> get meals;
  @override
  double get score;
  @override
  List<String> get lateRecordings;
  @override
  String get wakeTimeStatus;
  @override
  int get missionsCompleted;
  @override
  int get missionsTotal;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyDayReportImplCopyWith<_$WeeklyDayReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
