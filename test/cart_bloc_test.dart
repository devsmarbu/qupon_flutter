import 'package:flutter_test/flutter_test.dart';
import 'package:qupon/src/features/offers/data/models/offer.dart';
import 'package:qupon/src/features/offers/data/models/offer_option.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_event.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_state.dart';
import 'package:qupon/src/features/cart/data/repositories/cart_repository.dart';
import 'package:qupon/src/features/cart/data/models/api_cart_model.dart';

/// Fake repository that builds ApiCartData from the items list passed in.
/// Mirrors what the real backend does: it receives the full list and returns
/// a cart response for all those items.
class FakeCartRepository implements CartRepository {
  // Holds any items that were explicitly removed (by key) so removeFromCart works.
  final Set<String> _removedKeys = {};

  /// Build a fake ApiCartData from the raw item maps supplied by the caller.
  ApiCartData _buildCartData(List<Map<String, String>> items) {
    final cartItems = items
        .where((item) {
          final key = '${item['couponId']}:${item['variantId']}';
          return !_removedKeys.contains(key);
        })
        .map((item) => ApiCartItem(
              key: '${item['couponId']}:${item['variantId']}',
              couponId: item['couponId']!,
              variantId: item['variantId']!,
              addedAt: item['addedAt'] ?? '2026-08-01T00:00:00.000Z',
              name: 'Tech Gadgets 15% — Basic',
              nameAr: '',
              vendor: 'ElectroWorld',
              payable: 20.0,
              listPrice: 40.0,
              discount: '50%',
              expired: false,
            ))
        .toList();

    // Deduplicate: if same key appears multiple times, merge into one item
    // and accumulate payable/listPrice.
    final Map<String, ApiCartItem> merged = {};
    for (final item in cartItems) {
      if (merged.containsKey(item.key)) {
        final existing = merged[item.key]!;
        merged[item.key] = ApiCartItem(
          key: existing.key,
          couponId: existing.couponId,
          variantId: existing.variantId,
          addedAt: existing.addedAt,
          name: existing.name,
          nameAr: existing.nameAr,
          vendor: existing.vendor,
          payable: existing.payable + item.payable,
          listPrice: existing.listPrice + item.listPrice,
          discount: existing.discount,
          expired: existing.expired,
        );
      } else {
        merged[item.key] = item;
      }
    }

    final deduplicated = merged.values.toList();
    final totalPayable = deduplicated.fold(0.0, (sum, i) => sum + i.payable);
    final totalList = deduplicated.fold(0.0, (sum, i) => sum + i.listPrice);

    return ApiCartData(
      items: deduplicated,
      unavailable: [],
      totals: ApiCartTotals(
        itemCount: deduplicated.length,
        subtotal: totalPayable,
        totalListPrice: totalList,
        totalSavings: totalList - totalPayable,
      ),
    );
  }

  @override
  Future<ApiCartData> getCart(List<Map<String, String>> items) async {
    return _buildCartData(items);
  }

  @override
  Future<ApiCartData> addToCart(String couponId, String variantId) async {
    // Not called by the bloc anymore; kept to satisfy interface.
    return _buildCartData([
      {'couponId': couponId, 'variantId': variantId},
    ]);
  }

  @override
  Future<ApiCartData> removeFromCart(String key) async {
    _removedKeys.add(key);
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
}

void main() {
  group('CartBloc Tests', () {
    late Offer testOffer;
    late OfferOption testOption;
    late FakeCartRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeCartRepository();
      testOffer = const Offer(
        id: '5',
        title: 'Tech Gadgets 15%',
        category: 'Electronics',
        imageUrl: 'imageUrl',
        daysLeft: 152,
        hoursLeft: 15,
        minutesLeft: 32,
        location: '123 Tech Avenue',
        description: 'Upgrade your tech arsenal.',
        price: 20.0,
        currency: 'QAR',
      );
      testOption = const OfferOption(
        id: 'basic',
        name: 'Basic',
        originalPrice: 40.0,
        price: 20.0,
      );
    });

    test('initial state is empty', () {
      final bloc = CartBloc(cartRepository: fakeRepo);
      expect(bloc.state.items, isEmpty);
      expect(bloc.state.localItems, isEmpty);
      expect(bloc.state.isGift, isFalse);
      expect(bloc.state.paymentMethod, 'stripe');
      bloc.close();
    });

    test('AddToCart adds item to state', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(AddToCart(offer: testOffer, option: testOption));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) {
            return state.isLoading == false &&
                state.items.length == 1 &&
                state.items.first.couponId == '5' &&
                state.items.first.variantId == 'basic' &&
                state.subtotal == 20.0 &&
                state.totalSavings == 20.0 &&
                state.localItems.length == 1;
          }),
        ]),
      );
      bloc.close();
    });

    test('AddToCart twice accumulates localItems and increments payable', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      bloc.add(AddToCart(offer: testOffer, option: testOption));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) => state.localItems.length == 1),
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) {
            // Two entries in localItems (same item added twice → merged into
            // one cart item with doubled payable/listPrice in FakeRepo).
            return state.localItems.length == 2 &&
                state.items.length == 1 &&
                state.subtotal == 40.0 &&
                state.totalSavings == 40.0;
          }),
        ]),
      );
      bloc.close();
    });

    test('RemoveFromCart removes item from state', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      bloc.add(const RemoveFromCart(key: '5:basic'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) => state.items.length == 1),
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) =>
              state.items.isEmpty && state.localItems.isEmpty),
        ]),
      );
      bloc.close();
    });

    test('ToggleGift updates state isGift', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(const ToggleGift(isGift: true));

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.isGift == true)),
      );
      bloc.close();
    });

    test('SelectPaymentMethod updates state paymentMethod', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(const SelectPaymentMethod(method: 'wallet'));

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.paymentMethod == 'wallet')),
      );
      bloc.close();
    });

    test('ClearCart empties items and localItems', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      bloc.add(const ClearCart());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          anything, // AddToCart loading
          anything, // AddToCart loaded
          predicate<CartState>(
              (state) => state.items.isEmpty && state.localItems.isEmpty),
        ]),
      );
      bloc.close();
    });

    test('LoadCart with empty localItems returns empty cart', () async {
      final bloc = CartBloc(cartRepository: fakeRepo);
      bloc.add(const LoadCart());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>(
              (state) => state.isLoading == false && state.items.isEmpty),
        ]),
      );
      bloc.close();
    });
  });
}
