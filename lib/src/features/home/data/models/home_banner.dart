/// Represents a promotional banner from the storefront home API.
class HomeBanner {
  final String id;
  final String title;
  final String titleAr;
  final String subtitle;
  final String subtitleAr;
  final String imageUrl;

  const HomeBanner({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.subtitle,
    required this.subtitleAr,
    required this.imageUrl,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) {
    return HomeBanner(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      titleAr: json['titleAr']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      subtitleAr: json['subtitleAr']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
    );
  }
}
