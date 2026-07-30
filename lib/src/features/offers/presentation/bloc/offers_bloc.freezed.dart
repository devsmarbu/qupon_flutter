// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offers_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$OffersEvent {
  String? get categoryId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? categoryId) fetchOffers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? categoryId)? fetchOffers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? categoryId)? fetchOffers,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchOffers value) fetchOffers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchOffers value)? fetchOffers,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchOffers value)? fetchOffers,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of OffersEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OffersEventCopyWith<OffersEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OffersEventCopyWith<$Res> {
  factory $OffersEventCopyWith(
    OffersEvent value,
    $Res Function(OffersEvent) then,
  ) = _$OffersEventCopyWithImpl<$Res, OffersEvent>;
  @useResult
  $Res call({String? categoryId});
}

/// @nodoc
class _$OffersEventCopyWithImpl<$Res, $Val extends OffersEvent>
    implements $OffersEventCopyWith<$Res> {
  _$OffersEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OffersEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = freezed}) {
    return _then(
      _value.copyWith(
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FetchOffersImplCopyWith<$Res>
    implements $OffersEventCopyWith<$Res> {
  factory _$$FetchOffersImplCopyWith(
    _$FetchOffersImpl value,
    $Res Function(_$FetchOffersImpl) then,
  ) = __$$FetchOffersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? categoryId});
}

/// @nodoc
class __$$FetchOffersImplCopyWithImpl<$Res>
    extends _$OffersEventCopyWithImpl<$Res, _$FetchOffersImpl>
    implements _$$FetchOffersImplCopyWith<$Res> {
  __$$FetchOffersImplCopyWithImpl(
    _$FetchOffersImpl _value,
    $Res Function(_$FetchOffersImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OffersEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? categoryId = freezed}) {
    return _then(
      _$FetchOffersImpl(
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$FetchOffersImpl implements FetchOffers {
  const _$FetchOffersImpl({this.categoryId});

  @override
  final String? categoryId;

  @override
  String toString() {
    return 'OffersEvent.fetchOffers(categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchOffersImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categoryId);

  /// Create a copy of OffersEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchOffersImplCopyWith<_$FetchOffersImpl> get copyWith =>
      __$$FetchOffersImplCopyWithImpl<_$FetchOffersImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String? categoryId) fetchOffers,
  }) {
    return fetchOffers(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? categoryId)? fetchOffers,
  }) {
    return fetchOffers?.call(categoryId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? categoryId)? fetchOffers,
    required TResult orElse(),
  }) {
    if (fetchOffers != null) {
      return fetchOffers(categoryId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchOffers value) fetchOffers,
  }) {
    return fetchOffers(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchOffers value)? fetchOffers,
  }) {
    return fetchOffers?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchOffers value)? fetchOffers,
    required TResult orElse(),
  }) {
    if (fetchOffers != null) {
      return fetchOffers(this);
    }
    return orElse();
  }
}

abstract class FetchOffers implements OffersEvent {
  const factory FetchOffers({final String? categoryId}) = _$FetchOffersImpl;

  @override
  String? get categoryId;

