// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_history_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ChatHistoryState {
  int get today => throw _privateConstructorUsedError;
  List<HistoryItem> get items => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatHistoryStateCopyWith<ChatHistoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatHistoryStateCopyWith<$Res> {
  factory $ChatHistoryStateCopyWith(
    ChatHistoryState value,
    $Res Function(ChatHistoryState) then,
  ) = _$ChatHistoryStateCopyWithImpl<$Res, ChatHistoryState>;
  @useResult
  $Res call({int today, List<HistoryItem> items, String query});
}

/// @nodoc
class _$ChatHistoryStateCopyWithImpl<$Res, $Val extends ChatHistoryState>
    implements $ChatHistoryStateCopyWith<$Res> {
  _$ChatHistoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? items = null,
    Object? query = null,
  }) {
    return _then(
      _value.copyWith(
            today: null == today
                ? _value.today
                : today // ignore: cast_nullable_to_non_nullable
                      as int,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<HistoryItem>,
            query: null == query
                ? _value.query
                : query // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatHistoryStateImplCopyWith<$Res>
    implements $ChatHistoryStateCopyWith<$Res> {
  factory _$$ChatHistoryStateImplCopyWith(
    _$ChatHistoryStateImpl value,
    $Res Function(_$ChatHistoryStateImpl) then,
  ) = __$$ChatHistoryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int today, List<HistoryItem> items, String query});
}

/// @nodoc
class __$$ChatHistoryStateImplCopyWithImpl<$Res>
    extends _$ChatHistoryStateCopyWithImpl<$Res, _$ChatHistoryStateImpl>
    implements _$$ChatHistoryStateImplCopyWith<$Res> {
  __$$ChatHistoryStateImplCopyWithImpl(
    _$ChatHistoryStateImpl _value,
    $Res Function(_$ChatHistoryStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? today = null,
    Object? items = null,
    Object? query = null,
  }) {
    return _then(
      _$ChatHistoryStateImpl(
        today: null == today
            ? _value.today
            : today // ignore: cast_nullable_to_non_nullable
                  as int,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<HistoryItem>,
        query: null == query
            ? _value.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ChatHistoryStateImpl extends _ChatHistoryState {
  const _$ChatHistoryStateImpl({
    required this.today,
    required final List<HistoryItem> items,
    this.query = '',
  }) : _items = items,
       super._();

  @override
  final int today;
  final List<HistoryItem> _items;
  @override
  List<HistoryItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final String query;

  @override
  String toString() {
    return 'ChatHistoryState(today: $today, items: $items, query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatHistoryStateImpl &&
            (identical(other.today, today) || other.today == today) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    today,
    const DeepCollectionEquality().hash(_items),
    query,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatHistoryStateImplCopyWith<_$ChatHistoryStateImpl> get copyWith =>
      __$$ChatHistoryStateImplCopyWithImpl<_$ChatHistoryStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ChatHistoryState extends ChatHistoryState {
  const factory _ChatHistoryState({
    required final int today,
    required final List<HistoryItem> items,
    final String query,
  }) = _$ChatHistoryStateImpl;
  const _ChatHistoryState._() : super._();

  @override
  int get today;
  @override
  List<HistoryItem> get items;
  @override
  String get query;
  @override
  @JsonKey(ignore: true)
  _$$ChatHistoryStateImplCopyWith<_$ChatHistoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
