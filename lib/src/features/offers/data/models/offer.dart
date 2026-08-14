import 'offer_option.dart';
import 'vendor_details.dart';

class Offer {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final int daysLeft;
  final int hoursLeft;
  final int minutesLeft;
  final String location;
  final String description;
  final double price;
  final String currency;
  final String? titleAr;
  final String? descriptionAr;
  final String? vendor;
  final String? vendorId;
  final String? validity;
  final String? slug;
  final bool? wishlisted;
  final String locationEn;
  final String locationAr;
  final String? mapsOpenUrl;
  final List<OfferOption> variants;
  final VendorDetails? vendorDetails;

  const Offer({
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
    this.wishlisted,
    this.locationEn = '',
    this.locationAr = '',
    this.mapsOpenUrl,
    this.variants = const [],
    this.vendorDetails,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];
    final imageUrl = images.isNotEmpty
        ? images[0].toString()
        : json['image']?.toString() ?? json['imageUrl']?.toString() ?? '';

    final variantsList = json['variants'] as List<dynamic>? ?? [];
    final variants = variantsList.map((v) {
      final vMap = v as Map<String, dynamic>;
      return OfferOption(
        id: vMap['id']?.toString() ?? '',
        name: vMap['name']?.toString() ?? '',
        originalPrice: (vMap['originalPrice'] as num?)?.toDouble() ??
            (json['actualPrice'] as num?)?.toDouble() ??
            (json['price'] as num?)?.toDouble() ?? 0.0,
        price: (vMap['price'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    final locationEnVal = json['locationEn']?.toString() ??
        json['location']?.toString() ?? '';
    final locationArVal = json['locationAr']?.toString() ?? '';

    bool? wishlistedVal;
    if (json['wishlisted'] is bool) {
      wishlistedVal = json['wishlisted'] as bool;
    } else if (json['isWishlisted'] is bool) {
      wishlistedVal = json['isWishlisted'] as bool;
    }

    return Offer(
      id: json['id']?.toString() ?? '',
      title: json['name']?.toString() ?? json['title']?.toString() ?? '',
      titleAr: json['nameAr']?.toString() ?? json['titleAr']?.toString(),
      category: json['category']?.toString() ?? '',
      imageUrl: imageUrl,
      daysLeft: (json['daysLeft'] as num?)?.toInt() ?? 0,
      hoursLeft: (json['hoursLeft'] as num?)?.toInt() ?? 0,
      minutesLeft: (json['minutesLeft'] as num?)?.toInt() ?? 0,
      location: locationEnVal,
      locationEn: locationEnVal,
      locationAr: locationArVal,
      mapsOpenUrl: json['mapsOpenUrl']?.toString(),
      description: json['description']?.toString() ?? '',
      descriptionAr: json['descriptionAr']?.toString(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency']?.toString() ?? 'QAR',
      vendor: json['vendor']?.toString(),
      vendorId: json['vendorId']?.toString() ?? json['vendor_id']?.toString(),
      validity: json['validity']?.toString(),
      slug: json['slug']?.toString(),
      wishlisted: wishlistedVal,
      variants: variants,
      vendorDetails: json['vendorDetails'] != null
          ? VendorDetails.fromJson(
              json['vendorDetails'] as Map<String, dynamic>)
          : null,
    );
  }

  Offer copyWith({
    String? id,
    String? title,
    String? category,
    String? imageUrl,
    int? daysLeft,
    int? hoursLeft,
    int? minutesLeft,
    String? location,
    String? description,
    double? price,
    String? currency,
    String? titleAr,
    String? descriptionAr,
    String? vendor,
    String? vendorId,
    String? validity,
    String? slug,
    bool? wishlisted,
    String? locationEn,
    String? locationAr,
    String? mapsOpenUrl,
    List<OfferOption>? variants,
    VendorDetails? vendorDetails,
  }) {
    return Offer(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      daysLeft: daysLeft ?? this.daysLeft,
      hoursLeft: hoursLeft ?? this.hoursLeft,
      minutesLeft: minutesLeft ?? this.minutesLeft,
      location: location ?? this.location,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      titleAr: titleAr ?? this.titleAr,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      vendor: vendor ?? this.vendor,
      vendorId: vendorId ?? this.vendorId,
      validity: validity ?? this.validity,
      slug: slug ?? this.slug,
      wishlisted: wishlisted ?? this.wishlisted,
      locationEn: locationEn ?? this.locationEn,
      locationAr: locationAr ?? this.locationAr,
      mapsOpenUrl: mapsOpenUrl ?? this.mapsOpenUrl,
      variants: variants ?? this.variants,
      vendorDetails: vendorDetails ?? this.vendorDetails,
    );
  }
}
