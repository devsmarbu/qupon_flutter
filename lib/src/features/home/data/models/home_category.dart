/// Represents a product category from the storefront home API.
class HomeCategory {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final String iconUrl;
  final String imageUrl;
  final int offersCount;

  const HomeCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.iconUrl,
    required this.imageUrl,
    required this.offersCount,
  });

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    return HomeCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameAr: json['nameAr']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      iconUrl: json['icon']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
      offersCount: (json['categoryNumber'] as num?)?.toInt() ?? 0,
    );
  }
}
