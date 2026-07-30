abstract class OtpState {
  const OtpState();
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpSuccess extends OtpState {
  const OtpSuccess();
}

class OtpFailure extends OtpState {
  final String error;

  const OtpFailure({required this.error});
}

class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}

class OtpResendFailure extends OtpState {
  final String error;

  const OtpResendFailure({required this.error});
}
