// ─────────────────────────────────────────────────────────────────────────────
// Request model
// ─────────────────────────────────────────────────────────────────────────────

class CheckoutRequest {
  final String paymentGatewayId;
  final List<CheckoutItem> items;
  final bool gift;
  final String giftPhoneNumber;

  const CheckoutRequest({
    required this.paymentGatewayId,
    required this.items,
    required this.gift,
    required this.giftPhoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'paymentGatewayId': paymentGatewayId,
        'items': items.map((e) => e.toJson()).toList(),
        'gift': gift,
        'giftPhoneNumber': giftPhoneNumber,
      };
}

class CheckoutItem {
  final String couponId;
  final String variantId;

  const CheckoutItem({required this.couponId, required this.variantId});

  Map<String, dynamic> toJson() => {
        'couponId': couponId,
        'variantId': variantId,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Response model
// Actual API shape:
// {
//   "ok": true,
//   "redirectUrl": "https://...",
//   "checkoutSessionId": "6a7047f043d2f32514a4a27f"
// }
// ─────────────────────────────────────────────────────────────────────────────

class CheckoutResponse {
  /// true when the server accepted the checkout
  final bool ok;

  /// URL to open in WebView for payment
  final String? redirectUrl;

  /// Session ID returned by the backend
  final String? checkoutSessionId;

  const CheckoutResponse({
    required this.ok,
    this.redirectUrl,
    this.checkoutSessionId,
  });

  /// Whether we should open a WebView (gateway returned a redirect URL)
  bool get hasRedirect => ok && redirectUrl != null && redirectUrl!.isNotEmpty;

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      ok: json['ok'] as bool? ?? false,
      redirectUrl: json['redirectUrl'] as String?,
      checkoutSessionId: json['checkoutSessionId'] as String?,
    );
  }
}
