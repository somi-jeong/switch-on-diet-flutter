// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TodayState {
  int get day => throw _privateConstructorUsedError;
  DietRecord get record => throw _privateConstructorUsedError;
  DateTime get now => throw _privateConstructorUsedError;
  DietRecord? get yesterday => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TodayStateCopyWith<TodayState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayStateCopyWith<$Res> {
  factory $TodayStateCopyWith(
    TodayState value,
    $Res Function(TodayState) then,
  ) = _$TodayStateCopyWithImpl<$Res, TodayState>;
  @useResult
  $Res call({int day, DietRecord record, DateTime now, DietRecord? yesterday});

  $DietRecordCopyWith<$Res> get record;
  $DietRecordCopyWith<$Res>? get yesterday;
}

/// @nodoc
class _$TodayStateCopyWithImpl<$Res, $Val extends TodayState>
    implements $TodayStateCopyWith<$Res> {
  _$TodayStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? record = null,
    Object? now = null,
    Object? yesterday = freezed,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            record: null == record
                ? _value.record
                : record // ignore: cast_nullable_to_non_nullable
                      as DietRecord,
            now: null == now
                ? _value.now
                : now // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            yesterday: freezed == yesterday
                ? _value.yesterday
                : yesterday // ignore: cast_nullable_to_non_nullable
                      as DietRecord?,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $DietRecordCopyWith<$Res> get record {
    return $DietRecordCopyWith<$Res>(_value.record, (value) {
      return _then(_value.copyWith(record: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DietRecordCopyWith<$Res>? get yesterday {
    if (_value.yesterday == null) {
      return null;
    }

    return $DietRecordCopyWith<$Res>(_value.yesterday!, (value) {
      return _then(_value.copyWith(yesterday: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TodayStateImplCopyWith<$Res>
    implements $TodayStateCopyWith<$Res> {
  factory _$$TodayStateImplCopyWith(
    _$TodayStateImpl value,
    $Res Function(_$TodayStateImpl) then,
  ) = __$$TodayStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, DietRecord record, DateTime now, DietRecord? yesterday});

  @override
  $DietRecordCopyWith<$Res> get record;
  @override
  $DietRecordCopyWith<$Res>? get yesterday;
}

/// @nodoc
class __$$TodayStateImplCopyWithImpl<$Res>
    extends _$TodayStateCopyWithImpl<$Res, _$TodayStateImpl>
    implements _$$TodayStateImplCopyWith<$Res> {
  __$$TodayStateImplCopyWithImpl(
    _$TodayStateImpl _value,
    $Res Function(_$TodayStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? record = null,
    Object? now = null,
    Object? yesterday = freezed,
  }) {
    return _then(
      _$TodayStateImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        record: null == record
            ? _value.record
            : record // ignore: cast_nullable_to_non_nullable
                  as DietRecord,
        now: null == now
            ? _value.now
            : now // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        yesterday: freezed == yesterday
            ? _value.yesterday
            : yesterday // ignore: cast_nullable_to_non_nullable
                  as DietRecord?,
      ),
    );
  }
}

/// @nodoc

class _$TodayStateImpl extends _TodayState {
  const _$TodayStateImpl({
    required this.day,
    required this.record,
    required this.now,
    this.yesterday,
  }) : super._();

  @override
  final int day;
  @override
  final DietRecord record;
  @override
  final DateTime now;
  @override
  final DietRecord? yesterday;

  @override
  String toString() {
    return 'TodayState(day: $day, record: $record, now: $now, yesterday: $yesterday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayStateImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.record, record) || other.record == record) &&
            (identical(other.now, now) || other.now == now) &&
            (identical(other.yesterday, yesterday) ||
                other.yesterday == yesterday));
  }

  @override
  int get hashCode => Object.hash(runtimeType, day, record, now, yesterday);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayStateImplCopyWith<_$TodayStateImpl> get copyWith =>
      __$$TodayStateImplCopyWithImpl<_$TodayStateImpl>(this, _$identity);
}

abstract class _TodayState extends TodayState {
  const factory _TodayState({
    required final int day,
    required final DietRecord record,
    required final DateTime now,
    final DietRecord? yesterday,
  }) = _$TodayStateImpl;
  const _TodayState._() : super._();

  @override
  int get day;
  @override
  DietRecord get record;
  @override
  DateTime get now;
  @override
  DietRecord? get yesterday;
  @override
  @JsonKey(ignore: true)
  _$$TodayStateImplCopyWith<_$TodayStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MealTimelineItem {
  MealRecord get meal => throw _privateConstructorUsedError;
  bool get isNext => throw _privateConstructorUsedError;
  bool get isMissed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealTimelineItemCopyWith<MealTimelineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealTimelineItemCopyWith<$Res> {
  factory $MealTimelineItemCopyWith(
    MealTimelineItem value,
    $Res Function(MealTimelineItem) then,
  ) = _$MealTimelineItemCopyWithImpl<$Res, MealTimelineItem>;
  @useResult
  $Res call({MealRecord meal, bool isNext, bool isMissed});

  $MealRecordCopyWith<$Res> get meal;
}

/// @nodoc
class _$MealTimelineItemCopyWithImpl<$Res, $Val extends MealTimelineItem>
    implements $MealTimelineItemCopyWith<$Res> {
  _$MealTimelineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meal = null,
    Object? isNext = null,
    Object? isMissed = null,
  }) {
    return _then(
      _value.copyWith(
            meal: null == meal
                ? _value.meal
                : meal // ignore: cast_nullable_to_non_nullable
                      as MealRecord,
            isNext: null == isNext
                ? _value.isNext
                : isNext // ignore: cast_nullable_to_non_nullable
                      as bool,
            isMissed: null == isMissed
                ? _value.isMissed
                : isMissed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $MealRecordCopyWith<$Res> get meal {
    return $MealRecordCopyWith<$Res>(_value.meal, (value) {
      return _then(_value.copyWith(meal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MealTimelineItemImplCopyWith<$Res>
    implements $MealTimelineItemCopyWith<$Res> {
  factory _$$MealTimelineItemImplCopyWith(
    _$MealTimelineItemImpl value,
    $Res Function(_$MealTimelineItemImpl) then,
  ) = __$$MealTimelineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MealRecord meal, bool isNext, bool isMissed});

  @override
  $MealRecordCopyWith<$Res> get meal;
}

/// @nodoc
class __$$MealTimelineItemImplCopyWithImpl<$Res>
    extends _$MealTimelineItemCopyWithImpl<$Res, _$MealTimelineItemImpl>
    implements _$$MealTimelineItemImplCopyWith<$Res> {
  __$$MealTimelineItemImplCopyWithImpl(
    _$MealTimelineItemImpl _value,
    $Res Function(_$MealTimelineItemImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meal = null,
    Object? isNext = null,
    Object? isMissed = null,
  }) {
    return _then(
      _$MealTimelineItemImpl(
        meal: null == meal
            ? _value.meal
            : meal // ignore: cast_nullable_to_non_nullable
                  as MealRecord,
        isNext: null == isNext
            ? _value.isNext
            : isNext // ignore: cast_nullable_to_non_nullable
                  as bool,
        isMissed: null == isMissed
            ? _value.isMissed
            : isMissed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$MealTimelineItemImpl implements _MealTimelineItem {
  const _$MealTimelineItemImpl({
    required this.meal,
    required this.isNext,
    required this.isMissed,
  });

  @override
  final MealRecord meal;
  @override
  final bool isNext;
  @override
  final bool isMissed;

  @override
  String toString() {
    return 'MealTimelineItem(meal: $meal, isNext: $isNext, isMissed: $isMissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealTimelineItemImpl &&
            (identical(other.meal, meal) || other.meal == meal) &&
            (identical(other.isNext, isNext) || other.isNext == isNext) &&
            (identical(other.isMissed, isMissed) ||
                other.isMissed == isMissed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, meal, isNext, isMissed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealTimelineItemImplCopyWith<_$MealTimelineItemImpl> get copyWith =>
      __$$MealTimelineItemImplCopyWithImpl<_$MealTimelineItemImpl>(
        this,
        _$identity,
      );
}

abstract class _MealTimelineItem implements MealTimelineItem {
  const factory _MealTimelineItem({
    required final MealRecord meal,
    required final bool isNext,
    required final bool isMissed,
  }) = _$MealTimelineItemImpl;

  @override
  MealRecord get meal;
  @override
  bool get isNext;
  @override
  bool get isMissed;
  @override
  @JsonKey(ignore: true)
  _$$MealTimelineItemImplCopyWith<_$MealTimelineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
