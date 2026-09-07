import '../../../data/models/dashboard_model.dart';
import '../../../data/models/account_deletion_status.dart';
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
  final bool isDeletingAccount;
  final bool isCancellingDeletion;
  final AccountDeletionStatus? deletionStatus;
  final String? actionMessage;
  final String? error;
  final List<DashboardTransaction>? filteredTransactions;

  const AccountAuthenticated({
    required this.email,
    this.name = '',
    this.role = '',
    this.dashboardData,
    this.wishlist = const [],
    this.isLoadingDashboard = false,
    this.isDeletingAccount = false,
    this.isCancellingDeletion = false,
    this.deletionStatus,
    this.actionMessage,
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
    bool? isDeletingAccount,
    bool? isCancellingDeletion,
    AccountDeletionStatus? deletionStatus,
    String? actionMessage,
    String? error,
    List<DashboardTransaction>? filteredTransactions,
    bool clearFilteredTransactions = false,
    bool clearActionMessage = false,
  }) {
    return AccountAuthenticated(
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      dashboardData: dashboardData ?? this.dashboardData,
      wishlist: wishlist ?? this.wishlist,
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      isCancellingDeletion: isCancellingDeletion ?? this.isCancellingDeletion,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
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
