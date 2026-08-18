import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../main/presentation/widgets/app_footer.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';
import '../../data/models/vendor_details.dart';
import '../bloc/product_detail_bloc.dart';
import '../bloc/product_detail_event.dart';
import '../bloc/product_detail_state.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../../account/presentation/account/bloc/account_bloc.dart';
import '../../../account/presentation/account/bloc/account_state.dart';
import '../../../account/presentation/login/view/sign_in_dialog.dart';
import '../widgets/direct_checkout_sheet.dart';
import '../../../past_deals/presentation/pages/past_deals_page.dart';
import '../../../../core/preferences/pref_store.dart';
import '../../data/repositories/offers_repository.dart';


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
    final dynamicKey = _mapLocalizationsKeyToApiLabelsKey(key);
    if (dynamicKey != null) {
      final value = LocalizationService().getString(dynamicKey, '');
      if (value.isNotEmpty) return value;
    }
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  static String? _mapLocalizationsKeyToApiLabelsKey(String key) {
    switch (key) {
      case 'backToListings': return 'COUPON_DETAILS_BACK';
      case 'selectOption': return 'COUPON_DETAILS_SELECT_OPTION';
      case 'youPay': return 'COUPON_DETAILS_YOU_PAY';
      case 'getDealNow': return 'COUPON_DETAILS_GET_DEAL';
      case 'buyAsGift': return 'COUPON_DETAILS_BUY_AS_GIFT';
      case 'offerDescription': return 'COUPON_DETAILS_ABOUT_DEAL';
      case 'importantNotes': return 'COUPON_DETAILS_IMPORTANT_NOTES';
      case 'vendorDetails': return 'COUPON_DETAILS_ABOUT_VENDOR';
      case 'viewVendorProfile': return 'COUPON_DETAILS_VIEW_VENDOR';
      case 'followUs': return 'VENDOR_PROFILE_FOLLOW_US';
      default: return null;
    }
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

  Future<void> _handleRequestCoupon(
      BuildContext context, {
        required Offer offer,
        required bool isArabic,
      }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => RequestCouponDialog(
        brandName: offer.vendor ?? '',
        isArabic: isArabic,
      ),
    );

    if (result != null && context.mounted) {
      try {
        final profile = await PrefStore.getProfile();
        final customerId = profile?.id ?? 'guest';
        final customerName = profile?.name ?? 'Guest User';
        final customerEmail = profile?.email ?? 'guest@qupon.com';

        final payload = {
          'id': 'CR-${DateTime.now().millisecondsSinceEpoch}',
          'customerId': customerId,
          'customerName': customerName,
          'customerEmail': customerEmail,
          'couponId': offer.id,
          'couponName': offer.title,
          'vendorId': (offer.vendorId != null && offer.vendorId!.isNotEmpty) ? offer.vendorId! : 'unknown',
          'vendor': offer.vendor ?? 'unknown',
          'message': result,
          'requestedAt': DateTime.now().toUtc().toIso8601String(),
        };

        final successMsg = await OffersRepositoryImpl().submitCouponRequest(body: payload);

        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (successMsg != null && successMsg.isNotEmpty)
                    ? successMsg
                    : (isArabic
                    ? 'تم تقديم طلب لإعادة الكوبون!'
                    : 'Request submitted to bring this coupon back!'),
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
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isArabic
                    ? 'فشل تقديم الطلب. يرجى المحاولة مرة أخرى.'
                    : 'Failed to submit request. Please try again.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _showAddedToCartSnackBar(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'تمت الإضافة إلى السلة!'
              : 'Added to cart!',

          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          textColor: const Color(0xFFFF6B35),
          label: LocalizationService().getString('COUPON_DETAILS_CART', l10n.viewCartLabel),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      messenger.hideCurrentSnackBar();
    });
  }

  Future<bool> _ensureLoggedIn(BuildContext context) async {
    final accountState = context.read<AccountBloc>().state;
    if (accountState is AccountAuthenticated) {
      return true;
    }
    final loggedIn = await SignInDialog.show(context);
    return loggedIn == true;
  }

  void _shareOffer(BuildContext context, Offer offer) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    final vendorName = offer.vendorDetails?.name ?? offer.vendor ?? LocalizationService().getString('APP_NAME', l10n.appNameLabel);
    final title = (isArabic && offer.titleAr != null && offer.titleAr!.isNotEmpty)
        ? offer.titleAr!
        : offer.title;
    final desc = (isArabic && offer.descriptionAr != null && offer.descriptionAr!.isNotEmpty)
        ? offer.descriptionAr!
        : offer.description;

    final shareLink = offer.shareLink ?? offer.vendorDetails?.websiteUrl ?? offer.vendorDetails?.mapsOpenUrl ?? 'https://qupon.marbu.in/vendor/${offer.vendorDetails?.slug ?? ''}';

    final text = LocalizationService().getString(
      'SHARE_TEXT_TEMPLATE',
      isArabic
          ? 'تحقق من هذا العرض الرائع من {vendorName}!\n\n{title}\n{desc}\n\nلمزيد من التفاصيل: {shareLink}'
          : 'Check out this amazing deal from {vendorName}!\n\n{title}\n{desc}\n\nMore details: {shareLink}',
    ).replaceAll('{vendorName}', vendorName)
     .replaceAll('{title}', title)
     .replaceAll('{desc}', desc)
     .replaceAll('{shareLink}', shareLink);

    Share.share(text, subject: title);
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

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

        final isExpired = offer.daysLeft == 0 && offer.hoursLeft == 0 && offer.minutesLeft == 0;

        final canPop = Navigator.of(context).canPop();

        return PopScope(
          canPop: canPop,
          onPopInvoked: (didPop) {
            if (didPop) return;
            context.go('/');
          },
          child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: 16.0,
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
                      InkWell(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            context.go('/');
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                                _Localizations.get(context, 'backToListings'),
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

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
                                  color: Colors.white,
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
                                    if (offer.imageUrl.isNotEmpty && offer.imageUrl.startsWith('http'))
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
                            // Time Left Badge on top-left of image
                            if (!isExpired)
                              PositionedDirectional(
                                top: 16,
                                start: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8FDF5),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.access_time_filled,
                                        size: 14,
                                        color: Color(0xFF047857),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isArabic
                                            ? 'متبقي ${offer.daysLeft} يوم و ${offer.hoursLeft} ساعة و ${offer.minutesLeft} دقيقة'
                                            : '${offer.daysLeft}d ${offer.hoursLeft}h ${offer.minutesLeft}m left',
                                        style: const TextStyle(
                                          color: Color(0xFF047857),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Row of action buttons on the top-right of image
                            PositionedDirectional(
                              top: 16,
                              end: 16,
                              child: Row(
                                children: [
                                  _ImageCircularButton(
                                    icon: state.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                                    iconColor: state.isFavorite ? Colors.red : const Color(0xFF64748B),
                                    onTap: () async {
                                      final loggedIn = await _ensureLoggedIn(context);
                                      if (loggedIn && context.mounted) {
                                        context.read<ProductDetailBloc>().add(const ToggleFavorite());
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  _ImageCircularButton(
                                    icon: Icons.share_outlined,
                                    onTap: () => _shareOffer(context, offer),
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
                                    (isArabic && offer.vendorDetails?.nameAr != null && offer.vendorDetails!.nameAr!.isNotEmpty)
                                        ? offer.vendorDetails!.nameAr!
                                        : (offer.vendorDetails?.nameEn ?? offer.vendorDetails?.name ?? offer.vendor ?? _Localizations.get(context, 'electroWorld')),
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
                                if (isExpired) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Color(0xFFEF4444),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          LocalizationService().getString('COUPON_EXPIRED', l10n.expired),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

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
                                      children: [
                                        // Custom Radio indicator
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFCBD5E1),
                                              width: 2,
                                            ),
                                          ),
                                          child: isSelected
                                              ? Center(
                                            child: Container(
                                              width: 10,
                                              height: 10,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFFF6B35),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            option.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              'QAR ${option.originalPrice.toInt()}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF94A3B8),
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'QAR ${option.price.toInt()}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: isSelected ? const Color(0xFF0F172A) : const Color(0xFF475569),
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

                      // YOU PAY summary section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            if (isExpired) ...[
                              Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Color(0xFFEF4444),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            LocalizationService().getString('COUPON_DETAILS_EXPIRED_TITLE', l10n.thisOfferExpired),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isArabic
                                                ? 'هذا الكوبون لم يعد متاحاً للشراء. يمكنك طلبه من الصفقات السابقة وسنقوم بإخطار البائع.'
                                                : 'This coupon is no longer available for purchase. You can request it from Past Deals and we will notify the vendor.',
                                            style: const TextStyle(
                                              color: Color(0xFF64748B),
                                              fontSize: 12,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _Localizations.get(context, 'youPay'),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      'QAR ${selectedOption.originalPrice.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF94A3B8),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
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
                            const SizedBox(height: 20),

                            // Action Buttons Stack (Get Deal Now, Buy as Gift, Cart/Share Row)
                            if (isExpired) ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _handleRequestCoupon(context, offer: offer, isArabic: isArabic),
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
                                    LocalizationService().getString('COUPON_DETAILS_REQUEST_COUPON', l10n.requestCoupon),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!await _ensureLoggedIn(context)) return;
                                    if (!context.mounted) return;
                                    DirectCheckoutSheet.show(
                                      context,
                                      offer: offer,
                                      option: selectedOption,
                                      isGift: false,
                                    );
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    if (!await _ensureLoggedIn(context)) return;
                                    if (!context.mounted) return;
                                    DirectCheckoutSheet.show(
                                      context,
                                      offer: offer,
                                      option: selectedOption,
                                      isGift: true,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0F172A),
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    _Localizations.get(context, 'buyAsGift'),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: isExpired
                                          ? null
                                          : () {
                                        context.read<CartBloc>().add(
                                          AddToCart(offer: offer, option: selectedOption),
                                        );
                                        _showAddedToCartSnackBar(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart_outlined,
                                        color: isExpired ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => _shareOffer(context, offer),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Icon(
                                        Icons.ios_share,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

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
                                              (isArabic && offer.vendorDetails?.nameAr != null && offer.vendorDetails!.nameAr!.isNotEmpty)
                                                  ? offer.vendorDetails!.nameAr!
                                                  : (offer.vendorDetails?.nameEn ?? offer.vendorDetails?.name ?? offer.vendor ?? _Localizations.get(context, 'electroWorld')),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            InkWell(
                                              onTap: () async {
                                                final profileLink = offer.vendorProfileLink ?? offer.vendorDetails?.websiteUrl ?? 'https://qupon.marbu.in/vendor/${offer.vendorDetails?.slug ?? ''}';
                                                try {
                                                  final uri = Uri.parse(profileLink);
                                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                                } catch (e) {
                                                  debugPrint('Could not launch vendor profile URL: $e');
                                                  try {
                                                    final uri = Uri.parse(profileLink);
                                                    await launchUrl(uri, mode: LaunchMode.platformDefault);
                                                  } catch (_) {}
                                                }
                                              },
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
                                        Expanded(
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
                                  Builder(
                                    builder: (context) {
                                      final details = offer.vendorDetails;
                                      final locationName = details?.locationEn ?? details?.locationAr ?? offer.location;

                                      final openUrl = details?.mapsOpenUrl ?? details?.locationLink ??
                                          (locationName.isNotEmpty
                                              ? 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(locationName)}'
                                              : '');

                                      return VendorMapWidget(
                                        openUrl: openUrl,
                                        latitude: details?.latitude,
                                        longitude: details?.longitude,
                                      );
                                    },
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
                            Builder(
                              builder: (context) {
                                final details = offer.vendorDetails;
                                final vendorName = offer.vendor ?? 'Qupon';
                                final List<Widget> buttons = [];

                                void addSocial(IconData icon, String? url) {
                                  if (url != null && url.isNotEmpty) {
                                    buttons.add(
                                      _SocialCircleButton(
                                        icon: icon,
                                        onTap: () async {
                                          try {
                                            final uri = Uri.parse(url);
                                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                                          } catch (_) {
                                            try {
                                              await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
                                            } catch (_) {}
                                          }
                                        },
                                      ),
                                    );
                                  }
                                }

                                if (details != null) {
                                  addSocial(Icons.language, details.websiteUrl);
                                  addSocial(Icons.facebook, details.facebook);
                                  addSocial(Icons.camera_alt, details.instagram);
                                  addSocial(Icons.alternate_email, details.twitter);
                                  addSocial(Icons.music_note, details.tiktok);
                                  addSocial(details.whatsapp != null && details.whatsapp!.isNotEmpty ? Icons.chat_bubble : Icons.chat_bubble_outline, details.whatsapp != null && details.whatsapp!.isNotEmpty
                                      ? (details.whatsapp!.startsWith('http')
                                      ? details.whatsapp
                                      : 'https://wa.me/${details.whatsapp!.replaceAll(RegExp(r'[^0-9]'), '')}')
                                      : null);
                                  addSocial(Icons.snapchat, details.snapchat != null && details.snapchat!.isNotEmpty
                                      ? (details.snapchat!.startsWith('http')
                                      ? details.snapchat
                                      : 'https://www.snapchat.com/add/${details.snapchat}')
                                      : null);
                                }

                                if (buttons.isEmpty) {
                                  final query = Uri.encodeComponent(vendorName);
                                  addSocial(Icons.language, 'https://qupon.marbu.in');
                                  addSocial(Icons.facebook, 'https://www.facebook.com/search/top/?q=$query');
                                  addSocial(Icons.camera_alt, 'https://www.instagram.com');
                                  addSocial(Icons.alternate_email, 'https://twitter.com');
                                  addSocial(Icons.music_note, 'https://www.tiktok.com');
                                  addSocial(Icons.snapchat, 'https://www.snapchat.com');
                                  addSocial(Icons.chat_bubble_outline, 'https://wa.me/97412345678');
                                }

                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.start,
                                  children: buttons,
                                );
                              },
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
                            if (isExpired) ...[
                              Expanded(
                                flex: 8,
                                child: ElevatedButton(
                                  onPressed: () => _handleRequestCoupon(context, offer: offer, isArabic: isArabic),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6B35),
                                    foregroundColor: const Color(0xFF0F172A),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: Text(
                                    LocalizationService().getString('COUPON_DETAILS_REQUEST_COUPON', l10n.requestCoupon),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              // Buy as Gift
                              Expanded(
                                flex: 4,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    if (!await _ensureLoggedIn(context)) return;
                                    if (!context.mounted) return;

                                    DirectCheckoutSheet.show(
                                      context,
                                      offer: offer,
                                      option: selectedOption,
                                      isGift: true,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0F172A),
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
                              const SizedBox(width: 8),
                              // Get Deal Now
                              Expanded(
                                flex: 4,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (!await _ensureLoggedIn(context)) return;
                                    if (!context.mounted) return;

                                    DirectCheckoutSheet.show(
                                      context,
                                      offer: offer,
                                      option: selectedOption,
                                      isGift: false,
                                    );
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
                            ],

                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ));
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
  final VoidCallback onTap;

  const _SocialCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
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
      ),
    );
  }
}

class VendorMapWidget extends StatefulWidget {
  final String openUrl;
  final double? latitude;
  final double? longitude;

  const VendorMapWidget({
    super.key,
    required this.openUrl,
    this.latitude,
    this.longitude,
  });

  @override
  State<VendorMapWidget> createState() => _VendorMapWidgetState();
}

class _VendorMapWidgetState extends State<VendorMapWidget> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  Map<String, double>? _extractCoordinates(String url) {
    final atRegex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');
    final atMatch = atRegex.firstMatch(url);
    if (atMatch != null) {
      final lat = double.tryParse(atMatch.group(1) ?? '');
      final lon = double.tryParse(atMatch.group(2) ?? '');
      if (lat != null && lon != null) {
        return {'latitude': lat, 'longitude': lon};
      }
    }

    try {
      final uri = Uri.parse(url);
      final queryParam = uri.queryParameters['query'] ?? uri.queryParameters['q'];
      if (queryParam != null) {
        final parts = queryParam.split(',');
        if (parts.length >= 2) {
          final lat = double.tryParse(parts[0].trim());
          final lon = double.tryParse(parts[1].trim());
          if (lat != null && lon != null) {
            return {'latitude': lat, 'longitude': lon};
          }
        }
      }

      final llParam = uri.queryParameters['ll'];
      if (llParam != null) {
        final parts = llParam.split(',');
        if (parts.length >= 2) {
          final lon = double.tryParse(parts[0].trim());
          final lat = double.tryParse(parts[1].trim());
          if (lat != null && lon != null) {
            return {'latitude': lat, 'longitude': lon};
          }
        }
      }
    } catch (_) {}

    return null;
  }

  String _getEmbedUrl() {
    if (widget.openUrl.isEmpty) return '';

    double? lat = widget.latitude;
    double? lon = widget.longitude;

    if (lat == null || lon == null || (lat == 0 && lon == 0)) {
      final coords = _extractCoordinates(widget.openUrl);
      if (coords != null) {
        lat = coords['latitude'];
        lon = coords['longitude'];
      }
    }

    if (lat == null || lon == null || (lat == 0 && lon == 0)) {
      return '';
    }

    if (widget.openUrl.contains('output=embed')) {
      return widget.openUrl;
    }

    return 'https://maps.google.com/maps?q=$lat,$lon&t=&z=13&ie=UTF8&iwloc=&output=embed';
  }

  void _initOrUpdateController() {
    final embedUrl = _getEmbedUrl();
    if (embedUrl.isNotEmpty) {
      _controller ??= WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              onWebResourceError: (error) {
                debugPrint('WebView Resource Error: ${error.description}');
                if (mounted) {
                  setState(() {
                    _hasError = true;
                    _isLoading = false;
                  });
                }
              },
            ),
          );
      _isLoading = true;
      _hasError = false;
      _controller!.loadRequest(Uri.parse(embedUrl));
    }
  }

  @override
  void initState() {
    super.initState();
    _initOrUpdateController();
  }

  @override
  void didUpdateWidget(covariant VendorMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.openUrl != oldWidget.openUrl ||
        widget.latitude != oldWidget.latitude ||
        widget.longitude != oldWidget.longitude) {
      _initOrUpdateController();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    final embedUrl = _getEmbedUrl();

    Widget mapContent;
    if (embedUrl.isNotEmpty && !_hasError && _controller != null) {
      mapContent = Stack(
        children: [
          WebViewWidget(controller: _controller!),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
        ],
      );
    } else {
      mapContent = CustomPaint(
        painter: _MapPainter(),
        child: const Center(
          child: Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 36,
          ),
        ),
      );
    }

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(child: mapContent),
            // Open in maps button overlay
            PositionedDirectional(
              top: 12,
              start: 12,
              child: GestureDetector(
                onTap: () async {
                  final uri = Uri.parse(widget.openUrl.isNotEmpty ? widget.openUrl : 'https://www.google.com/maps');
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (e) {
                    debugPrint('Could not launch map URL: $e');
                    try {
                      await launchUrl(uri, mode: LaunchMode.platformDefault);
                    } catch (_) {}
                  }
                },
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        LocalizationService().getString('COUPON_DETAILS_VISIT_STORE', l10n.openInMaps),
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.open_in_new,
                        size: 12,
                        color: Color(0xFFFF6B35),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
