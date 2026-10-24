// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diet_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DayHistory {
  int get day => throw _privateConstructorUsedError;

  /// e.g. `2026.03.01 (일)`.
  String get dateLabel => throw _privateConstructorUsedError;
  DietRecord get record => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DayHistoryCopyWith<DayHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayHistoryCopyWith<$Res> {
  factory $DayHistoryCopyWith(
    DayHistory value,
    $Res Function(DayHistory) then,
  ) = _$DayHistoryCopyWithImpl<$Res, DayHistory>;
  @useResult
  $Res call({int day, String dateLabel, DietRecord record});

  $DietRecordCopyWith<$Res> get record;
}

/// @nodoc
class _$DayHistoryCopyWithImpl<$Res, $Val extends DayHistory>
    implements $DayHistoryCopyWith<$Res> {
  _$DayHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? dateLabel = null,
    Object? record = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            dateLabel: null == dateLabel
                ? _value.dateLabel
                : dateLabel // ignore: cast_nullable_to_non_nullable
                      as String,
            record: null == record
                ? _value.record
                : record // ignore: cast_nullable_to_non_nullable
                      as DietRecord,
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
}

/// @nodoc
abstract class _$$DayHistoryImplCopyWith<$Res>
    implements $DayHistoryCopyWith<$Res> {
  factory _$$DayHistoryImplCopyWith(
    _$DayHistoryImpl value,
    $Res Function(_$DayHistoryImpl) then,
  ) = __$$DayHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, String dateLabel, DietRecord record});

  @override
  $DietRecordCopyWith<$Res> get record;
}

/// @nodoc
class __$$DayHistoryImplCopyWithImpl<$Res>
    extends _$DayHistoryCopyWithImpl<$Res, _$DayHistoryImpl>
    implements _$$DayHistoryImplCopyWith<$Res> {
  __$$DayHistoryImplCopyWithImpl(
    _$DayHistoryImpl _value,
    $Res Function(_$DayHistoryImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? dateLabel = null,
    Object? record = null,
  }) {
    return _then(
      _$DayHistoryImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        dateLabel: null == dateLabel
            ? _value.dateLabel
            : dateLabel // ignore: cast_nullable_to_non_nullable
                  as String,
        record: null == record
            ? _value.record
            : record // ignore: cast_nullable_to_non_nullable
                  as DietRecord,
      ),
    );
  }
}

/// @nodoc

class _$DayHistoryImpl extends _DayHistory {
  const _$DayHistoryImpl({
    required this.day,
    required this.dateLabel,
    required this.record,
  }) : super._();

  @override
  final int day;

  /// e.g. `2026.03.01 (일)`.
  @override
  final String dateLabel;
  @override
  final DietRecord record;

  @override
  String toString() {
    return 'DayHistory(day: $day, dateLabel: $dateLabel, record: $record)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayHistoryImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.dateLabel, dateLabel) ||
                other.dateLabel == dateLabel) &&
            (identical(other.record, record) || other.record == record));
  }

  @override
  int get hashCode => Object.hash(runtimeType, day, dateLabel, record);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DayHistoryImplCopyWith<_$DayHistoryImpl> get copyWith =>
      __$$DayHistoryImplCopyWithImpl<_$DayHistoryImpl>(this, _$identity);
}

abstract class _DayHistory extends DayHistory {
  const factory _DayHistory({
    required final int day,
    required final String dateLabel,
    required final DietRecord record,
  }) = _$DayHistoryImpl;
  const _DayHistory._() : super._();

  @override
  int get day;
  @override
  /// e.g. `2026.03.01 (일)`.
  String get dateLabel;
  @override
  DietRecord get record;
  @override
  @JsonKey(ignore: true)
  _$$DayHistoryImplCopyWith<_$DayHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
