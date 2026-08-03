import '../../../data/models/dashboard_model.dart';

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
  final bool isLoadingDashboard;
  final String? error;

  const AccountAuthenticated({
    required this.email,
    this.name = '',
    this.role = '',
    this.dashboardData,
    this.isLoadingDashboard = false,
    this.error,
  });

  AccountAuthenticated copyWith({
    String? email,
    String? name,
    String? role,
    DashboardData? dashboardData,
    bool? isLoadingDashboard,
    String? error,
  }) {
    return AccountAuthenticated(
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      dashboardData: dashboardData ?? this.dashboardData,
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
      error: error ?? this.error,
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
