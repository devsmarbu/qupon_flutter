// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return _Offer.fromJson(json);
}

/// @nodoc
mixin _$Offer {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get daysLeft => throw _privateConstructorUsedError;
  int get hoursLeft => throw _privateConstructorUsedError;
  int get minutesLeft => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String? get titleAr => throw _privateConstructorUsedError;
  String? get descriptionAr => throw _privateConstructorUsedError;
  String? get vendor => throw _privateConstructorUsedError;
  String? get vendorId => throw _privateConstructorUsedError;
  String? get validity => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<OfferOption> get variants => throw _privateConstructorUsedError;
  VendorDetails? get vendorDetails => throw _privateConstructorUsedError;

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferCopyWith<Offer> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferCopyWith<$Res> {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) then) =
      _$OfferCopyWithImpl<$Res, Offer>;
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    String imageUrl,
    int daysLeft,
    int hoursLeft,
    int minutesLeft,
    String location,
    String description,
    double price,
    String currency,
    String? titleAr,
    String? descriptionAr,
    String? vendor,
    String? vendorId,
    String? validity,
    String? slug,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<OfferOption> variants,
    VendorDetails? vendorDetails,
  });
}

/// @nodoc
class _$OfferCopyWithImpl<$Res, $Val extends Offer>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? daysLeft = null,
    Object? hoursLeft = null,
    Object? minutesLeft = null,
    Object? location = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? titleAr = freezed,
    Object? descriptionAr = freezed,
    Object? vendor = freezed,
    Object? vendorId = freezed,
    Object? validity = freezed,
    Object? slug = freezed,
    Object? variants = null,
    Object? vendorDetails = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            daysLeft: null == daysLeft
                ? _value.daysLeft
                : daysLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            hoursLeft: null == hoursLeft
                ? _value.hoursLeft
                : hoursLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            minutesLeft: null == minutesLeft
                ? _value.minutesLeft
                : minutesLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            titleAr: freezed == titleAr
                ? _value.titleAr
                : titleAr // ignore: cast_nullable_to_non_nullable
                      as String?,
            descriptionAr: freezed == descriptionAr
                ? _value.descriptionAr
                : descriptionAr // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendor: freezed == vendor
                ? _value.vendor
                : vendor // ignore: cast_nullable_to_non_nullable
                      as String?,
            vendorId: freezed == vendorId
                ? _value.vendorId
                : vendorId // ignore: cast_nullable_to_non_nullable
                      as String?,
            validity: freezed == validity
                ? _value.validity
                : validity // ignore: cast_nullable_to_non_nullable
                      as String?,
            slug: freezed == slug
                ? _value.slug
                : slug // ignore: cast_nullable_to_non_nullable
                      as String?,
            variants: null == variants
                ? _value.variants
                : variants // ignore: cast_nullable_to_non_nullable
                      as List<OfferOption>,
            vendorDetails: freezed == vendorDetails
                ? _value.vendorDetails
                : vendorDetails // ignore: cast_nullable_to_non_nullable
                      as VendorDetails?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OfferImplCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$$OfferImplCopyWith(
    _$OfferImpl value,
    $Res Function(_$OfferImpl) then,
  ) = __$$OfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String category,
    String imageUrl,
    int daysLeft,
    int hoursLeft,
    int minutesLeft,
    String location,
    String description,
    double price,
    String currency,
    String? titleAr,
    String? descriptionAr,
    String? vendor,
    String? vendorId,
    String? validity,
    String? slug,
    @JsonKey(includeFromJson: false, includeToJson: false)
    List<OfferOption> variants,
    VendorDetails? vendorDetails,
  });
}

