// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_meal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecordMealTarget {
  int get day => throw _privateConstructorUsedError;
  String get mealType => throw _privateConstructorUsedError;

  /// Pre-fills the form; also what "delete" clears.
  MealRecord? get existingMeal => throw _privateConstructorUsedError;

  /// Past days are logged to the hour.
  bool get isPastDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordMealTargetCopyWith<RecordMealTarget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordMealTargetCopyWith<$Res> {
  factory $RecordMealTargetCopyWith(
    RecordMealTarget value,
    $Res Function(RecordMealTarget) then,
  ) = _$RecordMealTargetCopyWithImpl<$Res, RecordMealTarget>;
  @useResult
  $Res call({
    int day,
    String mealType,
    MealRecord? existingMeal,
    bool isPastDate,
  });

  $MealRecordCopyWith<$Res>? get existingMeal;
}

/// @nodoc
class _$RecordMealTargetCopyWithImpl<$Res, $Val extends RecordMealTarget>
    implements $RecordMealTargetCopyWith<$Res> {
  _$RecordMealTargetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? mealType = null,
    Object? existingMeal = freezed,
    Object? isPastDate = null,
  }) {
    return _then(
      _value.copyWith(
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            mealType: null == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as String,
            existingMeal: freezed == existingMeal
                ? _value.existingMeal
                : existingMeal // ignore: cast_nullable_to_non_nullable
                      as MealRecord?,
            isPastDate: null == isPastDate
                ? _value.isPastDate
                : isPastDate // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $MealRecordCopyWith<$Res>? get existingMeal {
    if (_value.existingMeal == null) {
      return null;
    }

    return $MealRecordCopyWith<$Res>(_value.existingMeal!, (value) {
      return _then(_value.copyWith(existingMeal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RecordMealTargetImplCopyWith<$Res>
    implements $RecordMealTargetCopyWith<$Res> {
  factory _$$RecordMealTargetImplCopyWith(
    _$RecordMealTargetImpl value,
    $Res Function(_$RecordMealTargetImpl) then,
  ) = __$$RecordMealTargetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int day,
    String mealType,
    MealRecord? existingMeal,
    bool isPastDate,
  });

  @override
  $MealRecordCopyWith<$Res>? get existingMeal;
}

/// @nodoc
class __$$RecordMealTargetImplCopyWithImpl<$Res>
    extends _$RecordMealTargetCopyWithImpl<$Res, _$RecordMealTargetImpl>
    implements _$$RecordMealTargetImplCopyWith<$Res> {
  __$$RecordMealTargetImplCopyWithImpl(
    _$RecordMealTargetImpl _value,
    $Res Function(_$RecordMealTargetImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? mealType = null,
    Object? existingMeal = freezed,
    Object? isPastDate = null,
  }) {
    return _then(
      _$RecordMealTargetImpl(
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
        existingMeal: freezed == existingMeal
            ? _value.existingMeal
            : existingMeal // ignore: cast_nullable_to_non_nullable
                  as MealRecord?,
        isPastDate: null == isPastDate
            ? _value.isPastDate
            : isPastDate // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RecordMealTargetImpl implements _RecordMealTarget {
  const _$RecordMealTargetImpl({
    required this.day,
    required this.mealType,
    this.existingMeal,
    this.isPastDate = false,
  });

  @override
  final int day;
  @override
  final String mealType;

  /// Pre-fills the form; also what "delete" clears.
  @override
  final MealRecord? existingMeal;

  /// Past days are logged to the hour.
  @override
  @JsonKey()
  final bool isPastDate;

  @override
  String toString() {
    return 'RecordMealTarget(day: $day, mealType: $mealType, existingMeal: $existingMeal, isPastDate: $isPastDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordMealTargetImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.existingMeal, existingMeal) ||
                other.existingMeal == existingMeal) &&
            (identical(other.isPastDate, isPastDate) ||
                other.isPastDate == isPastDate));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, day, mealType, existingMeal, isPastDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordMealTargetImplCopyWith<_$RecordMealTargetImpl> get copyWith =>
      __$$RecordMealTargetImplCopyWithImpl<_$RecordMealTargetImpl>(
        this,
        _$identity,
      );
}

abstract class _RecordMealTarget implements RecordMealTarget {
  const factory _RecordMealTarget({
    required final int day,
    required final String mealType,
    final MealRecord? existingMeal,
    final bool isPastDate,
  }) = _$RecordMealTargetImpl;

  @override
  int get day;
  @override
  String get mealType;
  @override
  /// Pre-fills the form; also what "delete" clears.
  MealRecord? get existingMeal;
  @override
  /// Past days are logged to the hour.
  bool get isPastDate;
  @override
  @JsonKey(ignore: true)
  _$$RecordMealTargetImplCopyWith<_$RecordMealTargetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecordMealState {
  String get foodText => throw _privateConstructorUsedError;
  int get hour => throw _privateConstructorUsedError;
  int get minute => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordMealStateCopyWith<RecordMealState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordMealStateCopyWith<$Res> {
  factory $RecordMealStateCopyWith(
    RecordMealState value,
    $Res Function(RecordMealState) then,
  ) = _$RecordMealStateCopyWithImpl<$Res, RecordMealState>;
  @useResult
  $Res call({String foodText, int hour, int minute, bool isSaving});
}

/// @nodoc
class _$RecordMealStateCopyWithImpl<$Res, $Val extends RecordMealState>
    implements $RecordMealStateCopyWith<$Res> {
  _$RecordMealStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodText = null,
    Object? hour = null,
    Object? minute = null,
    Object? isSaving = null,
  }) {
    return _then(
      _value.copyWith(
            foodText: null == foodText
                ? _value.foodText
                : foodText // ignore: cast_nullable_to_non_nullable
                      as String,
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                      as int,
            minute: null == minute
                ? _value.minute
                : minute // ignore: cast_nullable_to_non_nullable
                      as int,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecordMealStateImplCopyWith<$Res>
    implements $RecordMealStateCopyWith<$Res> {
  factory _$$RecordMealStateImplCopyWith(
    _$RecordMealStateImpl value,
    $Res Function(_$RecordMealStateImpl) then,
  ) = __$$RecordMealStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String foodText, int hour, int minute, bool isSaving});
}

/// @nodoc
class __$$RecordMealStateImplCopyWithImpl<$Res>
    extends _$RecordMealStateCopyWithImpl<$Res, _$RecordMealStateImpl>
    implements _$$RecordMealStateImplCopyWith<$Res> {
  __$$RecordMealStateImplCopyWithImpl(
    _$RecordMealStateImpl _value,
    $Res Function(_$RecordMealStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodText = null,
    Object? hour = null,
    Object? minute = null,
    Object? isSaving = null,
  }) {
    return _then(
      _$RecordMealStateImpl(
        foodText: null == foodText
            ? _value.foodText
            : foodText // ignore: cast_nullable_to_non_nullable
                  as String,
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
                  as int,
        minute: null == minute
            ? _value.minute
            : minute // ignore: cast_nullable_to_non_nullable
                  as int,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$RecordMealStateImpl extends _RecordMealState {
  const _$RecordMealStateImpl({
    required this.foodText,
    required this.hour,
    required this.minute,
    this.isSaving = false,
  }) : super._();

  @override
  final String foodText;
  @override
  final int hour;
  @override
  final int minute;
  @override
  @JsonKey()
  final bool isSaving;

  @override
  String toString() {
    return 'RecordMealState(foodText: $foodText, hour: $hour, minute: $minute, isSaving: $isSaving)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecordMealStateImpl &&
            (identical(other.foodText, foodText) ||
                other.foodText == foodText) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, foodText, hour, minute, isSaving);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecordMealStateImplCopyWith<_$RecordMealStateImpl> get copyWith =>
      __$$RecordMealStateImplCopyWithImpl<_$RecordMealStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RecordMealState extends RecordMealState {
  const factory _RecordMealState({
    required final String foodText,
    required final int hour,
    required final int minute,
    final bool isSaving,
  }) = _$RecordMealStateImpl;
  const _RecordMealState._() : super._();

  @override
  String get foodText;
  @override
  int get hour;
  @override
  int get minute;
  @override
  bool get isSaving;
  @override
  @JsonKey(ignore: true)
  _$$RecordMealStateImplCopyWith<_$RecordMealStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecordMealOutcome {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MealAnalysis analysis) analyzed,
    required TResult Function(String title, String message) analysisFailed,
    required TResult Function() notFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MealAnalysis analysis)? analyzed,
    TResult? Function(String title, String message)? analysisFailed,
    TResult? Function()? notFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MealAnalysis analysis)? analyzed,
    TResult Function(String title, String message)? analysisFailed,
    TResult Function()? notFound,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealAnalyzed value) analyzed,
    required TResult Function(MealAnalysisFailed value) analysisFailed,
    required TResult Function(MealNotFound value) notFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealAnalyzed value)? analyzed,
    TResult? Function(MealAnalysisFailed value)? analysisFailed,
    TResult? Function(MealNotFound value)? notFound,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealAnalyzed value)? analyzed,
    TResult Function(MealAnalysisFailed value)? analysisFailed,
    TResult Function(MealNotFound value)? notFound,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordMealOutcomeCopyWith<$Res> {
  factory $RecordMealOutcomeCopyWith(
    RecordMealOutcome value,
    $Res Function(RecordMealOutcome) then,
  ) = _$RecordMealOutcomeCopyWithImpl<$Res, RecordMealOutcome>;
}

/// @nodoc
class _$RecordMealOutcomeCopyWithImpl<$Res, $Val extends RecordMealOutcome>
    implements $RecordMealOutcomeCopyWith<$Res> {
  _$RecordMealOutcomeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MealAnalyzedImplCopyWith<$Res> {
  factory _$$MealAnalyzedImplCopyWith(
    _$MealAnalyzedImpl value,
    $Res Function(_$MealAnalyzedImpl) then,
  ) = __$$MealAnalyzedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MealAnalysis analysis});

  $MealAnalysisCopyWith<$Res> get analysis;
}

/// @nodoc
class __$$MealAnalyzedImplCopyWithImpl<$Res>
    extends _$RecordMealOutcomeCopyWithImpl<$Res, _$MealAnalyzedImpl>
    implements _$$MealAnalyzedImplCopyWith<$Res> {
  __$$MealAnalyzedImplCopyWithImpl(
    _$MealAnalyzedImpl _value,
    $Res Function(_$MealAnalyzedImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? analysis = null}) {
    return _then(
      _$MealAnalyzedImpl(
        null == analysis
            ? _value.analysis
            : analysis // ignore: cast_nullable_to_non_nullable
                  as MealAnalysis,
      ),
    );
  }

  @override
  @pragma('vm:prefer-inline')
  $MealAnalysisCopyWith<$Res> get analysis {
    return $MealAnalysisCopyWith<$Res>(_value.analysis, (value) {
      return _then(_value.copyWith(analysis: value));
    });
  }
}

/// @nodoc

class _$MealAnalyzedImpl implements MealAnalyzed {
  const _$MealAnalyzedImpl(this.analysis);

  @override
  final MealAnalysis analysis;

  @override
  String toString() {
    return 'RecordMealOutcome.analyzed(analysis: $analysis)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealAnalyzedImpl &&
            (identical(other.analysis, analysis) ||
                other.analysis == analysis));
  }

  @override
  int get hashCode => Object.hash(runtimeType, analysis);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealAnalyzedImplCopyWith<_$MealAnalyzedImpl> get copyWith =>
      __$$MealAnalyzedImplCopyWithImpl<_$MealAnalyzedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MealAnalysis analysis) analyzed,
    required TResult Function(String title, String message) analysisFailed,
    required TResult Function() notFound,
  }) {
    return analyzed(analysis);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MealAnalysis analysis)? analyzed,
    TResult? Function(String title, String message)? analysisFailed,
    TResult? Function()? notFound,
  }) {
    return analyzed?.call(analysis);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MealAnalysis analysis)? analyzed,
    TResult Function(String title, String message)? analysisFailed,
    TResult Function()? notFound,
    required TResult orElse(),
  }) {
    if (analyzed != null) {
      return analyzed(analysis);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealAnalyzed value) analyzed,
    required TResult Function(MealAnalysisFailed value) analysisFailed,
    required TResult Function(MealNotFound value) notFound,
  }) {
    return analyzed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealAnalyzed value)? analyzed,
    TResult? Function(MealAnalysisFailed value)? analysisFailed,
    TResult? Function(MealNotFound value)? notFound,
  }) {
    return analyzed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealAnalyzed value)? analyzed,
    TResult Function(MealAnalysisFailed value)? analysisFailed,
    TResult Function(MealNotFound value)? notFound,
    required TResult orElse(),
  }) {
    if (analyzed != null) {
      return analyzed(this);
    }
    return orElse();
  }
}

