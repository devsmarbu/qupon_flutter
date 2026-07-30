import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/preferences/pref_store.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/profile_data.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc({required AuthRepository authRepository})
      : super(const AccountInitial()) {
    on<AccountLoggedIn>(_onAccountLoggedIn);
    on<SignOutRequested>(_onSignOutRequested);
    on<AppStarted>(_onAppStarted);

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
}
