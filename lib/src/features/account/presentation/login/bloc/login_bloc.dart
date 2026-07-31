import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../data/repositories/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty) {
      emit(LoginFailure(error: 'Email cannot be empty'));
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emit(LoginFailure(error: 'Please enter a valid email address'));
      return;
    }

    if (password.isEmpty) {
      emit(LoginFailure(error: 'Password cannot be empty'));
      return;
    }

    if (password.length < 6) {
      emit(LoginFailure(error: 'Password must be at least 6 characters'));
      return;
    }

    emit(const LoginLoading());

    try {
      await _authRepository.login(
        email: email,
        password: password,
        role: AppConstants.roleUser,
      );
      emit(LoginSuccess(email: email));
    } catch (e) {
      emit(LoginFailure(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
