import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../cart/data/models/checkout_model.dart';
import '../../../cart/data/models/payment_gateway.dart';
import '../../../cart/data/repositories/cart_repository.dart';
import '../../../cart/presentation/pages/payment_webview_page.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../../data/models/offer.dart';
import '../../data/models/offer_option.dart';

class DirectCheckoutSheet extends StatefulWidget {
  final Offer offer;
  final OfferOption option;
  final bool isGift;

  const DirectCheckoutSheet({
    super.key,
    required this.offer,
    required this.option,
    this.isGift = false,
  });

  static Future<void> show(BuildContext context, {
    required Offer offer,
    required OfferOption option,
    bool isGift = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          DirectCheckoutSheet(
            offer: offer,
            option: option,
            isGift: isGift,
          ),
    );
  }

  @override
  State<DirectCheckoutSheet> createState() => _DirectCheckoutSheetState();
}

class _DirectCheckoutSheetState extends State<DirectCheckoutSheet> {
  final TextEditingController _phoneController = TextEditingController();

  List<PaymentGateway> _gateways = [];
  bool _isLoadingGateways = true;
  String? _gatewaysError;

  String _selectedGatewayId = '';
  bool _isCheckingOut = false;
  String? _checkoutError;

  @override
  void initState() {
    super.initState();
    _fetchPaymentGateways();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _fetchPaymentGateways() async {
    setState(() {
      _isLoadingGateways = true;
      _gatewaysError = null;
    });

    try {
      final repo = context.read<CartRepository>();
      final gateways = await repo.getPaymentGateways();
      final active = gateways.where((g) => g.isActive).toList();

      setState(() {
        _gateways = gateways;
        _isLoadingGateways = false;
        if (active.isNotEmpty) {
          _selectedGatewayId = active.first.identifier;
        }
      });
    } catch (e) {
      setState(() {
        _gatewaysError = e.toString().replaceFirst('Exception: ', '');
        _isLoadingGateways = false;
      });
    }
  }

  PaymentGateway? get _selectedGateway {
    return _gateways
        .where((g) => g.identifier == _selectedGatewayId)
        .firstOrNull;
  }

  Future<void> _handleCheckout() async {
    final gateway = _selectedGateway;
    if (gateway == null) {
      setState(() => _checkoutError = 'Please select a payment method.');
      return;
    }

    if (widget.isGift && _phoneController.text
        .trim()
        .isEmpty) {
      setState(() => _checkoutError = 'Please enter recipient mobile number.');
      return;
    }

    setState(() {
      _isCheckingOut = true;
      _checkoutError = null;
    });

    try {
      final repo = context.read<CartRepository>();
      final request = CheckoutRequest(
        paymentGatewayId: gateway.id,
        items: [
          CheckoutItem(
            couponId: widget.offer.id,
            variantId: widget.option.id,
          )
        ],
        gift: widget.isGift,
        giftPhoneNumber: widget.isGift ? _phoneController.text.trim() : '',
      );

      final response = await repo.checkout(request);

      if (!mounted) return;
      setState(() => _isCheckingOut = false);

      if (response.ok) {
        if (response.hasRedirect) {
          final result = await Navigator.of(context).push<PaymentResult>(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) =>
                  PaymentWebViewPage(
                    redirectUrl: response.redirectUrl!,
                    sessionId: response.checkoutSessionId,
                    provider: _selectedGatewayId,
                  ),
            ),
          );

          if (!mounted) return;

          if (result == PaymentResult.success) {
            Navigator.of(context).pop(); // Close sheet
            final mainPageState =
            context.findAncestorStateOfType<MainPageState>();
            if (mainPageState != null) {
              mainPageState.showCheckoutSuccess(context);
            }
          } else {
            _showSnackBar('Payment was cancelled.');
          }
        } else {
          Navigator.of(context).pop(); // Close sheet
          final mainPageState =
          context.findAncestorStateOfType<MainPageState>();
          if (mainPageState != null) {
            mainPageState.showCheckoutSuccess(context);
          }
        }
      } else {
        setState(() {
          _checkoutError = 'Checkout failed. Please try again.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      final errMsg = e.toString().replaceFirst('Exception: ', '');
      setState(() {
        _isCheckingOut = false;
        _checkoutError = errMsg;
      });
    }
  }


  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFDC2626) : const Color(
            0xFF64748B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  IconData _iconForGateway(String identifier) {
    switch (identifier) {
      case 'stripe':
        return Icons.credit_card;
      case 'wallet':
        return Icons.account_balance_wallet_outlined;
      case 'skipcash':
        return Icons.payment;
      case 'tap':
        return Icons.tap_and_play_outlined;
      case 'partner':
        return Icons.handshake_outlined;
      default:
        return Icons.payment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeGateways = _gateways.where((g) => g.isActive).toList();
    final double price = widget.option.price;
    final selectedGatewayName = _selectedGateway?.name ?? '';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery
              .of(context)
              .size
              .height * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isGift ? 'Gift this order' : 'Checkout',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.isGift
                                ? 'Enter the recipient\'s mobile number and pay for ${widget
                                .offer.title}.'
                                : 'Select a payment method to complete your purchase of ${widget
                                .offer.title}.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Color(0xFF0F172A)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── YOU PAY Box ─────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Stack(alignment: Alignment.center, children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/Subtract.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'GIFT COUPON',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  'Tech Gadgets',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                  ),
                                ),
                                const Text(
                                  '15% OFF ',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          ])
                        ],
                      ),
                    ),

                    // ── Gift Recipient Section (if isGift is true) ───────────
                    if (widget.isGift) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gift this order',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Send the coupon details to someone else by SMS.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Recipient mobile number',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: '50123456',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 15,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFF6B35),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFF6B35),
                                    width: 2.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'We will text the coupon code(s) to this number after payment.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // ── Pay via Title ───────────────────────────────────────
                    const Text(
                      'Pay via',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ── Payment Gateways List ──────────────────────────────
                    if (_isLoadingGateways)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      )
                    else
                      if (_gatewaysError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            _gatewaysError!,
                            style: const TextStyle(fontSize: 13,
                                color: Colors.red),
                          ),
                        )
                      else
                        if (activeGateways.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'No payment methods available.',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF94A3B8)),
                            ),
                          )
                        else
                          ...activeGateways
                              .asMap()
                              .entries
                              .map((entry) {
                            final index = entry.key;
                            final gateway = entry.value;

                            String? subtitle = gateway.description.isNotEmpty
                                ? gateway.description
                                : null;
                            bool isDisabled = false;

                            if (gateway.identifier == 'wallet') {
                              final walletBalance =
                                  gateway.walletSettings?.minBalance ?? 0.0;
                              final isInsufficient = walletBalance < price;
                              isDisabled = walletBalance <= 0 || isInsufficient;

                              subtitle =
                              'Balance: QAR ${walletBalance.toStringAsFixed(0)}'
                                  '${isInsufficient ? ' · Insufficient' : ''}';
                            }

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index < activeGateways.length - 1
                                    ? 12
                                    : 0,
                              ),
                              child: _buildPaymentTile(
                                gateway: gateway,
                                subtitle: subtitle,
                                isSelected: _selectedGatewayId ==
                                    gateway.identifier,
                                isDisabled: isDisabled,
                              ),
                            );
                          }),

                    if (_checkoutError != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Color(0xFFDC2626),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _checkoutError!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF991B1B),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // ── Pay Button ──────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isCheckingOut ? null : _handleCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                          const Color(0xFFFF6B35).withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isCheckingOut
                            ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          selectedGatewayName.isNotEmpty
                              ? 'Pay QAR ${price.toStringAsFixed(
                              0)} via $selectedGatewayName'
                              : 'Pay QAR ${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTile({
    required PaymentGateway gateway,
    String? subtitle,
    required bool isSelected,
    bool isDisabled = false,
  }) {
    final Color textColor =
    isDisabled ? const Color(0xFF94A3B8) : const Color(0xFF0F172A);
    final Color iconColor =
    isDisabled ? const Color(0xFFCBD5E1) : const Color(0xFF64748B);
    final Color borderColor = isSelected && !isDisabled
        ? const Color(0xFFFF6B35)
        : const Color(0xFFE2E8F0);
    final double borderWidth = isSelected && !isDisabled ? 1.8 : 1.2;

    return InkWell(
      onTap: isDisabled
          ? null
          : () =>
          setState(() {
            _selectedGatewayId = gateway.identifier;
            _checkoutError = null;
          }),
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected && !isDisabled
                ? const Color(0xFFFFF7ED)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(
                  _iconForGateway(gateway.identifier),
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gateway.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: subtitle.contains('Insufficient')
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isSelected && !isDisabled)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFFF6B35),
                  size: 22,
                )
              else
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
