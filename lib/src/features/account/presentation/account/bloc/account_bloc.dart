import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/preferences/pref_store.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/profile_data.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthRepository _authRepository;

  AccountBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AccountInitial()) {
    on<AccountLoggedIn>(_onAccountLoggedIn);
    on<SignOutRequested>(_onSignOutRequested);
    on<AppStarted>(_onAppStarted);
    on<LoadDashboard>(_onLoadDashboard);

    add(const AppStarted());
  }

  Future<void> _onAccountLoggedIn(
    AccountLoggedIn event,
    Emitter<AccountState> emit,
  ) async {
    // Persist profile to SharedPreferences as a fallback
    final currentProfile = await PrefStore.getProfile();
    await PrefStore.saveProfile(
      ProfileData(
        id: currentProfile?.id ?? '',
        role: event.role.isNotEmpty ? event.role : (currentProfile?.role ?? ''),
        email: event.email.isNotEmpty ? event.email : (currentProfile?.email ?? ''),
        name: event.name.isNotEmpty ? event.name : (currentProfile?.name ?? ''),
      ),
    );

    emit(AccountAuthenticated(
      email: event.email,
      name: event.name,
      role: event.role,
    ));
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AccountState> emit,
  ) async {
    await PrefStore().remove(AppStrings.keyToken);
    await PrefStore.clearProfile();
    emit(const AccountUnauthenticated());
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AccountState> emit,
  ) async {
    final token = PrefStore().loadString(AppStrings.keyToken);
    final profile = await PrefStore.getProfile();
    if (token != null && token.isNotEmpty) {
      emit(AccountAuthenticated(
        email: profile?.email ?? '',
        name: profile?.name ?? '',
        role: profile?.role ?? '',
      ));
    } else {
      emit(const AccountUnauthenticated());
    }
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AccountAuthenticated) return;

    emit(currentState.copyWith(
      isLoadingDashboard: true,
      error: null,
    ));

    try {
      final token = PrefStore().loadString(AppStrings.keyToken);
      if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }
      final data = await _authRepository.getDashboard(token: token);
      emit(currentState.copyWith(
        isLoadingDashboard: false,
        dashboardData: data,
        error: null,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isLoadingDashboard: false,
        error: e.toString(),
      ));
    }
  }
}
