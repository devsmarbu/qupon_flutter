import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final AuthRepository _authRepository;
  final String email;

  OtpBloc({
    required AuthRepository authRepository,
    required this.email,
  })  : _authRepository = authRepository,
        super(const OtpInitial()) {
    on<OtpSubmitted>(_onOtpSubmitted);
    on<OtpResendRequested>(_onOtpResendRequested);
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<OtpState> emit,
  ) async {
    final otp = event.otp.trim();

    if (otp.isEmpty) {
      emit(OtpFailure(error: 'OTP code cannot be empty'));
      return;
    }

    if (otp.length != 6) {
      emit(OtpFailure(error: 'OTP code must be exactly 6 digits'));
      return;
    }

    emit(const OtpLoading());

    try {
      await _authRepository.verifyOtp(
        email: email,
        otp: otp,
        role: AppConstants.roleUser,
      );
      emit(const OtpSuccess());
    } catch (e) {
      emit(OtpFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onOtpResendRequested(
    OtpResendRequested event,
    Emitter<OtpState> emit,
  ) async {
    emit(const OtpLoading());

    try {
      await _authRepository.resendOtp(
        email: email,
        role: AppConstants.roleUser,
      );
      emit(const OtpResendSuccess());
    } catch (e) {
      emit(OtpResendFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
