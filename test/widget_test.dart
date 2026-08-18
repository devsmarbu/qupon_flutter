import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qupon/main.dart';
import 'package:qupon/src/core/constants/app_strings.dart';
import 'package:qupon/src/core/preferences/pref_store.dart';
import 'package:qupon/src/features/home/presentation/bloc/home_bloc.dart';
import 'package:qupon/src/features/home/presentation/pages/home_page.dart';
import 'package:qupon/src/features/account/data/models/profile_data.dart';
import 'package:qupon/src/features/home/data/models/home_category.dart';
import 'package:qupon/src/features/home/data/repositories/home_repository.dart';
import 'package:qupon/src/features/offers/data/repositories/offers_repository.dart';
import 'package:qupon/src/features/home/data/models/home_data.dart';
import 'package:qupon/src/features/home/data/models/home_collection.dart';
import 'package:qupon/src/features/offers/data/models/offer.dart';
import 'package:qupon/src/features/main/presentation/pages/splash_page.dart';
import 'package:qupon/src/features/account/presentation/welcome/view/welcome_page.dart';
import 'package:qupon/src/features/cart/data/repositories/cart_repository.dart';
import 'package:qupon/src/features/account/data/repositories/auth_repository.dart';
import 'package:qupon/src/features/cart/data/models/api_cart_model.dart';
import 'package:qupon/src/features/cart/data/models/payment_gateway.dart';
import 'package:qupon/src/features/cart/data/models/checkout_model.dart';
import 'package:qupon/src/features/account/data/models/dashboard_model.dart';
import 'package:qupon/src/features/home/data/models/home_coupon.dart';
import 'package:qupon/src/features/localization/data/repositories/localization_repository.dart';

class FakeHomeRepository implements HomeRepository {
  @override
  Future<List<HomeCategory>> getCategories() async {
    return [];
  }

  @override
  Future<HomeData> getHomeData() async {
    return const HomeData(
      banners: [],
      categories: [],
      collections: [
        HomeCollection(
          meta: HomeCollectionMeta(
            id: '1',
            title: 'Top Picks',
            titleAr: 'أفضل الاختيارات',
            slug: 'top-picks',
            layout: 'carousel',
            background: 'default',
            order: 1,
          ),
          coupons: [],
        ),
      ],
    );
  }

  @override
  Future<List<HomeCoupon>> searchCoupons(String query, {int limit = 8}) async {
    return [];
  }
}

class FakeOffersRepository implements OffersRepository {
  @override
  Future<List<Offer>> getOffers() async {
    return [];
  }

  @override
  Future<List<Offer>> getCategoryOffers(String categoryId) async {
    return [];
  }

  @override
  Future<Offer> getCouponDetails(String slug) async {
    return Offer(
      id: 'dummy',
      title: 'Dummy',
      category: 'Dummy',
      imageUrl: '',
      daysLeft: 0,
      hoursLeft: 0,
      minutesLeft: 0,
      location: '',
      description: '',
      price: 0.0,
      currency: 'QAR',
      variants: const [],
    );
  }

  @override
  Future<String?> submitCouponRequest({required Map<String, dynamic> body}) async {
    return null;
  }

  @override
  Future<bool> toggleWishlist({required String couponId}) async {
    return true;
  }
}

class FakeCartRepository implements CartRepository {
  @override
  Future<ApiCartData> getCart(List<Map<String, String>> items) async {
    return ApiCartData(
      items: [],
      unavailable: [],
      totals: ApiCartTotals(
        itemCount: 0,
        subtotal: 0.0,
        totalListPrice: 0.0,
        totalSavings: 0.0,
      ),
    );
  }

  @override
  Future<ApiCartData> addToCart(String couponId, String variantId) async {
    return ApiCartData(
      items: [],
      unavailable: [],
      totals: ApiCartTotals(
        itemCount: 0,
        subtotal: 0.0,
        totalListPrice: 0.0,
        totalSavings: 0.0,
      ),
    );
  }

  @override
  Future<ApiCartData> removeFromCart(String key) async {
    return ApiCartData(
      items: [],
      unavailable: [],
      totals: ApiCartTotals(
        itemCount: 0,
        subtotal: 0.0,
        totalListPrice: 0.0,
        totalSavings: 0.0,
      ),
    );
  }

  @override
  Future<List<PaymentGateway>> getPaymentGateways() async {
    return [];
  }

