import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/offer.dart';
import '../pages/product_detail_page.dart';

import '../../../main/presentation/pages/main_page.dart';

class OfferHorizontalCard extends StatelessWidget {
  final Offer offer;

  const OfferHorizontalCard({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Format price to drop decimal if it's a whole number
    final priceString = offer.price % 1 == 0 
        ? offer.price.toInt().toString() 
        : offer.price.toStringAsFixed(2);

    return GestureDetector(
      onTap: () async {
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
        border: Border.all(
          color: const Color(0xFFF1F5F9), // Light border divider
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Offer Image with overlays
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  offer.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 140,
                      color: const Color(0xFFF8FAFC),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF6B35), // Primary orange
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay at the bottom of the image for text legibility
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Countdown timer badge (Top Right)
              PositionedDirectional(
                top: 10,
                end: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xE6E8FDF5), // Light green tint
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFA7F3D0), // Soft green border
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Color(0xFF047857), // Forest green
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.timeLeft(offer.daysLeft, offer.hoursLeft, offer.minutesLeft),
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
              // Bold title overlay at the bottom
              Positioned(
                bottom: 8,
                left: 12,
                right: 12,
                child: Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Details Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        offer.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A), // Slate 900
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Small uppercase category tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: offer.category.toUpperCase() == 'FOOD & DRINKS'
                            ? const Color(0xFFECF2FF)
                            : offer.category.toUpperCase() == 'ANIMAL CARE'
                                ? const Color(0xFFFFF7ED)
                                : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        offer.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: offer.category.toUpperCase() == 'FOOD & DRINKS'
                              ? const Color(0xFF4F46E5)
                              : offer.category.toUpperCase() == 'ANIMAL CARE'
                                  ? const Color(0xFFEA580C)
                                  : const Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Location row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(0xFF94A3B8), // Slate 400
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        offer.location,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B), // Slate 500
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description text in uppercase
                Text(
                  offer.description.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569), // Slate 600
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer Row: Price & View Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Expanded(
                      child: Text(
                        l10n.qarPrice(priceString),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF6B35), // Primary orange
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.viewDetails,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
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
}
