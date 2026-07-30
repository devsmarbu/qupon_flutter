import 'home_banner.dart';
import 'home_category.dart';
import 'home_collection.dart';

/// Top-level model for the `/api/storefront/home` response data.
class HomeData {
  final List<HomeBanner> banners;
  final List<HomeCategory> categories;
  final List<HomeCollection> collections;

  const HomeData({
    required this.banners,
    required this.categories,
    required this.collections,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final rawBanners = data['banners'] as List<dynamic>? ?? [];
    final banners = rawBanners
        .whereType<Map<String, dynamic>>()
        .map(HomeBanner.fromJson)
        .toList();

    final rawCategories = data['categories'] as List<dynamic>? ?? [];
    final categories = rawCategories
        .whereType<Map<String, dynamic>>()
        .map(HomeCategory.fromJson)
        .toList();

    final rawCollections = data['collections'] as List<dynamic>? ?? [];
    final collections = rawCollections
        .whereType<Map<String, dynamic>>()
        .map(HomeCollection.fromJson)
        .toList()
      ..sort((a, b) => a.meta.order.compareTo(b.meta.order));

    return HomeData(
      banners: banners,
      categories: categories,
      collections: collections,
    );
  }

  /// Convenience: first collection with layout 'carousel'.
  HomeCollection? get carouselCollection =>
      collections.where((c) => c.meta.layout == 'carousel').firstOrNull;

  /// Convenience: first collection with layout 'compact'.
  HomeCollection? get compactCollection =>
      collections.where((c) => c.meta.layout == 'compact').firstOrNull;
}
