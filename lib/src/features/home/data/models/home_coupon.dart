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
  });

  factory HomeCoupon.fromJson(Map<String, dynamic> json) {
    return HomeCoupon(
      id: json['id']?.toString() ?? '',
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
}
