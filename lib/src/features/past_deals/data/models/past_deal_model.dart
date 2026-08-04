class PastDeal {
  final String id;
  final String title;
  final String titleAr;
  final String brand;
  final String category;
  final String location;
  final String description;
  final String descriptionAr;
  final double price;
  final String currency;
  final String imageUrl;
  final String slug;

  const PastDeal({
    required this.id,
    required this.title,
    this.titleAr = '',
    required this.brand,
    required this.category,
    required this.location,
    required this.description,
    this.descriptionAr = '',
    required this.price,
    required this.currency,
    required this.imageUrl,
    this.slug = '',
  });

  factory PastDeal.fromJson(Map<String, dynamic> json) {
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

    // Resolve relative URL path if any
    if (imgUrl.isNotEmpty && !imgUrl.startsWith('http')) {
      imgUrl = 'https://qupon.marbu.in$imgUrl';
    }

    return PastDeal(
      id: json['id']?.toString() ?? '',
      title: json['name']?.toString() ?? '',
      titleAr: json['nameAr']?.toString() ?? '',
      brand: json['vendor']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      location: json['location']?.toString() ?? 'Doha, Qatar',
      description: json['description']?.toString() ?? '',
      descriptionAr: json['descriptionAr']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: 'QAR',
      imageUrl: imgUrl,
      slug: json['slug']?.toString() ?? json['id']?.toString() ?? '',
    );
  }

  static const List<PastDeal> mockPastDeals = [
    PastDeal(
      id: 'pd-1',
      title: 'Discover Arabia for Tourism',
      brand: 'Burger King',
      category: 'FASHION',
      location: '5505 Blue Lagoon Drive, Miami, FL 33126',
      description: 'YACHT TOUR IN THE PERSIAN GULF',
      price: 1400.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1582233479366-6d38bc390a08?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-2',
      title: 'INTO THE INFINITE',
      brand: 'Starry Night Art',
      category: 'ART & GALLERY',
      location: 'Gallery One, The Pearl-Qatar',
      description: 'STRENGTH MEETS SURRENDER PAINTING',
      price: 2500.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1461360370896-922624d12aa1?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-3',
      title: 'Luxury Yacht Cruise',
      brand: 'Royal Marine',
      category: 'ENTERTAINMENT',
      location: 'Marina Gate, Doha',
      description: '4-HOUR PRIVATE DOCK CRUISE WITH DINNER',
      price: 3500.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-4',
      title: 'Premium Tomahawk Steak Dinner',
      brand: 'The Steakhouse',
      category: 'FOOD & DRINKS',
      location: 'Msheireb Downtown, Doha',
      description: '3-COURSE DINNER FOR TWO',
      price: 499.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-5',
      title: 'Banana Island Resort Getaway',
      brand: 'Anantara Resorts',
      category: 'HOTELS',
      location: 'Banana Island, Doha',
      description: 'ONE NIGHT STAY IN OCEAN VIEW ROOM',
      price: 1200.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-6',
      title: 'Designer Summer Collection',
      brand: 'Vogue Boutique',
      category: 'FASHION',
      location: 'Mall of Qatar, Doha',
      description: 'QAR 500 GIFT VOUCHER FOR FASHION ITEMS',
      price: 400.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-7',
      title: 'Sunset Desert Safari & BBQ',
      brand: 'Qatar Adventures',
      category: 'SPORTS & OUTDOOR',
      location: 'Sealine Beach, Mesaieed',
      description: 'HALF-DAY SAFARI WITH DUNE BASHING',
      price: 299.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1509316975850-ff9c5edd0cd9?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-8',
      title: 'VIP Concert Access',
      brand: 'Qatar Music Arena',
      category: 'EVENTS',
      location: 'Lusail Iconic Stadium',
      description: 'VIP PASS FOR INTERNATIONAL MUSIC FESTIVAL',
      price: 850.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=800&q=80',
    ),
    PastDeal(
      id: 'pd-9',
      title: 'Moroccan Hammam & Massage',
      brand: 'Luxe Spa & Salon',
      category: 'BEAUTY & SPA',
      location: 'West Bay Suites, Doha',
      description: '90-MINUTES FULL BODY TREATMENT',
      price: 350.0,
      currency: 'QAR',
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
    ),
  ];
}