abstract class MealAnalyzed implements RecordMealOutcome {
  const factory MealAnalyzed(final MealAnalysis analysis) = _$MealAnalyzedImpl;

  MealAnalysis get analysis;
  @JsonKey(ignore: true)
  _$$MealAnalyzedImplCopyWith<_$MealAnalyzedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MealAnalysisFailedImplCopyWith<$Res> {
  factory _$$MealAnalysisFailedImplCopyWith(
    _$MealAnalysisFailedImpl value,
    $Res Function(_$MealAnalysisFailedImpl) then,
  ) = __$$MealAnalysisFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String title, String message});
}

/// @nodoc
class __$$MealAnalysisFailedImplCopyWithImpl<$Res>
    extends _$RecordMealOutcomeCopyWithImpl<$Res, _$MealAnalysisFailedImpl>
    implements _$$MealAnalysisFailedImplCopyWith<$Res> {
  __$$MealAnalysisFailedImplCopyWithImpl(
    _$MealAnalysisFailedImpl _value,
    $Res Function(_$MealAnalysisFailedImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? message = null}) {
    return _then(
      _$MealAnalysisFailedImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MealAnalysisFailedImpl implements MealAnalysisFailed {
  const _$MealAnalysisFailedImpl({required this.title, required this.message});

  @override
  final String title;
  @override
  final String message;

  @override
  String toString() {
    return 'RecordMealOutcome.analysisFailed(title: $title, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealAnalysisFailedImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealAnalysisFailedImplCopyWith<_$MealAnalysisFailedImpl> get copyWith =>
      __$$MealAnalysisFailedImplCopyWithImpl<_$MealAnalysisFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MealAnalysis analysis) analyzed,
    required TResult Function(String title, String message) analysisFailed,
    required TResult Function() notFound,
  }) {
    return analysisFailed(title, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MealAnalysis analysis)? analyzed,
    TResult? Function(String title, String message)? analysisFailed,
    TResult? Function()? notFound,
  }) {
    return analysisFailed?.call(title, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MealAnalysis analysis)? analyzed,
    TResult Function(String title, String message)? analysisFailed,
    TResult Function()? notFound,
    required TResult orElse(),
  }) {
    if (analysisFailed != null) {
      return analysisFailed(title, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealAnalyzed value) analyzed,
    required TResult Function(MealAnalysisFailed value) analysisFailed,
    required TResult Function(MealNotFound value) notFound,
  }) {
    return analysisFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealAnalyzed value)? analyzed,
    TResult? Function(MealAnalysisFailed value)? analysisFailed,
    TResult? Function(MealNotFound value)? notFound,
  }) {
    return analysisFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealAnalyzed value)? analyzed,
    TResult Function(MealAnalysisFailed value)? analysisFailed,
    TResult Function(MealNotFound value)? notFound,
    required TResult orElse(),
  }) {
    if (analysisFailed != null) {
      return analysisFailed(this);
    }
    return orElse();
  }
}