  @override
  Future<CheckoutResponse> checkout(CheckoutRequest request) async {
    return const CheckoutResponse(
      ok: true,
      redirectUrl: 'https://example.com',
      checkoutSessionId: '123',
    );
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    String recaptchaToken = '',
  }) async {}

  @override
  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {}

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String role,
  }) async {}

  @override
  Future<void> resendOtp({
    required String email,
    required String role,
    String recaptchaToken = '',
  }) async {}

  @override
  Future<void> forgotPassword({
    required String phoneNumber,
    required String role,
  }) async {}

  @override
  Future<DashboardData> getDashboard({required String token}) async {
    return DashboardData(
      totalSpent: 0.0,
      couponsUsed: 0,
      totalSaved: 0.0,
      activeCoupons: 0,
      wallet: 0.0,
      transactions: [],
    );
  }

  @override
  Future<List<HomeCoupon>> getWishlist({required String token}) async {
    return [];
  }

  @override
  Future<List<DashboardTransaction>> getFilteredOrders({
    required String token,
    String? status,
    String? from,
    String? to,
    String? vendor,
  }) async {
    return [];
  }
}

class FakeLocalizationRepository implements LocalizationRepository {
  @override
  Future<Map<String, String>> getLabels(int langId) async {
    return {
      'APP_FILTER': 'Filter',
      'NAV_HOME': 'Home',
      'NAV_SEARCH_PLACEHOLDER': 'Search...',
      'HOME_SHOP_BY_CATEGORY': 'Shop by Category',
      'HOME_ELECTRONICS': 'Electronics',
      'HOME_VIEW_ALL': 'View All',
      'NAV_PAST_DEALS': 'Past Deals',
      'PAST_DEALS_SUBTITLE': 'Past Deals Subtitle',
      'PAST_DEALS_REQUEST_BUTTON': 'Request Coupon',
      'PAST_DEALS_REQUEST_TITLE': 'Request Coupon Dialog',
      'PAST_DEALS_MESSAGE_LABEL': 'Your message',
      'PAST_DEALS_SUBMIT': 'Submit request',
      'PAST_DEALS_CANCEL': 'Cancel',
      'WISHLIST_TITLE': 'My Wishlist',
      'WISHLIST_EMPTY': 'No items in wishlist',
      'CART_TITLE': 'Shopping Cart',
      'CART_EMPTY_TITLE': 'Your cart is empty',
      'CART_EMPTY_DESC': 'Add items to cart',
      'CART_BROWSE_DEALS': 'Browse deals',
      'COUPON_DETAILS_YOU_SAVE': 'You save',
      'WISHLIST_REMOVE': 'Delete',
      'CART_ORDER_SUMMARY': 'Order summary',
      'CART_SUBTOTAL': 'Subtotal',
      'CART_TOTAL_SAVINGS': 'Total savings',
      'CART_TOTAL': 'Total',
      'CHECKOUT_GIFT_TITLE': 'Gift this order',
      'CHECKOUT_GIFT_DESC': 'Send as gift',
      'CHECKOUT_GIFT_PHONE_LABEL': 'Recipient phone',
      'CHECKOUT_GIFT_PHONE_HINT': 'Enter recipient phone',
      'COMMON_QATAR_PHONE_HINT': 'Qatar number',
      'CART_PAY_VIA': 'Pay via',
      'CART_BALANCE': 'Balance',
      'CART_CHECKOUT': 'Checkout',
      'COUPON_DETAILS_DEAL_PRICE': 'Deal Price',
      'COMMON_DETAILS': 'Details',
    };
  }
}

void main() {
  testWidgets('Smoke test for MainPage, CartPage, and PastDealsPage', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Initialize preferences and set mock authenticated profile directly
    await PrefStore.init();
    await PrefStore().saveString(AppStrings.keyToken, 'mock_token');
    await PrefStore.saveProfile(ProfileData(
      id: '1',
      role: 'user',
      email: 'test@example.com',
      name: 'Test User',
    ));

    final fakeHomeRepo = FakeHomeRepository();
    final fakeOffersRepo = FakeOffersRepository();
    final fakeCartRepo = FakeCartRepository();
    final fakeAuthRepo = FakeAuthRepository();

    final sharedPrefs = await SharedPreferences.getInstance();

    final fakeLocRepo = FakeLocalizationRepository();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      homeRepository: fakeHomeRepo,
      offersRepository: fakeOffersRepo,
      cartRepository: fakeCartRepo,
      authRepository: fakeAuthRepo,
      localizationRepository: fakeLocRepo,
      sharedPreferences: sharedPrefs,
    ));
    
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pumpAndSettle();
    // Verify home page loads by checking "Top Picks" text is visible
    expect(find.text('Top Picks', skipOffstage: false), findsOneWidget);

    // Tap on the cart icon in the AppBar actions to switch to CartPage
    final cartIconButton = find.byIcon(Icons.shopping_cart_outlined).first;
    await tester.tap(cartIconButton);
    await tester.pumpAndSettle();

    // Verify Cart Page is shown with its Empty State
    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Tap on "Browse deals" button to return to Home page
    final continueShoppingButton = find.text('Browse deals');
    expect(continueShoppingButton, findsOneWidget);
    await tester.tap(continueShoppingButton);
    await tester.pumpAndSettle();

    // Verify we are back on the Home page
    expect(find.text('Top Picks', skipOffstage: false), findsOneWidget);
  });
}
