import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../../login/view/login_page.dart';
import 'package:qupon/src/core/constants/app_colors.dart';
import 'package:qupon/l10n/app_localizations.dart';
import '../../../data/models/dashboard_model.dart';
import 'package:qupon/src/features/offers/presentation/widgets/offer_horizontal_card_api.dart';
import 'package:qupon/src/features/home/data/models/home_coupon.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback? onNavigateHome;
  const AccountPage({super.key, this.onNavigateHome});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _selectedPeriod = 'All time';
  String _selectedStatus = 'all';
  String _selectedVendor = 'all';
  final TextEditingController _fromCtrl = TextEditingController();
  final TextEditingController _toCtrl = TextEditingController();

  final List<String> _periods = [
    'All time',
    'Today',
    'Last 7 days',
    'Last 30 days',
    'Last 90 days',
    'This month',
    'This year',
  ];

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountInitial) {
          return const Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            ),
          );
        }
        if (state is AccountAuthenticated) {
          return _buildDashboard(context, state);
        }
        return _buildLoggedOut(context);
      },
    );
  }

  // ─────────────────────────── Logged-in Dashboard ────────────────────────
  Widget _buildDashboard(BuildContext context, AccountAuthenticated state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.isLoadingDashboard && state.dashboardData == null) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 16),
              Text(
                'Loading dashboard...',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (state.error != null && state.dashboardData == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<AccountBloc>().add(const LoadDashboard());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final data = state.dashboardData;
    final totalSpent = data?.totalSpent ?? 0.0;
    final couponsUsed = data?.couponsUsed ?? 0;
    final totalSaved = data?.totalSaved ?? 0.0;
    final activeCoupons = data?.activeCoupons ?? 0;
    final wallet = data?.wallet ?? 0.0;
    final transactions = data?.transactions ?? [];

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final vendors = transactions.map((t) => t.vendor).where((v) => v.isNotEmpty).toSet().toList();
    if (_selectedVendor != 'all' && !vendors.contains(_selectedVendor)) {
      _selectedVendor = 'all';
    }

    final filteredTransactions = transactions.where((tx) {
      if (_selectedStatus != 'all') {
        final lowerStatus = tx.status.toLowerCase();
        if (_selectedStatus == 'active' && !lowerStatus.contains('active') && !lowerStatus.contains('awaiting')) {
          return false;
        }
        if (_selectedStatus == 'expired' && !lowerStatus.contains('expired')) {
          return false;
        }
        if (_selectedStatus == 'pending' && !lowerStatus.contains('pending')) {
          return false;
        }
      }
      
      if (_selectedVendor != 'all') {
        if (tx.vendor.toLowerCase() != _selectedVendor.toLowerCase()) {
          return false;
        }
      }
      
      if (_selectedPeriod != 'All time') {
        try {
          DateTime? txDate;
          if (tx.date.contains('-') || tx.date.contains('/')) {
            txDate = DateTime.tryParse(tx.date);
          }
          if (txDate != null) {
            final now = DateTime.now();
            if (_selectedPeriod == 'Today') {
              if (txDate.year != now.year || txDate.month != now.month || txDate.day != now.day) {
                return false;
              }
            } else if (_selectedPeriod == 'Last 7 days') {
              if (now.difference(txDate).inDays > 7) {
                return false;
              }
            } else if (_selectedPeriod == 'Last 30 days') {
              if (now.difference(txDate).inDays > 30) {
                return false;
              }
            } else if (_selectedPeriod == 'Last 90 days') {
              if (now.difference(txDate).inDays > 90) {
                return false;
              }
            } else if (_selectedPeriod == 'This month') {
              if (txDate.year != now.year || txDate.month != now.month) {
                return false;
              }
            } else if (_selectedPeriod == 'This year') {
              if (txDate.year != now.year) {
                return false;
              }
            }
          }
        } catch (_) {}
      }

      if (_fromCtrl.text.isNotEmpty || _toCtrl.text.isNotEmpty) {
        try {
          DateTime? txDate;
          if (tx.date.contains('-') || tx.date.contains('/')) {
            txDate = DateTime.tryParse(tx.date);
          }
          if (txDate != null) {
            DateTime? parseCustomDate(String s) {
              final parts = s.split('/');
              if (parts.length == 3) {
                final day = int.tryParse(parts[0]);
                final month = int.tryParse(parts[1]);
                final year = int.tryParse(parts[2]);
                if (day != null && month != null && year != null) {
                  return DateTime(year, month, day);
                }
              }
              return null;
            }
            if (_fromCtrl.text.isNotEmpty) {
              final fromDate = parseCustomDate(_fromCtrl.text);
              if (fromDate != null && txDate.isBefore(fromDate)) {
                return false;
              }
            }
            if (_toCtrl.text.isNotEmpty) {
              final toDate = parseCustomDate(_toCtrl.text);
              if (toDate != null && txDate.isAfter(toDate)) {
                return false;
              }
            }
          }
        } catch (_) {}
      }
      
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(

          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Title & Subtitle ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.dashboardTitle,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.dashboardSubtitle(
                                  transactions.length,
                                  couponsUsed,
                                  _selectedPeriod == 'All time' ? l10n.periodAllTime : _selectedPeriod,
                                ),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Sign out icon next to title
                        IconButton(
                          icon: const Icon(Icons.logout, color: Color(0xFF64748B)),
                          onPressed: () => _confirmSignOut(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Search & Filter Row ──────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.searchHint,
                                  style: const TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _showFilterBottomSheet(context, vendors),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              // border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.tune_outlined, color: AppColors.primary, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  l10n.filtersBtn,
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Total Spent Card ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.iconBgOrange,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.credit_card_outlined,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'QAR ${totalSpent.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.totalSpent,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 2x2 Stats Grid ──────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            title: l10n.couponsUsed,
                            icon: Icons.confirmation_number_outlined,
                            iconColor: const Color(0xFF0284C7),
                            bgColor: AppColors.iconBgBlue,
                            value: couponsUsed.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            title: l10n.totalSaved,
                            icon: Icons.stars_outlined,
                            iconColor: const Color(0xFF16A34A),
                            bgColor: AppColors.iconBgGreen,
                            value: 'QAR ${totalSaved.toStringAsFixed(0)}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            title: l10n.activeCoupons,
                            icon: Icons.local_offer_outlined,
                            iconColor: const Color(0xFFEA580C),
                            bgColor: AppColors.iconBgLightOrange,
                            value: activeCoupons.toString(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            title: l10n.wallet,
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: const Color(0xFF9333EA),
                            bgColor: AppColors.iconBgPurple,
                            value: 'QAR ${wallet.toStringAsFixed(0)}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── My Orders Section ────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.myOrders,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          l10n.seeAll,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Transaction Items
                    if (filteredTransactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No recent orders',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 32),
                            Expanded(
                              flex: 3,
                              child: Text(
                                isArabic ? 'الطلب' : 'Order',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  isArabic ? 'الكوبونات' : 'Coupons',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                                child: Text(
                                  isArabic ? 'السعر' : 'Price',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      const SizedBox(height: 8),
                      ...filteredTransactions.map((tx) => _OrderCardItem(tx: tx, isArabic: isArabic)),
                    ],

                    const SizedBox(height: 32),

                    // ── My Wishlist Section ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isArabic ? 'قائمة رغباتي' : 'My Wishlist',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (state.wishlist.isNotEmpty)
                          Text(
                            '${state.wishlist.length} ${isArabic ? 'عناصر' : (state.wishlist.length == 1 ? 'item' : 'items')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (state.wishlist.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Center(
                          child: Text(
                            isArabic ? 'لا توجد عناصر في قائمة رغباتك حالياً' : 'No items in your wishlist yet',
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 310,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.wishlist.length,
                          itemBuilder: (context, index) {
                            return OfferHorizontalCardApi(coupon: state.wishlist[index]);
                          },
                        ),
                      ),
                  ],
                ),
              ),
              // const AppFooter(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  Widget _statCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, List<String> vendors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheetContent(
        selectedPeriod: _selectedPeriod,
        selectedStatus: _selectedStatus,
        selectedVendor: _selectedVendor,
        initialFrom: _fromCtrl.text,
        initialTo: _toCtrl.text,
        periods: _periods,
        vendors: vendors,
        onApply: (period, status, vendor, from, to) {
          setState(() {
            _selectedPeriod = period;
            _selectedStatus = status;
            _selectedVendor = vendor;
            _fromCtrl.text = from;
            _toCtrl.text = to;
          });
        },
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AccountBloc>().add(const SignOutRequested());
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────── Logged-out View ────────────────────────────
  Widget _buildLoggedOut(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Column(
                    children: [
                      const Text(
                        'Qupon',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(4, -8),
                        child: const Text(
                          'كيوبون',
                          style: TextStyle(
                            color: Color(0xFFFF6B35),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_circle_outlined,
                            color: Color(0xFFFF6B35),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'My Account',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Sign in to access your purchased coupons, order history, and account settings.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              final loggedIn = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                              if (loggedIn == true) {
                                widget.onNavigateHome?.call();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6B35),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
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
        ),
      ),
    );
  }
}

// ─────────────────────────── Filter Bottom Sheet Content ───────────────────────────
class _FilterBottomSheetContent extends StatefulWidget {
  final String selectedPeriod;
  final String selectedStatus;
  final String selectedVendor;
  final String initialFrom;
  final String initialTo;
  final List<String> periods;
  final List<String> vendors;
  final Function(String period, String status, String vendor, String from, String to) onApply;

  const _FilterBottomSheetContent({
    required this.selectedPeriod,
    required this.selectedStatus,
    required this.selectedVendor,
    required this.initialFrom,
    required this.initialTo,
    required this.periods,
    required this.vendors,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheetContent> createState() => _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<_FilterBottomSheetContent> {
  late String _localPeriod;
  late String _localStatus;
  late String _localVendor;
  late TextEditingController _localFromCtrl;
  late TextEditingController _localToCtrl;

  @override
  void initState() {
    super.initState();
    _localPeriod = widget.selectedPeriod;
    _localStatus = widget.selectedStatus;
    _localVendor = widget.selectedVendor;
    if (_localVendor != 'all' && !widget.vendors.contains(_localVendor)) {
      _localVendor = 'all';
    }
    _localFromCtrl = TextEditingController(text: widget.initialFrom);
    _localToCtrl = TextEditingController(text: widget.initialTo);
  }

  @override
  void dispose() {
    _localFromCtrl.dispose();
    _localToCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      setState(() {
        controller.text = formatted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.only(top: 80 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.filterTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0F172A),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.chipInactiveBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF0F172A),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFFF1F5F9), height: 1),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter by Date Range
                  Text(
                    l10n.filterDateRange,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.periods.map((p) {
                      final selected = _localPeriod == p;
                      String displayLabel = p;
                      if (p == 'All time') displayLabel = l10n.periodAllTime;
                      else if (p == 'Today') displayLabel = l10n.periodToday;
                      else if (p == 'Last 7 days') displayLabel = l10n.periodLast7Days;
                      else if (p == 'Last 30 days') displayLabel = l10n.periodLast30Days;
                      else if (p == 'Last 90 days') displayLabel = l10n.periodLast90Days;
                      else if (p == 'This month') displayLabel = l10n.periodThisMonth;
                      else if (p == 'This year') displayLabel = l10n.periodThisYear;

                      return GestureDetector(
                        onTap: () => setState(() => _localPeriod = p),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.chipInactiveBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            displayLabel,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                              color: selected ? Colors.white : AppColors.chipInactiveText,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Custom Date Range
                  Text(
                    l10n.customDateRange,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.startDate,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 6),
                            _buildDateField(_localFromCtrl),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.endDate,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            const SizedBox(height: 6),
                            _buildDateField(_localToCtrl),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filter by Status
                  Text(
                    l10n.filterStatus,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statusChip(l10n.statusAll, 'all'),
                      _statusChip(l10n.statusActive, 'active'),
                      _statusChip(l10n.statusExpired, 'expired'),
                      _statusChip(l10n.statusPending, 'pending'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filter by Vendor
                  Text(
                    l10n.filterVendor,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.selectVendor,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.chipInactiveBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _localVendor,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text(l10n.statusAll)),
                          ...widget.vendors.map((v) => DropdownMenuItem(value: v, child: Text(v))),
                        ],
                        onChanged: (v) => setState(() => _localVendor = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onApply(
                          _localPeriod,
                          _localStatus,
                          _localVendor,
                          _localFromCtrl.text,
                          _localToCtrl.text,
                        );
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        l10n.applyFilters,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _localPeriod = 'All time';
                          _localStatus = 'all';
                          _localVendor = 'all';
                          _localFromCtrl.clear();
                          _localToCtrl.clear();
                        });
                      },
                      child: Text(
                        l10n.resetFilters,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, String value) {
    final selected = _localStatus == value;
    return GestureDetector(
      onTap: () => setState(() => _localStatus = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.chipInactiveBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? Colors.white : AppColors.chipInactiveText,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return GestureDetector(
      onTap: () => _selectDate(context, controller),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.chipInactiveBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.text.isEmpty ? 'DD / MM / YYYY' : controller.text,
              style: TextStyle(
                fontSize: 14,
                color: controller.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                fontWeight: controller.text.isEmpty ? FontWeight.normal : FontWeight.w500,
              ),
            ),
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B), size: 18),
          ],
        ),
      ),
    );
  }
}

// _OrderCardItem represents the expandable row item in the My Orders list.
class _OrderCardItem extends StatefulWidget {
  final DashboardTransaction tx;
  final bool isArabic;

  const _OrderCardItem({
    super.key,
    required this.tx,
    required this.isArabic,
  });

  @override
  State<_OrderCardItem> createState() => _OrderCardItemState();
}

class _OrderCardItemState extends State<_OrderCardItem> {
  bool _isExpanded = false;

  void _showQrCodeDialog(BuildContext context, String code, String redeemBy) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row: Title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24), // Offset for Close button to center title
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.isArabic ? 'رمز الاستجابة السريعة للكوبون' : 'Your Coupon QR Code',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.isArabic
                      ? 'قم بتقديم رمز QR للبائع لاسترداد مشترياتك.'
                      : 'Show this QR code to the vendor to redeem your purchase.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // QR Code Image
              Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=$code',
                width: 200,
                height: 200,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                      child: Icon(Icons.qr_code, size: 100, color: Color(0xFF94A3B8)),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Coupon Code Label
              Text(
                widget.isArabic ? 'رمز الكوبون' : 'Coupon Code',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 6),
              // Actual Code
              Text(
                code,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              // Redeem by badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // light blue background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.isArabic
                          ? 'صالح للاستخدام حتى $redeemBy'
                          : 'Redeem by $redeemBy',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildDetailRow(String label, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: valueWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(String status, bool isArabic) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('awaiting') || lowerStatus.contains('pending')) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.access_time;
      text = isArabic ? 'في انتظار الاسترداد' : 'Awaiting redemption';
    } else if (lowerStatus.contains('expired')) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFEF4444);
      icon = Icons.error_outline;
      text = isArabic ? 'منتهي الصلاحية' : 'Expired';
    } else if (lowerStatus.contains('redeemed') || lowerStatus.contains('used')) {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF15803D);
      icon = Icons.check_circle_outline;
      text = isArabic ? 'تم الاسترداد' : 'Redeemed';
    } else {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.access_time;
      text = isArabic ? 'في انتظار الاسترداد' : 'Awaiting redemption';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget _buildCouponSection(BuildContext context, DashboardCoupon coupon, bool isArabic) {
    final vendor = coupon.vendor.isNotEmpty ? coupon.vendor : '';
    final offerName = coupon.offer.isNotEmpty ? coupon.offer : '';
    final couponCode = coupon.code.isNotEmpty ? coupon.code : '';

    final couponUrl = coupon.couponUrl.isNotEmpty
        ? coupon.couponUrl
        : 'https://qupon.marbu.in/coupon/${couponCode.isNotEmpty ? couponCode : ''}';

    final status = coupon.status.isNotEmpty ? coupon.status : '';
    final rawRedeemBy = coupon.redeemBy.isNotEmpty ? coupon.redeemBy : '';

    String timeLeft = '';
    final daysUntil = coupon.daysUntilRedeem;
    if (daysUntil != null) {
      timeLeft = isArabic ? '$daysUntil يوم متبقي' : '${daysUntil}d left';
    }

    String redeemByFormatted = rawRedeemBy;
    try {
      DateTime? expiry;
      if (rawRedeemBy.contains('-') || rawRedeemBy.contains('/')) {
        expiry = DateTime.tryParse(rawRedeemBy);
      } else {
        final parts = rawRedeemBy.split(' ');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final monthStr = parts[1].toLowerCase();
          final year = int.tryParse(parts[2]);
          int? month;
          if (monthStr.startsWith('jan')) month = 1;
          else if (monthStr.startsWith('feb')) month = 2;
          else if (monthStr.startsWith('mar')) month = 3;
          else if (monthStr.startsWith('apr')) month = 4;
          else if (monthStr.startsWith('may')) month = 5;
          else if (monthStr.startsWith('jun')) month = 6;
          else if (monthStr.startsWith('jul')) month = 7;
          else if (monthStr.startsWith('aug')) month = 8;
          else if (monthStr.startsWith('sep')) month = 9;
          else if (monthStr.startsWith('oct')) month = 10;
          else if (monthStr.startsWith('nov')) month = 11;
          else if (monthStr.startsWith('dec')) month = 12;

          if (day != null && month != null && year != null) {
            expiry = DateTime(year, month, day);
          }
        }
      }

      if (expiry != null) {
        redeemByFormatted = DateFormat('d MMM yyyy', isArabic ? 'ar' : 'en').format(expiry);
        if (timeLeft.isEmpty) {
          final difference = expiry.difference(DateTime.now());
          final days = difference.inDays;
          timeLeft = isArabic ? '$days يوم متبقي' : '${days}d left';
        }
      }
    } catch (_) {}

    if (timeLeft.isEmpty) {
      timeLeft = isArabic ? '118 يوم متبقي' : '118d left';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          isArabic ? 'البائع' : 'Vendor',
          Text(vendor, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          isArabic ? 'العرض' : 'Offer',
          Text(offerName, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          isArabic ? 'الكود' : 'Code',
          Text(couponCode, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        ),
        _buildDetailRow(
          isArabic ? 'رابط الكوبون' : 'Coupon URL',
          GestureDetector(
            onTap: () => _copyToClipboard(
              couponUrl,
              isArabic ? 'تم نسخ الرابط في الحافظة' : 'Coupon URL copied to clipboard',
            ),
            child: Text(
              couponUrl,
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: AppColors.primary,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        _buildDetailRow(
          isArabic ? 'السعر' : 'Price',
          Text(coupon.price.isNotEmpty ? coupon.price : 'QAR 20', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        _buildDetailRow(
          isArabic ? 'الحالة' : 'Status',
          _buildStatusWidget(status, isArabic),
        ),
        _buildDetailRow(
          isArabic ? 'تاريخ الاسترداد' : 'Redeem by',
          Text(redeemByFormatted, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          isArabic ? 'الوقت المتبقي' : 'Time left',
          Row(
            children: [
              const Icon(Icons.access_time_outlined, size: 16, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                timeLeft,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        _buildDetailRow(
          isArabic ? 'رمز QR' : 'QR code',
          GestureDetector(
            onTap: () => _showQrCodeDialog(context, couponCode, redeemByFormatted),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_2, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  isArabic ? 'عرض رمز QR' : 'Show QR code',
                  style: const TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.tx;
    final isArabic = widget.isArabic;

    // Fallbacks matching screenshot if API fields are missing
    final orderDisplayRef = tx.orderDisplayRef;
    print("orderDisplayRef....$orderDisplayRef");
    final coupons = tx.couponsCount;
    final price = tx.price;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          // Order main row
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_down : (isArabic ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right),
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      orderDisplayRef,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        coupons.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                      child: Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Expanded detail section
          if (_isExpanded) ...[
            const Divider(color: Color(0xFFF1F5F9), height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  for (int i = 0; i < tx.coupons.length; i++) ...[
                    if (i > 0) ...[
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFE2E8F0), height: 1),
                      const SizedBox(height: 16),
                    ],
                    _buildCouponSection(context, tx.coupons[i], isArabic),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
