import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qupon/src/core/preferences/pref_store.dart';
import 'package:qupon/src/core/constants/app_strings.dart';
import 'package:qupon/src/features/account/data/models/profile_data.dart';
import 'package:qupon/src/features/account/data/repositories/auth_repository.dart';
import 'package:qupon/src/features/account/data/models/dashboard_model.dart';
import 'package:qupon/src/features/home/data/models/home_coupon.dart';
import 'package:qupon/src/features/account/presentation/account/bloc/account_bloc.dart';
import 'package:qupon/src/features/account/presentation/account/bloc/account_event.dart';
import 'package:qupon/src/features/account/presentation/account/bloc/account_state.dart';
import 'package:qupon/src/features/account/presentation/login/bloc/login_bloc.dart';
import 'package:qupon/src/features/account/presentation/login/bloc/login_event.dart';
import 'package:qupon/src/features/account/presentation/login/bloc/login_state.dart';
import 'package:qupon/src/features/account/presentation/register/bloc/register_bloc.dart';
import 'package:qupon/src/features/account/presentation/register/bloc/register_event.dart';
import 'package:qupon/src/features/account/presentation/register/bloc/register_state.dart';
import 'package:qupon/src/features/account/presentation/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:qupon/src/features/account/presentation/forgot_password/bloc/forgot_password_event.dart';
import 'package:qupon/src/features/account/presentation/forgot_password/bloc/forgot_password_state.dart';
import 'package:qupon/src/features/account/presentation/otp/bloc/otp_bloc.dart';
import 'package:qupon/src/features/account/presentation/otp/bloc/otp_event.dart';
import 'package:qupon/src/features/account/presentation/otp/bloc/otp_state.dart';

class FakeAuthRepository implements AuthRepository {
  bool registerCalled = false;
  bool loginCalled = false;
  bool verifyOtpCalled = false;
  bool resendOtpCalled = false;
  bool forgotPasswordCalled = false;

  String? lastEmail;
  String? lastPassword;
  String? lastName;
  String? lastPhoneNumber;
  String? lastRole;
  String? lastOtp;

  bool throwError = false;
  String errorMessage = 'Test error';

  void reset() {
    registerCalled = false;
    loginCalled = false;
    verifyOtpCalled = false;
    resendOtpCalled = false;
    forgotPasswordCalled = false;
    lastEmail = null;
    lastPassword = null;
    lastName = null;
    lastPhoneNumber = null;
    lastRole = null;
    lastOtp = null;
    throwError = false;
    errorMessage = 'Test error';
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required String role,
    String recaptchaToken = '',
  }) async {
    registerCalled = true;
    lastEmail = email;
    lastPassword = password;
    lastName = name;
    lastPhoneNumber = phoneNumber;
    lastRole = role;
    if (throwError) throw Exception(errorMessage);
  }

  @override
  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    loginCalled = true;
    lastEmail = email;
    lastPassword = password;
    lastRole = role;
    if (throwError) throw Exception(errorMessage);
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String otp,
    required String role,
  }) async {
    verifyOtpCalled = true;
    lastEmail = email;
    lastOtp = otp;
    lastRole = role;
    if (throwError) throw Exception(errorMessage);
  }

  @override
  Future<void> resendOtp({
    required String email,
    required String role,
    String recaptchaToken = '',
  }) async {
    resendOtpCalled = true;
    lastEmail = email;
    lastRole = role;
    if (throwError) throw Exception(errorMessage);
  }

  @override
  Future<void> forgotPassword({
    required String phoneNumber,
    required String role,
  }) async {
    forgotPasswordCalled = true;
    lastPhoneNumber = phoneNumber;
    lastRole = role;
    if (throwError) throw Exception(errorMessage);
  }

  @override
  Future<DashboardData> getDashboard({required String token}) async {
    if (throwError) throw Exception(errorMessage);
    return DashboardData(
      totalSpent: 1250,
      couponsUsed: 12,
      totalSaved: 340,
      activeCoupons: 5,
      wallet: 500,
      transactions: [],
    );
  }

  @override
  Future<List<HomeCoupon>> getWishlist({required String token}) async {
    if (throwError) throw Exception(errorMessage);
    return [];
  }

  bool getFilteredOrdersCalled = false;
  String? lastStatus;
  String? lastFrom;
  String? lastTo;
  String? lastVendor;

  @override
  Future<List<DashboardTransaction>> getFilteredOrders({
    required String token,
    String? status,
    String? from,
    String? to,
    String? vendor,
  }) async {
    getFilteredOrdersCalled = true;
    lastStatus = status;
    lastFrom = from;
    lastTo = to;
    lastVendor = vendor;
    if (throwError) throw Exception(errorMessage);
    return [
      DashboardTransaction(
        id: '123',
        orderDisplayRef: 'REF123',
        title: 'Filtered Order',
        date: '2026-08-14',
        price: 'QAR 100',
        type: 'other',
        couponsCount: 1,
        vendor: vendor ?? 'ElectroWorld',
        offer: 'Offer 1',
        code: 'CODE1',
        couponUrl: '',
        status: status ?? 'pending',
        redeemBy: '',
        coupons: [],
      ),
    ];
  }
}

