import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/main/presentation/pages/main_page.dart';
import '../../features/main/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/collection_coupons_page.dart';
import '../../features/home/data/models/home_collection.dart';
import '../../features/offers/data/models/offer.dart';
import '../../features/offers/presentation/pages/product_detail_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/account/presentation/account/view/account_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/offers',
        builder: (context, state) => const MainPageWithTab(initialIndex: 2),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const MainPageWithTab(initialIndex: 1),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const MainPageWithTab(initialIndex: 3),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const MainPageWithTab(initialIndex: 4),
      ),
      GoRoute(
        path: '/collection/:id',
        builder: (context, state) {
          final collectionIdStr = state.pathParameters['id'] ?? '0';
          final title = state.uri.queryParameters['title'] ?? 'Collection';
          final collection = HomeCollection(
            meta: HomeCollectionMeta(
              id: collectionIdStr,
              title: title,
              titleAr: title,
              slug: 'collection-$collectionIdStr',
              layout: 'grid',
              background: 'default',
              order: 1,
            ),
            coupons: const [],
          );
          return CollectionCouponsPage(collection: collection);
        },
      ),
      GoRoute(
        path: '/coupon/:id',
        builder: (context, state) {
          final couponIdStr = state.pathParameters['id'] ?? '0';
          final dummyOffer = Offer(
            id: couponIdStr,
            title: 'Coupon #$couponIdStr',
            category: 'Offers',
            imageUrl: '',
            daysLeft: 7,
            hoursLeft: 0,
            minutesLeft: 0,
            location: '',
            description: '',
            price: 0.0,
            currency: 'QAR',
            variants: const [],
          );
          return ProductDetailPage(offer: dummyOffer);
        },
      ),
    ],
  );
}

class MainPageWithTab extends StatefulWidget {
  final int initialIndex;

  const MainPageWithTab({
    super.key,
    required this.initialIndex,
  });

  @override
  State<MainPageWithTab> createState() => _MainPageWithTabState();
}

class _MainPageWithTabState extends State<MainPageWithTab> {
  @override
  Widget build(BuildContext context) {
    return MainPage(initialIndex: widget.initialIndex);
  }
}