/// @nodoc
class __$$OfferImplCopyWithImpl<$Res>
    extends _$OfferCopyWithImpl<$Res, _$OfferImpl>
    implements _$$OfferImplCopyWith<$Res> {
  __$$OfferImplCopyWithImpl(
    _$OfferImpl _value,
    $Res Function(_$OfferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? imageUrl = null,
    Object? daysLeft = null,
    Object? hoursLeft = null,
    Object? minutesLeft = null,
    Object? location = null,
    Object? description = null,
    Object? price = null,
    Object? currency = null,
    Object? titleAr = freezed,
    Object? descriptionAr = freezed,
    Object? vendor = freezed,
    Object? vendorId = freezed,
    Object? validity = freezed,
    Object? slug = freezed,
    Object? variants = null,
    Object? vendorDetails = freezed,
  }) {
    return _then(
      _$OfferImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        daysLeft: null == daysLeft
            ? _value.daysLeft
            : daysLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        hoursLeft: null == hoursLeft
            ? _value.hoursLeft
            : hoursLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        minutesLeft: null == minutesLeft
            ? _value.minutesLeft
            : minutesLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        titleAr: freezed == titleAr
            ? _value.titleAr
            : titleAr // ignore: cast_nullable_to_non_nullable
                  as String?,
        descriptionAr: freezed == descriptionAr
            ? _value.descriptionAr
            : descriptionAr // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendor: freezed == vendor
            ? _value.vendor
            : vendor // ignore: cast_nullable_to_non_nullable
                  as String?,
        vendorId: freezed == vendorId
            ? _value.vendorId
            : vendorId // ignore: cast_nullable_to_non_nullable
                  as String?,
        validity: freezed == validity
            ? _value.validity
            : validity // ignore: cast_nullable_to_non_nullable
                  as String?,
        slug: freezed == slug
            ? _value.slug
            : slug // ignore: cast_nullable_to_non_nullable
                  as String?,
        variants: null == variants
            ? _value._variants
            : variants // ignore: cast_nullable_to_non_nullable
                  as List<OfferOption>,
        vendorDetails: freezed == vendorDetails
            ? _value.vendorDetails
            : vendorDetails // ignore: cast_nullable_to_non_nullable
                  as VendorDetails?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OfferImpl implements _Offer {
  const _$OfferImpl({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.daysLeft,
    required this.hoursLeft,
    required this.minutesLeft,
    required this.location,
    required this.description,
    required this.price,
    required this.currency,
    this.titleAr,
    this.descriptionAr,
    this.vendor,
    this.vendorId,
    this.validity,
    this.slug,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<OfferOption> variants = const [],
    this.vendorDetails,
  }) : _variants = variants;

  factory _$OfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String category;
  @override
  final String imageUrl;
  @override
  final int daysLeft;
  @override
  final int hoursLeft;
  @override
  final int minutesLeft;
  @override
  final String location;
  @override
  final String description;
  @override
  final double price;
  @override
  final String currency;
  @override
  final String? titleAr;
  @override
  final String? descriptionAr;
  @override
  final String? vendor;
  @override
  final String? vendorId;
  @override
  final String? validity;
  @override
  final String? slug;
  final List<OfferOption> _variants;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<OfferOption> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  @override
  final VendorDetails? vendorDetails;

  @override
  String toString() {
    return 'Offer(id: $id, title: $title, category: $category, imageUrl: $imageUrl, daysLeft: $daysLeft, hoursLeft: $hoursLeft, minutesLeft: $minutesLeft, location: $location, description: $description, price: $price, currency: $currency, titleAr: $titleAr, descriptionAr: $descriptionAr, vendor: $vendor, vendorId: $vendorId, validity: $validity, slug: $slug, variants: $variants, vendorDetails: $vendorDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.daysLeft, daysLeft) ||
                other.daysLeft == daysLeft) &&
            (identical(other.hoursLeft, hoursLeft) ||
                other.hoursLeft == hoursLeft) &&
            (identical(other.minutesLeft, minutesLeft) ||
                other.minutesLeft == minutesLeft) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.titleAr, titleAr) || other.titleAr == titleAr) &&
            (identical(other.descriptionAr, descriptionAr) ||
                other.descriptionAr == descriptionAr) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.vendorId, vendorId) ||
                other.vendorId == vendorId) &&
            (identical(other.validity, validity) ||
                other.validity == validity) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            (identical(other.vendorDetails, vendorDetails) ||
                other.vendorDetails == vendorDetails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    title,
    category,
    imageUrl,
    daysLeft,
    hoursLeft,
    minutesLeft,
    location,
    description,
    price,
    currency,
    titleAr,
    descriptionAr,
    vendor,
    vendorId,
    validity,
    slug,
    const DeepCollectionEquality().hash(_variants),
    vendorDetails,
  ]);

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      __$$OfferImplCopyWithImpl<_$OfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferImplToJson(this);
  }
}

abstract class _Offer implements Offer {
  const factory _Offer({
    required final String id,
    required final String title,
    required final String category,
    required final String imageUrl,
    required final int daysLeft,
    required final int hoursLeft,
    required final int minutesLeft,
    required final String location,
    required final String description,
    required final double price,
    required final String currency,
    final String? titleAr,
    final String? descriptionAr,
    final String? vendor,
    final String? vendorId,
    final String? validity,
    final String? slug,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final List<OfferOption> variants,
    final VendorDetails? vendorDetails,
  }) = _$OfferImpl;

  factory _Offer.fromJson(Map<String, dynamic> json) = _$OfferImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get category;
  @override
  String get imageUrl;
  @override
  int get daysLeft;
  @override
  int get hoursLeft;
  @override
  int get minutesLeft;
  @override
  String get location;
  @override
  String get description;
  @override
  double get price;
  @override
  String get currency;
  @override
  String? get titleAr;
  @override
  String? get descriptionAr;
  @override
  String? get vendor;
  @override
  String? get vendorId;
  @override
  String? get validity;
  @override
  String? get slug;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  List<OfferOption> get variants;
  @override
  VendorDetails? get vendorDetails;

  /// Create a copy of Offer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferImplCopyWith<_$OfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