void main() {
  group('Authentication Blocs Tests', () {
    late FakeAuthRepository authRepository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PrefStore.init();
      await PrefStore().clearAll();
      authRepository = FakeAuthRepository();
    });

    group('RegisterBloc', () {
      test('initial state is correct', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        expect(bloc.state, const RegisterInitial());
        bloc.close();
      });

      test('validates empty name', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: '',
          email: 'test@example.com',
          phone: '55551234',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Full name cannot be empty'),
          ]),
        );
      });

      test('validates empty/invalid email', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'invalid-email',
          phone: '55551234',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Please enter a valid email address'),
          ]),
        );
      });

      test('validates empty/invalid phone number', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '123',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Please enter a valid 8-digit mobile number'),
          ]),
        );
      });

      test('validates too short phone number with country code', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '+974555',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Please enter a valid mobile number with country code'),
          ]),
        );
      });

      test('validates short password', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '55551234',
          password: '123',
          confirmPassword: '123',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Password must be at least 6 characters'),
          ]),
        );
      });

      test('validates password mismatch', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '55551234',
          password: 'password',
          confirmPassword: 'mismatch',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Passwords do not match'),
          ]),
        );
      });

      test('emits RegisterSuccess on repository success', () {
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '55551234',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<RegisterLoading>(),
            predicate<RegisterState>((state) {
              return state is RegisterSuccess &&
                  state.email == 'test@example.com' &&
                  state.phoneNumber == '+97455551234';
            }),
          ]),
        );
      });

      test('emits RegisterFailure on repository failure', () {
        authRepository.throwError = true;
        authRepository.errorMessage = 'Network timeout';
        final bloc = RegisterBloc(authRepository: authRepository);
        bloc.add(const RegisterSubmitted(
          name: 'John Doe',
          email: 'test@example.com',
          phone: '55551234',
          password: 'password',
          confirmPassword: 'password',
        ));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<RegisterLoading>(),
            predicate<RegisterState>((state) => state is RegisterFailure && state.error == 'Network timeout'),
          ]),
        );
      });
    });

    group('ForgotPasswordBloc', () {
      test('initial state is correct', () {
        final bloc = ForgotPasswordBloc(authRepository: authRepository);
        expect(bloc.state, const ForgotPasswordInitial());
        bloc.close();
      });

      test('validates invalid phone number', () {
        final bloc = ForgotPasswordBloc(authRepository: authRepository);
        bloc.add(const ForgotPasswordSubmitted(phone: '12345'));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<ForgotPasswordState>((state) => state is ForgotPasswordFailure && state.error == 'Please enter a valid 8-digit mobile number'),
          ]),
        );
      });

      test('emits ForgotPasswordSuccess on success', () {
        final bloc = ForgotPasswordBloc(authRepository: authRepository);
        bloc.add(const ForgotPasswordSubmitted(phone: '55551234'));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<ForgotPasswordLoading>(),
            predicate<ForgotPasswordState>((state) => state is ForgotPasswordSuccess && state.phone == '55551234'),
          ]),
        );
      });

      test('emits ForgotPasswordFailure on failure', () {
        authRepository.throwError = true;
        authRepository.errorMessage = 'Server error';
        final bloc = ForgotPasswordBloc(authRepository: authRepository);
        bloc.add(const ForgotPasswordSubmitted(phone: '55551234'));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<ForgotPasswordLoading>(),
            predicate<ForgotPasswordState>((state) => state is ForgotPasswordFailure && state.error == 'Server error'),
          ]),
        );
      });
    });

    group('LoginBloc', () {
      test('initial state is correct', () {
        final bloc = LoginBloc(authRepository: authRepository);
        expect(bloc.state, const LoginInitial());
        bloc.close();
      });

      test('validates invalid email', () {
        final bloc = LoginBloc(authRepository: authRepository);
        bloc.add(const LoginSubmitted(email: 'invalid', password: 'password'));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<LoginState>((state) => state is LoginFailure && state.error == 'Please enter a valid email address'),
          ]),
        );
      });

      test('emits LoginSuccess on success', () {
        final bloc = LoginBloc(authRepository: authRepository);
        bloc.add(const LoginSubmitted(email: 'test@example.com', password: 'password'));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<LoginLoading>(),
            predicate<LoginState>((state) => state is LoginSuccess && state.email == 'test@example.com'),
          ]),
        );
      });
    });

    group('OtpBloc', () {
      test('initial state is correct', () {
        final bloc = OtpBloc(authRepository: authRepository, email: 'test@example.com');
        expect(bloc.state, const OtpInitial());
        bloc.close();
      });

      test('validates OTP length', () {
        final bloc = OtpBloc(authRepository: authRepository, email: 'test@example.com');
        bloc.add(const OtpSubmitted(otp: '123'));
        expect(
          bloc.stream,
          emitsInOrder([
            predicate<OtpState>((state) => state is OtpFailure && state.error == 'OTP code must be exactly 6 digits'),
          ]),
        );
      });

      test('emits OtpSuccess on success', () {
        final bloc = OtpBloc(authRepository: authRepository, email: 'test@example.com');
        bloc.add(const OtpSubmitted(otp: '123456'));
        expect(
          bloc.stream,
          emitsInOrder([
            isA<OtpLoading>(),
            isA<OtpSuccess>(),
          ]),
        );
      });

      test('emits OtpResendSuccess on resend', () {
        final bloc = OtpBloc(authRepository: authRepository, email: 'test@example.com');
        bloc.add(const OtpResendRequested());
        expect(
          bloc.stream,
          emitsInOrder([
            isA<OtpLoading>(),
            isA<OtpResendSuccess>(),
          ]),
        );
      });
    });

    group('AccountBloc', () {
      test('initial state is AccountInitial', () {
        final bloc = AccountBloc(authRepository: authRepository);
        expect(bloc.state, const AccountInitial());
        bloc.close();
      });

      test('LoadDashboard emits loading then loaded data when successful', () async {
        final bloc = AccountBloc(authRepository: authRepository);
        
        // Wait for constructor AppStarted to complete (reaches AccountUnauthenticated)
        await expectLater(
          bloc.stream,
          emitsThrough(isA<AccountUnauthenticated>()),
        );

        await PrefStore().saveString(AppStrings.keyToken, 'mock_token');

        // Emit AccountAuthenticated manually
        bloc.emit(const AccountAuthenticated(email: 'test@example.com'));

        // Trigger LoadDashboard
        bloc.add(const LoadDashboard());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<AccountState>((state) => state is AccountAuthenticated && state.isLoadingDashboard),
            predicate<AccountState>((state) => state is AccountAuthenticated && !state.isLoadingDashboard && state.dashboardData != null && state.error == null),
          ]),
        );
        bloc.close();
      });

      test('LoadDashboard emits loading then error when repository fails', () async {
        final bloc = AccountBloc(authRepository: authRepository);

        // Wait for constructor AppStarted to complete (reaches AccountUnauthenticated)
        await expectLater(
          bloc.stream,
          emitsThrough(isA<AccountUnauthenticated>()),
        );

        await PrefStore().saveString(AppStrings.keyToken, 'mock_token');
        authRepository.throwError = true;
        authRepository.errorMessage = 'Network error';

        // Emit AccountAuthenticated manually
        bloc.emit(const AccountAuthenticated(email: 'test@example.com'));

        // Trigger LoadDashboard
        bloc.add(const LoadDashboard());

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<AccountState>((state) => state is AccountAuthenticated && state.isLoadingDashboard),
            predicate<AccountState>((state) => state is AccountAuthenticated && !state.isLoadingDashboard && state.error == 'Exception: Network error'),
          ]),
        );
        bloc.close();
      });

      test('LoadDashboard with filter parameters calls getFilteredOrders and emits state with filteredTransactions', () async {
        final bloc = AccountBloc(authRepository: authRepository);

        // Wait for constructor AppStarted to complete
        await expectLater(
          bloc.stream,
          emitsThrough(isA<AccountUnauthenticated>()),
        );

        await PrefStore().saveString(AppStrings.keyToken, 'mock_token');
        authRepository.getFilteredOrdersCalled = false;

        // Emit AccountAuthenticated manually
        bloc.emit(const AccountAuthenticated(email: 'test@example.com'));

        // Trigger LoadDashboard with filters
        bloc.add(const LoadDashboard(
          status: 'pending',
          from: '2026-08-01',
          to: '2026-08-31',
          vendor: 'ElectroWorld',
        ));

        await expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<AccountState>((state) => state is AccountAuthenticated && state.isLoadingDashboard),
            predicate<AccountState>((state) => 
                state is AccountAuthenticated && 
                !state.isLoadingDashboard && 
                state.filteredTransactions != null && 
                state.filteredTransactions!.isNotEmpty && 
                state.filteredTransactions!.first.vendor == 'ElectroWorld' &&
                state.filteredTransactions!.first.status == 'pending'
            ),
          ]),
        );

        expect(authRepository.getFilteredOrdersCalled, isTrue);
        expect(authRepository.lastStatus, 'pending');
        expect(authRepository.lastFrom, '2026-08-01');
        expect(authRepository.lastTo, '2026-08-31');
        expect(authRepository.lastVendor, 'ElectroWorld');

        bloc.close();
      });
    });
  });
}
