// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MealRecord {
  /// Meal name, e.g. `아침`. Also identifies the slot within a day.
  String get label => throw _privateConstructorUsedError;
  bool get checked => throw _privateConstructorUsedError;
  bool get skipped => throw _privateConstructorUsedError;
  String? get foodText => throw _privateConstructorUsedError;
  String? get eatenAt => throw _privateConstructorUsedError;
  String? get recordedAt => throw _privateConstructorUsedError;
  MealVerdict? get verdict => throw _privateConstructorUsedError;
  String? get aiFeedback => throw _privateConstructorUsedError;
  String? get mealTime => throw _privateConstructorUsedError;
  String? get guideText => throw _privateConstructorUsedError;
  String? get skipReason => throw _privateConstructorUsedError;
  String? get lateReason => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  String? get photoTimestamp => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MealRecordCopyWith<MealRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealRecordCopyWith<$Res> {
  factory $MealRecordCopyWith(
    MealRecord value,
    $Res Function(MealRecord) then,
  ) = _$MealRecordCopyWithImpl<$Res, MealRecord>;
  @useResult
  $Res call({
    String label,
    bool checked,
    bool skipped,
    String? foodText,
    String? eatenAt,
    String? recordedAt,
    MealVerdict? verdict,
    String? aiFeedback,
    String? mealTime,
    String? guideText,
    String? skipReason,
    String? lateReason,
    String? photoPath,
    String? photoTimestamp,
  });
}

/// @nodoc
class _$MealRecordCopyWithImpl<$Res, $Val extends MealRecord>
    implements $MealRecordCopyWith<$Res> {
  _$MealRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? checked = null,
    Object? skipped = null,
    Object? foodText = freezed,
    Object? eatenAt = freezed,
    Object? recordedAt = freezed,
    Object? verdict = freezed,
    Object? aiFeedback = freezed,
    Object? mealTime = freezed,
    Object? guideText = freezed,
    Object? skipReason = freezed,
    Object? lateReason = freezed,
    Object? photoPath = freezed,
    Object? photoTimestamp = freezed,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            checked: null == checked
                ? _value.checked
                : checked // ignore: cast_nullable_to_non_nullable
                      as bool,
            skipped: null == skipped
                ? _value.skipped
                : skipped // ignore: cast_nullable_to_non_nullable
                      as bool,
            foodText: freezed == foodText
                ? _value.foodText
                : foodText // ignore: cast_nullable_to_non_nullable
                      as String?,
            eatenAt: freezed == eatenAt
                ? _value.eatenAt
                : eatenAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            recordedAt: freezed == recordedAt
                ? _value.recordedAt
                : recordedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            verdict: freezed == verdict
                ? _value.verdict
                : verdict // ignore: cast_nullable_to_non_nullable
                      as MealVerdict?,
            aiFeedback: freezed == aiFeedback
                ? _value.aiFeedback
                : aiFeedback // ignore: cast_nullable_to_non_nullable
                      as String?,
            mealTime: freezed == mealTime
                ? _value.mealTime
                : mealTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            guideText: freezed == guideText
                ? _value.guideText
                : guideText // ignore: cast_nullable_to_non_nullable
                      as String?,
            skipReason: freezed == skipReason
                ? _value.skipReason
                : skipReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            lateReason: freezed == lateReason
                ? _value.lateReason
                : lateReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPath: freezed == photoPath
                ? _value.photoPath
                : photoPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoTimestamp: freezed == photoTimestamp
                ? _value.photoTimestamp
                : photoTimestamp // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealRecordImplCopyWith<$Res>
    implements $MealRecordCopyWith<$Res> {
  factory _$$MealRecordImplCopyWith(
    _$MealRecordImpl value,
    $Res Function(_$MealRecordImpl) then,
  ) = __$$MealRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    bool checked,
    bool skipped,
    String? foodText,
    String? eatenAt,
    String? recordedAt,
    MealVerdict? verdict,
    String? aiFeedback,
    String? mealTime,
    String? guideText,
    String? skipReason,
    String? lateReason,
    String? photoPath,
    String? photoTimestamp,
  });
}

