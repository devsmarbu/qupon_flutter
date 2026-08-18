import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_event.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_state.dart';
import 'package:qupon/src/features/cart/data/models/api_cart_model.dart';
import 'package:qupon/src/features/cart/data/models/checkout_model.dart';
import 'package:qupon/src/features/cart/data/models/payment_gateway.dart';
import 'package:qupon/src/features/cart/data/repositories/cart_repository.dart';

class MockCartRepository implements CartRepository {
  List<Map<String, String>> lastGetCartItems = [];
  String? lastRemovedKey;

  @override
  Future<ApiCartData> getCart(List<Map<String, String>> items) async {
    lastGetCartItems = items;
    final cartItems = items.map((item) {
      final couponId = item['couponId'] ?? '';
      final variantId = item['variantId'] ?? '';
      final key = '$couponId:$variantId';
      return ApiCartItem(
        key: key,
        couponId: couponId,
        variantId: variantId,
        addedAt: item['addedAt'] ?? '',
        name: 'Item $couponId',
        nameAr: 'عنصر $couponId',
        vendor: 'Test Vendor',
        payable: 20.0,
        listPrice: 40.0,
        discount: '50%',
        expired: false,
      );
    }).toList();

    final subtotal = cartItems.fold<double>(0, (sum, i) => sum + i.payable);
    final totalListPrice = cartItems.fold<double>(0, (sum, i) => sum + i.listPrice);
    final totalSavings = totalListPrice - subtotal;

    return ApiCartData(
      items: cartItems,
      unavailable: [],
      totals: ApiCartTotals(
        itemCount: cartItems.length,
        subtotal: subtotal,
        totalListPrice: totalListPrice,
        totalSavings: totalSavings,
      ),
    );
  }

  @override
  Future<ApiCartData> addToCart(String couponId, String variantId) async {
    return getCart([{'couponId': couponId, 'variantId': variantId}]);
  }

  @override
  Future<ApiCartData> removeFromCart(String key) async {
    lastRemovedKey = key;
    final remaining = lastGetCartItems
        .where((item) => '${item['couponId']}:${item['variantId']}' != key && item['couponId'] != key)
        .toList();
    return getCart(remaining);
  }

  @override
  Future<List<PaymentGateway>> getPaymentGateways() async {
    return [];
  }

  @override
  Future<CheckoutResponse> checkout(CheckoutRequest request) async {
    return CheckoutResponse(ok: true, checkoutSessionId: 'sess_123');
  }
}

void main() {
  group('CartBloc Tests', () {
    late MockCartRepository repository;
    late CartBloc cartBloc;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repository = MockCartRepository();
      cartBloc = CartBloc(cartRepository: repository, sharedPreferences: prefs);
    });

    tearDown(() {
      cartBloc.close();
    });

    test('initial state is empty', () {
      expect(cartBloc.state.items, isEmpty);
      expect(cartBloc.state.localItems, isEmpty);
      expect(cartBloc.state.totalQuantity, 0);
    });

    test('RemoveFromCart removes selected item from cart state and local items', () async {
      // First populate cart with 2 items
      repository.lastGetCartItems = [
        {'couponId': 'item1', 'variantId': 'v1'},
        {'couponId': 'item2', 'variantId': 'v2'},
      ];
      cartBloc.emit(CartState(
        localItems: [
          {'couponId': 'item1', 'variantId': 'v1'},
          {'couponId': 'item2', 'variantId': 'v2'},
        ],
        cartData: ApiCartData(
          items: [
            ApiCartItem(
              key: 'item1:v1',
              couponId: 'item1',
              variantId: 'v1',
              addedAt: '',
              name: 'Item 1',
              nameAr: 'Item 1',
              vendor: 'Vendor',
              payable: 20.0,
              listPrice: 40.0,
              discount: '50%',
              expired: false,
            ),
            ApiCartItem(
              key: 'item2:v2',
              couponId: 'item2',
              variantId: 'v2',
              addedAt: '',
              name: 'Item 2',
              nameAr: 'Item 2',
              vendor: 'Vendor',
              payable: 30.0,
              listPrice: 60.0,
              discount: '50%',
              expired: false,
            ),
          ],
          unavailable: [],
          totals: ApiCartTotals(
            itemCount: 2,
            subtotal: 50.0,
            totalListPrice: 100.0,
            totalSavings: 50.0,
          ),
        ),
      ));

      // Remove item1:v1
      cartBloc.add(const RemoveFromCart(key: 'item1:v1'));

      await expectLater(
        cartBloc.stream,
        emitsInOrder([
          predicate<CartState>((state) => state.isLoading == true),
          predicate<CartState>((state) {
            return state.isLoading == false &&
                state.items.length == 1 &&
                state.items.first.key == 'item2:v2' &&
                state.localItems.length == 1 &&
                state.localItems.first['couponId'] == 'item2';
          }),
        ]),
      );
    });

    test('ClearCart resets state', () {
      cartBloc.add(const ClearCart());
      expect(cartBloc.state.items, isEmpty);
      expect(cartBloc.state.localItems, isEmpty);
    });
  });
}

