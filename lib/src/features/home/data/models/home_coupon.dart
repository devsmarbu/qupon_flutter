/// Represents a coupon / deal returned inside a collection from the API.
class HomeCoupon {
  final String id;
  final String name;
  final String nameAr;
  final String vendor;
  final String discount;
  final double price;
  final double actualPrice;
  final String validity;
  final String category;
  final String description;
  final String descriptionAr;
  final String imageUrl;
  final String slug;
  final String vendorId;
  final bool? wishlisted;
  final String locationEn;
  final String locationAr;

  const HomeCoupon({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.vendor,
    required this.discount,
    required this.price,
    required this.actualPrice,
    required this.validity,
    required this.category,
    required this.description,
    required this.descriptionAr,
    required this.imageUrl,
    required this.slug,
    required this.vendorId,
    this.wishlisted,
    this.locationEn = '',
    this.locationAr = '',
  });

  factory HomeCoupon.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    String imgUrl = '';
    if (rawImages is List && rawImages.isNotEmpty) {
      imgUrl = rawImages[0]?.toString() ?? '';
    } else {
      imgUrl = json['image']?.toString() ??
          json['imageUrl']?.toString() ??
          json['photo']?.toString() ??
          '';
    }

    bool? isWishlisted;
    if (json['wishlisted'] is bool) {
      isWishlisted = json['wishlisted'] as bool;
    } else if (json['isWishlisted'] is bool) {
      isWishlisted = json['isWishlisted'] as bool;
    } else if (json['is_wishlisted'] is bool) {
      isWishlisted = json['is_wishlisted'] as bool;
    }

    return HomeCoupon(
      id: json['couponId']?.toString() ??
          json['coupon_id']?.toString() ??
          json['id']?.toString() ??
          json['_id']?.toString() ??
          '',
      name: json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ?? '',
      vendor: json['vendor']?.toString() ?? '',
      discount: json['discount']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      actualPrice: (json['actualPrice'] as num?)?.toDouble() ?? 0.0,
      validity: json['validity']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      descriptionAr: json['descriptionAr']?.toString() ?? '',
      imageUrl: imgUrl,
      slug: json['slug']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? json['vendor_id']?.toString() ?? '',
      wishlisted: isWishlisted,
      locationEn: json['locationEn']?.toString() ?? json['location']?.toString() ?? '',
      locationAr: json['locationAr']?.toString() ?? '',
    );
  }

  /// Days left until validity date expires.
  int get daysLeft {
    try {
      final expiry = DateTime.parse(validity);
      final diff = expiry.difference(DateTime.now());
      return diff.inDays.clamp(0, 9999);
    } catch (_) {
      return 0;
    }
  }

  int get hoursLeft {
    try {
      final expiry = DateTime.parse(validity);
      final diff = expiry.difference(DateTime.now());
      return (diff.inHours % 24).clamp(0, 23);
    } catch (_) {
      return 0;
    }
  }

  int get minutesLeft {
    try {
      final expiry = DateTime.parse(validity);
      final diff = expiry.difference(DateTime.now());
      return (diff.inMinutes % 60).clamp(0, 59);
    } catch (_) {
      return 0;
    }
  }

  /// Formatted price string (drops .0 for whole numbers).
  String get priceString =>
      price % 1 == 0 ? price.toInt().toString() : price.toStringAsFixed(2);

  /// Returns the localised location string based on the current locale.
  String location(bool isArabic) {
    if (isArabic && locationAr.isNotEmpty) return locationAr;
    return locationEn;
  }
}
