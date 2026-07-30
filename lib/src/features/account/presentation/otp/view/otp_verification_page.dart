import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/network/api_client.dart';
import '../../../data/repositories/auth_repository.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String phoneNumber;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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
    return BlocProvider<OtpBloc>(
      create: (context) => OtpBloc(
        authRepository: AuthRepositoryImpl(
          apiClient: ApiClient(),
        ),
        email: widget.email,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              if (state is OtpSuccess) {
                _showTopSnackBar(
                  context,
                  AppStrings.getLocalizedError(context, 'OTP Verified successfully! Please Sign In.'),
                  isError: false,
                );
                // Go back to Login page
                Navigator.of(context).pop();
              } else if (state is OtpFailure) {
                _showTopSnackBar(context, AppStrings.getLocalizedError(context, state.error), isError: true);
              } else if (state is OtpResendSuccess) {
                _showTopSnackBar(
                  context,
                  AppStrings.getLocalizedError(context, 'OTP resent successfully!'),
                  isError: false,
                );
              } else if (state is OtpResendFailure) {
                _showTopSnackBar(context, AppStrings.getLocalizedError(context, state.error), isError: true);
              }
            },
            builder: (context, state) {
              final isLoading = state is OtpLoading;

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phone verification',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Enter the OTP sent to your mobile number to complete registration.',
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

                              // ── Subtitle text with bold phone number ───────────
                              Center(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Enter verification code',
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
                                          const TextSpan(text: 'We sent a 6-digit code to '),
                                          TextSpan(
                                            text: widget.phoneNumber,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0F172A),
                                            ),
                                          ),
                                          const TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Verification Code Field ───────────────────────
                              const Text(
                                'Verification code',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: _inputDecoration(hint: '123456'),
                              ),
                              const SizedBox(height: 20),

                              // ── Verify Button ────────────────────────────────
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context.read<OtpBloc>().add(
                                                OtpSubmitted(
                                                  otp: _otpController.text,
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
                                          'Verify and continue',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),

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
                                        text: 'The code expires in 10 minutes. Do not share it with anyone.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // ── Resend Code Button ───────────────────────────
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          context.read<OtpBloc>().add(
                                                const OtpResendRequested(),
                                              );
                                        },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF0F172A),
                                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.refresh,
                                        size: 20,
                                        color: isLoading ? Colors.grey : const Color(0xFF0F172A),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Resend code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Back to storefront ───────────────────────────
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
                          ),
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

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
      counterText: '', // Hides default character counter
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
