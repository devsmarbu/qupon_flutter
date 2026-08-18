import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../data/models/home_collection.dart';
import '../../data/models/home_coupon.dart';
import '../../../offers/data/models/offer.dart';
import '../../../offers/presentation/pages/product_detail_page.dart';

/// Full-page list shown when the user taps "View All" on a home collection.
/// Design mirrors [CategoryOffersPage] — same AppBar, header, and offer cards.
class CollectionCouponsPage extends StatefulWidget {
  final HomeCollection collection;

  const CollectionCouponsPage({super.key, required this.collection});

  @override
  State<CollectionCouponsPage> createState() => _CollectionCouponsPageState();
}

class _CollectionCouponsPageState extends State<CollectionCouponsPage> {
  List<HomeCoupon>? _coupons;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCollectionCoupons();
  }

  Future<void> _fetchCollectionCoupons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiClient = ApiClient();
      final slug = widget.collection.meta.slug;
      final response = await apiClient.dio.get('/api/storefront/collections/$slug');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData != null) {
          Map<String, dynamic> collectionJson;
          if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
            collectionJson = responseData['data'] as Map<String, dynamic>? ?? responseData;
          } else {
            collectionJson = responseData as Map<String, dynamic>? ?? {};
          }

          final fetchedCollection = HomeCollection.fromJson(collectionJson);
          if (mounted) {
            setState(() {
              _coupons = fetchedCollection.coupons;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('Empty response from collection API');
        }
      } else {
        throw Exception('Failed to load collection coupons. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching collection coupons: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';
    final title = isArabic && widget.collection.meta.titleAr.isNotEmpty
        ? widget.collection.meta.titleAr
        : widget.collection.meta.title;
    final coupons = _coupons ?? widget.collection.coupons;

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
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
            color: const Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.read<LocaleCubit>().toggleLocale(),
            child: Text(
              localeCubit.state.languageCode == 'en' ? 'عربي' : 'English',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Divider under AppBar ──────────────────────────────────────
              Container(height: 1, color: const Color(0xFFE2E8F0)),

              // ── Header: collection icon + title + count ───────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    // Collection icon circle (uses first letter as fallback)
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
                      child: Center(
                        child: Text(
                          title.isNotEmpty ? title[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.offersAvailable(coupons.length),
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

              // ── Offer Cards List ──────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 80),
                    child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  ),
                )
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LocalizationService().getString(
                            'COLLECTION_LOAD_ERROR',
                            AppLocalizations.of(context)!.failedToLoadOffers,
                          ),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchCollectionCoupons,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(LocalizationService().getString('RETRY', l10n.retryLabel)),
                        ),
                      ],
                    ),
                  ),
                )
              else if (coupons.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                    child: Text(
                      LocalizationService().getString(
                        'COLLECTION_EMPTY_OFFERS',
                        AppLocalizations.of(context)!.noOffersInCollection,
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
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    return _buildOfferCard(context, coupons[index], l10n, isArabic);
                  },
                ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToDetail(BuildContext context, HomeCoupon coupon) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final offer = Offer(
      id: coupon.id,
      title: coupon.name,
      titleAr: coupon.nameAr,
      category: coupon.category,
      imageUrl: coupon.imageUrl,
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
      final mainPageState =
          context.findAncestorStateOfType<MainPageState>();
      if (mainPageState != null) {
        mainPageState.setSelectedIndex(3);
      }
    }
  }

  Widget _buildOfferCard(
    BuildContext context,
    HomeCoupon coupon,
    AppLocalizations l10n,
    bool isArabic,
  ) {
    final initialLetter =
        coupon.category.isNotEmpty ? coupon.category[0].toUpperCase() : '?';

    final description = isArabic && coupon.descriptionAr.isNotEmpty
        ? coupon.descriptionAr
        : coupon.description;
    final optionName =
        description.length <= 20 ? description.toUpperCase() : LocalizationService().getString('COUPON_OPTION_BASIC', l10n.couponOptionBasic);

    return GestureDetector(
      onTap: () async {
        final isArabic = Localizations.localeOf(context).languageCode == 'ar';
        final offer = Offer(
          id: coupon.id,
          title: coupon.name,
          titleAr: coupon.nameAr,
          category: coupon.category,
          imageUrl: coupon.imageUrl,
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
          final mainPageState =
              context.findAncestorStateOfType<MainPageState>();
          if (mainPageState != null) {
            mainPageState.setSelectedIndex(3);
          }
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
            // ── Image Section ────────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFFEFF6FF),
                    child: coupon.imageUrl.isNotEmpty &&
                            coupon.imageUrl.startsWith('http')
                        ? Image.network(
                            coupon.imageUrl,
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
  
                // Gradient overlay at bottom of image
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
  
                // Title text over the gradient
                Positioned(
                  bottom: 14,
                  left: 16,
                  right: 16,
                  child: Text(
                    isArabic && coupon.nameAr.isNotEmpty ? coupon.nameAr : coupon.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
  
                // Time left badge
                PositionedDirectional(
                  top: 12,
                  end: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xE6E8FDF5),
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
                          l10n.timeLeft(
                              coupon.daysLeft, coupon.hoursLeft, coupon.minutesLeft),
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
  
            // ── Details Area ────────────────────────────────────────────────
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
                          coupon.vendor,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          coupon.category.toUpperCase(),
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
                          coupon.location(isArabic),
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
  
                  // Price & View Details Row
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
                            'QAR ${coupon.priceString}',
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
                          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
                          final offer = Offer(
                            id: coupon.id,
                            title: coupon.name,
                            titleAr: coupon.nameAr,
                            category: coupon.category,
                            imageUrl: coupon.imageUrl,
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
                            final mainPageState =
                                context.findAncestorStateOfType<MainPageState>();
                            if (mainPageState != null) {
                              mainPageState.setSelectedIndex(3);
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocalizationService().getString('COUPON_VIEW_DETAILS', l10n.couponViewDetails),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
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
