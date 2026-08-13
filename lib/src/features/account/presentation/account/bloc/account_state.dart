import '../../../data/models/dashboard_model.dart';
import '../../../../home/data/models/home_coupon.dart';

abstract class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountAuthenticated extends AccountState {
  final String email;
  final String name;
  final String role;
  final DashboardData? dashboardData;
  final List<HomeCoupon> wishlist;
  final bool isLoadingDashboard;
  final String? error;
  final List<DashboardTransaction>? filteredTransactions;

  const AccountAuthenticated({
    required this.email,
    this.name = '',
    this.role = '',
    this.dashboardData,
    this.wishlist = const [],
    this.isLoadingDashboard = false,
    this.error,
    this.filteredTransactions,
  });

  AccountAuthenticated copyWith({
    String? email,
    String? name,
    String? role,
    DashboardData? dashboardData,
    List<HomeCoupon>? wishlist,
    bool? isLoadingDashboard,
    String? error,
    List<DashboardTransaction>? filteredTransactions,
    bool clearFilteredTransactions = false,
  }) {
    return AccountAuthenticated(
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      dashboardData: dashboardData ?? this.dashboardData,
      wishlist: wishlist ?? this.wishlist,
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
      error: error ?? this.error,
      filteredTransactions: clearFilteredTransactions ? null : (filteredTransactions ?? this.filteredTransactions),
    );
  }
}

class AccountUnauthenticated extends AccountState {
  const AccountUnauthenticated();
}

class AccountError extends AccountState {
  final String message;

  const AccountError({required this.message});
}
