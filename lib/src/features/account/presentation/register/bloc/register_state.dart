abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final String email;
  final String phoneNumber;

  const RegisterSuccess({required this.email, required this.phoneNumber});
}

class RegisterFailure extends RegisterState {
  final String error;

  const RegisterFailure({required this.error});
}
