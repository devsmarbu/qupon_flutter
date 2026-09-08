import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/offer.dart';
import '../pages/product_detail_page.dart';
import '../../../main/presentation/pages/main_page.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({
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
        final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
        if (viewCart == true && context.mounted) {
          final mainPageState = context.findAncestorStateOfType<MainPageState>();
          if (mainPageState != null) {
            mainPageState.setSelectedIndex(4);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
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
                      height: 200,
                      color: const Color(0xFFF1F5F9),
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
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
                  height: 80,
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
                top: 12,
                end: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xE6E8FDF5), // Light green tint
                    borderRadius: BorderRadius.circular(8),
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
                        size: 14,
                        color: Color(0xFF047857), // Forest green
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.timeLeft(offer.daysLeft, offer.hoursLeft, offer.minutesLeft),
                        style: const TextStyle(
                          fontSize: 12,
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
                bottom: 12,
                left: 16,
                right: 16,
                child: Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 16,
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
            padding: const EdgeInsets.all(16),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A), // Slate 900
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Small uppercase category tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                          fontSize: 10,
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
                const SizedBox(height: 8),

                // Location row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF94A3B8), // Slate 400
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        offer.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B), // Slate 500
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description text in uppercase
                Text(
                  offer.description.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569), // Slate 600
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Footer Row: Price & View Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      l10n.qarPrice(priceString),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF6B35), // Primary orange
                      ),
                    ),
                    // Button
                    ElevatedButton(
                      onPressed: () async {
                        final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
                        if (viewCart == true && context.mounted) {
                          final mainPageState = context.findAncestorStateOfType<MainPageState>();
                          if (mainPageState != null) {
                            mainPageState.setSelectedIndex(4);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.viewDetails,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
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
