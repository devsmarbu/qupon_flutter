import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/neubrutalist_button.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/preferences/pref_store.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../account/bloc/account_bloc.dart';
import '../../account/bloc/account_event.dart';
import '../../forgot_password/view/forgot_password_page.dart';
import '../../register/view/register_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showTopSnackBar(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 20,
          right: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        authRepository: AuthRepositoryImpl(
          apiClient: ApiClient(),
        ),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.white,
                AppColors.splashMid,
                AppColors.splashEnd,
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: SafeArea(
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccess) {
                  final profile = await PrefStore.getProfile();
                  if (context.mounted) {
                    context.read<AccountBloc>().add(AccountLoggedIn(
                      email: state.email,
                      name: profile?.name ?? '',
                      role: profile?.role ?? '',
                    ));
                    _showTopSnackBar(
                      context,
                      AppStrings.getLocalizedError(context, 'Successfully signed in as ${state.email}'),
                      isError: false,
                    );
                    Navigator.of(context).pop(true);
                  }
                } else if (state is LoginFailure) {
                  _showTopSnackBar(context, AppStrings.getLocalizedError(context, state.error), isError: true);
                }
              },
              builder: (context, state) {
                final isLoading = state is LoginLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Welcome Back Title
                      Text(
                        AppStrings.welcomeBack(context),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDarkBlue,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Row Field
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppStrings.emailLabel(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.emailHint(context),
                                  hintStyle: const TextStyle(color: AppColors.textHint),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password Row Field
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AppStrings.passwordLabel(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.textDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.passwordHint(context),
                                  hintStyle: const TextStyle(color: AppColors.textHint),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            AppStrings.forgotPassword(context),
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              decorationColor: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Neubrutalist Login Button
                      NeubrutalistButton(
                        text: AppStrings.login(context),
                        backgroundColor: AppColors.primary,
                        isLoading: isLoading,
                        onTap: () {
                          context.read<LoginBloc>().add(
                                LoginSubmitted(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Don't have an account? Sign up Footer
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: AppStrings.dontHaveAccount(context),
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: AppStrings.signUp(context),
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterPage(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      /*
                      // Divider Row
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.borderLight, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              AppStrings.orLoginWith(context),
                              style: const TextStyle(
                                color:  AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppColors.borderLight, thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Social Login Row
                      Row(
                        children: [
                          Expanded(
                            child: NeubrutalistButton(
                              text: AppStrings.google(context),
                              backgroundColor: AppColors.white,
                              leading: SvgPicture.asset(
                                'assets/appIcons/ic_google.svg',
                                width: 22,
                                height: 22,
                              ),
                              onTap: () {
                                _showTopSnackBar(
                                  context,
                                  AppStrings.getLocalizedError(context, 'Google Sign-In is not configured yet.'),
                                  isError: true,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: NeubrutalistButton(
                              text: AppStrings.facebook(context),
                              backgroundColor: AppColors.white,
                              leading: SvgPicture.asset(
                                'assets/appIcons/ic_facebook.svg',
                                width: 22,
                                height: 22,
                                colorFilter: const ColorFilter.mode(AppColors.facebookBlue, BlendMode.srcIn),
                              ),
                              onTap: () {
                                _showTopSnackBar(
                                  context,
                                  AppStrings.getLocalizedError(context, 'Facebook Sign-In is not configured yet.'),
                                  isError: true,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      */
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
