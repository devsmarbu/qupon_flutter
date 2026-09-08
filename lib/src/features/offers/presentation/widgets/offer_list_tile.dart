import 'package:flutter/material.dart';

import '../../data/models/offer.dart';
import '../pages/product_detail_page.dart';

import '../../../main/presentation/pages/main_page.dart';

/// A compact horizontal list tile used in the "Handpicked" section on the home page.
/// Shows a small avatar/image, title, vendor name, and "YOU PAY QAR X" price.
class OfferListTile extends StatelessWidget {
  final Offer offer;

  const OfferListTile({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    // Format price to drop decimal if whole number
    final priceString = offer.price % 1 == 0
        ? offer.price.toInt().toString()
        : offer.price.toStringAsFixed(2);

    return GestureDetector(
      onTap: () async {
        final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
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
          border: Border.all(
            color: const Color(0xFFF1F5F9),
            width: 1,
          ),
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
            // ── Thumbnail avatar ─────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Image.network(
                  offer.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Text(
                          offer.title.isNotEmpty
                              ? offer.title[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Text(
                          offer.title.isNotEmpty
                              ? offer.title[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    );
                  },
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
                  // Title
                  Text(
                    offer.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  // Vendor / category
                  Text(
                    offer.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // YOU PAY label + price
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
                        'QAR $priceString',
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

            // ── Arrow ────────────────────────────────────────────────────────
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
