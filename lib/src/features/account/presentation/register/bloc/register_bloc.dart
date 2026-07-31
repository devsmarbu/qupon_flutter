import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final name = event.name.trim();
    final email = event.email.trim();
    final phone = event.phone.trim();
    final password = event.password.trim();
    final confirmPassword = event.confirmPassword.trim();

    if (name.isEmpty) {
      emit(RegisterFailure(error: 'Full name cannot be empty'));
      return;
    }

    if (email.isEmpty) {
      emit(RegisterFailure(error: 'Email cannot be empty'));
      return;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emit(RegisterFailure(error: 'Please enter a valid email address'));
      return;
    }

    if (phone.isEmpty) {
      emit(RegisterFailure(error: 'Phone number cannot be empty'));
      return;
    }

    if (password.isEmpty) {
      emit(RegisterFailure(error: 'Password cannot be empty'));
      return;
    }

    if (password.length < 6) {
      emit(RegisterFailure(error: 'Password must be at least 6 characters'));
      return;
    }

    if (password != confirmPassword) {
      emit(RegisterFailure(error: 'Passwords do not match'));
      return;
    }

    // Format and validate phone number
    final sanitizedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    String formattedPhone = sanitizedPhone;
    if (!sanitizedPhone.startsWith('+')) {
      if (sanitizedPhone.length == 8) {
        formattedPhone = '+974$sanitizedPhone';
      } else {
        emit(RegisterFailure(error: 'Please enter a valid 8-digit mobile number'));
        return;
      }
    } else {
      if (sanitizedPhone.length < 11) {
        emit(RegisterFailure(error: 'Please enter a valid mobile number with country code'));
        return;
      }
    }

    emit(const RegisterLoading());

    try {
      await _authRepository.register(
        email: email,
        password: password,
        name: name,
        phoneNumber: formattedPhone,
        role: AppConstants.roleUser,
      );
      emit(RegisterSuccess(email: email, phoneNumber: formattedPhone));
    } catch (e) {
      emit(RegisterFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
