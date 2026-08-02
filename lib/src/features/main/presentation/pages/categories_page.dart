import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../home/data/models/home_category.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../offers/presentation/pages/category_offers_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key, this.onNavigateHome});

  final VoidCallback? onNavigateHome;

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    // Trigger home data fetch if it hasn't been fetched yet
    final homeBloc = context.read<HomeBloc>();
    if (homeBloc.state is! HomeLoaded && homeBloc.state is! HomeLoading) {
      homeBloc.add(const FetchHomeData());
    }

    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is HomeLoaded) {
            return _buildContent(context, state.data.categories, isArabic);
          } else if (state is HomeError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<HomeCategory> categories, bool isArabic) {
    final l10n = AppLocalizations.of(context)!;
    final totalOffers = categories.fold<int>(0, (sum, cat) => sum + cat.offersCount);
    final totalCategories = categories.length;

    final subtitleText = isArabic
        ? '$totalOffers عرضاً عبر $totalCategories فئات مميزة'
        : '$totalOffers offers across $totalCategories premium categories';

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<HomeBloc>().add(const FetchHomeData());
        await context
            .read<HomeBloc>()
            .stream
            .firstWhere((state) => state is HomeLoaded || state is HomeError);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header Navigation Back to Home ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: InkWell(
                onTap: onNavigateHome,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isArabic ? Icons.arrow_forward : Icons.arrow_back,
                        size: 18,
                        color: AppColors.textDarkBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.drawerHome,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Page Titles ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'الفئات' : 'Categories',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitleText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Categories Vertical List ───────────────────────────────────────
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              padding: const EdgeInsets.only(bottom: 32),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final name = isArabic ? cat.nameAr : cat.name;

                final offersCountText = isArabic
                    ? '${cat.offersCount} ${cat.offersCount == 1 ? 'عرض' : 'عروض'}'
                    : '${cat.offersCount} ${cat.offersCount == 1 ? 'OFFER' : 'OFFERS'}';

                final hasValidIcon = cat.iconUrl.startsWith('http');
                final hasValidImage = cat.imageUrl.startsWith('http');
                final imageUrlToUse = hasValidIcon ? cat.iconUrl : (hasValidImage ? cat.imageUrl : '');

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: InkWell(
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
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Category Circle Icon/Image
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFF1F5F9),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: imageUrlToUse.isNotEmpty
                                  ? Image.network(
                                      imageUrlToUse,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.category_outlined,
                                        color: Color(0xFF94A3B8),
                                        size: 28,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.category_outlined,
                                      color: Color(0xFF94A3B8),
                                      size: 28,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Title and Offers count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  offersCountText.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow Forward Indicator
                          Icon(
                            isArabic ? Icons.arrow_back : Icons.arrow_forward,
                            color: const Color(0xFF64748B),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
