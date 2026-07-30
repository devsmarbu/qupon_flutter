import 'package:flutter/material.dart';
import '../../../home/data/models/home_coupon.dart';
import '../../data/models/offer.dart';
import '../pages/product_detail_page.dart';
import '../../../main/presentation/pages/main_page.dart';

/// A compact list tile for the compact/tinted collection sections (e.g. "Handpicked").
/// Driven by real [HomeCoupon] data from the storefront home API.
class OfferListTileApi extends StatelessWidget {
  final HomeCoupon coupon;

  const OfferListTileApi({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final offer = Offer(
          id: coupon.id,
          title: coupon.name,
          category: coupon.category,
          imageUrl: '',
          daysLeft: coupon.daysLeft,
          hoursLeft: coupon.hoursLeft,
          minutesLeft: coupon.minutesLeft,
          location: '123 Tech Avenue, Silicon Valley, CA 94025',
          description: coupon.description,
          price: coupon.price,
          currency: 'QAR',
        );
        final viewCart = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(offer: offer),
          ),
        );
        if (viewCart == true && context.mounted) {
          final mainPageState = context.findAncestorStateOfType<MainPageState>();
          if (mainPageState != null) {
            mainPageState.setSelectedIndex(4);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Avatar (initial letter) ──────────────────────────────────────
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  coupon.name.isNotEmpty
                      ? coupon.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Title + vendor + price ────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coupon.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    coupon.vendor,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'YOU PAY',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'QAR ${coupon.priceString}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Arrow ─────────────────────────────────────────────────────────
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFFCBD5E1),
            ),
          ],
        ),
      ),
    );
  }
}
