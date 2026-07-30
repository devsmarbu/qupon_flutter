import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/models/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ToggleGift>(_onToggleGift);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<ClearCart>(_onClearCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere(
      (item) => item.offer.id == event.offer.id && item.option.id == event.option.id,
    );

    List<CartItem> updatedItems;
    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      updatedItems = List.from(state.items)
        ..[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      updatedItems = List.from(state.items)
        ..add(CartItem(offer: event.offer, option: event.option));
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = List<CartItem>.from(state.items)
      ..removeWhere((item) => item.offer.id == event.item.offer.id && item.option.id == event.item.option.id);
    emit(state.copyWith(items: updatedItems));
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
