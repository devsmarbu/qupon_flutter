abstract class AccountEvent {
  const AccountEvent();
}

class AccountLoggedIn extends AccountEvent {
  final String email;
  final String name;
  final String role;

  const AccountLoggedIn({
    required this.email,
    this.name = '',
    this.role = '',
  });
}

class SignOutRequested extends AccountEvent {
  const SignOutRequested();
}

class AppStarted extends AccountEvent {
  const AppStarted();
}

class LoadDashboard extends AccountEvent {
  final String? status;
  final String? from;
  final String? to;
  final String? vendor;

  const LoadDashboard({
    this.status,
    this.from,
    this.to,
    this.vendor,
  });
}
