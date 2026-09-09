import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../main/presentation/widgets/app_footer.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../home/data/models/home_category.dart';

import '../bloc/offers_bloc.dart';
import '../../data/models/offer.dart';
import 'product_detail_page.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';

class CategoryOffersPage extends StatefulWidget {
  final HomeCategory category;

  const CategoryOffersPage({super.key, required this.category});

  @override
  State<CategoryOffersPage> createState() => _CategoryOffersPageState();
}

class _CategoryOffersPageState extends State<CategoryOffersPage> {
  @override
  void initState() {
    super.initState();
    context.read<OffersBloc>().add(FetchOffers(categoryId: widget.category.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';
    final categoryName = isArabic ? widget.category.nameAr : widget.category.name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Qupon',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
            Transform.translate(
              offset: const Offset(2, -4),
              child: const Text(
                'كوبون',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<LocaleCubit>().toggleLocale();
            },
            child: Text(
              localeCubit.state.languageCode == 'en'
                  ? 'عربي'
                  : 'English',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<OffersBloc, OffersState>(
          builder: (context, state) {
            if (state is OffersLoading || state is OffersInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
              );
            } else if (state is OffersError) {
              final lower = state.message.toLowerCase();
              final displayMessage = (lower.contains('exception') ||
                      lower.contains('failed host lookup') ||
                      lower.contains('socketexception') ||
                      lower.contains('dioexception'))
                  ? (isArabic
                      ? 'فشل تحميل العروض. يرجى التحقق من اتصالك بالإنترنت.'
                      : 'Failed to load offers. Please check your network connection.')
                  : state.message;

              return RefreshIndicator(
                color: const Color(0xFFFF6B35),
                backgroundColor: Colors.white,
                onRefresh: () async {
                  context.read<OffersBloc>().add(FetchOffers(categoryId: widget.category.id));
                  await context
                      .read<OffersBloc>()
                      .stream
                      .firstWhere((s) => s is OffersLoaded || s is OffersError);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF2EC),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.wifi_off_outlined,
                              size: 36,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          displayMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 15,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<OffersBloc>().add(FetchOffers(categoryId: widget.category.id));
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: Text(
                            LocalizationService().getString('RETRY', l10n.retryLabel),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is OffersLoaded) {
              final filteredOffers = state.offers;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider under Appbar
                    Container(height: 1, color: const Color(0xFFE2E8F0)),

                   // // ── Back Button ──────────────────────────────────────────
                   //  Padding(
                   //    padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                   //    child:
                   //    InkWell(
                   //      onTap: () => Navigator.of(context).pop(),
                   //      borderRadius: BorderRadius.circular(4),
                   //      child: Padding(
                   //        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                   //        child: Row(
                   //          mainAxisSize: MainAxisSize.min,
                   //          children: [
                   //            Icon(
                   //              isArabic ? Icons.arrow_forward : Icons.arrow_back,
                   //              size: 16,
                   //              color: const Color(0xFF64748B),
                   //            ),
                   //            const SizedBox(width: 8),
                   //            Text(
                   //              l10n.back,
                   //              style: const TextStyle(
                   //                fontSize: 14,
                   //                fontWeight: FontWeight.w600,
                   //                color: Color(0xFF64748B),
                   //              ),
                   //            ),
                   //          ],
                   //        ),
                   //      ),
                   //    ),
                   //  ),

                    // ── Header Title & Category Icon Section ─────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Row(
                        children: [
                          // Category Circular Icon/Avatar
                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: widget.category.iconUrl.isNotEmpty || widget.category.imageUrl.isNotEmpty
                                  ? Image.network(
                                      widget.category.iconUrl.isNotEmpty ? widget.category.iconUrl : widget.category.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.category_outlined,
                                        size: 30,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.category_outlined,
                                      size: 30,
                                      color: Color(0xFF94A3B8),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Title & Count
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoryName,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.offersAvailable(filteredOffers.length),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Category Offers List ────────────────────────────────
                    if (filteredOffers.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                          child: Text(
                            LocalizationService().getString(
                              'CATEGORY_EMPTY_OFFERS',
                              l10n.noOffersInCategory,
                            ),
                            style: const TextStyle(color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredOffers.length,
                        itemBuilder: (context, index) {
                          final offer = filteredOffers[index];
                          return _buildOfferCard(context, offer, l10n, isArabic);
                        },
                      ),

                    const SizedBox(height: 48),

                    // ── Footer ──────────────────────────────────────────────
                    // const AppFooter(),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _navigateToDetail(BuildContext context, Offer offer) async {
    final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
    if (viewCart == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Widget _buildOfferCard(BuildContext context, Offer offer, AppLocalizations l10n, bool isArabic) {
    final vendorName = offer.vendor ?? (offer.category == 'Electronics' ? 'ElectroWorld' : offer.title);
    final initialLetter = offer.category.isNotEmpty ? offer.category[0].toUpperCase() : '?';

    // Option Name Calculation: if short (<= 20 chars e.g. "Laptop Sleeve"), use it, else default to "BASIC"
    final description = (isArabic && offer.descriptionAr != null && offer.descriptionAr!.isNotEmpty)
        ? offer.descriptionAr!
        : offer.description;
    final optionName = description.length <= 20
        ? description.toUpperCase()
        : LocalizationService().getString('COUPON_OPTION_BASIC', l10n.couponOptionBasic);

    return GestureDetector(
      onTap: () async {
        final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
        if (viewCart == true && context.mounted) {
          Navigator.of(context).pop(true);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image Section (Stack) ────────────────────────────────────────
            Stack(
              children: [
                // Cover Image or Initial Letter Fallback
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFFEFF6FF), // soft premium blue tint
                    child: offer.imageUrl.isNotEmpty
                        ? Image.network(
                            offer.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Text(
                                initialLetter,
                                style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              initialLetter,
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                  ),
                ),
  
                // Gradient Overlay at bottom of image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
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
  
                // Title text over the image bottom gradient
                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Text(
                    (isArabic && offer.titleAr != null && offer.titleAr!.isNotEmpty)
                        ? offer.titleAr!
                        : offer.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
  
                // Time Left countdown badge
                PositionedDirectional(
                  top: 12,
                  end: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xE6E8FDF5), // Soft green tint
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFA7F3D0),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF047857),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.timeLeft(offer.daysLeft, offer.hoursLeft, offer.minutesLeft),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
  
            // ── Details Area ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vendor and Category Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          vendorName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          offer.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
  
                  // Location row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          (isArabic && offer.locationAr.isNotEmpty) ? offer.locationAr : offer.locationEn,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFF1F5F9), height: 1),
                  const SizedBox(height: 16),
  
                  // Prices & View Details Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            optionName,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'QAR ${offer.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFFF6B35),
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          final viewCart = await ProductDetailPage.navigateWithPreload(context, offer);
                          if (viewCart == true && context.mounted) {
                            Navigator.of(context).pop(true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocalizationService().getString('COUPON_VIEW_DETAILS', l10n.couponViewDetails),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isArabic ? Icons.arrow_back : Icons.arrow_forward,
                              size: 14,
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
