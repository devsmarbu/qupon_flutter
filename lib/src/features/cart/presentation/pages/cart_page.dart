import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../main/presentation/widgets/app_footer.dart';
import '../../../main/presentation/pages/main_page.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import '../bloc/cart_event.dart';
import '../../data/models/cart_item.dart';

class CartPage extends StatelessWidget {
  final VoidCallback onNavigateHome;

  const CartPage({
    super.key,
    required this.onNavigateHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';

    return SafeArea(
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final isEmpty = state.items.isEmpty;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Divider under AppBar ──────────────────────────────────────
                Container(height: 1, color: const Color(0xFFE2E8F0)),

                // ── Back Button "Continue shopping" ───────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: InkWell(
                    onTap: onNavigateHome,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isArabic ? Icons.arrow_forward : Icons.arrow_back,
                            size: 16,
                            color: const Color(0xFF64748B),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.continueShopping,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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
                            ? l10n.shoppingCartTitle 
                            : '${l10n.shoppingCartTitle} (${state.totalQuantity})',
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
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return _buildCartItemCard(context, item, l10n, isArabic);
                    },
                  ),

                  const SizedBox(height: 12),

                  // ── Order Summary Card ───────────────────────────────────────
                  _buildOrderSummaryCard(context, state, l10n, isArabic),

                  // ── Payment Methods Card ──────────────────────────────────────
                  _buildPaymentMethodsCard(context, state, l10n, isArabic),
                ],

                const SizedBox(height: 48),

                // ── Footer ────────────────────────────────────────────────────
                // const AppFooter(),
              ],
            ),
          );
        },
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
            l10n.cartEmptyTitle,
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
            l10n.cartEmptySubtitle,
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
            onPressed: onNavigateHome,
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
              l10n.browseDeals,
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

  Widget _buildCartItemCard(BuildContext context, CartItem item, AppLocalizations l10n, bool isArabic) {
    // Electronics maps to ElectroWorld as vendor, otherwise default to offer.title
    final vendorName = item.offer.category == 'Electronics' ? 'ElectroWorld' : item.offer.title;

    // Get first letter of category as initial, default to '?'
    final initialLetter = item.offer.category.isNotEmpty ? item.offer.category[0].toUpperCase() : '?';

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
          // ── Premium Category Initial Avatar (Blue-grey tint) ───────────
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
                // Offer Title + Selected Option
                Text(
                  '${item.offer.title} — ${item.option.name}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),

                // Vendor Subtitle
                Text(
                  vendorName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),

                // Prices row
                Row(
                  children: [
                    Text(
                      'QAR ${item.option.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFF6B35), // Signature Orange
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'QAR ${item.option.originalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.youSave((item.option.originalPrice - item.option.price).toStringAsFixed(0)),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF16A34A), // Rich Green
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Delete Button (Align bottom-left as requested)
                Align(
                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      context.read<CartBloc>().add(RemoveFromCart(item: item));
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Icon(
                        Icons.delete_outline,
                        color: Color(0xFF94A3B8),
                        size: 20,
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

  Widget _buildOrderSummaryCard(BuildContext context, CartState state, AppLocalizations l10n, bool isArabic) {
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
          Text(
            l10n.orderSummary,
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
                l10n.subtotal(state.totalQuantity),
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
                l10n.totalSavings,
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
                l10n.totalLabel,
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
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),

          // Gift order option row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.giftThisOrder,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.giftSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
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
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard(BuildContext context, CartState state, AppLocalizations l10n, bool isArabic) {
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
          Text(
            l10n.payVia,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Stripe Selection Row
          _buildPaymentOptionTile(
            context,
            id: 'stripe',
            icon: Icons.credit_card,
            title: l10n.stripe,
            isSelected: state.paymentMethod == 'stripe',
          ),
          const SizedBox(height: 12),

          // Wallet Selection Row
          _buildPaymentOptionTile(
            context,
            id: 'wallet',
            icon: Icons.account_balance_wallet_outlined,
            title: l10n.wallet,
            subtitle: l10n.walletBalance('0'),
            isSelected: state.paymentMethod == 'wallet',
          ),
          const SizedBox(height: 12),

          // SkipCash Selection Row
          _buildPaymentOptionTile(
            context,
            id: 'skipcash',
            icon: Icons.payment,
            title: l10n.skipCash,
            isSelected: state.paymentMethod == 'skipcash',
          ),

          const SizedBox(height: 24),

          // Checkout CTA button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                final mainPageState = context.findAncestorStateOfType<MainPageState>();
                if (mainPageState != null) {
                  mainPageState.showCheckoutSuccess(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.checkoutWithPrice(state.total.toStringAsFixed(0)),
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
  }) {
    return InkWell(
      onTap: () {
        context.read<CartBloc>().add(SelectPaymentMethod(method: id));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFE2E8F0),
            width: isSelected ? 2.0 : 1.2,
          ),
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
              child: Icon(icon, color: const Color(0xFF64748B), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
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
                  color: isSelected ? const Color(0xFFFF6B35) : const Color(0xFFCBD5E1),
                  width: isSelected ? 6.0 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
