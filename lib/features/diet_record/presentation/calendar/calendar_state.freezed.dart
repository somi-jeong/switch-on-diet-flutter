// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MealSummary {
  String get label => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  MealSummaryStatus get status => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String? get skipReason => throw _privateConstructorUsedError;
  String? get lateReason => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealSummaryCopyWith<MealSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealSummaryCopyWith<$Res> {
  factory $MealSummaryCopyWith(
    MealSummary value,
    $Res Function(MealSummary) then,
  ) = _$MealSummaryCopyWithImpl<$Res, MealSummary>;
  @useResult
  $Res call({
    String label,
    String time,
    MealSummaryStatus status,
    String text,
    String? skipReason,
    String? lateReason,
  });
}

/// @nodoc
class _$MealSummaryCopyWithImpl<$Res, $Val extends MealSummary>
    implements $MealSummaryCopyWith<$Res> {
  _$MealSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? time = null,
    Object? status = null,
    Object? text = null,
    Object? skipReason = freezed,
    Object? lateReason = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as MealSummaryStatus,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            skipReason: freezed == skipReason
                ? _value.skipReason
                : skipReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            lateReason: freezed == lateReason
                ? _value.lateReason
                : lateReason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealSummaryImplCopyWith<$Res>
    implements $MealSummaryCopyWith<$Res> {
  factory _$$MealSummaryImplCopyWith(
    _$MealSummaryImpl value,
    $Res Function(_$MealSummaryImpl) then,
  ) = __$$MealSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    String time,
    MealSummaryStatus status,
    String text,
    String? skipReason,
    String? lateReason,
  });
}

