import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../data/models/home_data.dart';
import '../../data/models/home_collection.dart';
import '../../data/models/home_coupon.dart';
import '../../presentation/bloc/home_bloc.dart';
import '../../../offers/presentation/widgets/offer_horizontal_card_api.dart';
import '../widgets/home_promo_slider_api.dart';
import '../widgets/home_category_section_api.dart';
import '../../../offers/data/models/offer.dart';
import '../../../offers/presentation/pages/product_detail_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import 'collection_coupons_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(const FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return SafeArea(
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            );
          } else if (state is HomeLoaded) {
            return _buildContent(context, state.data, isArabic);
          } else if (state is HomeError) {
            return _buildError(context, state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 48, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  context.read<HomeBloc>().add(const FetchHomeData()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, HomeData data, bool isArabic) {
    // Find the promo coupon dynamically from any collections
    final allCoupons = data.collections.expand((c) => c.coupons).toList();
    HomeCoupon? promoCoupon;
    if (allCoupons.isNotEmpty) {
      promoCoupon = allCoupons.firstWhere(
        (c) => c.name.toLowerCase().contains('tech') || c.name.toLowerCase().contains('gadget') || c.name.toLowerCase().contains('laptop'),
        orElse: () => allCoupons.first,
      );
    }
    final localPromo = promoCoupon;

    // Identify collections safely
    HomeCollection? summerPicks;
    HomeCollection? handpicked;
    
    for (final col in data.collections) {
      if (col.meta.slug == 'summer-picks') {
        summerPicks = col;
      } else if (col.meta.slug == 'handpicked') {
        handpicked = col;
      }
    }
    
    // Fallbacks if not found by slug
    if (data.collections.isNotEmpty) {
      summerPicks ??= data.collections.first;
      if (data.collections.length > 1) {
        handpicked ??= data.collections[1];
      }
    }

    return RefreshIndicator(
      color: const Color(0xFFFF6B35),
      backgroundColor: Colors.white,
      onRefresh: () async {
        context.read<HomeBloc>().add(const FetchHomeData());
        await context
            .read<HomeBloc>()
            .stream
            .firstWhere((state) => state is HomeLoaded || state is HomeError);
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // ── Search Bar ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: GestureDetector(
                onTap: () {
                  // Navigate to search (future feature) or show search
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        isArabic
                            ? 'البحث عن كوبونات، موردين...'
                            : 'Search for coupons, vendors...',
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Promotional Slider ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: HomePromoSliderApi(banners: data.banners),
          ),

          // ── Divider ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              height: 1,
              color: const Color(0xFFE2E8F0),
            ),
          ),

          // ── Shop by Category ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                isArabic ? 'تسوق حسب الفئة' : 'Shop by Category',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: HomeCategorySectionApi(categories: data.categories),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Summer Picks ───────────────────────────────────────────────────
          if (summerPicks != null) _buildCollection(summerPicks, isArabic),

          // ── Mid Promotional Banner Card ────────────────────────────────────
          if (localPromo != null)
            SliverToBoxAdapter(
              child: GestureDetector(
                onTap: () async {
                  final offer = Offer(
                    id: localPromo.id,
                    title: localPromo.name,
                    category: localPromo.category,
                    imageUrl: localPromo.imageUrl,
                    daysLeft: localPromo.daysLeft,
                    hoursLeft: localPromo.hoursLeft,
                    minutesLeft: localPromo.minutesLeft,
                    location: '123 Tech Avenue, Silicon Valley, CA 94025',
                    description: localPromo.description,
                    price: localPromo.price,
                    currency: 'QAR',
                    slug: localPromo.slug,
                  );
                  final viewCart = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(offer: offer),
                    ),
                  );
                  if (viewCart == true && context.mounted) {
                    final mainPageState = context.findAncestorStateOfType<MainPageState>();
                    if (mainPageState != null) {
                      mainPageState.setSelectedIndex(3); // Cart is index 3
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2EC), // Peach background
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE0D3), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isArabic ? 'إلكترونيات' : 'ELECTRONICS',
                          style: const TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isArabic && localPromo.nameAr.isNotEmpty ? localPromo.nameAr : localPromo.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isArabic && localPromo.descriptionAr.isNotEmpty ? localPromo.descriptionAr : localPromo.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Handpicked ─────────────────────────────────────────────────────
          if (handpicked != null) _buildCollection(handpicked, isArabic),

          // ── Footer ─────────────────────────────────────────────────────────
        //  const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
    );
  }

  Widget _buildCollection(HomeCollection collection, bool isArabic) {
    final title = isArabic && collection.meta.titleAr.isNotEmpty
        ? collection.meta.titleAr
        : collection.meta.title;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CollectionCouponsPage(
                          collection: collection,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isArabic ? 'عرض الكل' : 'View All',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          isArabic ? Icons.arrow_back : Icons.arrow_forward,
                          size: 16,
                          color: const Color(0xFFFF6B35),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 310,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.only(left: 16, top: 8, bottom: 16),
              itemCount: collection.coupons.length,
              itemBuilder: (context, index) {
                return OfferHorizontalCardApi(
                    coupon: collection.coupons[index]);
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