abstract class MealAnalysisFailed implements RecordMealOutcome {
  const factory MealAnalysisFailed({
    required final String title,
    required final String message,
  }) = _$MealAnalysisFailedImpl;

  String get title;
  String get message;
  @JsonKey(ignore: true)
  _$$MealAnalysisFailedImplCopyWith<_$MealAnalysisFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MealNotFoundImplCopyWith<$Res> {
  factory _$$MealNotFoundImplCopyWith(
    _$MealNotFoundImpl value,
    $Res Function(_$MealNotFoundImpl) then,
  ) = __$$MealNotFoundImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MealNotFoundImplCopyWithImpl<$Res>
    extends _$RecordMealOutcomeCopyWithImpl<$Res, _$MealNotFoundImpl>
    implements _$$MealNotFoundImplCopyWith<$Res> {
  __$$MealNotFoundImplCopyWithImpl(
    _$MealNotFoundImpl _value,
    $Res Function(_$MealNotFoundImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$MealNotFoundImpl implements MealNotFound {
  const _$MealNotFoundImpl();

  @override
  String toString() {
    return 'RecordMealOutcome.notFound()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MealNotFoundImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(MealAnalysis analysis) analyzed,
    required TResult Function(String title, String message) analysisFailed,
    required TResult Function() notFound,
  }) {
    return notFound();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(MealAnalysis analysis)? analyzed,
    TResult? Function(String title, String message)? analysisFailed,
    TResult? Function()? notFound,
  }) {
    return notFound?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(MealAnalysis analysis)? analyzed,
    TResult Function(String title, String message)? analysisFailed,
    TResult Function()? notFound,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MealAnalyzed value) analyzed,
    required TResult Function(MealAnalysisFailed value) analysisFailed,
    required TResult Function(MealNotFound value) notFound,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MealAnalyzed value)? analyzed,
    TResult? Function(MealAnalysisFailed value)? analysisFailed,
    TResult? Function(MealNotFound value)? notFound,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MealAnalyzed value)? analyzed,
    TResult Function(MealAnalysisFailed value)? analysisFailed,
    TResult Function(MealNotFound value)? notFound,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class MealNotFound implements RecordMealOutcome {
  const factory MealNotFound() = _$MealNotFoundImpl;
}
