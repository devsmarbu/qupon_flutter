import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import '../../login/view/login_page.dart';
import 'package:qupon/src/core/constants/app_colors.dart';
import 'package:qupon/l10n/app_localizations.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
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
                                l10n.dashboardSubtitle(3, 12, _selectedPeriod == 'All time' ? l10n.periodAllTime : _selectedPeriod),
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
                          onTap: () => _showFilterBottomSheet(context),
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
                          const Text(
                            'QAR 1,250',
                            style: TextStyle(
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
                            value: '12',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            title: l10n.totalSaved,
                            icon: Icons.stars_outlined,
                            iconColor: const Color(0xFF16A34A),
                            bgColor: AppColors.iconBgGreen,
                            value: 'QAR 340',
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
                            value: '5',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _statCard(
                            title: l10n.wallet,
                            icon: Icons.account_balance_wallet_outlined,
                            iconColor: const Color(0xFF9333EA),
                            bgColor: AppColors.iconBgPurple,
                            value: 'QAR 500',
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
                    _buildOrderItem(
                      title: l10n.groceryStore,
                      date: 'Jul 15, 2025',
                      price: '-QAR 85',
                      icon: Icons.shopping_bag_outlined,
                      iconColor: const Color(0xFFEA580C),
                      bgColor: AppColors.iconBgLightOrange,
                    ),
                    _buildOrderItem(
                      title: l10n.couponRedeemed,
                      date: 'Jul 14, 2025',
                      price: '+QAR 25',
                      priceColor: AppColors.textPositive,
                      icon: Icons.card_giftcard_outlined,
                      iconColor: const Color(0xFF16A34A),
                      bgColor: AppColors.iconBgGreen,
                    ),
                    _buildOrderItem(
                      title: l10n.coffeeShop,
                      date: 'Jul 13, 2025',
                      price: '-QAR 18',
                      icon: Icons.local_cafe_outlined,
                      iconColor: const Color(0xFF0284C7),
                      bgColor: AppColors.iconBgBlue,
                    ),
                  ],
                ),
              ),
           //   const AppFooter(),
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

  Widget _buildOrderItem({
    required String title,
    required String date,
    required String price,
    Color? priceColor,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: priceColor ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
  final Function(String period, String status, String vendor, String from, String to) onApply;

  const _FilterBottomSheetContent({
    required this.selectedPeriod,
    required this.selectedStatus,
    required this.selectedVendor,
    required this.initialFrom,
    required this.initialTo,
    required this.periods,
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
