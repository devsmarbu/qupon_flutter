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
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<CancelDeleteAccountRequested>(_onCancelDeleteAccountRequested);
    on<CheckDeletionStatusRequested>(_onCheckDeletionStatusRequested);
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
    add(const LoadDashboard());
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AccountState> emit,
  ) async {
    await PrefStore().remove(AppStrings.keyToken);
    await PrefStore.clearProfile();
    emit(const AccountUnauthenticated());
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AccountAuthenticated) return;

    emit(currentState.copyWith(
      isDeletingAccount: true,
      error: null,
      clearActionMessage: true,
    ));

    try {
      final msg = await _authRepository.requestAccountDeletion(reason: event.reason);

      if (event.logoutAfterRequest) {
        await PrefStore().remove(AppStrings.keyToken);
        await PrefStore.clearProfile();
        emit(const AccountUnauthenticated());
        return;
      }

      final status = await _authRepository.getAccountDeletionStatus();
      emit(currentState.copyWith(
        isDeletingAccount: false,
        deletionStatus: status.deletionRequested
            ? status
            : status.copyWith(deletionRequested: true, deletionReason: event.reason),
        actionMessage: msg,
        error: null,
      ));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(currentState.copyWith(
        isDeletingAccount: false,
        error: errorMessage,
      ));
    }
  }

  Future<void> _onCancelDeleteAccountRequested(
    CancelDeleteAccountRequested event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AccountAuthenticated) return;

    emit(currentState.copyWith(
      isCancellingDeletion: true,
      error: null,
      clearActionMessage: true,
    ));

    try {
      final msg = await _authRepository.cancelAccountDeletion();
      final status = await _authRepository.getAccountDeletionStatus();

      emit(currentState.copyWith(
        isCancellingDeletion: false,
        deletionStatus: status,
        actionMessage: msg,
        error: null,
      ));
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(currentState.copyWith(
        isCancellingDeletion: false,
        error: errorMessage,
      ));
    }
  }

  Future<void> _onCheckDeletionStatusRequested(
    CheckDeletionStatusRequested event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AccountAuthenticated) return;

    try {
      final status = await _authRepository.getAccountDeletionStatus();
      emit(currentState.copyWith(
        deletionStatus: status,
      ));
    } catch (_) {}
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
      add(const LoadDashboard());
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

      final hasStatus = event.status != null && event.status != 'all' && event.status!.isNotEmpty;
      final hasVendor = event.vendor != null && event.vendor != 'all' && event.vendor!.isNotEmpty;
      final hasFrom = event.from != null && event.from!.isNotEmpty;
      final hasTo = event.to != null && event.to!.isNotEmpty;
      final hasFilters = hasStatus || hasVendor || hasFrom || hasTo;

      if (hasFilters) {
        final filtered = await _authRepository.getFilteredOrders(
          token: token,
          status: event.status,
          from: event.from,
          to: event.to,
          vendor: event.vendor,
        );

        emit(currentState.copyWith(
          isLoadingDashboard: false,
          filteredTransactions: filtered,
          error: null,
        ));
      } else {
        final data = await _authRepository.getDashboard(token: token);
        final wishlist = await _authRepository.getWishlist(token: token);
        final deletionStatus = await _authRepository.getAccountDeletionStatus();
        emit(currentState.copyWith(
          isLoadingDashboard: false,
          dashboardData: data,
          wishlist: wishlist,
          deletionStatus: deletionStatus,
          clearFilteredTransactions: true,
          error: null,
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(
        isLoadingDashboard: false,
        error: e.toString(),
      ));
    }
  }
}
