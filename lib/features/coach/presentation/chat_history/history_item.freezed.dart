// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HistoryItem {
  HistoryKind get kind => throw _privateConstructorUsedError;
  int get dayIdx => throw _privateConstructorUsedError;
  int get weekNum => throw _privateConstructorUsedError;

  /// Shown on the card, `yyyy.MM.dd`.
  String get date => throw _privateConstructorUsedError;

  /// The stored conversation key, `yyyy-MM-dd`.
  String get chatDate => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get preview => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Whether the day has a conversation to open.
  bool get hasConversation => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HistoryItemCopyWith<HistoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryItemCopyWith<$Res> {
  factory $HistoryItemCopyWith(
    HistoryItem value,
    $Res Function(HistoryItem) then,
  ) = _$HistoryItemCopyWithImpl<$Res, HistoryItem>;
  @useResult
  $Res call({
    HistoryKind kind,
    int dayIdx,
    int weekNum,
    String date,
    String chatDate,
    String topic,
    String preview,
    List<String> tags,
    bool hasConversation,
  });
}

/// @nodoc
class _$HistoryItemCopyWithImpl<$Res, $Val extends HistoryItem>
    implements $HistoryItemCopyWith<$Res> {
  _$HistoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? dayIdx = null,
    Object? weekNum = null,
    Object? date = null,
    Object? chatDate = null,
    Object? topic = null,
    Object? preview = null,
    Object? tags = null,
    Object? hasConversation = null,
  }) {
    return _then(
      _value.copyWith(
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as HistoryKind,
            dayIdx: null == dayIdx
                ? _value.dayIdx
                : dayIdx // ignore: cast_nullable_to_non_nullable
                      as int,
            weekNum: null == weekNum
                ? _value.weekNum
                : weekNum // ignore: cast_nullable_to_non_nullable
                      as int,
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            chatDate: null == chatDate
                ? _value.chatDate
                : chatDate // ignore: cast_nullable_to_non_nullable
                      as String,
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            preview: null == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            hasConversation: null == hasConversation
                ? _value.hasConversation
                : hasConversation // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HistoryItemImplCopyWith<$Res>
    implements $HistoryItemCopyWith<$Res> {
  factory _$$HistoryItemImplCopyWith(
    _$HistoryItemImpl value,
    $Res Function(_$HistoryItemImpl) then,
  ) = __$$HistoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HistoryKind kind,
    int dayIdx,
    int weekNum,
    String date,
    String chatDate,
    String topic,
    String preview,
    List<String> tags,
    bool hasConversation,
  });
}

/// @nodoc
class __$$HistoryItemImplCopyWithImpl<$Res>
    extends _$HistoryItemCopyWithImpl<$Res, _$HistoryItemImpl>
    implements _$$HistoryItemImplCopyWith<$Res> {
  __$$HistoryItemImplCopyWithImpl(
    _$HistoryItemImpl _value,
    $Res Function(_$HistoryItemImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kind = null,
    Object? dayIdx = null,
    Object? weekNum = null,
    Object? date = null,
    Object? chatDate = null,
    Object? topic = null,
    Object? preview = null,
    Object? tags = null,
    Object? hasConversation = null,
  }) {
    return _then(
      _$HistoryItemImpl(
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as HistoryKind,
        dayIdx: null == dayIdx
            ? _value.dayIdx
            : dayIdx // ignore: cast_nullable_to_non_nullable
                  as int,
        weekNum: null == weekNum
            ? _value.weekNum
            : weekNum // ignore: cast_nullable_to_non_nullable
                  as int,
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        chatDate: null == chatDate
            ? _value.chatDate
            : chatDate // ignore: cast_nullable_to_non_nullable
                  as String,
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        preview: null == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        hasConversation: null == hasConversation
            ? _value.hasConversation
            : hasConversation // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$HistoryItemImpl implements _HistoryItem {
  const _$HistoryItemImpl({
    required this.kind,
    required this.dayIdx,
    required this.weekNum,
    required this.date,
    required this.chatDate,
    required this.topic,
    required this.preview,
    required final List<String> tags,
    required this.hasConversation,
  }) : _tags = tags;

  @override
  final HistoryKind kind;
  @override
  final int dayIdx;
  @override
  final int weekNum;

  /// Shown on the card, `yyyy.MM.dd`.
  @override
  final String date;

  /// The stored conversation key, `yyyy-MM-dd`.
  @override
  final String chatDate;
  @override
  final String topic;
  @override
  final String preview;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Whether the day has a conversation to open.
  @override
  final bool hasConversation;

  @override
  String toString() {
    return 'HistoryItem(kind: $kind, dayIdx: $dayIdx, weekNum: $weekNum, date: $date, chatDate: $chatDate, topic: $topic, preview: $preview, tags: $tags, hasConversation: $hasConversation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryItemImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.dayIdx, dayIdx) || other.dayIdx == dayIdx) &&
            (identical(other.weekNum, weekNum) || other.weekNum == weekNum) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.chatDate, chatDate) ||
                other.chatDate == chatDate) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.preview, preview) || other.preview == preview) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.hasConversation, hasConversation) ||
                other.hasConversation == hasConversation));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    kind,
    dayIdx,
    weekNum,
    date,
    chatDate,
    topic,
    preview,
    const DeepCollectionEquality().hash(_tags),
    hasConversation,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryItemImplCopyWith<_$HistoryItemImpl> get copyWith =>
      __$$HistoryItemImplCopyWithImpl<_$HistoryItemImpl>(this, _$identity);
}

abstract class _HistoryItem implements HistoryItem {
  const factory _HistoryItem({
    required final HistoryKind kind,
    required final int dayIdx,
    required final int weekNum,
    required final String date,
    required final String chatDate,
    required final String topic,
    required final String preview,
    required final List<String> tags,
    required final bool hasConversation,
  }) = _$HistoryItemImpl;

  @override
  HistoryKind get kind;
  @override
  int get dayIdx;
  @override
  int get weekNum;
  @override
  /// Shown on the card, `yyyy.MM.dd`.
  String get date;
  @override
  /// The stored conversation key, `yyyy-MM-dd`.
  String get chatDate;
  @override
  String get topic;
  @override
  String get preview;
  @override
  List<String> get tags;
  @override
  /// Whether the day has a conversation to open.
  bool get hasConversation;
  @override
  @JsonKey(ignore: true)
  _$$HistoryItemImplCopyWith<_$HistoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
