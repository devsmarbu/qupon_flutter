import 'package:flutter/material.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../home/data/models/home_coupon.dart';
import '../../data/models/offer.dart';
import '../pages/product_detail_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../../../l10n/app_localizations.dart';

/// Horizontal card for the carousel-layout collection sections.
/// Redesigned to exactly match the premium look in the screenshot.
class OfferHorizontalCardApi extends StatelessWidget {
  final HomeCoupon coupon;

  const OfferHorizontalCardApi({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = coupon.imageUrl;

    return GestureDetector(
      onTap: () async {
        final offer = Offer(
          id: coupon.id,
          title: coupon.name,
          titleAr: coupon.nameAr,
          category: coupon.category,
          imageUrl: imageUrl,
          daysLeft: coupon.daysLeft,
          hoursLeft: coupon.hoursLeft,
          minutesLeft: coupon.minutesLeft,
          location: coupon.location(isArabic),
          description: coupon.description,
          descriptionAr: coupon.descriptionAr,
          price: coupon.price,
          currency: 'QAR',
          slug: coupon.slug,
          wishlisted: coupon.wishlisted,
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
        width: 290,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image with overlays ────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                      ? Image.network(
                          imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (ctx, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              height: 140,
                              color: const Color(0xFFF1F5F9),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFF6B35),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => _buildEmptyImage(),
                        )
                      : _buildEmptyImage(),
                ),
                // Countdown badge (top-left)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2FBE9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: const Color(0xFFA7F3D0), width: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time,
                            size: 12, color: Color(0xFF047857)),
                        const SizedBox(width: 4),
                        Text(
                          isArabic
                              ? '${coupon.daysLeft} يوم متبقي'
                              : '${coupon.daysLeft}d ${coupon.hoursLeft}h left',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Details ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vendor Name & Category Tag
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          coupon.vendor,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isArabic && coupon.category == 'Electronics' ? 'إلكترونيات' : coupon.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF475569),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Card Title
                  Text(
                    isArabic && coupon.nameAr.isNotEmpty ? coupon.nameAr : coupon.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location Row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          coupon.location(isArabic),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Price & Details CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationService().getString('COUPON_DETAILS_DEAL_PRICE', l10n.dealPrice),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'QAR ${coupon.priceString}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocalizationService().getString('COMMON_DETAILS', l10n.detailsLabel),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isArabic ? Icons.arrow_back : Icons.arrow_forward,
                              size: 12,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyImage() {
    return Container(
      height: 140,
      width: double.infinity,
      color: const Color(0xFFF8FAFC),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 44,
          color: Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}
