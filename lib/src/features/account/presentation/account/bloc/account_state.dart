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

  const AccountAuthenticated({
    required this.email,
    this.name = '',
    this.role = '',
  });
}

class AccountUnauthenticated extends AccountState {
  const AccountUnauthenticated();
}

class AccountError extends AccountState {
  final String message;

  const AccountError({required this.message});
}
