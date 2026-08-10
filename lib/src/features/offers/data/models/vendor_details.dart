class SocialLink {
  final String platform;
  final String label;
  final String href;

  const SocialLink({
    required this.platform,
    required this.label,
    required this.href,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      href: json['href']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'label': label,
      'href': href,
    };
  }
}

class VendorDetails {
  final String id;
  final String slug;
  final String name;
  final String? nameEn;
  final String? nameAr;
  final String? locationEn;
  final String? locationAr;
  final String? locationLink;
  final double? latitude;
  final double? longitude;
  final String? mapsEmbedUrl;
  final String? mapsOpenUrl;
  final String? profilePath;
  final String? websiteUrl;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? tiktok;
  final String? snapchat;
  final String? whatsapp;
  final List<SocialLink> socialLinks;

  const VendorDetails({
    required this.id,
    required this.slug,
    required this.name,
    this.nameEn,
    this.nameAr,
    this.locationEn,
    this.locationAr,
    this.locationLink,
    this.latitude,
    this.longitude,
    this.mapsEmbedUrl,
    this.mapsOpenUrl,
    this.profilePath,
    this.websiteUrl,
    this.facebook,
    this.instagram,
    this.twitter,
    this.tiktok,
    this.snapchat,
    this.whatsapp,
    this.socialLinks = const [],
  });

  factory VendorDetails.fromJson(Map<String, dynamic> json) {
    final socialList = json['socialLinks'] as List<dynamic>? ?? [];
    return VendorDetails(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nameEn: json['nameEn']?.toString(),
      nameAr: json['nameAr']?.toString(),
      locationEn: json['locationEn']?.toString(),
      locationAr: json['locationAr']?.toString(),
      locationLink: json['locationLink']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      mapsEmbedUrl: json['mapsEmbedUrl']?.toString(),
      mapsOpenUrl: json['mapsOpenUrl']?.toString(),
      profilePath: json['profilePath']?.toString(),
      websiteUrl: json['websiteUrl']?.toString(),
      facebook: json['facebook']?.toString(),
      instagram: json['instagram']?.toString(),
      twitter: json['twitter']?.toString(),
      tiktok: json['tiktok']?.toString(),
      snapchat: json['snapchat']?.toString(),
      whatsapp: json['whatsapp']?.toString(),
      socialLinks: socialList
          .map((s) => SocialLink.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
      'nameEn': nameEn,
      'nameAr': nameAr,
      'locationEn': locationEn,
      'locationAr': locationAr,
      'locationLink': locationLink,
      'latitude': latitude,
      'longitude': longitude,
      'mapsEmbedUrl': mapsEmbedUrl,
      'mapsOpenUrl': mapsOpenUrl,
      'profilePath': profilePath,
      'websiteUrl': websiteUrl,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'tiktok': tiktok,
      'snapchat': snapchat,
      'whatsapp': whatsapp,
      'socialLinks': socialLinks.map((s) => s.toJson()).toList(),
    };
  }
}
