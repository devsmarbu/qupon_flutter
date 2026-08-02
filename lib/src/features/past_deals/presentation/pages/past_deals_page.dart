import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/past_deal_model.dart';

class PastDealsPage extends StatefulWidget {
  final VoidCallback onNavigateHome;

  const PastDealsPage({
    super.key,
    required this.onNavigateHome,
  });

  @override
  State<PastDealsPage> createState() => _PastDealsPageState();
}

class _PastDealsPageState extends State<PastDealsPage> {
  List<PastDeal>? _deals;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPastDeals();
  }

  Future<void> _fetchPastDeals() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiClient().dio.get(ApiEndpoints.pastDeals);
      if (!mounted) return;
      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData != null && responseData['success'] == true) {
          final couponsList = responseData['data']?['coupons'] as List?;
          if (couponsList != null) {
            final parsedDeals = couponsList
                .map((json) => PastDeal.fromJson(json as Map<String, dynamic>))
                .toList();
            setState(() {
              _deals = parsedDeals;
              _isLoading = false;
            });
            return;
          }
        }
      }
      throw Exception('Failed to load past deals');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: Colors.white,
        onRefresh: _fetchPastDeals,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Back to Home Button ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: InkWell(
                  onTap: widget.onNavigateHome,
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isArabic ? Icons.arrow_forward : Icons.arrow_back,
                          size: 16,
                          color: const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.drawerHome,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Page Title Row ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7ED), // Soft orange tint
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFFFD8C2),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.history,
                          color: Color(0xFFFF6B35), // Orange clock icon
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      l10n.pastDealsTitle,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Subtitle Description ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  l10n.pastDealsSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Dynamic Body State ────────────────────────────────────────
              _buildBodyState(l10n, isArabic),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyState(AppLocalizations l10n, bool isArabic) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_outlined, size: 48, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'فشل تحميل العروض السابقة. يرجى التحقق من اتصالك بالإنترنت.'
                    : 'Failed to load past deals. Please check your network connection.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchPastDeals,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isArabic ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final deals = _deals ?? [];

    if (deals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history_toggle_off_outlined, size: 64, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),
              Text(
                isArabic ? 'لا توجد عروض سابقة متاحة حالياً.' : 'No past deals available at the moment.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Deal Count ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.pastDealsCount(deals.length),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF475569),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ── Vertical List of Expired Deals ─────────────────────────────
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: deals.length,
          itemBuilder: (context, index) {
            final deal = deals[index];
            return _PastDealCard(deal: deal, isArabic: isArabic);
          },
        ),
      ],
    );
  }
}

class _PastDealCard extends StatelessWidget {
  final PastDeal deal;
  final bool isArabic;

  const _PastDealCard({
    required this.deal,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final priceString = deal.price % 1 == 0
        ? deal.price.toInt().toString()
        : deal.price.toStringAsFixed(2);

    final title = isArabic && deal.titleAr.isNotEmpty ? deal.titleAr : deal.title;
    final description = isArabic && deal.descriptionAr.isNotEmpty ? deal.descriptionAr : deal.description;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Image Stack ────────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: deal.imageUrl.isNotEmpty
                    ? Image.network(
                        deal.imageUrl,
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
                                color: Color(0xFFFF6B35),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildEmptyPlaceholderImage();
                        },
                      )
                    : _buildEmptyPlaceholderImage(),
              ),
              // Bottom gradient overlay
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
              // Expired Badge (Top Right / End)
              PositionedDirectional(
                top: 12,
                end: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2), // Very soft red
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFEE2E2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Color(0xFFEF4444), // Crimson/Red
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.expired,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Overlay Title inside image bottom
              Positioned(
                bottom: 12,
                left: 16,
                right: 16,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // ── Details Body ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand name and Category Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        deal.brand,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (deal.category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF), // Soft blue tint
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          deal.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB), // Blue text
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
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        deal.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Uppercase Description
                if (description.isNotEmpty)
                  Text(
                    description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 16),

                // Price and Request Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.qarPrice(priceString),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isArabic
                                  ? 'تم تقديم طلب لإعادة الكوبون!'
                                  : 'Request submitted to bring this coupon back!',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: const Color(0xFFFF6B35),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        isArabic ? 'اطلب الإعادة' : 'Request Back',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPlaceholderImage() {
    return Container(
      height: 200,
      color: const Color(0xFFF8FAFC),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          size: 40,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
