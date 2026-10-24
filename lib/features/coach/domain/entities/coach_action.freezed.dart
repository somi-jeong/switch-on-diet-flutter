// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoachAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String time) wake,
    required TResult Function(String mealType, String foods) meal,
    required TResult Function(String mealType) skip,
    required TResult Function(String time) sleep,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String time)? wake,
    TResult? Function(String mealType, String foods)? meal,
    TResult? Function(String mealType)? skip,
    TResult? Function(String time)? sleep,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String time)? wake,
    TResult Function(String mealType, String foods)? meal,
    TResult Function(String mealType)? skip,
    TResult Function(String time)? sleep,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WakeAction value) wake,
    required TResult Function(MealAction value) meal,
    required TResult Function(SkipAction value) skip,
    required TResult Function(SleepAction value) sleep,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WakeAction value)? wake,
    TResult? Function(MealAction value)? meal,
    TResult? Function(SkipAction value)? skip,
    TResult? Function(SleepAction value)? sleep,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WakeAction value)? wake,
    TResult Function(MealAction value)? meal,
    TResult Function(SkipAction value)? skip,
    TResult Function(SleepAction value)? sleep,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachActionCopyWith<$Res> {
  factory $CoachActionCopyWith(
    CoachAction value,
    $Res Function(CoachAction) then,
  ) = _$CoachActionCopyWithImpl<$Res, CoachAction>;
}

/// @nodoc
class _$CoachActionCopyWithImpl<$Res, $Val extends CoachAction>
    implements $CoachActionCopyWith<$Res> {
  _$CoachActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$WakeActionImplCopyWith<$Res> {
  factory _$$WakeActionImplCopyWith(
    _$WakeActionImpl value,
    $Res Function(_$WakeActionImpl) then,
  ) = __$$WakeActionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String time});
}

/// @nodoc
class __$$WakeActionImplCopyWithImpl<$Res>
    extends _$CoachActionCopyWithImpl<$Res, _$WakeActionImpl>
    implements _$$WakeActionImplCopyWith<$Res> {
  __$$WakeActionImplCopyWithImpl(
    _$WakeActionImpl _value,
    $Res Function(_$WakeActionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null}) {
    return _then(
      _$WakeActionImpl(
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$WakeActionImpl implements WakeAction {
  const _$WakeActionImpl({required this.time});

  @override
  final String time;

  @override
  String toString() {
    return 'CoachAction.wake(time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WakeActionImpl &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WakeActionImplCopyWith<_$WakeActionImpl> get copyWith =>
      __$$WakeActionImplCopyWithImpl<_$WakeActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String time) wake,
    required TResult Function(String mealType, String foods) meal,
    required TResult Function(String mealType) skip,
    required TResult Function(String time) sleep,
  }) {
    return wake(time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String time)? wake,
    TResult? Function(String mealType, String foods)? meal,
    TResult? Function(String mealType)? skip,
    TResult? Function(String time)? sleep,
  }) {
    return wake?.call(time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String time)? wake,
    TResult Function(String mealType, String foods)? meal,
    TResult Function(String mealType)? skip,
    TResult Function(String time)? sleep,
    required TResult orElse(),
  }) {
    if (wake != null) {
      return wake(time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WakeAction value) wake,
    required TResult Function(MealAction value) meal,
    required TResult Function(SkipAction value) skip,
    required TResult Function(SleepAction value) sleep,
  }) {
    return wake(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WakeAction value)? wake,
    TResult? Function(MealAction value)? meal,
    TResult? Function(SkipAction value)? skip,
    TResult? Function(SleepAction value)? sleep,
  }) {
    return wake?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WakeAction value)? wake,
    TResult Function(MealAction value)? meal,
    TResult Function(SkipAction value)? skip,
    TResult Function(SleepAction value)? sleep,
    required TResult orElse(),
  }) {
    if (wake != null) {
      return wake(this);
    }
    return orElse();
  }
}

abstract class WakeAction implements CoachAction {
  const factory WakeAction({required final String time}) = _$WakeActionImpl;

  String get time;
  @JsonKey(ignore: true)
  _$$WakeActionImplCopyWith<_$WakeActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MealActionImplCopyWith<$Res> {
  factory _$$MealActionImplCopyWith(
    _$MealActionImpl value,
    $Res Function(_$MealActionImpl) then,
  ) = __$$MealActionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String mealType, String foods});
}

