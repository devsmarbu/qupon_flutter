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
