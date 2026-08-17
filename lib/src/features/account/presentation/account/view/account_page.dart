import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../../login/view/login_page.dart';
import 'package:qupon/src/core/constants/app_colors.dart';
import 'package:qupon/src/features/localization/data/services/localization_service.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final accountState = context.read<AccountBloc>().state;
      if (accountState is AccountAuthenticated &&
          accountState.dashboardData == null &&
          !accountState.isLoadingDashboard) {
        context.read<AccountBloc>().add(const LoadDashboard());
      }
    });
  }

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

    if (state.dashboardData == null && state.isLoadingDashboard && state.error == null) {
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
    final transactions = state.filteredTransactions ?? data?.transactions ?? [];

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final vendors = (data?.transactions ?? []).map((t) => t.vendor).where((v) => v.isNotEmpty).toSet().toList();
    if (_selectedVendor != 'all' && !vendors.contains(_selectedVendor)) {
      _selectedVendor = 'all';
    }

    final filteredTransactions = transactions;

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
                    // ── Title & Filters Row ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            ],
                          ),
                        ),
                        // ── Filters Button ─────────────────────────
                        _buildFiltersButton(context, vendors),
                        const SizedBox(width: 4),
                        // Sign out icon
                        GestureDetector(
                          onTap: () => _confirmSignOut(context),
                          child: const Icon(Icons.logout, color: Color(0xFF94A3B8), size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Active Filter Chips Row ───────────────────────────
                    _buildActiveFilterChips(l10n, isArabic),
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
                        // Text(
                        //   l10n.seeAll,
                        //   style: const TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,
                        //     color: AppColors.primary,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Transaction Items
                    if (state.isLoadingDashboard)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      )
                    else if (filteredTransactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'No recent orders',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          ),
                        ),
                      )
                    else
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        child: Column(
                          children: [
                            for (int i = 0; i < filteredTransactions.length; i++) ...[
                              if (i > 0)
                                const Divider(
                                  color: Color(0xFFF1F5F9),
                                  height: 1,
                                  indent: 76,
                                  endIndent: 16,
                                ),
                              _OrderCardItem(
                                tx: filteredTransactions[i],
                                isArabic: isArabic,
                                isFirst: i == 0,
                                isLast: i == filteredTransactions.length - 1,
                              ),
                            ],
                          ],
                        ),
                      ),

                    const SizedBox(height: 32),

                    // ── My Wishlist Section ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.myWishlist,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (state.wishlist.isNotEmpty)
                          Text(
                            l10n.itemCount(state.wishlist.length),
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
                            l10n.noItemsInWishlist,
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

  /// Count of active (non-default) filters — always shown in the badge.
  int get _activeFilterCount {
    int count = 0;
    // Date/period filter
    if (_selectedPeriod != 'All time' || _fromCtrl.text.isNotEmpty || _toCtrl.text.isNotEmpty) count++;
    // Status filter
    if (_selectedStatus != 'all') count++;
    // Vendor filter
    if (_selectedVendor != 'all') count++;
    return count;
  }

  Widget _buildFiltersButton(BuildContext context, List<String> vendors) {
    final count = _activeFilterCount;
    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context, vendors),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tune_rounded,
              color: Color(0xFFFF6B35),
              size: 17,
            ),
            const SizedBox(width: 6),
            const Text(
              'Filters',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            // Count badge — only shown when filters are active
            if (count > 0)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilterChips(AppLocalizations l10n, bool isArabic) {
    // ── Date label ─────────────────────────────────────────────────────────
    String dateValue;
    if (_fromCtrl.text.isNotEmpty || _toCtrl.text.isNotEmpty) {
      final from = _fromCtrl.text.isNotEmpty ? _fromCtrl.text : '...';
      final to   = _toCtrl.text.isNotEmpty   ? _toCtrl.text   : '...';
      dateValue = '$from – $to';
    } else if (_selectedPeriod == 'All time') {
      dateValue = LocalizationService().getString('FILTER_ALL_TIME', l10n.filterAllTime);
    } else {
      dateValue = _selectedPeriod;
    }

    // ── Status label ───────────────────────────────────────────────────────
    final String statusValue;
    switch (_selectedStatus) {
      case 'active':
        statusValue = LocalizationService().getString('STATUS_ACTIVE', l10n.filterStatusActive);
        break;
      case 'expired':
        statusValue = LocalizationService().getString('COUPON_EXPIRED', l10n.filterStatusExpired);
        break;
      case 'pending':
        statusValue = LocalizationService().getString('STATUS_PENDING', l10n.filterStatusPending);
        break;
      default:
        statusValue = LocalizationService().getString('FILTER_ALL', l10n.filterAll);
    }

    // ── Vendor label ───────────────────────────────────────────────────────
    final String vendorValue = _selectedVendor == 'all'
        ? LocalizationService().getString('FILTER_ALL', l10n.filterAll)
        : _selectedVendor;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(label: LocalizationService().getString('FILTER_DATE_LABEL', l10n.filterDateLabel), value: dateValue),
          const SizedBox(width: 8),
          _filterChip(label: LocalizationService().getString('FILTER_STATUS_LABEL', l10n.filterStatusLabel), value: statusValue),
          const SizedBox(width: 8),
          _filterChip(label: LocalizationService().getString('FILTER_VENDOR_LABEL', l10n.filterVendorLabel), value: vendorValue),
        ],
      ),
    );
  }

  Widget _filterChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _triggerFilter() {
    String? fromDate;
    String? toDate;

    if (_fromCtrl.text.isNotEmpty) {
      fromDate = _formatToYyyyMmDd(_fromCtrl.text);
    }
    if (_toCtrl.text.isNotEmpty) {
      toDate = _formatToYyyyMmDd(_toCtrl.text);
    }

    if (fromDate == null && toDate == null && _selectedPeriod != 'All time') {
      final now = DateTime.now();
      final yyyymmdd = (DateTime dt) => "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
      
      if (_selectedPeriod == 'Today') {
        fromDate = yyyymmdd(now);
        toDate = yyyymmdd(now);
      } else if (_selectedPeriod == 'Last 7 days') {
        fromDate = yyyymmdd(now.subtract(const Duration(days: 7)));
        toDate = yyyymmdd(now);
      } else if (_selectedPeriod == 'Last 30 days') {
        fromDate = yyyymmdd(now.subtract(const Duration(days: 30)));
        toDate = yyyymmdd(now);
      } else if (_selectedPeriod == 'Last 90 days') {
        fromDate = yyyymmdd(now.subtract(const Duration(days: 90)));
        toDate = yyyymmdd(now);
      } else if (_selectedPeriod == 'This month') {
        fromDate = yyyymmdd(DateTime(now.year, now.month, 1));
        toDate = yyyymmdd(DateTime(now.year, now.month + 1, 0));
      } else if (_selectedPeriod == 'This year') {
        fromDate = yyyymmdd(DateTime(now.year, 1, 1));
        toDate = yyyymmdd(DateTime(now.year, 12, 31));
      }
    }

    context.read<AccountBloc>().add(LoadDashboard(
      status: _selectedStatus,
      from: fromDate,
      to: toDate,
      vendor: _selectedVendor,
    ));
  }

  String _formatToYyyyMmDd(String input) {
    if (input.isEmpty) return '';
    if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(input)) {
      return input;
    }
    final parts = input.split('/');
    if (parts.length == 3) {
      final day = parts[0];
      final month = parts[1];
      final year = parts[2];
      return '$year-$month-$day';
    }
    return input;
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
          _triggerFilter();
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
  final bool isFirst;
  final bool isLast;

  const _OrderCardItem({
    super.key,
    required this.tx,
    required this.isArabic,
    this.isFirst = false,
    this.isLast = false,
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
                        LocalizationService().getString(
                          'COUPON_QR_CODE_TITLE',
                          AppLocalizations.of(context)!.couponQrCodeTitle,
                        ),
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
                  LocalizationService().getString(
                    'COUPON_QR_CODE_SUBTITLE',
                    AppLocalizations.of(context)!.qrCodeSubtitle,
                  ),
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
                LocalizationService().getString(
                  'COUPON_CODE_LABEL',
                  AppLocalizations.of(context)!.couponCodeQr,
                ),
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

  Widget _buildStatusWidget(String status, bool isArabic, AppLocalizations l10n) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String text;

    final lowerStatus = status.toLowerCase();
    if (lowerStatus.contains('awaiting') || lowerStatus.contains('pending')) {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.access_time;
      text = LocalizationService().getString('STATUS_AWAITING_REDEMPTION', l10n.awaitingRedemption);
    } else if (lowerStatus.contains('expired')) {
      bgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFFEF4444);
      icon = Icons.error_outline;
      text = LocalizationService().getString('COUPON_EXPIRED', l10n.filterStatusExpired);
    } else if (lowerStatus.contains('redeemed') || lowerStatus.contains('used')) {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF15803D);
      icon = Icons.check_circle_outline;
      text = LocalizationService().getString('STATUS_REDEEMED', l10n.redeemedLabel);
    } else {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.access_time;
      text = LocalizationService().getString('STATUS_AWAITING_REDEMPTION', l10n.awaitingRedemption);
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
    final l10n = AppLocalizations.of(context)!;
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
      timeLeft = LocalizationService().getString(
        'COUPON_DAYS_LEFT',
        l10n.daysLeftShort(daysUntil),
      ).replaceAll('{count}', daysUntil.toString()).replaceAll('{days}', daysUntil.toString());
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
          timeLeft = LocalizationService().getString(
            'COUPON_DAYS_LEFT',
            l10n.daysLeftShort(days),
          ).replaceAll('{count}', days.toString()).replaceAll('{days}', days.toString());
        }
      }
    } catch (_) {}

    if (timeLeft.isEmpty) {
      timeLeft = LocalizationService().getString(
        'COUPON_DAYS_LEFT',
        l10n.daysLeftShort(118),
      ).replaceAll('{count}', '118').replaceAll('{days}', '118');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          LocalizationService().getString('COUPON_VENDOR_LABEL', l10n.vendorLabel),
          Text(vendor, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_OFFER_LABEL', l10n.offerLabel),
          Text(offerName, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_CODE_LABEL', l10n.codeLabel),
          Text(couponCode, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_URL_LABEL', l10n.couponUrlLabel),
          GestureDetector(
            onTap: () => _copyToClipboard(
              couponUrl,
              LocalizationService().getString('COUPON_SHARE_COPIED', l10n.couponCopiedClipboard),
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
          LocalizationService().getString('COUPON_DETAILS_PRICE', l10n.priceLabel),
          Text(coupon.price.isNotEmpty ? coupon.price : 'QAR 20', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_STATUS_LABEL', l10n.statusLabel),
          _buildStatusWidget(status, isArabic, l10n),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_REDEEM_BY_LABEL', l10n.redeemByLabel),
          Text(redeemByFormatted, style: const TextStyle(color: Color(0xFF0F172A))),
        ),
        _buildDetailRow(
          LocalizationService().getString('COUPON_TIME_LEFT_LABEL', l10n.timeLeftLabel),
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
          LocalizationService().getString('COUPON_QR_CODE_LABEL', l10n.qrCodeLabel),
          GestureDetector(
            onTap: () => _showQrCodeDialog(context, couponCode, redeemByFormatted),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.qr_code_2, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  LocalizationService().getString('COUPON_SHOW_QR_CODE', l10n.showQrCode),
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

  IconData _getIcon(DashboardTransaction tx) {
    final type = tx.type.toLowerCase();
    final title = tx.title.toLowerCase();
    final vendor = tx.vendor.toLowerCase();

    if (type.contains('redeemed') || type.contains('credit') || tx.price.startsWith('+') || title.contains('redeem') || title.contains('coupon')) {
      return Icons.card_giftcard;
    }
    if (type.contains('coffee') || type.contains('cafe') || title.contains('coffee') || title.contains('cafe') || title.contains('starbucks') || vendor.contains('coffee') || vendor.contains('cafe')) {
      return Icons.local_cafe_outlined;
    }
    return Icons.shopping_bag_outlined;
  }

  Color _getIconColor(DashboardTransaction tx) {
    final type = tx.type.toLowerCase();
    final title = tx.title.toLowerCase();
    final vendor = tx.vendor.toLowerCase();

    if (type.contains('redeemed') || type.contains('credit') || tx.price.startsWith('+') || title.contains('redeem') || title.contains('coupon')) {
      return const Color(0xFF22C55E); // Green
    }
    if (type.contains('coffee') || type.contains('cafe') || title.contains('coffee') || title.contains('cafe') || title.contains('starbucks') || vendor.contains('coffee') || vendor.contains('cafe')) {
      return const Color(0xFF2563EB); // Blue
    }
    return const Color(0xFFFF6B35); // Orange
  }

  Color _getBgColor(DashboardTransaction tx) {
    final type = tx.type.toLowerCase();
    final title = tx.title.toLowerCase();
    final vendor = tx.vendor.toLowerCase();

    if (type.contains('redeemed') || type.contains('credit') || tx.price.startsWith('+') || title.contains('redeem') || title.contains('coupon')) {
      return const Color(0xFFE8F8EE); // Light green
    }
    if (type.contains('coffee') || type.contains('cafe') || title.contains('coffee') || title.contains('cafe') || title.contains('starbucks') || vendor.contains('coffee') || vendor.contains('cafe')) {
      return const Color(0xFFEFF6FF); // Light blue
    }
    return const Color(0xFFFFEFEA); // Light orange
  }

  String _getDisplayTitle(DashboardTransaction tx) {
    if (tx.title.isNotEmpty) return tx.title;
    if (tx.vendor.isNotEmpty) return tx.vendor;

    final type = tx.type.toLowerCase();
    if (type.contains('redeemed') || type.contains('credit') || tx.price.startsWith('+')) {
      return 'Coupon Redeemed';
    }
    if (type.contains('coffee') || type.contains('cafe')) {
      return 'Coffee Shop';
    }
    return 'Grocery Store';
  }

  String _getFormattedDate(String dateStr, bool isArabic) {
    if (dateStr.isEmpty) return 'Jul 15, 2025';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy', isArabic ? 'ar' : 'en').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  String _getFormattedPrice(DashboardTransaction tx) {
    String p = tx.price;
    if (p.isEmpty) return '-QAR 0';

    p = p.replaceAll(' ', '');
    final isCredit = p.startsWith('+') || tx.type.toLowerCase().contains('redeemed') || tx.type.toLowerCase().contains('credit');

    String numericPart = p.replaceAll('+', '').replaceAll('-', '').replaceAll('QAR', '');
    final numVal = double.tryParse(numericPart);
    if (numVal != null && numVal % 1 == 0) {
      numericPart = numVal.toInt().toString();
    }
    return '${isCredit ? '+' : '-'}QAR $numericPart';
  }

  Color _getPriceColor(DashboardTransaction tx) {
    final p = tx.price;
    final isCredit = p.startsWith('+') || tx.type.toLowerCase().contains('redeemed') || tx.type.toLowerCase().contains('credit');
    return isCredit ? const Color(0xFF22C55E) : const Color(0xFF0F172A);
  }

  @override
  Widget build(BuildContext context) {
    final tx = widget.tx;
    final isArabic = widget.isArabic;

    final borderRadius = BorderRadius.only(
      topLeft: widget.isFirst ? const Radius.circular(24) : Radius.zero,
      topRight: widget.isFirst ? const Radius.circular(24) : Radius.zero,
      bottomLeft: widget.isLast && !_isExpanded ? const Radius.circular(24) : Radius.zero,
      bottomRight: widget.isLast && !_isExpanded ? const Radius.circular(24) : Radius.zero,
    );

    return Column(
      children: [
        // Order main row styled exactly like the screenshot
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Category-specific circular icon container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getBgColor(tx),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getIcon(tx),
                      color: _getIconColor(tx),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Title and Date Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayTitle(tx),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getFormattedDate(tx.date, isArabic),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Formatted price with proper green/black coloring and sign (+/-)
                Text(
                  _getFormattedPrice(tx),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: _getPriceColor(tx),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Expanded detail section (retains expandable coupon metadata visual layout)
        if (_isExpanded) ...[
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: widget.isLast
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    )
                  : null,
            ),
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
    );
  }
}