/// @nodoc
class __$$MealActionImplCopyWithImpl<$Res>
    extends _$CoachActionCopyWithImpl<$Res, _$MealActionImpl>
    implements _$$MealActionImplCopyWith<$Res> {
  __$$MealActionImplCopyWithImpl(
    _$MealActionImpl _value,
    $Res Function(_$MealActionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mealType = null, Object? foods = null}) {
    return _then(
      _$MealActionImpl(
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
        foods: null == foods
            ? _value.foods
            : foods // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$MealActionImpl implements MealAction {
  const _$MealActionImpl({required this.mealType, required this.foods});

  @override
  final String mealType;
  @override
  final String foods;

  @override
  String toString() {
    return 'CoachAction.meal(mealType: $mealType, foods: $foods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealActionImpl &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.foods, foods) || other.foods == foods));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealType, foods);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MealActionImplCopyWith<_$MealActionImpl> get copyWith =>
      __$$MealActionImplCopyWithImpl<_$MealActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String time) wake,
    required TResult Function(String mealType, String foods) meal,
    required TResult Function(String mealType) skip,
    required TResult Function(String time) sleep,
  }) {
    return meal(mealType, foods);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String time)? wake,
    TResult? Function(String mealType, String foods)? meal,
    TResult? Function(String mealType)? skip,
    TResult? Function(String time)? sleep,
  }) {
    return meal?.call(mealType, foods);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String time)? wake,
    TResult Function(String mealType, String foods)? meal,
    TResult Function(String mealType)? skip,
    TResult Function(String time)? sleep,
    required TResult orElse(),
  }) {
    if (meal != null) {
      return meal(mealType, foods);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WakeAction value) wake,
    required TResult Function(MealAction value) meal,
    required TResult Function(SkipAction value) skip,
    required TResult Function(SleepAction value) sleep,
  }) {
    return meal(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WakeAction value)? wake,
    TResult? Function(MealAction value)? meal,
    TResult? Function(SkipAction value)? skip,
    TResult? Function(SleepAction value)? sleep,
  }) {
    return meal?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WakeAction value)? wake,
    TResult Function(MealAction value)? meal,
    TResult Function(SkipAction value)? skip,
    TResult Function(SleepAction value)? sleep,
    required TResult orElse(),
  }) {
    if (meal != null) {
      return meal(this);
    }
    return orElse();
  }
}

abstract class MealAction implements CoachAction {
  const factory MealAction({
    required final String mealType,
    required final String foods,
  }) = _$MealActionImpl;

  String get mealType;
  String get foods;
  @JsonKey(ignore: true)
  _$$MealActionImplCopyWith<_$MealActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SkipActionImplCopyWith<$Res> {
  factory _$$SkipActionImplCopyWith(
    _$SkipActionImpl value,
    $Res Function(_$SkipActionImpl) then,
  ) = __$$SkipActionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String mealType});
}

/// @nodoc
class __$$SkipActionImplCopyWithImpl<$Res>
    extends _$CoachActionCopyWithImpl<$Res, _$SkipActionImpl>
    implements _$$SkipActionImplCopyWith<$Res> {
  __$$SkipActionImplCopyWithImpl(
    _$SkipActionImpl _value,
    $Res Function(_$SkipActionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mealType = null}) {
    return _then(
      _$SkipActionImpl(
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SkipActionImpl implements SkipAction {
  const _$SkipActionImpl({required this.mealType});

  @override
  final String mealType;

  @override
  String toString() {
    return 'CoachAction.skip(mealType: $mealType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkipActionImpl &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mealType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkipActionImplCopyWith<_$SkipActionImpl> get copyWith =>
      __$$SkipActionImplCopyWithImpl<_$SkipActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String time) wake,
    required TResult Function(String mealType, String foods) meal,
    required TResult Function(String mealType) skip,
    required TResult Function(String time) sleep,
  }) {
    return skip(mealType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String time)? wake,
    TResult? Function(String mealType, String foods)? meal,
    TResult? Function(String mealType)? skip,
    TResult? Function(String time)? sleep,
  }) {
    return skip?.call(mealType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String time)? wake,
    TResult Function(String mealType, String foods)? meal,
    TResult Function(String mealType)? skip,
    TResult Function(String time)? sleep,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(mealType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WakeAction value) wake,
    required TResult Function(MealAction value) meal,
    required TResult Function(SkipAction value) skip,
    required TResult Function(SleepAction value) sleep,
  }) {
    return skip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WakeAction value)? wake,
    TResult? Function(MealAction value)? meal,
    TResult? Function(SkipAction value)? skip,
    TResult? Function(SleepAction value)? sleep,
  }) {
    return skip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WakeAction value)? wake,
    TResult Function(MealAction value)? meal,
    TResult Function(SkipAction value)? skip,
    TResult Function(SleepAction value)? sleep,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(this);
    }
    return orElse();
  }
}

abstract class SkipAction implements CoachAction {
  const factory SkipAction({required final String mealType}) = _$SkipActionImpl;

  String get mealType;
  @JsonKey(ignore: true)
  _$$SkipActionImplCopyWith<_$SkipActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SleepActionImplCopyWith<$Res> {
  factory _$$SleepActionImplCopyWith(
    _$SleepActionImpl value,
    $Res Function(_$SleepActionImpl) then,
  ) = __$$SleepActionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String time});
}

