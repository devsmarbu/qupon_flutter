abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String phone;

  const ForgotPasswordSubmitted({required this.phone});
}

class ForgotPasswordReset extends ForgotPasswordEvent {
  const ForgotPasswordReset();
}
