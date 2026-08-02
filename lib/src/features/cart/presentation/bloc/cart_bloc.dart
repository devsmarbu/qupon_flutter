import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
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
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true));
    print("api calling");
    try {
      final cartData = await _cartRepository.getCart(state.localItems);
      emit(state.copyWith(cartData: cartData, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
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

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}

