import '../../data/models/cart_item.dart';

class CartState {
  final List<CartItem> items;
  final bool isGift;
  final String paymentMethod; // 'stripe', 'wallet', 'skipcash'

  const CartState({
    this.items = const [],
    this.isGift = false,
    this.paymentMethod = 'stripe',
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + (item.option.price * item.quantity));
  
  double get totalSavings => items.fold(0.0, (sum, item) => sum + ((item.option.originalPrice - item.option.price) * item.quantity));
  
  double get total => subtotal;
  
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    List<CartItem>? items,
    bool? isGift,
    String? paymentMethod,
  }) {
    return CartState(
      items: items ?? this.items,
      isGift: isGift ?? this.isGift,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
