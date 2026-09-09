import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../main/presentation/pages/main_page.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../../data/models/api_cart_model.dart';
import '../../../account/presentation/account/bloc/account_bloc.dart';
import '../../../account/presentation/account/bloc/account_state.dart';
import '../../../account/presentation/login/view/sign_in_dialog.dart';
import 'payment_webview_page.dart';

class CartPage extends StatefulWidget {
  final VoidCallback onNavigateHome;

  const CartPage({
    super.key,
    required this.onNavigateHome,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.checkoutResponse != current.checkoutResponse ||
          previous.checkoutError != current.checkoutError,
      listener: (context, state) {
        // ── Checkout error ──────────────────────────────────────────────────
        if (state.checkoutError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.checkoutError!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }

        // ── Checkout success — open WebView if redirectUrl is present ────────
        if (state.checkoutResponse != null && state.checkoutResponse!.ok) {
          final response = state.checkoutResponse!;

          if (response.hasRedirect) {
            // Open payment gateway in WebView
            Navigator.of(context)
                .push<PaymentResult>(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => PaymentWebViewPage(
                      redirectUrl: response.redirectUrl!,
                      sessionId: response.checkoutSessionId,
                      provider: state.paymentMethod,
                    ),
                  ),
                )
                .then((result) {
                  if (!context.mounted) return;
                  if (result == PaymentResult.success) {
                    // Payment completed — show success screen
                    final mainPageState =
                        context.findAncestorStateOfType<MainPageState>();
                    if (mainPageState != null) {
                      mainPageState.showCheckoutSuccess(context);
                    }
                  } else {
                    // User cancelled / closed WebView
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Text('Payment was cancelled.',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        backgroundColor: const Color(0xFF64748B),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  }
                });
          } else {
            // No redirect URL — gateway handled payment server-side
            final mainPageState =
                context.findAncestorStateOfType<MainPageState>();
            if (mainPageState != null) {
              mainPageState.showCheckoutSuccess(context);
            }
          }
        }
      },
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final isEmpty = state.items.isEmpty;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Divider under AppBar ──────────────────────────────────────
                  Container(height: 1, color: const Color(0xFFE2E8F0)),

                  // ── Page Title ───────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED), // Soft orange tint background
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFFFFD8C2),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFFFF6B35), // Signature Orange
                              size: 28,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          isEmpty
                              ? LocalizationService().getString('CART_TITLE', l10n.shoppingCartTitle)
                              : '${LocalizationService().getString('CART_TITLE', l10n.shoppingCartTitle)} (${state.totalQuantity})',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isEmpty)
                    _buildEmptyState(context, l10n)
                  else ...[
                    // ── Cart Items List ──────────────────────────────────────────
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _buildCartItemCard(context, item, l10n, isArabic);
                      },
                    ),

                    // ── Combined Order Summary Card ──────────────────────────────
                    _buildCombinedOrderCard(context, state, l10n, isArabic),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Centered Gray Bag Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFCBD5E1), // Light outline
                width: 3,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF94A3B8),
                size: 34,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title: "Your cart is empty"
          Text(
            LocalizationService().getString('CART_EMPTY_TITLE', l10n.cartEmptyTitle),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Subtitle
          Text(
            LocalizationService().getString('CART_EMPTY_DESC', l10n.cartEmptySubtitle),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Orange "Browse deals" button
          ElevatedButton(
            onPressed: widget.onNavigateHome,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
            ),
            child: Text(
              LocalizationService().getString('CART_BROWSE_DEALS', l10n.browseDeals),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, ApiCartItem item, AppLocalizations l10n, bool isArabic) {
    final initialLetter = item.name.isNotEmpty ? item.name[0].toUpperCase() : 'E';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category Initial Avatar (Blue-grey tint) ───────────────────
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF), // Soft Muted Blue Tint
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                initialLetter,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B82F6), // Premium Blue
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // ── Details Column ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  isArabic && item.nameAr.isNotEmpty ? item.nameAr : item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),

                // Vendor
                Text(
                  item.vendor,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),

                // Price and Savings Row
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'QAR ${item.payable.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF6B35), // Signature Orange
                      ),
                    ),
                    Text(
                      'QAR ${item.listPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      isArabic
                          ? '${LocalizationService().getString('COUPON_DETAILS_YOU_SAVE', 'أنت وفرت')} ${(item.listPrice - item.payable).toStringAsFixed(0)} ر.ق'
                          : '${LocalizationService().getString('COUPON_DETAILS_YOU_SAVE', 'You save')} QAR ${(item.listPrice - item.payable).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A), // Rich Green
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Delete Button
                Align(
                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      final deleteKey = item.key.isNotEmpty ? item.key : item.couponId;
                      context.read<CartBloc>().add(RemoveFromCart(key: deleteKey));
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFEF4444),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            LocalizationService().getString('WISHLIST_REMOVE', l10n.deleteLabel),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombinedOrderCard(BuildContext context, CartState state, AppLocalizations l10n, bool isArabic) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title "Order summary" ──
          Text(
            LocalizationService().getString('CART_ORDER_SUMMARY', l10n.orderSummary),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Subtotal Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${LocalizationService().getString('CART_SUBTOTAL', l10n.subtotalLabel)} (${state.totalQuantity})',
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              Text(
                'QAR ${state.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Total Savings Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationService().getString('CART_TOTAL_SAVINGS', l10n.totalSavings),
                style: const TextStyle(fontSize: 14, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
              ),
              Text(
                '-QAR ${state.totalSavings.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),

          // Total Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocalizationService().getString('CART_TOTAL', l10n.totalLabel),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              Text(
                'QAR ${state.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Gift card option inside border container ──
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationService().getString('CHECKOUT_GIFT_TITLE', l10n.giftThisOrder),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            LocalizationService().getString('CHECKOUT_GIFT_DESC', l10n.giftSubtitle),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.isGift,
                      onChanged: (val) {
                        context.read<CartBloc>().add(ToggleGift(isGift: val));
                      },
                      activeColor: const Color(0xFFFF6B35),
                    ),
                  ],
                ),
                // Phone number input — shown only when gift is enabled
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: state.isGift
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        LocalizationService().getString('CHECKOUT_GIFT_PHONE_LABEL', l10n.recipientPhoneLabel),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                              color: Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF6B35),
                              width: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        LocalizationService().getString('CHECKOUT_GIFT_PHONE_HINT', l10n.giftPhoneHint),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        LocalizationService().getString('COMMON_QATAR_PHONE_HINT', l10n.qatarPhoneHint),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Pay via section ──
          Text(
            LocalizationService().getString('CART_PAY_VIA', l10n.payVia),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Dynamic payment methods from API
          if (state.gatewaysLoading)
            _buildGatewaysLoadingShimmer()
          else if (state.activeGateways.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No payment methods available.',
                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            )
          else
            ...state.activeGateways.asMap().entries.map((entry) {
              final index = entry.key;
              final gateway = entry.value;

              // Wallet: show balance subtitle and disable if balance == 0
              String? subtitle;
              bool isDisabled = false;
              if (gateway.identifier == 'wallet') {
                final walletBalance = gateway.walletSettings?.minBalance ?? 0.0;
                subtitle = isArabic
                    ? '${LocalizationService().getString('CART_BALANCE', 'الرصيد')}: ${walletBalance.toStringAsFixed(0)} ر.ق'
                    : '${LocalizationService().getString('CART_BALANCE', 'Balance')}: QAR ${walletBalance.toStringAsFixed(0)}';
                isDisabled = walletBalance <= 0;
              }

              return Padding(
                padding: EdgeInsets.only(bottom: index < state.activeGateways.length - 1 ? 12 : 0),
                child: _buildPaymentOptionTile(
                  context,
                  id: gateway.identifier,
                  icon: _iconForGateway(gateway.identifier),
                  title: gateway.name,
                  subtitle: subtitle,
                  isSelected: state.paymentMethod == gateway.identifier,
                  isDisabled: isDisabled,
                ),
              );
            }),
          const SizedBox(height: 24),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: state.isCheckingOut
                  ? null
                  : () async {
                      final accountState = context.read<AccountBloc>().state;
                      if (accountState is! AccountAuthenticated) {
                        final loggedIn = await SignInDialog.show(context);
                        if (loggedIn != true || !context.mounted) return;
                      }
                      context.read<CartBloc>().add(
                        PlaceOrder(
                          giftPhoneNumber: _phoneController.text.trim(),
                        ),
                      );
                    },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFFF6B35).withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: state.isCheckingOut
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isArabic
                          ? '${LocalizationService().getString('CART_CHECKOUT', 'الدفع')} · ${state.total.toStringAsFixed(0)} ر.ق'
                          : '${LocalizationService().getString('CART_CHECKOUT', 'Checkout')} · QAR ${state.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionTile(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isSelected,
    bool isDisabled = false,
  }) {
    final Color textColor = isDisabled ? const Color(0xFFB0BEC5) : const Color(0xFF0F172A);
    final Color iconColor = isDisabled ? const Color(0xFFCFD8DC) : const Color(0xFF64748B);
    final Color borderColor = isSelected && !isDisabled
        ? const Color(0xFFFF6B35)
        : const Color(0xFFE2E8F0);
    final double borderWidth = isSelected && !isDisabled ? 2.0 : 1.2;
    final Color radioColor = isSelected && !isDisabled
        ? const Color(0xFFFF6B35)
        : const Color(0xFFCBD5E1);
    final double radioWidth = isSelected && !isDisabled ? 6.0 : 1.5;

    return InkWell(
      onTap: isDisabled
          ? null
          : () => context.read<CartBloc>().add(SelectPaymentMethod(method: id)),
      borderRadius: BorderRadius.circular(12),
      child: Opacity(
        opacity: isDisabled ? 0.55 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: radioColor,
                    width: radioWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maps gateway identifier to a suitable icon
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

  /// Skeleton placeholder shown while payment gateways are loading
  Widget _buildGatewaysLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
          child: _ShimmerBox(
            height: 68,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}

/// Simple animated shimmer/skeleton box widget
class _ShimmerBox extends StatefulWidget {
  final double height;
  final BorderRadius borderRadius;

  const _ShimmerBox({required this.height, required this.borderRadius});

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => Opacity(
        opacity: _animation.value,
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}
