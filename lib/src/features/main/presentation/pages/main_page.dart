import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../localization/presentation/cubit/locale_cubit.dart';
import '../../../localization/data/services/localization_service.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../account/presentation/account/view/account_page.dart';
import '../../../account/presentation/welcome/view/welcome_page.dart';
import '../../../account/presentation/account/bloc/account_bloc.dart';
import '../../../account/presentation/account/bloc/account_event.dart';
import '../../../account/presentation/account/bloc/account_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../past_deals/presentation/pages/past_deals_page.dart';
import 'categories_page.dart';

import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../../../l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // Track the currently active page index
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showCheckoutSuccess(BuildContext context) {
    _showCheckoutSuccessDialog(context);
  }

  void _showCheckoutSuccessDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF15803D),
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.checkoutSuccessTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.checkoutSuccessMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(const ClearCart());
                  Navigator.of(dialogCtx).pop();
                  setSelectedIndex(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  l10n.goBackHome,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.watch<LocaleCubit>();
    final isArabic = localeCubit.state.languageCode == 'ar';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF2EC), // Peach tint
            Colors.white,
          ],
          stops: [0.0, 0.40],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: false,
          titleSpacing: 16,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text(
                'Qupon',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 24,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'كوبون',
                style: TextStyle(
                  color: AppColors.primary.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<LocaleCubit>().toggleLocale();
              },
              child: Text(
                localeCubit.state.languageCode == 'en'
                    ? 'عربي'
                    : 'English',
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF0F172A)),
              onPressed: () {
                context.read<CartBloc>().add(const LoadCart());
                setSelectedIndex(3);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Color(0xFF0F172A)),
              onPressed: () async {
                final accountState = context.read<AccountBloc>().state;
                if (accountState is! AccountAuthenticated) {
                  final loggedIn = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(builder: (context) => const WelcomePage()),
                  );
                  if (loggedIn == true) {
                    context.read<AccountBloc>().add(const LoadDashboard());
                    setSelectedIndex(4);
                  }
                  return;
                }
                context.read<AccountBloc>().add(const LoadDashboard());
                setSelectedIndex(4);
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _buildBody(_selectedIndex),
        bottomNavigationBar: Material(
          color: Colors.transparent,
          elevation: 0,
          child: _buildBottomNavigationBar(context, isArabic),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, bool isArabic) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 8
            : 16,
        top: 8,
      ),
      child:
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: LocalizationService().getString('NAV_HOME', l10n.drawerHome),
              ),
              _buildTabItem(
                context: context,
                index: 1,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: LocalizationService().getString('NAV_CATEGORIES', l10n.navCategories),
              ),
              _buildTabItem(
                context: context,
                index: 2,
                icon: Icons.local_offer_outlined,
                activeIcon: Icons.local_offer,
                label: LocalizationService().getString('NAV_PAST_DEALS', l10n.pastDealsTitle),
              ),
              _buildTabItem(
                context: context,
                index: 3,
                icon: Icons.shopping_cart_outlined,
                activeIcon: Icons.shopping_cart,
                label: LocalizationService().getString('COUPON_DETAILS_CART', l10n.drawerCart),
                badgeCount: context.watch<CartBloc>().state.totalQuantity,
              ),
              _buildTabItem(
                context: context,
                index: 4,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: LocalizationService().getString('FOOTER_MY_ACCOUNT', l10n.navAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFFFF6B35) : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () async {
        if (index == 4) { // Account
          final accountState = context.read<AccountBloc>().state;
          if (accountState is! AccountAuthenticated) {
            final loggedIn = await Navigator.of(context).push<bool>(
              MaterialPageRoute(builder: (context) => const WelcomePage()),
            );
            if (loggedIn == true) {
              context.read<AccountBloc>().add(const LoadDashboard());
              setState(() {
                _selectedIndex = 4;
              });
            }
            return;
          } else {
            context.read<AccountBloc>().add(const LoadDashboard());
          }
        }
        if (index == 3) {
          context.read<CartBloc>().add(const LoadCart());
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF2EC) : const Color(0x00FFF2EC),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            badgeCount > 0
                ? Badge(
                    backgroundColor: const Color(0xFFFF6B35),
                    label: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Icon(
                      isSelected ? activeIcon : icon,
                      color: color,
                      size: 24,
                    ),
                  )
                : Icon(
                    isSelected ? activeIcon : icon,
                    color: color,
                    size: 24,
                  ),
            // const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return CategoriesPage(
          onNavigateHome: () => setState(() => _selectedIndex = 0),
        );
      case 2:
        return PastDealsPage(
          onNavigateHome: () => setState(() => _selectedIndex = 0),
        );
      case 3:
        return CartPage(
          onNavigateHome: () => setState(() => _selectedIndex = 0),
        );
      case 4:
        return AccountPage(
          onNavigateHome: () => setState(() => _selectedIndex = 0),
        );
      default:
        return const HomePage();
    }
  }
}


