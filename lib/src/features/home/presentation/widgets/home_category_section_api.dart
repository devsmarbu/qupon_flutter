import 'package:flutter/material.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/home_category.dart';
import '../../../offers/presentation/pages/category_offers_page.dart';
import '../../../main/presentation/pages/main_page.dart';

/// 3x2 grid of category bubbles matching the design of the screenshot.
class HomeCategorySectionApi extends StatelessWidget {
  final List<HomeCategory> categories;

  const HomeCategorySectionApi({super.key, required this.categories});

  static const List<HomeCategory> customCategoriesList = [
    HomeCategory(
      id: '6a0988fb458bd9ca85ee6c30',
      name: 'Electronics',
      nameAr: 'إلكترونيات',
      slug: 'electronics',
      iconUrl: 'https://images.unsplash.com/photo-1588508065123-287b28e013da?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
    HomeCategory(
      id: '6a0988fb458bd9ca85ee6c2f',
      name: 'Fashion',
      nameAr: 'الموضة',
      slug: 'fashion',
      iconUrl: 'https://images.unsplash.com/photo-1489987707025-afc232f7ea0f?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
    HomeCategory(
      id: 'home-living',
      name: 'Home & Living',
      nameAr: 'المنزل والمعيشة',
      slug: 'home-living',
      iconUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
    HomeCategory(
      id: 'beauty',
      name: 'Beauty',
      nameAr: 'التجميل',
      slug: 'beauty',
      iconUrl: 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
    HomeCategory(
      id: 'sports',
      name: 'Sports',
      nameAr: 'الرياضة',
      slug: 'sports',
      iconUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
    HomeCategory(
      id: 'groceries',
      name: 'Groceries',
      nameAr: 'البقالة',
      slug: 'groceries',
      iconUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=200&auto=format&fit=crop&q=80',
      imageUrl: '',
      offersCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final name = isArabic ? cat.nameAr : cat.name;

          final hasValidIcon = cat.iconUrl.startsWith('http');
          final hasValidImage = cat.imageUrl.startsWith('http');
          final imageUrlToUse = hasValidIcon ? cat.iconUrl : (hasValidImage ? cat.imageUrl : '');

          return GestureDetector(
            onTap: () async {
              final viewCart = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => CategoryOffersPage(category: cat),
                ),
              );
              if (viewCart == true && context.mounted) {
                final mainPageState = context.findAncestorStateOfType<MainPageState>();
                if (mainPageState != null) {
                  mainPageState.setSelectedIndex(3); // Cart is index 3
                }
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF1F5F9),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: imageUrlToUse.isNotEmpty
                        ? Image.network(
                            imageUrlToUse,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.category_outlined,
                              size: 32,
                              color: Color(0xFF94A3B8),
                            ),
                          )
                        : const Icon(
                            Icons.category_outlined,
                            size: 32,
                            color: Color(0xFF94A3B8),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
