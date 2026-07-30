import 'package:flutter_test/flutter_test.dart';
import 'package:qupon/src/features/offers/data/models/offer.dart';
import 'package:qupon/src/features/offers/data/models/offer_option.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_event.dart';
import 'package:qupon/src/features/cart/presentation/bloc/cart_state.dart';
import 'package:qupon/src/features/cart/data/models/cart_item.dart';

void main() {
  group('CartBloc Tests', () {
    late Offer testOffer;
    late OfferOption testOption;

    setUp(() {
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
      final bloc = CartBloc();
      expect(bloc.state.items, isEmpty);
      expect(bloc.state.isGift, isFalse);
      expect(bloc.state.paymentMethod, 'stripe');
      bloc.close();
    });

    test('AddToCart adds item to state', () async {
      final bloc = CartBloc();
      bloc.add(AddToCart(offer: testOffer, option: testOption));

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) {
          return state.items.length == 1 &&
              state.items.first.offer.id == '5' &&
              state.items.first.option.id == 'basic' &&
              state.items.first.quantity == 1 &&
              state.subtotal == 20.0 &&
              state.totalSavings == 20.0;
        })),
      );
      bloc.close();
    });

    test('AddToCart increments quantity for existing item', () async {
      final bloc = CartBloc();
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      bloc.add(AddToCart(offer: testOffer, option: testOption));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          anything, // first add
          predicate<CartState>((state) {
            return state.items.length == 1 &&
                state.items.first.quantity == 2 &&
                state.subtotal == 40.0 &&
                state.totalSavings == 40.0;
          }),
        ]),
      );
      bloc.close();
    });

    test('RemoveFromCart removes item from state', () async {
      final bloc = CartBloc();
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      final cartItem = CartItem(offer: testOffer, option: testOption);
      bloc.add(RemoveFromCart(item: cartItem));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          anything, // AddToCart
          predicate<CartState>((state) => state.items.isEmpty), // RemoveFromCart
        ]),
      );
      bloc.close();
    });

    test('ToggleGift updates state isGift', () async {
      final bloc = CartBloc();
      bloc.add(const ToggleGift(isGift: true));

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.isGift == true)),
      );
      bloc.close();
    });

    test('SelectPaymentMethod updates state paymentMethod', () async {
      final bloc = CartBloc();
      bloc.add(const SelectPaymentMethod(method: 'wallet'));

      await expectLater(
        bloc.stream,
        emits(predicate<CartState>((state) => state.paymentMethod == 'wallet')),
      );
      bloc.close();
    });

    test('ClearCart empties state', () async {
      final bloc = CartBloc();
      bloc.add(AddToCart(offer: testOffer, option: testOption));
      bloc.add(const ClearCart());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          anything, // AddToCart
          predicate<CartState>((state) => state.items.isEmpty), // ClearCart
        ]),
      );
      bloc.close();
    });
  });
}