/// @nodoc
class __$$SleepActionImplCopyWithImpl<$Res>
    extends _$CoachActionCopyWithImpl<$Res, _$SleepActionImpl>
    implements _$$SleepActionImplCopyWith<$Res> {
  __$$SleepActionImplCopyWithImpl(
    _$SleepActionImpl _value,
    $Res Function(_$SleepActionImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? time = null}) {
    return _then(
      _$SleepActionImpl(
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SleepActionImpl implements SleepAction {
  const _$SleepActionImpl({required this.time});

  @override
  final String time;

  @override
  String toString() {
    return 'CoachAction.sleep(time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepActionImpl &&
            (identical(other.time, time) || other.time == time));
  }

  @override
  int get hashCode => Object.hash(runtimeType, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepActionImplCopyWith<_$SleepActionImpl> get copyWith =>
      __$$SleepActionImplCopyWithImpl<_$SleepActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String time) wake,
    required TResult Function(String mealType, String foods) meal,
    required TResult Function(String mealType) skip,
    required TResult Function(String time) sleep,
  }) {
    return sleep(time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String time)? wake,
    TResult? Function(String mealType, String foods)? meal,
    TResult? Function(String mealType)? skip,
    TResult? Function(String time)? sleep,
  }) {
    return sleep?.call(time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String time)? wake,
    TResult Function(String mealType, String foods)? meal,
    TResult Function(String mealType)? skip,
    TResult Function(String time)? sleep,
    required TResult orElse(),
  }) {
    if (sleep != null) {
      return sleep(time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(WakeAction value) wake,
    required TResult Function(MealAction value) meal,
    required TResult Function(SkipAction value) skip,
    required TResult Function(SleepAction value) sleep,
  }) {
    return sleep(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(WakeAction value)? wake,
    TResult? Function(MealAction value)? meal,
    TResult? Function(SkipAction value)? skip,
    TResult? Function(SleepAction value)? sleep,
  }) {
    return sleep?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(WakeAction value)? wake,
    TResult Function(MealAction value)? meal,
    TResult Function(SkipAction value)? skip,
    TResult Function(SleepAction value)? sleep,
    required TResult orElse(),
  }) {
    if (sleep != null) {
      return sleep(this);
    }
    return orElse();
  }
}

abstract class SleepAction implements CoachAction {
  const factory SleepAction({required final String time}) = _$SleepActionImpl;

  String get time;
  @JsonKey(ignore: true)
  _$$SleepActionImplCopyWith<_$SleepActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CoachReply {
  String get text => throw _privateConstructorUsedError;
  List<CoachAction> get actions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CoachReplyCopyWith<CoachReply> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachReplyCopyWith<$Res> {
  factory $CoachReplyCopyWith(
    CoachReply value,
    $Res Function(CoachReply) then,
  ) = _$CoachReplyCopyWithImpl<$Res, CoachReply>;
  @useResult
  $Res call({String text, List<CoachAction> actions});
}

/// @nodoc
class _$CoachReplyCopyWithImpl<$Res, $Val extends CoachReply>
    implements $CoachReplyCopyWith<$Res> {
  _$CoachReplyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? actions = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            actions: null == actions
                ? _value.actions
                : actions // ignore: cast_nullable_to_non_nullable
                      as List<CoachAction>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachReplyImplCopyWith<$Res>
    implements $CoachReplyCopyWith<$Res> {
  factory _$$CoachReplyImplCopyWith(
    _$CoachReplyImpl value,
    $Res Function(_$CoachReplyImpl) then,
  ) = __$$CoachReplyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, List<CoachAction> actions});
}

/// @nodoc
class __$$CoachReplyImplCopyWithImpl<$Res>
    extends _$CoachReplyCopyWithImpl<$Res, _$CoachReplyImpl>
    implements _$$CoachReplyImplCopyWith<$Res> {
  __$$CoachReplyImplCopyWithImpl(
    _$CoachReplyImpl _value,
    $Res Function(_$CoachReplyImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? actions = null}) {
    return _then(
      _$CoachReplyImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        actions: null == actions
            ? _value._actions
            : actions // ignore: cast_nullable_to_non_nullable
                  as List<CoachAction>,
      ),
    );
  }
}

/// @nodoc

class _$CoachReplyImpl implements _CoachReply {
  const _$CoachReplyImpl({
    required this.text,
    final List<CoachAction> actions = const <CoachAction>[],
  }) : _actions = actions;

  @override
  final String text;
  final List<CoachAction> _actions;
  @override
  @JsonKey()
  List<CoachAction> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  String toString() {
    return 'CoachReply(text: $text, actions: $actions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachReplyImpl &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._actions, _actions));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    text,
    const DeepCollectionEquality().hash(_actions),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachReplyImplCopyWith<_$CoachReplyImpl> get copyWith =>
      __$$CoachReplyImplCopyWithImpl<_$CoachReplyImpl>(this, _$identity);
}

abstract class _CoachReply implements CoachReply {
  const factory _CoachReply({
    required final String text,
    final List<CoachAction> actions,
  }) = _$CoachReplyImpl;

  @override
  String get text;
  @override
  List<CoachAction> get actions;
  @override
  @JsonKey(ignore: true)
  _$$CoachReplyImplCopyWith<_$CoachReplyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
