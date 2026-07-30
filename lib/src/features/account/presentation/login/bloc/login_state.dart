abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String email;

  const LoginSuccess({required this.email});
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});
}
