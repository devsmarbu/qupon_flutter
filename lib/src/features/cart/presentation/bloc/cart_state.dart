import '../../data/models/api_cart_model.dart';
import '../../data/models/checkout_model.dart';
import '../../data/models/payment_gateway.dart';

class CartState {
  final ApiCartData? cartData;
  final List<Map<String, String>> localItems;
  final bool isGift;
  final String paymentMethod; // selected gateway identifier
  final bool isLoading;
  final String? error;
  final List<PaymentGateway> paymentGateways;
  final bool gatewaysLoading;

  // ── Checkout ──────────────────────────────────────────────────────────────
  final bool isCheckingOut;
  final CheckoutResponse? checkoutResponse;
  final String? checkoutError;

  const CartState({
    this.cartData,
    this.localItems = const [],
    this.isGift = false,
    this.paymentMethod = '',
    this.isLoading = false,
    this.error,
    this.paymentGateways = const [],
    this.gatewaysLoading = false,
    this.isCheckingOut = false,
    this.checkoutResponse,
    this.checkoutError,
  });

  List<ApiCartItem> get items => cartData?.items ?? const [];

  double get subtotal => cartData?.totals.subtotal ?? 0.0;

  double get totalSavings => cartData?.totals.totalSavings ?? 0.0;

  double get total => subtotal;

  int get totalQuantity => cartData?.totals.itemCount ?? 0;

  /// Only the gateways that the API marks as active
  List<PaymentGateway> get activeGateways =>
      paymentGateways.where((g) => g.isActive).toList();

  /// Returns the PaymentGateway object for the currently selected method
  PaymentGateway? get selectedGateway => paymentGateways
      .where((g) => g.identifier == paymentMethod)
      .firstOrNull;

  CartState copyWith({
    ApiCartData? cartData,
    List<Map<String, String>>? localItems,
    bool? isGift,
    String? paymentMethod,
    bool? isLoading,
    String? error,
    List<PaymentGateway>? paymentGateways,
    bool? gatewaysLoading,
    bool? isCheckingOut,
    CheckoutResponse? checkoutResponse,
    String? checkoutError,
    bool clearCheckout = false,
    bool clearError = false,
  }) {
    return CartState(
      cartData: cartData ?? this.cartData,
      localItems: localItems ?? this.localItems,
      isGift: isGift ?? this.isGift,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      paymentGateways: paymentGateways ?? this.paymentGateways,
      gatewaysLoading: gatewaysLoading ?? this.gatewaysLoading,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      checkoutResponse: clearCheckout ? null : (checkoutResponse ?? this.checkoutResponse),
      checkoutError: clearCheckout ? null : (checkoutError ?? this.checkoutError),
    );
  }
}
