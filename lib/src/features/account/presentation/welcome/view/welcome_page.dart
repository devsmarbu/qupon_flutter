import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/neubrutalist_button.dart';
import '../../../../main/presentation/pages/main_page.dart';
import '../../account/bloc/account_bloc.dart';
import '../../account/bloc/account_state.dart';
import '../../login/view/login_page.dart';
import '../../register/view/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _onBack(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainPage(initialIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onBack(context);
      },
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is AccountAuthenticated) {
            _onSuccess(context);
          }
        },
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: BackButton(
                        color: AppColors.textDarkBlue,
                        onPressed: () => _onBack(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Centered App Logo
                    SvgPicture.asset(
                      'assets/appIcons/ic_splash_logo.svg',
                      width: 160,
                    ),
                    const SizedBox(height: 15),
                    
                    // Welcome Title
                    Text(
                      AppStrings.welcomeTitle(context),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDarkBlue,
                        letterSpacing: -1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Subtitle
                    Text(
                      AppStrings.welcomeSubtitle(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    
                    const Spacer(flex: 4),
                    
                    // Create Account Button (Neubrutalism Style)
                    NeubrutalistButton(
                      text: AppStrings.createAccount(context),
                      backgroundColor: AppColors.primary,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                        if (context.mounted) {
                          _checkAuthAndNavigate(context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Login Button (Neubrutalism Style)
                    NeubrutalistButton(
                      text: AppStrings.login(context),
                      backgroundColor: AppColors.white,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                        if (context.mounted) {
                          _checkAuthAndNavigate(context);
                        }
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Footer (Terms and Privacy Policy)
                    _buildTermsAndPrivacyText(context),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkAuthAndNavigate(BuildContext context) {
    final state = context.read<AccountBloc>().state;
    if (state is AccountAuthenticated) {
      _onSuccess(context);
    }
  }

  void _onSuccess(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    }
  }

  Widget _buildTermsAndPrivacyText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text.rich(
        TextSpan(
          text: AppStrings.byContinuing(context),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            height: 1.5,
          ),
          children: [
            TextSpan(
              text: AppStrings.termsOfService(context),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showInfoDialog(context, AppStrings.termsOfService(context), 'Terms of Service content goes here.');
                },
            ),
            TextSpan(text: AppStrings.and(context)),
            TextSpan(
              text: AppStrings.privacyPolicy(context),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _showInfoDialog(context, AppStrings.privacyPolicy(context), 'Privacy Policy content goes here.');
                },
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