  /// Create a copy of OffersEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchOffersImplCopyWith<_$FetchOffersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OffersState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Offer> offers) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Offer> offers)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Offer> offers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OffersInitial value) initial,
    required TResult Function(OffersLoading value) loading,
    required TResult Function(OffersLoaded value) loaded,
    required TResult Function(OffersError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OffersInitial value)? initial,
    TResult? Function(OffersLoading value)? loading,
    TResult? Function(OffersLoaded value)? loaded,
    TResult? Function(OffersError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OffersInitial value)? initial,
    TResult Function(OffersLoading value)? loading,
    TResult Function(OffersLoaded value)? loaded,
    TResult Function(OffersError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OffersStateCopyWith<$Res> {
  factory $OffersStateCopyWith(
    OffersState value,
    $Res Function(OffersState) then,
  ) = _$OffersStateCopyWithImpl<$Res, OffersState>;
}

/// @nodoc
class _$OffersStateCopyWithImpl<$Res, $Val extends OffersState>
    implements $OffersStateCopyWith<$Res> {
  _$OffersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$OffersInitialImplCopyWith<$Res> {
  factory _$$OffersInitialImplCopyWith(
    _$OffersInitialImpl value,
    $Res Function(_$OffersInitialImpl) then,
  ) = __$$OffersInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OffersInitialImplCopyWithImpl<$Res>
    extends _$OffersStateCopyWithImpl<$Res, _$OffersInitialImpl>
    implements _$$OffersInitialImplCopyWith<$Res> {
  __$$OffersInitialImplCopyWithImpl(
    _$OffersInitialImpl _value,
    $Res Function(_$OffersInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OffersInitialImpl implements OffersInitial {
  const _$OffersInitialImpl();

  @override
  String toString() {
    return 'OffersState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OffersInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Offer> offers) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Offer> offers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Offer> offers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OffersInitial value) initial,
    required TResult Function(OffersLoading value) loading,
    required TResult Function(OffersLoaded value) loaded,
    required TResult Function(OffersError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OffersInitial value)? initial,
    TResult? Function(OffersLoading value)? loading,
    TResult? Function(OffersLoaded value)? loaded,
    TResult? Function(OffersError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OffersInitial value)? initial,
    TResult Function(OffersLoading value)? loading,
    TResult Function(OffersLoaded value)? loaded,
    TResult Function(OffersError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class OffersInitial implements OffersState {
  const factory OffersInitial() = _$OffersInitialImpl;
}

/// @nodoc
abstract class _$$OffersLoadingImplCopyWith<$Res> {
  factory _$$OffersLoadingImplCopyWith(
    _$OffersLoadingImpl value,
    $Res Function(_$OffersLoadingImpl) then,
  ) = __$$OffersLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OffersLoadingImplCopyWithImpl<$Res>
    extends _$OffersStateCopyWithImpl<$Res, _$OffersLoadingImpl>
    implements _$$OffersLoadingImplCopyWith<$Res> {
  __$$OffersLoadingImplCopyWithImpl(
    _$OffersLoadingImpl _value,
    $Res Function(_$OffersLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$OffersLoadingImpl implements OffersLoading {
  const _$OffersLoadingImpl();

  @override
  String toString() {
    return 'OffersState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OffersLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Offer> offers) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Offer> offers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Offer> offers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OffersInitial value) initial,
    required TResult Function(OffersLoading value) loading,
    required TResult Function(OffersLoaded value) loaded,
    required TResult Function(OffersError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OffersInitial value)? initial,
    TResult? Function(OffersLoading value)? loading,
    TResult? Function(OffersLoaded value)? loaded,
    TResult? Function(OffersError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OffersInitial value)? initial,
    TResult Function(OffersLoading value)? loading,
    TResult Function(OffersLoaded value)? loaded,
    TResult Function(OffersError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class OffersLoading implements OffersState {
  const factory OffersLoading() = _$OffersLoadingImpl;
}

/// @nodoc
abstract class _$$OffersLoadedImplCopyWith<$Res> {
  factory _$$OffersLoadedImplCopyWith(
    _$OffersLoadedImpl value,
    $Res Function(_$OffersLoadedImpl) then,
  ) = __$$OffersLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Offer> offers});
}

/// @nodoc
class __$$OffersLoadedImplCopyWithImpl<$Res>
    extends _$OffersStateCopyWithImpl<$Res, _$OffersLoadedImpl>
    implements _$$OffersLoadedImplCopyWith<$Res> {
  __$$OffersLoadedImplCopyWithImpl(
    _$OffersLoadedImpl _value,
    $Res Function(_$OffersLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? offers = null}) {
    return _then(
      _$OffersLoadedImpl(
        null == offers
            ? _value._offers
            : offers // ignore: cast_nullable_to_non_nullable
                  as List<Offer>,
      ),
    );
  }
}

/// @nodoc

class _$OffersLoadedImpl implements OffersLoaded {
  const _$OffersLoadedImpl(final List<Offer> offers) : _offers = offers;

  final List<Offer> _offers;
  @override
  List<Offer> get offers {
    if (_offers is EqualUnmodifiableListView) return _offers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_offers);
  }

  @override
  String toString() {
    return 'OffersState.loaded(offers: $offers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OffersLoadedImpl &&
            const DeepCollectionEquality().equals(other._offers, _offers));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_offers));

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OffersLoadedImplCopyWith<_$OffersLoadedImpl> get copyWith =>
      __$$OffersLoadedImplCopyWithImpl<_$OffersLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Offer> offers) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(offers);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Offer> offers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(offers);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Offer> offers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(offers);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OffersInitial value) initial,
    required TResult Function(OffersLoading value) loading,
    required TResult Function(OffersLoaded value) loaded,
    required TResult Function(OffersError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OffersInitial value)? initial,
    TResult? Function(OffersLoading value)? loading,
    TResult? Function(OffersLoaded value)? loaded,
    TResult? Function(OffersError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OffersInitial value)? initial,
    TResult Function(OffersLoading value)? loading,
    TResult Function(OffersLoaded value)? loaded,
    TResult Function(OffersError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class OffersLoaded implements OffersState {
  const factory OffersLoaded(final List<Offer> offers) = _$OffersLoadedImpl;

  List<Offer> get offers;

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OffersLoadedImplCopyWith<_$OffersLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OffersErrorImplCopyWith<$Res> {
  factory _$$OffersErrorImplCopyWith(
    _$OffersErrorImpl value,
    $Res Function(_$OffersErrorImpl) then,
  ) = __$$OffersErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$OffersErrorImplCopyWithImpl<$Res>
    extends _$OffersStateCopyWithImpl<$Res, _$OffersErrorImpl>
    implements _$$OffersErrorImplCopyWith<$Res> {
  __$$OffersErrorImplCopyWithImpl(
    _$OffersErrorImpl _value,
    $Res Function(_$OffersErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$OffersErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OffersErrorImpl implements OffersError {
  const _$OffersErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'OffersState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OffersErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OffersErrorImplCopyWith<_$OffersErrorImpl> get copyWith =>
      __$$OffersErrorImplCopyWithImpl<_$OffersErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Offer> offers) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Offer> offers)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Offer> offers)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OffersInitial value) initial,
    required TResult Function(OffersLoading value) loading,
    required TResult Function(OffersLoaded value) loaded,
    required TResult Function(OffersError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(OffersInitial value)? initial,
    TResult? Function(OffersLoading value)? loading,
    TResult? Function(OffersLoaded value)? loaded,
    TResult? Function(OffersError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OffersInitial value)? initial,
    TResult Function(OffersLoading value)? loading,
    TResult Function(OffersLoaded value)? loaded,
    TResult Function(OffersError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OffersError implements OffersState {
  const factory OffersError(final String message) = _$OffersErrorImpl;

  String get message;

  /// Create a copy of OffersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OffersErrorImplCopyWith<_$OffersErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
