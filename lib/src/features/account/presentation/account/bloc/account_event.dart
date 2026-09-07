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

class DeleteAccountRequested extends AccountEvent {
  final String? reason;
  final bool logoutAfterRequest;

  const DeleteAccountRequested({
    this.reason,
    this.logoutAfterRequest = false,
  });
}

class CancelDeleteAccountRequested extends AccountEvent {
  const CancelDeleteAccountRequested();
}

class CheckDeletionStatusRequested extends AccountEvent {
  const CheckDeletionStatusRequested();
}