/// @nodoc
class __$$MealSummaryImplCopyWithImpl<$Res>
    extends _$MealSummaryCopyWithImpl<$Res, _$MealSummaryImpl>
    implements _$$MealSummaryImplCopyWith<$Res> {
  __$$MealSummaryImplCopyWithImpl(
    _$MealSummaryImpl _value,
    $Res Function(_$MealSummaryImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? time = null,
    Object? status = null,
    Object? text = null,
    Object? skipReason = freezed,
    Object? lateReason = freezed,
  }) {
    return _then(
      _$MealSummaryImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as MealSummaryStatus,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        skipReason: freezed == skipReason
            ? _value.skipReason
            : skipReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        lateReason: freezed == lateReason
            ? _value.lateReason
            : lateReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MealSummaryImpl implements _MealSummary {
  const _$MealSummaryImpl({
    required this.label,
    required this.time,
    required this.status,
    required this.text,
    this.skipReason,
    this.lateReason,
  });

  @override
  final String label;
  @override
  final String time;
  @override
  final MealSummaryStatus status;
  @override
  final String text;
  @override
  final String? skipReason;
  @override
  final String? lateReason;

  @override
  String toString() {
    return 'MealSummary(label: $label, time: $time, status: $status, text: $text, skipReason: $skipReason, lateReason: $lateReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealSummaryImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.skipReason, skipReason) ||
                other.skipReason == skipReason) &&
            (identical(other.lateReason, lateReason) ||
                other.lateReason == lateReason));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    time,
    status,
    text,
    skipReason,
    lateReason,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealSummaryImplCopyWith<_$MealSummaryImpl> get copyWith =>
      __$$MealSummaryImplCopyWithImpl<_$MealSummaryImpl>(this, _$identity);
}

abstract class _MealSummary implements MealSummary {
  const factory _MealSummary({
    required final String label,
    required final String time,
    required final MealSummaryStatus status,
    required final String text,
    final String? skipReason,
    final String? lateReason,
  }) = _$MealSummaryImpl;

  @override
  String get label;
  @override
  String get time;
  @override
  MealSummaryStatus get status;
  @override
  String get text;
  @override
  String? get skipReason;
  @override
  String? get lateReason;
  @override
  @JsonKey(ignore: true)
  _$$MealSummaryImplCopyWith<_$MealSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$WeekProgress {
  String get status => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// `null` for a week that has not started.
  double? get progress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WeekProgressCopyWith<WeekProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeekProgressCopyWith<$Res> {
  factory $WeekProgressCopyWith(
    WeekProgress value,
    $Res Function(WeekProgress) then,
  ) = _$WeekProgressCopyWithImpl<$Res, WeekProgress>;
  @useResult
  $Res call({String status, bool isActive, double? progress});
}

/// @nodoc
class _$WeekProgressCopyWithImpl<$Res, $Val extends WeekProgress>
    implements $WeekProgressCopyWith<$Res> {
  _$WeekProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isActive = null,
    Object? progress = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            progress: freezed == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WeekProgressImplCopyWith<$Res>
    implements $WeekProgressCopyWith<$Res> {
  factory _$$WeekProgressImplCopyWith(
    _$WeekProgressImpl value,
    $Res Function(_$WeekProgressImpl) then,
  ) = __$$WeekProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status, bool isActive, double? progress});
}

/// @nodoc
class __$$WeekProgressImplCopyWithImpl<$Res>
    extends _$WeekProgressCopyWithImpl<$Res, _$WeekProgressImpl>
    implements _$$WeekProgressImplCopyWith<$Res> {
  __$$WeekProgressImplCopyWithImpl(
    _$WeekProgressImpl _value,
    $Res Function(_$WeekProgressImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? isActive = null,
    Object? progress = freezed,
  }) {
    return _then(
      _$WeekProgressImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        progress: freezed == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc

class _$WeekProgressImpl implements _WeekProgress {
  const _$WeekProgressImpl({
    required this.status,
    required this.isActive,
    this.progress,
  });

  @override
  final String status;
  @override
  final bool isActive;

  /// `null` for a week that has not started.
  @override
  final double? progress;

  @override
  String toString() {
    return 'WeekProgress(status: $status, isActive: $isActive, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeekProgressImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, isActive, progress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeekProgressImplCopyWith<_$WeekProgressImpl> get copyWith =>
      __$$WeekProgressImplCopyWithImpl<_$WeekProgressImpl>(this, _$identity);
}

abstract class _WeekProgress implements WeekProgress {
  const factory _WeekProgress({
    required final String status,
    required final bool isActive,
    final double? progress,
  }) = _$WeekProgressImpl;

  @override
  String get status;
  @override
  bool get isActive;
  @override
  /// `null` for a week that has not started.
  double? get progress;
  @override
  @JsonKey(ignore: true)
  _$$WeekProgressImplCopyWith<_$WeekProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CalendarState {
  int get today => throw _privateConstructorUsedError;
  DateTime get now => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  Map<int, DietRecord> get records => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarStateCopyWith<CalendarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarStateCopyWith<$Res> {
  factory $CalendarStateCopyWith(
    CalendarState value,
    $Res Function(CalendarState) then,
  ) = _$CalendarStateCopyWithImpl<$Res, CalendarState>;
  @useResult
  $Res call({
    int today,
    DateTime now,
    DateTime startDate,
    Map<int, DietRecord> records,
  });
}

/// @nodoc
class _$CalendarStateCopyWithImpl<$Res, $Val extends CalendarState>
    implements $CalendarStateCopyWith<$Res> {
  _$CalendarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? now = null,
    Object? startDate = null,
    Object? records = null,
  }) {
    return _then(
      _value.copyWith(
            today: null == today
                ? _value.today
                : today // ignore: cast_nullable_to_non_nullable
                      as int,
            now: null == now
                ? _value.now
                : now // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            records: null == records
                ? _value.records
                : records // ignore: cast_nullable_to_non_nullable
                      as Map<int, DietRecord>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CalendarStateImplCopyWith<$Res>
    implements $CalendarStateCopyWith<$Res> {
  factory _$$CalendarStateImplCopyWith(
    _$CalendarStateImpl value,
    $Res Function(_$CalendarStateImpl) then,
  ) = __$$CalendarStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int today,
    DateTime now,
    DateTime startDate,
    Map<int, DietRecord> records,
  });
}

/// @nodoc
class __$$CalendarStateImplCopyWithImpl<$Res>
    extends _$CalendarStateCopyWithImpl<$Res, _$CalendarStateImpl>
    implements _$$CalendarStateImplCopyWith<$Res> {
  __$$CalendarStateImplCopyWithImpl(
    _$CalendarStateImpl _value,
    $Res Function(_$CalendarStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? now = null,
    Object? startDate = null,
    Object? records = null,
  }) {
    return _then(
      _$CalendarStateImpl(
        today: null == today
            ? _value.today
            : today // ignore: cast_nullable_to_non_nullable
                  as int,
        now: null == now
            ? _value.now
            : now // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        records: null == records
            ? _value._records
            : records // ignore: cast_nullable_to_non_nullable
                  as Map<int, DietRecord>,
      ),
    );
  }
}

/// @nodoc

class _$CalendarStateImpl extends _CalendarState {
  const _$CalendarStateImpl({
    required this.today,
    required this.now,
    required this.startDate,
    required final Map<int, DietRecord> records,
  }) : _records = records,
       super._();

  @override
  final int today;
  @override
  final DateTime now;
  @override
  final DateTime startDate;
  final Map<int, DietRecord> _records;
  @override
  Map<int, DietRecord> get records {
    if (_records is EqualUnmodifiableMapView) return _records;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_records);
  }

  @override
  String toString() {
    return 'CalendarState(today: $today, now: $now, startDate: $startDate, records: $records)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarStateImpl &&
            (identical(other.today, today) || other.today == today) &&
            (identical(other.now, now) || other.now == now) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            const DeepCollectionEquality().equals(other._records, _records));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    today,
    now,
    startDate,
    const DeepCollectionEquality().hash(_records),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarStateImplCopyWith<_$CalendarStateImpl> get copyWith =>
      __$$CalendarStateImplCopyWithImpl<_$CalendarStateImpl>(this, _$identity);
}

abstract class _CalendarState extends CalendarState {
  const factory _CalendarState({
    required final int today,
    required final DateTime now,
    required final DateTime startDate,
    required final Map<int, DietRecord> records,
  }) = _$CalendarStateImpl;
  const _CalendarState._() : super._();

  @override
  int get today;
  @override
  DateTime get now;
  @override
  DateTime get startDate;
  @override
  Map<int, DietRecord> get records;
  @override
  @JsonKey(ignore: true)
  _$$CalendarStateImplCopyWith<_$CalendarStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
