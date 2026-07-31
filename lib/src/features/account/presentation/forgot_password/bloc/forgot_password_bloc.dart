import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
    on<ForgotPasswordReset>(_onForgotPasswordReset);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final phone = event.phone.trim();

    if (phone.isEmpty) {
      emit(ForgotPasswordFailure(error: 'Phone number cannot be empty'));
      return;
    }

    final sanitizedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    String formattedPhone = sanitizedPhone;
    if (!sanitizedPhone.startsWith('+')) {
      if (sanitizedPhone.length == 8) {
        formattedPhone = '+974$sanitizedPhone';
      } else {
        emit(ForgotPasswordFailure(error: 'Please enter a valid 8-digit mobile number'));
        return;
      }
    } else {
      if (sanitizedPhone.length < 11) {
        emit(ForgotPasswordFailure(error: 'Please enter a valid mobile number with country code'));
        return;
      }
    }

    emit(const ForgotPasswordLoading());

    try {
      await _authRepository.forgotPassword(
        phoneNumber: formattedPhone,
        role: AppConstants.roleUser,
      );
      emit(ForgotPasswordSuccess(phone: phone));
    } catch (e) {
      emit(ForgotPasswordFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void _onForgotPasswordReset(
    ForgotPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordInitial());
  }
}
