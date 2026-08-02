import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../main/presentation/widgets/app_footer.dart';

import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';

class _Localizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'backToListings': 'Back to Listings',
      'selectOption': 'Select Option',
      'basic': 'Basic',
      'pro': 'Pro',
      'youPay': 'YOU PAY',
      'getDealNow': 'Get Deal Now',
      'buyAsGift': 'Buy as Gift',
      'offerDescription': 'Offer Description',
      'importantNotes': 'Important Notes',
      'importantNotesText': 'Excludes Apple products and clearance items.',
      'vendorDetails': 'Vendor Details',
      'viewVendorProfile': 'View Vendor Profile',
      'openInMaps': 'Open in Maps',
      'followUs': 'FOLLOW US',
      'electronics': 'Electronics',
      'electroWorld': 'ElectroWorld',
      'arabic': 'عربي',
      'english': 'English',
      'qupon': 'Qupon',
      'quponAr': 'كوبون',
      'timeLeft': '{days}d {hours}h {minutes}m left',
    },
    'ar': {
      'backToListings': 'العودة للقائمة',
      'selectOption': 'حدد خياراً',
      'basic': 'أساسي',
      'pro': 'برو',
      'youPay': 'أنت تدفع',
      'getDealNow': 'احصل على الصفقة الآن',
      'buyAsGift': 'شراء كهدية',
      'offerDescription': 'وصف العرض',
      'importantNotes': 'ملاحظات هامة',
      'importantNotesText': 'يستثنى من ذلك منتجات Apple والعناصر المخفضة.',
      'vendorDetails': 'تفاصيل البائع',
      'viewVendorProfile': 'عرض ملف البائع',
      'openInMaps': 'افتح في الخرائط',
      'followUs': 'تابعنا',
      'electronics': 'إلكترونيات',
      'electroWorld': 'إلكترو ورلد',
      'arabic': 'عربي',
      'english': 'English',
      'qupon': 'Qupon',
      'quponAr': 'كوبون',
      'timeLeft': 'متبقي {days} يوم و {hours} ساعة و {minutes} دقيقة',
    },
  };

  static String get(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }
}

class ProductDetailPage extends StatelessWidget {
  final Offer offer;

  const ProductDetailPage({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailBloc>(
      create: (context) => ProductDetailBloc()..add(InitializeProductDetail(offer, variants: offer.variants)),
      child: const ProductDetailView(),
    );
  }
}

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({super.key});

