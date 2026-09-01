import '../../../../core/network/api_endpoints.dart';

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
    String img = json['image']?.toString() ??
        json['imageUrl']?.toString() ??
        json['image_url']?.toString() ??
        json['banner']?.toString() ??
        json['bannerUrl']?.toString() ??
        json['banner_url']?.toString() ??
        json['photo']?.toString() ??
        '';

    if (img.isNotEmpty && !img.startsWith('http://') && !img.startsWith('https://')) {
      if (img.startsWith('/')) {
        img = '${ApiEndpoints.baseUrl}$img';
      } else {
        img = '${ApiEndpoints.baseUrl}/$img';
      }
    }

    return HomeBanner(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      titleAr: json['titleAr']?.toString() ?? json['nameAr']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? json['description']?.toString() ?? '',
      subtitleAr: json['subtitleAr']?.toString() ?? json['descriptionAr']?.toString() ?? '',
      imageUrl: img,
    );
  }
}

