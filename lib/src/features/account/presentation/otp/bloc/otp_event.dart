abstract class OtpEvent {
  const OtpEvent();
}

class OtpSubmitted extends OtpEvent {
  final String otp;

  const OtpSubmitted({required this.otp});
}

class OtpResendRequested extends OtpEvent {
  const OtpResendRequested();
}