/// @nodoc
class __$$MealRecordImplCopyWithImpl<$Res>
    extends _$MealRecordCopyWithImpl<$Res, _$MealRecordImpl>
    implements _$$MealRecordImplCopyWith<$Res> {
  __$$MealRecordImplCopyWithImpl(
    _$MealRecordImpl _value,
    $Res Function(_$MealRecordImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? checked = null,
    Object? skipped = null,
    Object? foodText = freezed,
    Object? eatenAt = freezed,
    Object? recordedAt = freezed,
    Object? verdict = freezed,
    Object? aiFeedback = freezed,
    Object? mealTime = freezed,
    Object? guideText = freezed,
    Object? skipReason = freezed,
    Object? lateReason = freezed,
    Object? photoPath = freezed,
    Object? photoTimestamp = freezed,
  }) {
    return _then(
      _$MealRecordImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        checked: null == checked
            ? _value.checked
            : checked // ignore: cast_nullable_to_non_nullable
                  as bool,
        skipped: null == skipped
            ? _value.skipped
            : skipped // ignore: cast_nullable_to_non_nullable
                  as bool,
        foodText: freezed == foodText
            ? _value.foodText
            : foodText // ignore: cast_nullable_to_non_nullable
                  as String?,
        eatenAt: freezed == eatenAt
            ? _value.eatenAt
            : eatenAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        recordedAt: freezed == recordedAt
            ? _value.recordedAt
            : recordedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        verdict: freezed == verdict
            ? _value.verdict
            : verdict // ignore: cast_nullable_to_non_nullable
                  as MealVerdict?,
        aiFeedback: freezed == aiFeedback
            ? _value.aiFeedback
            : aiFeedback // ignore: cast_nullable_to_non_nullable
                  as String?,
        mealTime: freezed == mealTime
            ? _value.mealTime
            : mealTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        guideText: freezed == guideText
            ? _value.guideText
            : guideText // ignore: cast_nullable_to_non_nullable
                  as String?,
        skipReason: freezed == skipReason
            ? _value.skipReason
            : skipReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        lateReason: freezed == lateReason
            ? _value.lateReason
            : lateReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPath: freezed == photoPath
            ? _value.photoPath
            : photoPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoTimestamp: freezed == photoTimestamp
            ? _value.photoTimestamp
            : photoTimestamp // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$MealRecordImpl extends _MealRecord {
  const _$MealRecordImpl({
    required this.label,
    this.checked = false,
    this.skipped = false,
    this.foodText,
    this.eatenAt,
    this.recordedAt,
    this.verdict,
    this.aiFeedback,
    this.mealTime,
    this.guideText,
    this.skipReason,
    this.lateReason,
    this.photoPath,
    this.photoTimestamp,
  }) : super._();

  /// Meal name, e.g. `아침`. Also identifies the slot within a day.
  @override
  final String label;
  @override
  @JsonKey()
  final bool checked;
  @override
  @JsonKey()
  final bool skipped;
  @override
  final String? foodText;
  @override
  final String? eatenAt;
  @override
  final String? recordedAt;
  @override
  final MealVerdict? verdict;
  @override
  final String? aiFeedback;
  @override
  final String? mealTime;
  @override
  final String? guideText;
  @override
  final String? skipReason;
  @override
  final String? lateReason;
  @override
  final String? photoPath;
  @override
  final String? photoTimestamp;

  @override
  String toString() {
    return 'MealRecord(label: $label, checked: $checked, skipped: $skipped, foodText: $foodText, eatenAt: $eatenAt, recordedAt: $recordedAt, verdict: $verdict, aiFeedback: $aiFeedback, mealTime: $mealTime, guideText: $guideText, skipReason: $skipReason, lateReason: $lateReason, photoPath: $photoPath, photoTimestamp: $photoTimestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealRecordImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.checked, checked) || other.checked == checked) &&
            (identical(other.skipped, skipped) || other.skipped == skipped) &&
            (identical(other.foodText, foodText) ||
                other.foodText == foodText) &&
            (identical(other.eatenAt, eatenAt) || other.eatenAt == eatenAt) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.verdict, verdict) || other.verdict == verdict) &&
            (identical(other.aiFeedback, aiFeedback) ||
                other.aiFeedback == aiFeedback) &&
            (identical(other.mealTime, mealTime) ||
                other.mealTime == mealTime) &&
            (identical(other.guideText, guideText) ||
                other.guideText == guideText) &&
            (identical(other.skipReason, skipReason) ||
                other.skipReason == skipReason) &&
            (identical(other.lateReason, lateReason) ||
                other.lateReason == lateReason) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.photoTimestamp, photoTimestamp) ||
                other.photoTimestamp == photoTimestamp));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    label,
    checked,
    skipped,
    foodText,
    eatenAt,
    recordedAt,
    verdict,
    aiFeedback,
    mealTime,
    guideText,
    skipReason,
    lateReason,
    photoPath,
    photoTimestamp,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      __$$MealRecordImplCopyWithImpl<_$MealRecordImpl>(this, _$identity);
}

abstract class _MealRecord extends MealRecord {
  const factory _MealRecord({
    required final String label,
    final bool checked,
    final bool skipped,
    final String? foodText,
    final String? eatenAt,
    final String? recordedAt,
    final MealVerdict? verdict,
    final String? aiFeedback,
    final String? mealTime,
    final String? guideText,
    final String? skipReason,
    final String? lateReason,
    final String? photoPath,
    final String? photoTimestamp,
  }) = _$MealRecordImpl;
  const _MealRecord._() : super._();

  @override
  /// Meal name, e.g. `아침`. Also identifies the slot within a day.
  String get label;
  @override
  bool get checked;
  @override
  bool get skipped;
  @override
  String? get foodText;
  @override
  String? get eatenAt;
  @override
  String? get recordedAt;
  @override
  MealVerdict? get verdict;
  @override
  String? get aiFeedback;
  @override
  String? get mealTime;
  @override
  String? get guideText;
  @override
  String? get skipReason;
  @override
  String? get lateReason;
  @override
  String? get photoPath;
  @override
  String? get photoTimestamp;
  @override
  @JsonKey(ignore: true)
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
