// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_chat_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoachThread {
  /// `yyyy-MM-dd`, the key the conversation is stored under.
  String get date => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;

  /// Open an empty thread with a locally composed greeting.
  bool get greet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CoachThreadCopyWith<CoachThread> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachThreadCopyWith<$Res> {
  factory $CoachThreadCopyWith(
    CoachThread value,
    $Res Function(CoachThread) then,
  ) = _$CoachThreadCopyWithImpl<$Res, CoachThread>;
  @useResult
  $Res call({String date, int day, bool greet});
}

/// @nodoc
class _$CoachThreadCopyWithImpl<$Res, $Val extends CoachThread>
    implements $CoachThreadCopyWith<$Res> {
  _$CoachThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? day = null, Object? greet = null}) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            day: null == day
                ? _value.day
                : day // ignore: cast_nullable_to_non_nullable
                      as int,
            greet: null == greet
                ? _value.greet
                : greet // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachThreadImplCopyWith<$Res>
    implements $CoachThreadCopyWith<$Res> {
  factory _$$CoachThreadImplCopyWith(
    _$CoachThreadImpl value,
    $Res Function(_$CoachThreadImpl) then,
  ) = __$$CoachThreadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, int day, bool greet});
}

/// @nodoc
class __$$CoachThreadImplCopyWithImpl<$Res>
    extends _$CoachThreadCopyWithImpl<$Res, _$CoachThreadImpl>
    implements _$$CoachThreadImplCopyWith<$Res> {
  __$$CoachThreadImplCopyWithImpl(
    _$CoachThreadImpl _value,
    $Res Function(_$CoachThreadImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? date = null, Object? day = null, Object? greet = null}) {
    return _then(
      _$CoachThreadImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        day: null == day
            ? _value.day
            : day // ignore: cast_nullable_to_non_nullable
                  as int,
        greet: null == greet
            ? _value.greet
            : greet // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CoachThreadImpl implements _CoachThread {
  const _$CoachThreadImpl({
    required this.date,
    required this.day,
    this.greet = false,
  });

  /// `yyyy-MM-dd`, the key the conversation is stored under.
  @override
  final String date;
  @override
  final int day;

  /// Open an empty thread with a locally composed greeting.
  @override
  @JsonKey()
  final bool greet;

  @override
  String toString() {
    return 'CoachThread(date: $date, day: $day, greet: $greet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachThreadImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.greet, greet) || other.greet == greet));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, day, greet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachThreadImplCopyWith<_$CoachThreadImpl> get copyWith =>
      __$$CoachThreadImplCopyWithImpl<_$CoachThreadImpl>(this, _$identity);
}

abstract class _CoachThread implements CoachThread {
  const factory _CoachThread({
    required final String date,
    required final int day,
    final bool greet,
  }) = _$CoachThreadImpl;

  @override
  /// `yyyy-MM-dd`, the key the conversation is stored under.
  String get date;
  @override
  int get day;
  @override
  /// Open an empty thread with a locally composed greeting.
  bool get greet;
  @override
  @JsonKey(ignore: true)
  _$$CoachThreadImplCopyWith<_$CoachThreadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CoachChatState {
  List<ChatMessage> get messages => throw _privateConstructorUsedError;
  String? get daySummary => throw _privateConstructorUsedError;
  bool get isSending => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CoachChatStateCopyWith<CoachChatState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachChatStateCopyWith<$Res> {
  factory $CoachChatStateCopyWith(
    CoachChatState value,
    $Res Function(CoachChatState) then,
  ) = _$CoachChatStateCopyWithImpl<$Res, CoachChatState>;
  @useResult
  $Res call({List<ChatMessage> messages, String? daySummary, bool isSending});
}

/// @nodoc
class _$CoachChatStateCopyWithImpl<$Res, $Val extends CoachChatState>
    implements $CoachChatStateCopyWith<$Res> {
  _$CoachChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? daySummary = freezed,
    Object? isSending = null,
  }) {
    return _then(
      _value.copyWith(
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<ChatMessage>,
            daySummary: freezed == daySummary
                ? _value.daySummary
                : daySummary // ignore: cast_nullable_to_non_nullable
                      as String?,
            isSending: null == isSending
                ? _value.isSending
                : isSending // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoachChatStateImplCopyWith<$Res>
    implements $CoachChatStateCopyWith<$Res> {
  factory _$$CoachChatStateImplCopyWith(
    _$CoachChatStateImpl value,
    $Res Function(_$CoachChatStateImpl) then,
  ) = __$$CoachChatStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ChatMessage> messages, String? daySummary, bool isSending});
}

/// @nodoc
class __$$CoachChatStateImplCopyWithImpl<$Res>
    extends _$CoachChatStateCopyWithImpl<$Res, _$CoachChatStateImpl>
    implements _$$CoachChatStateImplCopyWith<$Res> {
  __$$CoachChatStateImplCopyWithImpl(
    _$CoachChatStateImpl _value,
    $Res Function(_$CoachChatStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? daySummary = freezed,
    Object? isSending = null,
  }) {
    return _then(
      _$CoachChatStateImpl(
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<ChatMessage>,
        daySummary: freezed == daySummary
            ? _value.daySummary
            : daySummary // ignore: cast_nullable_to_non_nullable
                  as String?,
        isSending: null == isSending
            ? _value.isSending
            : isSending // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CoachChatStateImpl implements _CoachChatState {
  const _$CoachChatStateImpl({
    required final List<ChatMessage> messages,
    this.daySummary,
    this.isSending = false,
  }) : _messages = messages;

  final List<ChatMessage> _messages;
  @override
  List<ChatMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final String? daySummary;
  @override
  @JsonKey()
  final bool isSending;

  @override
  String toString() {
    return 'CoachChatState(messages: $messages, daySummary: $daySummary, isSending: $isSending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachChatStateImpl &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.daySummary, daySummary) ||
                other.daySummary == daySummary) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_messages),
    daySummary,
    isSending,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachChatStateImplCopyWith<_$CoachChatStateImpl> get copyWith =>
      __$$CoachChatStateImplCopyWithImpl<_$CoachChatStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CoachChatState implements CoachChatState {
  const factory _CoachChatState({
    required final List<ChatMessage> messages,
    final String? daySummary,
    final bool isSending,
  }) = _$CoachChatStateImpl;

  @override
  List<ChatMessage> get messages;
  @override
  String? get daySummary;
  @override
  bool get isSending;
  @override
  @JsonKey(ignore: true)
  _$$CoachChatStateImplCopyWith<_$CoachChatStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
