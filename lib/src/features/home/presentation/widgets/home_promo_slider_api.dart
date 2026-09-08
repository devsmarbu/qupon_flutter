import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../data/models/home_banner.dart';
import '../../../offers/data/models/offer.dart';
import '../../../offers/presentation/pages/product_detail_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../../../l10n/app_localizations.dart';

/// Promotional banner slider driven by real API data.
class HomePromoSliderApi extends StatefulWidget {
  final List<HomeBanner> banners;

  const HomePromoSliderApi({super.key, required this.banners});

  @override
  State<HomePromoSliderApi> createState() => _HomePromoSliderApiState();
}

class _HomePromoSliderApiState extends State<HomePromoSliderApi> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (_pageController.hasClients && widget.banners.isNotEmpty) {
          final next = (_currentPage + 1) % widget.banners.length;
          _pageController.animateToPage(
            next,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: AspectRatio(
            aspectRatio: 640 / 360,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: widget.banners.length,
              itemBuilder: (context, index) {
                final b = widget.banners[index];
                return GestureDetector(
                  onTap: () async {
                    // Try to guess/map to a category for nicer fallback UI
                    final category = b.title.toLowerCase().contains('smile')
                        ? LocalizationService().getString('HEALTH_WELLNESS', l10n.healthWellness)
                        : b.title.toLowerCase().contains('zubara')
                            ? LocalizationService().getString('TRAVEL_TOURISM', l10n.travelTourism)
                            : b.title.toLowerCase().contains('foodie')
                                ? LocalizationService().getString('HOME_BEST_IN_FOOD', l10n.foodDrinks)
                                : b.title.toLowerCase().contains('gaming')
                                    ? LocalizationService().getString('ENTERTAINMENT', l10n.entertainmentLabel)
                                    : LocalizationService().getString('BEAUTY', l10n.beautyLabel);

                    final bannerCouponId = (b.couponId != null && b.couponId!.isNotEmpty) ? b.couponId! : b.id;
                    final offer = Offer(
                      id: bannerCouponId,
                      title: b.title,
                      titleAr: b.titleAr,
                      category: category,
                      imageUrl: b.imageUrl,
                      daysLeft: 30,
                      hoursLeft: 12,
                      minutesLeft: 0,
                      location: 'Doha, Qatar',
                      description: b.subtitle,
                      descriptionAr: b.subtitleAr,
                      price: 99.0, // Default premium dummy price
                      currency: 'QAR',
                      vendor: b.title.toLowerCase().contains('smile')
                          ? 'Smile Dental Clinic'
                          : b.title.toLowerCase().contains('zubara')
                              ? 'Qatar Adventures'
                              : b.title.toLowerCase().contains('foodie')
                                  ? 'Foodie Festival'
                                  : b.title.toLowerCase().contains('gaming')
                                      ? 'Tactical Gaming'
                                      : 'Laser Treatment Center',
                    );

                    final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
                    if (viewCart == true && context.mounted) {
                      final mainPageState = context.findAncestorStateOfType<MainPageState>();
                      if (mainPageState != null) {
                        mainPageState.setSelectedIndex(3); // Cart is index 3
                      }
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Dynamic network image loading from API response
                      if (b.imageUrl.isNotEmpty && (b.imageUrl.startsWith('http://') || b.imageUrl.startsWith('https://'))) ...[
                        // Blurred background image
                        ImageFiltered(
                          imageFilter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Image.network(
                            b.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (ctx, _, __) => const SizedBox.shrink(),
                          ),
                        ),
                        // Subtle dark tint overlay over the blurred background
                        Container(
                          color: Colors.black.withValues(alpha: 0.15),
                        ),
                        // Main network image
                        Image.network(
                          b.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              color: const Color(0xFFF1F5F9),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF6B35),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (ctx, _, __) => Container(
                            color: const Color(0xFFF1F5F9),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_offer_outlined,
                              size: 48,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Title and subtitle overlay
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isArabic && b.titleAr.isNotEmpty ? b.titleAr : b.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  isArabic && b.subtitleAr.isNotEmpty ? b.subtitleAr : b.subtitle,
                                  style: const TextStyle(
                                    color: Color(0xFFFF6B35),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
    // Indicator Dots
        if (widget.banners.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 14 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _currentPage == index ? const Color(0xFFFF6B35) : const Color(0xFFFFE0D3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
