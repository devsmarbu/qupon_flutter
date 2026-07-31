import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/network/api_client.dart';
import '../../../../../core/widgets/custom_snack_bar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/forgot_password_bloc.dart';
import '../bloc/forgot_password_event.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ForgotPasswordBloc>(
      create: (context) => ForgotPasswordBloc(
        authRepository: AuthRepositoryImpl(
          apiClient: ApiClient(),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                CustomSnackBar.showTop(
                  context,
                  AppStrings.getLocalizedError(context, 'Reset link sent successfully!'),
                  isError: false,
                );
              } else if (state is ForgotPasswordFailure) {
                CustomSnackBar.showTop(context, AppStrings.getLocalizedError(context, state.error), isError: true);
              }
            },
            builder: (context, state) {
              final isLoading = state is ForgotPasswordLoading;
              final isSuccess = state is ForgotPasswordSuccess;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Centered Qupon Branding Logo ────────────────────────
                        Column(
                          children: [
                            const Text(
                              'Qupon',
                              style: TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -2,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(4, -8),
                              child: const Text(
                                'كيوبون',
                                style: TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ── Card Container ────────────────────────────────────
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: isSuccess
                              ? _buildSuccessContent(context, state.phone)
                              : _buildFormContent(context, isLoading),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Customer account — enter the mobile number linked to your account and we will send a reset link via SMS.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // ── Key Icon Badge ──────────────────────────────
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEFE9), // Soft orange tint
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.vpn_key_outlined,
              color: Color(0xFFFF6B35),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Mobile Number Field ──────────────────────────
        const Text(
          'Mobile number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: _inputDecoration(hint: '50123456'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Enter the mobile number linked to your customer account. We\'ll send the reset link via SMS only.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF94A3B8),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // ── Send Button ────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<ForgotPasswordBloc>().add(
                          ForgotPasswordSubmitted(
                            phone: _phoneController.text,
                          ),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFFF6B35).withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Send reset link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Footer Links ──────────────────────────────────
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember your password? ',
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  ),
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'Back to storefront',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent(BuildContext context, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Customer account — enter the mobile number linked to your account and we will send a reset link via SMS.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),

        // ── Phone Icon Badge ──────────────────────────────
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEFE9), // Soft orange tint
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_android_outlined,
              color: Color(0xFFFF6B35),
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Subtitle text with bold mobile number ───────────
        Center(
          child: Column(
            children: [
              const Text(
                'Check your messages',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'If a customer account exists for '),
                    TextSpan(
                      text: phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const TextSpan(text: ', we sent a password reset link to that mobile number via SMS.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ── Tip Container ────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB), // Soft yellow/amber background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFEF3C7)),
          ),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF92400E), // Amber 800
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: 'Tip: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: 'Open the link on this device to set a new password. The link expires in 1 hour.',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ── Buttons ──────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F172A),
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Back to sign in',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Center(
          child: GestureDetector(
            onTap: () {
              context.read<ForgotPasswordBloc>().add(const ForgotPasswordReset());
            },
            child: const Text(
              'Try a different phone number',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'Back to storefront',
              style: TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 1.5),
      ),
    );
  }
}
