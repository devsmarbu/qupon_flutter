import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/models/api_cart_model.dart';
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
      // Remove matching item from localItems by key or couponId
      final updatedLocalItems = state.localItems.where((item) {
        final itemKey = '${item['couponId']}:${item['variantId']}';
        return itemKey != event.key &&
            item['couponId'] != event.key &&
            item['variantId'] != event.key;
      }).toList();

      ApiCartData cartData;
      try {
        cartData = await _cartRepository.removeFromCart(event.key);
      } catch (_) {
        cartData = await _cartRepository.getCart(updatedLocalItems);
      }

      final filteredItems = cartData.items.where((i) {
        final itemKey = i.key.isNotEmpty ? i.key : '${i.couponId}:${i.variantId}';
        return itemKey != event.key && i.couponId != event.key && i.key != event.key;
      }).toList();

      final subtotal = filteredItems.fold<double>(0, (sum, i) => sum + i.payable);
      final totalListPrice = filteredItems.fold<double>(0, (sum, i) => sum + i.listPrice);
      final totalSavings = totalListPrice - subtotal;

      final updatedCartData = ApiCartData(
        items: filteredItems,
        unavailable: cartData.unavailable,
        totals: ApiCartTotals(
          itemCount: filteredItems.length,
          subtotal: subtotal,
          totalListPrice: totalListPrice,
          totalSavings: totalSavings,
        ),
      );

      emit(state.copyWith(
        cartData: updatedCartData,
        localItems: updatedLocalItems,
        isLoading: false,
      ));
    } catch (e) {
      final remainingItems = state.items.where((i) => i.key != event.key && i.couponId != event.key).toList();
      final subtotal = remainingItems.fold<double>(0, (sum, i) => sum + i.payable);
      final totalListPrice = remainingItems.fold<double>(0, (sum, i) => sum + i.listPrice);
      final totalSavings = totalListPrice - subtotal;

      final updatedLocalItems = state.localItems.where((item) {
        final itemKey = '${item['couponId']}:${item['variantId']}';
        return itemKey != event.key && item['couponId'] != event.key;
      }).toList();

      emit(state.copyWith(
        cartData: ApiCartData(
          items: remainingItems,
          unavailable: state.cartData?.unavailable ?? [],
          totals: ApiCartTotals(
            itemCount: remainingItems.length,
            subtotal: subtotal,
            totalListPrice: totalListPrice,
            totalSavings: totalSavings,
          ),
        ),
        localItems: updatedLocalItems,
        isLoading: false,
      ));
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
