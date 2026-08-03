import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/models/checkout_model.dart';
import '../../data/repositories/cart_repository.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ToggleGift>(_onToggleGift);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<PlaceOrder>(_onPlaceOrder);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true, gatewaysLoading: true));
    print("api calling");
    try {
      // Call cart and payment-gateways APIs in parallel
      final cartFuture = _cartRepository.getCart(state.localItems);
      final gatewaysFuture = _cartRepository.getPaymentGateways();

      final cartData = await cartFuture;
      final gateways = await gatewaysFuture;

      // Auto-select first active gateway if none selected yet
      final activeGateways = gateways.where((g) => g.isActive).toList();
      final selectedMethod = state.paymentMethod.isEmpty && activeGateways.isNotEmpty
          ? activeGateways.first.identifier
          : state.paymentMethod;

      emit(state.copyWith(
        cartData: cartData,
        paymentGateways: gateways,
        paymentMethod: selectedMethod,
        isLoading: false,
        gatewaysLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false, gatewaysLoading: false));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      // Build the new item map
      final newItem = {
        'couponId': event.offer.id,
        'variantId': event.option.id,
        'addedAt': now,
      };
      // Accumulate: add the new item to the existing local list
      final updatedItems = List<Map<String, String>>.from(state.localItems)
        ..add(newItem);

      // Call API with the full accumulated list
      final cartData = await _cartRepository.getCart(updatedItems);
      emit(state.copyWith(
        cartData: cartData,
        localItems: updatedItems,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final cartData = await _cartRepository.removeFromCart(event.key);
      // Also remove from localItems by matching the key format "couponId:variantId"
      final updatedItems = state.localItems
          .where((item) => '${item['couponId']}:${item['variantId']}' != event.key)
          .toList();
      emit(state.copyWith(
        cartData: cartData,
        localItems: updatedItems,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onToggleGift(ToggleGift event, Emitter<CartState> emit) {
    emit(state.copyWith(isGift: event.isGift));
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<CartState> emit) {
    emit(state.copyWith(paymentMethod: event.method));
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<CartState> emit) async {
    final gateway = state.selectedGateway;
    if (gateway == null) {
      emit(state.copyWith(checkoutError: 'Please select a payment method.'));
      return;
    }

    if (state.items.isEmpty) {
      emit(state.copyWith(checkoutError: 'Your cart is empty.'));
      return;
    }

    emit(state.copyWith(
      isCheckingOut: true,
      clearCheckout: true, // clear any previous result/error
    ));

    try {
      final request = CheckoutRequest(
        paymentGatewayId: gateway.id,
        items: state.items
            .map((item) => CheckoutItem(
                  couponId: item.couponId,
                  variantId: item.variantId,
                ))
            .toList(),
        gift: state.isGift,
        giftPhoneNumber: state.isGift ? event.giftPhoneNumber : '',
      );

      final response = await _cartRepository.checkout(request);

      emit(state.copyWith(
        isCheckingOut: false,
        checkoutResponse: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        isCheckingOut: false,
        checkoutError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}
