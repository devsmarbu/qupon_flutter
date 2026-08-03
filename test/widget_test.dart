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

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      homeRepository: fakeHomeRepo,
      offersRepository: fakeOffersRepo,
    ));
    
    // Wait for splash screen (2.5 seconds) and page transition (0.6 seconds) to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();
    // Verify home page loads by checking "Top Picks" text is visible
    expect(find.text('Top Picks', skipOffstage: false), findsOneWidget);

    // Tap on the cart icon in the AppBar actions to switch to CartPage
    final cartIconButton = find.byIcon(Icons.shopping_cart_outlined).first;
    await tester.tap(cartIconButton);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    // Verify Cart Page is shown with its Empty State
    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Tap on "Browse deals" button to return to Home page
    final continueShoppingButton = find.text('Browse deals');
    expect(continueShoppingButton, findsOneWidget);
    await tester.tap(continueShoppingButton);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pump();

    // Verify we are back on the Home page
    expect(find.text('Top Picks', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Splash screen redirects to WelcomePage when unauthenticated', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Initialize preferences and clear all values
    await PrefStore.init();
    await PrefStore().clearAll();

    final fakeHomeRepo = FakeHomeRepository();
    final fakeOffersRepo = FakeOffersRepository();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      homeRepository: fakeHomeRepo,
      offersRepository: fakeOffersRepo,
    ));

    // Verify we start on splash page
    expect(find.byType(SplashPage), findsOneWidget);

    // Wait for splash screen (2.5 seconds) and page transition (0.6 seconds) to complete
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 800));

    // Verify WelcomePage is shown
    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
