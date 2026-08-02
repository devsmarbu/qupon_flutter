import '../../data/models/api_cart_model.dart';

class CartState {
  final ApiCartData? cartData;
  final List<Map<String, String>> localItems;
  final bool isGift;
  final String paymentMethod; // 'stripe', 'wallet', 'skipcash'
  final bool isLoading;
  final String? error;

  const CartState({
    this.cartData,
    this.localItems = const [],
    this.isGift = false,
    this.paymentMethod = 'stripe',
    this.isLoading = false,
    this.error,
  });

  List<ApiCartItem> get items => cartData?.items ?? const [];

  double get subtotal => cartData?.totals.subtotal ?? 0.0;

  double get totalSavings => cartData?.totals.totalSavings ?? 0.0;

  double get total => subtotal;

  int get totalQuantity => cartData?.totals.itemCount ?? 0;

  CartState copyWith({
    ApiCartData? cartData,
    List<Map<String, String>>? localItems,
    bool? isGift,
    String? paymentMethod,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cartData: cartData ?? this.cartData,
      localItems: localItems ?? this.localItems,
      isGift: isGift ?? this.isGift,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
