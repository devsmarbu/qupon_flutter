import 'home_coupon.dart';

/// Metadata for a collection section (e.g. "Summer Picks" or "Handpicked").
class HomeCollectionMeta {
  final String id;
  final String title;
  final String titleAr;
  final String slug;
  /// 'carousel' → horizontal scrolling cards; 'compact' → vertical list tiles.
  final String layout;
  /// 'default' → white/transparent; 'tinted' → salmon/peach background.
  final String background;
  final int order;

  const HomeCollectionMeta({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.slug,
    required this.layout,
    required this.background,
    required this.order,
  });

  factory HomeCollectionMeta.fromJson(Map<String, dynamic> json) {
    return HomeCollectionMeta(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      titleAr: json['titleAr']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      layout: json['layout']?.toString() ?? 'carousel',
      background: json['background']?.toString() ?? 'default',
      order: (json['order'] as num?)?.toInt() ?? 0,
    );
  }
}

/// A section on the home page that groups coupons under a named collection.
class HomeCollection {
  final HomeCollectionMeta meta;
  final List<HomeCoupon> coupons;

  const HomeCollection({required this.meta, required this.coupons});

  factory HomeCollection.fromJson(Map<String, dynamic> json) {
    final meta = HomeCollectionMeta.fromJson(
        json['collection'] as Map<String, dynamic>? ?? {});
    final rawCoupons = json['coupons'] as List<dynamic>? ?? [];
    final coupons = rawCoupons
        .whereType<Map<String, dynamic>>()
        .map(HomeCoupon.fromJson)
        .toList();
    return HomeCollection(meta: meta, coupons: coupons);
  }
}
