import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/neubrutalist_button.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';
import '../../otp/view/otp_verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showTopSnackBar(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
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
            child: BlocConsumer<RegisterBloc, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  _showTopSnackBar(
                    context,
                    AppStrings.getLocalizedError(context, 'Registration successful! Please verify your phone number.'),
                    isError: false,
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => OtpVerificationPage(
                        email: state.email,
                        phoneNumber: state.phoneNumber,
                      ),
                    ),
                  );
                } else if (state is RegisterFailure) {
                  _showTopSnackBar(context, AppStrings.getLocalizedError(context, state.error), isError: true);
                }
              },
              builder: (context, state) {
                final isLoading = state is RegisterLoading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),

                      // Title
                      Text(
                        AppStrings.createAnAccount(context),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDarkBlue,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 30),

                      /*
                      // Social Login Row
                      Row(
                        children: [
                          Expanded(
                            child: NeubrutalistButton(
                              text: AppStrings.google(context),
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              shadowOffset: const Offset(-5, 5),
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
                              textColor: AppColors.black,
                              shadowOffset: const Offset(-5, 5),
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
                      const SizedBox(height: 36),
                      */

                      // Full Name Field
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
                              AppStrings.fullNameLabel(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.fullNameHint(context),
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

                      // Email Field
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
                                fontWeight: FontWeight.w700,
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
                                  hintText: AppStrings.emailHintRegister(context),
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

                      // Phone Number Field
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
                              AppStrings.phoneNumberLabel(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.phoneNumberHint(context),
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

                      // Password Field
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
                                fontWeight: FontWeight.w700,
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
                                  hintText: AppStrings.passwordHintRegister(context),
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
                                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Password Field
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
                              AppStrings.confirmPasswordLabel(context),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.textDarkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: _confirmPasswordController,
                                obscureText: !_isConfirmPasswordVisible,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textDarkBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: AppStrings.confirmPasswordHint(context),
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
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Neubrutalist Register Button
                      NeubrutalistButton(
                        text: AppStrings.registerButton(context),
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.black,
                        shadowOffset: const Offset(-5, 5),
                        isLoading: isLoading,
                        onTap: () {
                          context.read<RegisterBloc>().add(
                                RegisterSubmitted(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  password: _passwordController.text,
                                  confirmPassword: _confirmPasswordController.text,
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Footer Navigation Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: AppStrings.alreadyHaveAccount(context),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: AppStrings.login(context),
                                  style: const TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 24),
                      // Center(
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.of(context).popUntil((route) => route.isFirst);
                      //     },
                      //     child: Text(
                      //       AppStrings.backToStorefront(context),
                      //       style: const TextStyle(
                      //         color: AppColors.primary,
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 14,
                      //         decoration: TextDecoration.underline,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
