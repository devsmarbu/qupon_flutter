import 'package:flutter/material.dart';
import 'package:qupon/l10n/app_localizations.dart';

class AppStrings {
  static const String keyProfile = 'profile_data';
  static const String keyToken = 'token';

  // Welcome Screen Strings
  static String welcomeTitle(BuildContext context) => AppLocalizations.of(context)!.welcomeTitle;
  static String welcomeSubtitle(BuildContext context) => AppLocalizations.of(context)!.welcomeSubtitle;
  static String createAccount(BuildContext context) => AppLocalizations.of(context)!.createAccount;
  static String login(BuildContext context) => AppLocalizations.of(context)!.login;
  static String byContinuing(BuildContext context) => AppLocalizations.of(context)!.byContinuing;
  static String termsOfService(BuildContext context) => AppLocalizations.of(context)!.termsOfService;
  static String and(BuildContext context) => AppLocalizations.of(context)!.and;
  static String privacyPolicy(BuildContext context) => AppLocalizations.of(context)!.privacyPolicy;

  // Login Screen Strings
  static String welcomeBack(BuildContext context) => AppLocalizations.of(context)!.welcomeBack;
  static String emailLabel(BuildContext context) => AppLocalizations.of(context)!.emailLabel;
  static String emailHint(BuildContext context) => AppLocalizations.of(context)!.emailHint;
  static String passwordLabel(BuildContext context) => AppLocalizations.of(context)!.passwordLabel;
  static String passwordHint(BuildContext context) => AppLocalizations.of(context)!.passwordHint;
  static String forgotPassword(BuildContext context) => AppLocalizations.of(context)!.forgotPassword;
  static String dontHaveAccount(BuildContext context) => AppLocalizations.of(context)!.dontHaveAccount;
  static String signUp(BuildContext context) => AppLocalizations.of(context)!.signUp;
  static String orLoginWith(BuildContext context) => AppLocalizations.of(context)!.orLoginWith;
  static String google(BuildContext context) => AppLocalizations.of(context)!.google;
  static String facebook(BuildContext context) => AppLocalizations.of(context)!.facebook;

  // Register Screen Strings
  static String createAnAccount(BuildContext context) => AppLocalizations.of(context)!.createAnAccount;
  static String fullNameLabel(BuildContext context) => AppLocalizations.of(context)!.fullNameLabel;
  static String fullNameHint(BuildContext context) => AppLocalizations.of(context)!.fullNameHint;
  static String emailHintRegister(BuildContext context) => AppLocalizations.of(context)!.emailHintRegister;
  static String passwordHintRegister(BuildContext context) => AppLocalizations.of(context)!.passwordHintRegister;
  static String phoneNumberLabel(BuildContext context) => AppLocalizations.of(context)!.phoneNumberLabel;
  static String phoneNumberHint(BuildContext context) => AppLocalizations.of(context)!.phoneNumberHint;
  static String confirmPasswordLabel(BuildContext context) => AppLocalizations.of(context)!.confirmPasswordLabel;
  static String confirmPasswordHint(BuildContext context) => AppLocalizations.of(context)!.confirmPasswordHint;
  static String registerButton(BuildContext context) => AppLocalizations.of(context)!.registerButton;
  static String alreadyHaveAccount(BuildContext context) => AppLocalizations.of(context)!.alreadyHaveAccount;
  static String backToStorefront(BuildContext context) => AppLocalizations.of(context)!.backToStorefront;

  static String getLocalizedError(BuildContext context, String error) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return error;

    final trimmedError = error.trim();

    switch (trimmedError) {
      case 'Email cannot be empty':
        return l10n.errorEmailEmpty;
      case 'Please enter a valid email address':
        return l10n.errorInvalidEmail;
      case 'Password cannot be empty':
        return l10n.errorPasswordEmpty;
      case 'Password must be at least 6 characters':
        return l10n.errorPasswordLength;
      case 'Full name cannot be empty':
        return l10n.errorFullNameEmpty;
      case 'Phone number cannot be empty':
        return l10n.errorPhoneEmpty;
      case 'Please enter a valid 8-digit mobile number':
        return l10n.errorInvalidQatarPhone;
      case 'Please enter a valid mobile number with country code':
        return l10n.errorInvalidPhoneWithCountryCode;
      case 'Passwords do not match':
        return l10n.errorPasswordsDoNotMatch;
      case 'OTP code cannot be empty':
        return l10n.errorOtpEmpty;
      case 'OTP code must be exactly 6 digits':
        return l10n.errorOtpLength;
      case 'Google Sign-In is not configured yet.':
        return l10n.errorGoogleSignInNotConfigured;
      case 'Facebook Sign-In is not configured yet.':
        return l10n.errorFacebookSignInNotConfigured;
      case 'Registration successful! Please verify your phone number.':
        return l10n.successRegistration;
      case 'OTP Verified successfully! Please Sign In.':
        return l10n.successOtpVerified;
      case 'OTP resent successfully!':
        return l10n.successOtpResent;
      case 'Reset link sent successfully!':
        return l10n.successResetLinkSent;
      case 'Unknown network error occurred':
        return l10n.errorUnknownNetwork;
      case 'Network error while fetching category offers':
        return l10n.errorNetworkCategoryOffers;
      case 'Empty response from category API':
        return l10n.errorEmptyCategoryResponse;
      case 'Empty response from home API':
        return l10n.errorEmptyHomeResponse;
      default:
        // Handle format templates or unknown errors:
        if (trimmedError.startsWith('Successfully signed in as')) {
          final email = trimmedError.split(' ').last;
          return l10n.successSignIn(email);
        }
        if (trimmedError.startsWith('Failed to register. Server returned code')) {
          final code = trimmedError.split(' ').last;
          return l10n.errorFailedToRegister(code);
        }
        if (trimmedError.startsWith('Failed to login. Server returned code')) {
          final code = trimmedError.split(' ').last;
          return l10n.errorFailedToLogin(code);
        }
        if (trimmedError.startsWith('Failed to verify OTP. Server returned code')) {
          final code = trimmedError.split(' ').last;
          return l10n.errorFailedToVerifyOtp(code);
        }
        if (trimmedError.startsWith('Failed to resend OTP. Server returned code')) {
          final code = trimmedError.split(' ').last;
          return l10n.errorFailedToResendOtp(code);
        }
        if (trimmedError.startsWith('Failed to send reset link. Server returned code')) {
          final code = trimmedError.split(' ').last;
          return l10n.errorFailedToSendResetLink(code);
        }
        return error;
    }
  }
}