  void _showAddedToCartSnackBar(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'تمت إضافة العرض إلى السلة بنجاح!'
              : 'Offer added to cart successfully!',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          textColor: const Color(0xFFFF6B35),
          label: isArabic ? 'عرض السلة' : 'View Cart',
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      builder: (context, state) {
        final offer = state.offer;
        if (offer == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
          );
        }

        final selectedOption = state.options.isNotEmpty
            ? state.options[state.selectedOptionIndex]
            : OfferOption(id: 'dummy', name: 'Basic', originalPrice: offer.price * 2, price: offer.price);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                isArabic ? Icons.arrow_forward : Icons.arrow_back,
                color: const Color(0xFF0F172A),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: false,
            titleSpacing: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _Localizations.get(context, 'qupon'),
                  style: const TextStyle(
                    color: Color(0xFFFF6B35),
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                Transform.translate(
                  offset: const Offset(2, -4),
                  child: Text(
                    _Localizations.get(context, 'quponAr'),
                    style: const TextStyle(
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
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 150), // bottom margin to clear sticky bar
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Divider
                       Container(height: 1, color: const Color(0xFFE2E8F0)),

                      SizedBox(height: 20),
                      // "Back to Listings" Row
                      // InkWell(
                      //   onTap: () => Navigator.of(context).pop(),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Icon(
                      //           isArabic ? Icons.arrow_forward : Icons.arrow_back,
                      //           size: 18,
                      //           color: const Color(0xFF64748B),
                      //         ),
                      //         const SizedBox(width: 8),
                      //         Text(
                      //           _Localizations.get(context, 'backToListings'),
                      //           style: const TextStyle(
                      //             color: Color(0xFF64748B),
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      // Image Area Card with Center placeholder 'E' tilted, and overlay actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Stack(
                          children: [
                            Container(
                              height: 240,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  children: [
                                    // Big 'E' tilted placeholder in center
                                    Center(
                                      child: Transform.rotate(
                                        angle: -0.15,
                                        child: Text(
                                          offer.category.toUpperCase().startsWith('E') ? 'E' : offer.category[0].toUpperCase(),
                                          style: TextStyle(
                                            color: const Color(0xFFE2E8F0).withOpacity(0.9),
                                            fontSize: 140,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Unsplash image if category is not mock electronic, else standard gradient/illustration
                                    Positioned.fill(
                                      child: Image.network(
                                        offer.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Category Tag on top-left of image
                            PositionedDirectional(
                              top: 16,
                              start: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  offer.category == 'Electronics'
                                      ? _Localizations.get(context, 'electronics')
                                      : offer.category,
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Column of action buttons on the right edge of image
                            PositionedDirectional(
                              top: 16,
                              end: 16,
                              child: Column(
                                children: [
                                  _ImageCircularButton(
                                    icon: state.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                    iconColor: state.isFavorite ? Colors.red : const Color(0xFF64748B),
                                    onTap: () => context.read<ProductDetailBloc>().add(const ToggleFavorite()),
                                  ),
                                  const SizedBox(height: 12),
                                  _ImageCircularButton(
                                    icon: state.isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
                                    iconColor: state.isBookmarked ? const Color(0xFFFF6B35) : const Color(0xFF64748B),
                                    onTap: () => context.read<ProductDetailBloc>().add(const ToggleBookmark()),
                                  ),
                                  const SizedBox(height: 12),
                                  _ImageCircularButton(
                                    icon: Icons.share_outlined,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title & Badges
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (isArabic && offer.titleAr != null && offer.titleAr!.isNotEmpty)
                                  ? offer.titleAr!
                                  : offer.title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Badges Row
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFFFEDD5), width: 0.5),
                                  ),
                                  child: Text(
                                    offer.vendor ?? _Localizations.get(context, 'electroWorld'),
                                    style: const TextStyle(
                                      color: Color(0xFFEA580C),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    offer.category == 'Electronics'
                                        ? _Localizations.get(context, 'electronics')
                                        : offer.category,
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Time Left Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8FDF5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time_filled,
                                    size: 15,
                                    color: Color(0xFF047857),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    isArabic
                                        ? 'متبقي ${offer.daysLeft} يوم و ${offer.hoursLeft} ساعة و ${offer.minutesLeft} دقيقة'
                                        : '${offer.daysLeft}d ${offer.hoursLeft}h ${offer.minutesLeft}m left',
                                    style: const TextStyle(
                                      color: Color(0xFF047857),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(height: 1, color: const Color(0xFFF1F5F9)),
                      ),
                      const SizedBox(height: 20),

                      // Select Option
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _Localizations.get(context, 'selectOption'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.options.length,
                              itemBuilder: (context, index) {
                                final option = state.options[index];
                                final isSelected = state.selectedOptionIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    context.read<ProductDetailBloc>().add(SelectOption(index));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFFFFDFB) : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE2E8F0),
                                        width: isSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          option.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              'QAR ${option.originalPrice.toInt()}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF94A3B8),
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              _Localizations.get(context, 'youPay'),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                            Text(
                                              'QAR ${option.price.toInt()}',
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xFFFF6B35),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Offer Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _Localizations.get(context, 'offerDescription'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              (isArabic && offer.descriptionAr != null && offer.descriptionAr!.isNotEmpty)
                                  ? offer.descriptionAr!
                                  : offer.description,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF475569),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Important Notes Box
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBEB),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFDE68A),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.bookmark_border_outlined,
                                color: Color(0xFF78350F),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _Localizations.get(context, 'importantNotes'),
                                      style: const TextStyle(
                                        color: Color(0xFF78350F),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _Localizations.get(context, 'importantNotesText'),
                                      style: const TextStyle(
                                        color: Color(0xFF92400E),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Mid-page summary details card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'QAR ${selectedOption.originalPrice.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF94A3B8),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _Localizations.get(context, 'youPay'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF64748B),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'QAR ${selectedOption.price.toInt()}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFFF6B35),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    AddToCart(offer: offer, option: selectedOption),
                                  );
                                  _showAddedToCartSnackBar(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B35),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 50),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  _Localizations.get(context, 'getDealNow'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    AddToCart(offer: offer, option: selectedOption),
                                  );
                                  context.read<CartBloc>().add(
                                    const ToggleGift(isGift: true),
                                  );
                                  _showAddedToCartSnackBar(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  _Localizations.get(context, 'buyAsGift'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.read<ProductDetailBloc>().add(const ToggleBookmark()),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Icon(
                                        state.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                        color: state.isBookmarked ? const Color(0xFFFF6B35) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF64748B)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: const Icon(Icons.share_outlined, color: Color(0xFF64748B)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Vendor Details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _Localizations.get(context, 'vendorDetails'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Profile row
                                  Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: const Color(0xFFE2E8F0)),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.storefront_outlined,
                                            color: Color(0xFF64748B),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              offer.vendor ?? _Localizations.get(context, 'electroWorld'),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                _Localizations.get(context, 'viewVendorProfile'),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xFFFF6B35),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Address Field
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF64748B),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            '123 Tech Avenue, Silicon Valley, CA 94025',
                                            style: TextStyle(
                                              color: Color(0xFF475569),
                                              fontSize: 13,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Map View
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      height: 180,
                                      width: double.infinity,
                                      color: const Color(0xFFE0F2FE), // water blue
                                      child: Stack(
                                        children: [
                                          // Custom drawn map vector elements
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: _MapPainter(),
                                            ),
                                          ),
                                          // Map Marker labels
                                          const Positioned(
                                            top: 80,
                                            left: 90,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 32,
                                                ),
                                                Text(
                                                  'Future Today Inc.',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Positioned(
                                            top: 100,
                                            left: 170,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  color: Color(0xFFFF6B35),
                                                  size: 32,
                                                ),
                                                Text(
                                                  'Baytech Digital',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Open in maps button overlay
                                          Positioned(
                                            top: 12,
                                            left: 12,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    _Localizations.get(context, 'openInMaps'),
                                                    style: const TextStyle(
                                                      color: Color(0xFF2563EB),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Icon(
                                                    Icons.open_in_new,
                                                    size: 12,
                                                    color: Color(0xFF2563EB),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Follow Us
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _Localizations.get(context, 'followUs'),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF64748B),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _SocialCircleButton(icon: Icons.language),
                                _SocialCircleButton(icon: Icons.facebook),
                                _SocialCircleButton(icon: Icons.camera_alt),
                                _SocialCircleButton(icon: Icons.alternate_email),
                                _SocialCircleButton(icon: Icons.music_note),
                                _SocialCircleButton(icon: Icons.snapchat),
                                _SocialCircleButton(icon: Icons.chat_bubble_outline),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // App Footer
                      // AppFooter(),

                    ],
                  ),
                ),
              ),

              // Sticky Bottom Navigation Bar matching Screenshot 4
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            // YOU PAY
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _Localizations.get(context, 'youPay'),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  Text(
                                    'QAR ${selectedOption.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFFF6B35),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Get Deal Now
                            Expanded(
                              flex: 4,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    AddToCart(offer: offer, option: selectedOption),
                                  );
                                  _showAddedToCartSnackBar(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B35),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  _Localizations.get(context, 'getDealNow'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Buy as Gift
                            Expanded(
                              flex: 4,
                              child: OutlinedButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    AddToCart(offer: offer, option: selectedOption),
                                  );
                                  context.read<CartBloc>().add(
                                    const ToggleGift(isGift: true),
                                  );
                                  _showAddedToCartSnackBar(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  _Localizations.get(context, 'buyAsGift'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // qupon.marbu.in badge pill at bottom
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: const Text(
                            'qupon.marbu.in',
                            style: TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ImageCircularButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ImageCircularButton({
    required this.icon,
    this.iconColor = const Color(0xFF64748B),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),

      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final IconData icon;

  const _SocialCircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF64748B),
        size: 20,
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final landPaint = Paint()..color = const Color(0xFFE2F0D9);
    final waterPaint = Paint()..color = const Color(0xFFBAE6FD);
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw background land
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), landPaint);

    // Draw some stylized water areas on the left/top
    final waterPath = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width * 0.3, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // Draw stylized roads/lines
    canvas.drawLine(Offset(0, size.height * 0.4), Offset(size.width, size.height * 0.6), roadPaint);
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.7, size.height), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.2), Offset(0, size.height * 0.8), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
