import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Qupon'**
  String get appTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @beautyAndSpa.
  ///
  /// In en, this message translates to:
  /// **'Beauty & Spa'**
  String get beautyAndSpa;

  /// No description provided for @offersAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} offers available'**
  String offersAvailable(int count);

  /// No description provided for @locationDoha.
  ///
  /// In en, this message translates to:
  /// **'874 St Al Qawafell Street, (Al Diyafa Suites Hotel) Doha'**
  String get locationDoha;

  /// No description provided for @offerDescription.
  ///
  /// In en, this message translates to:
  /// **'ONE NIGHT FOR TWO ADULTS AND TWO CHILDREN IN DELUX'**
  String get offerDescription;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @qarPrice.
  ///
  /// In en, this message translates to:
  /// **'QAR {price}'**
  String qarPrice(String price);

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h {minutes}m left'**
  String timeLeft(int days, int hours, int minutes);

  /// No description provided for @offerTitle.
  ///
  /// In en, this message translates to:
  /// **'Abu Dhabi: 1 Night for Two with Breakfast...'**
  String get offerTitle;

  /// No description provided for @drawerHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get drawerHome;

  /// No description provided for @drawerOffers.
  ///
  /// In en, this message translates to:
  /// **'My Offers'**
  String get drawerOffers;

  /// No description provided for @drawerCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get drawerCart;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get drawerSettings;

  /// No description provided for @drawerLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get drawerLanguage;

  /// No description provided for @toggleLanguage.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get toggleLanguage;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get continueShopping;

  /// No description provided for @shoppingCartTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse deals and add coupons to your cart.'**
  String get cartEmptySubtitle;

  /// No description provided for @browseDeals.
  ///
  /// In en, this message translates to:
  /// **'Browse deals'**
  String get browseDeals;

  /// No description provided for @pastDealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Past Deals'**
  String get pastDealsTitle;

  /// No description provided for @pastDealsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse expired offers and request your favourite coupons to come back.'**
  String get pastDealsSubtitle;

  /// No description provided for @pastDealsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} past deals'**
  String pastDealsCount(int count);

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @requestCoupon.
  ///
  /// In en, this message translates to:
  /// **'Request Coupon'**
  String get requestCoupon;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({count})'**
  String subtotal(int count);

  /// No description provided for @totalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total savings'**
  String get totalSavings;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @giftThisOrder.
  ///
  /// In en, this message translates to:
  /// **'Gift this order'**
  String get giftThisOrder;

  /// No description provided for @giftSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send the coupon details to someone else by SMS.'**
  String get giftSubtitle;

  /// No description provided for @payVia.
  ///
  /// In en, this message translates to:
  /// **'Pay via'**
  String get payVia;

  /// No description provided for @stripe.
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get stripe;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance: QAR {balance}'**
  String walletBalance(String balance);

  /// No description provided for @skipCash.
  ///
  /// In en, this message translates to:
  /// **'SkipCash'**
  String get skipCash;

  /// No description provided for @checkoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutLabel;

  /// No description provided for @checkoutWithPrice.
  ///
  /// In en, this message translates to:
  /// **'Checkout · QAR {price}'**
  String checkoutWithPrice(String price);

  /// No description provided for @youSave.
  ///
  /// In en, this message translates to:
  /// **'You save QAR {amount}'**
  String youSave(String amount);

  /// No description provided for @checkoutSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get checkoutSuccessTitle;

  /// No description provided for @checkoutSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your coupon details have been sent. Thank you for shopping with Qupon!'**
  String get checkoutSuccessMessage;

  /// No description provided for @goBackHome.
  ///
  /// In en, this message translates to:
  /// **'Go Back Home'**
  String get goBackHome;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get started with your account'**
  String get welcomeSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our '**
  String get byContinuing;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'yourname@domain.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'........'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'OR LOGIN WITH'**
  String get orLoginWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHint;

  /// No description provided for @emailHintRegister.
  ///
  /// In en, this message translates to:
  /// **'john@example.com'**
  String get emailHintRegister;

  /// No description provided for @passwordHintRegister.
  ///
  /// In en, this message translates to:
  /// **'........'**
  String get passwordHintRegister;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'5555 5555'**
  String get phoneNumberHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'........'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @backToStorefront.
  ///
  /// In en, this message translates to:
  /// **'Back to storefront'**
  String get backToStorefront;

  /// No description provided for @errorEmailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get errorEmailEmpty;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get errorPasswordEmpty;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordLength;

  /// No description provided for @errorFullNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Full name cannot be empty'**
  String get errorFullNameEmpty;

  /// No description provided for @errorPhoneEmpty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get errorPhoneEmpty;

  /// No description provided for @errorInvalidQatarPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 8-digit mobile number'**
  String get errorInvalidQatarPhone;

  /// No description provided for @errorInvalidPhoneWithCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number with country code'**
  String get errorInvalidPhoneWithCountryCode;

  /// No description provided for @errorPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordsDoNotMatch;

  /// No description provided for @errorOtpEmpty.
  ///
  /// In en, this message translates to:
  /// **'OTP code cannot be empty'**
  String get errorOtpEmpty;

  /// No description provided for @errorOtpLength.
  ///
  /// In en, this message translates to:
  /// **'OTP code must be exactly 6 digits'**
  String get errorOtpLength;

  /// No description provided for @errorGoogleSignInNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In is not configured yet.'**
  String get errorGoogleSignInNotConfigured;

  /// No description provided for @errorFacebookSignInNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Facebook Sign-In is not configured yet.'**
  String get errorFacebookSignInNotConfigured;

  /// No description provided for @successRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please verify your phone number.'**
  String get successRegistration;

  /// No description provided for @successOtpVerified.
  ///
  /// In en, this message translates to:
  /// **'OTP Verified successfully! Please Sign In.'**
  String get successOtpVerified;

  /// No description provided for @successOtpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully!'**
  String get successOtpResent;

  /// No description provided for @successResetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent successfully!'**
  String get successResetLinkSent;

  /// No description provided for @errorFailedToRegister.
  ///
  /// In en, this message translates to:
  /// **'Failed to register. Server returned code {code}'**
  String errorFailedToRegister(String code);

  /// No description provided for @errorFailedToLogin.
  ///
  /// In en, this message translates to:
  /// **'Failed to login. Server returned code {code}'**
  String errorFailedToLogin(String code);

  /// No description provided for @errorFailedToVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify OTP. Server returned code {code}'**
  String errorFailedToVerifyOtp(String code);

  /// No description provided for @errorFailedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP. Server returned code {code}'**
  String errorFailedToResendOtp(String code);

  /// No description provided for @errorFailedToSendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Failed to send reset link. Server returned code {code}'**
  String errorFailedToSendResetLink(String code);

  /// No description provided for @errorUnknownNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unknown network error occurred'**
  String get errorUnknownNetwork;

  /// No description provided for @errorNetworkCategoryOffers.
  ///
  /// In en, this message translates to:
  /// **'Network error while fetching category offers'**
  String get errorNetworkCategoryOffers;

  /// No description provided for @errorEmptyCategoryResponse.
  ///
  /// In en, this message translates to:
  /// **'Empty response from category API'**
  String get errorEmptyCategoryResponse;

  /// No description provided for @errorEmptyHomeResponse.
  ///
  /// In en, this message translates to:
  /// **'Empty response from home API'**
  String get errorEmptyHomeResponse;

  /// No description provided for @successSignIn.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed in as {email}'**
  String successSignIn(String email);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'My Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Showing {orders} orders · {coupons} coupons · {period}'**
  String dashboardSubtitle(int orders, int coupons, String period);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search orders, coupons...'**
  String get searchHint;

  /// No description provided for @filtersBtn.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersBtn;

  /// No description provided for @filterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTitle;

  /// No description provided for @filterDateRange.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date Range'**
  String get filterDateRange;

  /// No description provided for @periodAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get periodAllTime;

  /// No description provided for @periodToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get periodToday;

  /// No description provided for @periodLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get periodLast7Days;

  /// No description provided for @periodLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get periodLast30Days;

  /// No description provided for @periodLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get periodLast90Days;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @periodThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get periodThisYear;

  /// No description provided for @customDateRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Date Range'**
  String get customDateRange;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @filterStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterStatus;

  /// No description provided for @statusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get statusAll;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @filterVendor.
  ///
  /// In en, this message translates to:
  /// **'Filter by Vendor'**
  String get filterVendor;

  /// No description provided for @selectVendor.
  ///
  /// In en, this message translates to:
  /// **'Select Vendor'**
  String get selectVendor;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @couponsUsed.
  ///
  /// In en, this message translates to:
  /// **'Coupons Used'**
  String get couponsUsed;

  /// No description provided for @totalSaved.
  ///
  /// In en, this message translates to:
  /// **'Total Saved'**
  String get totalSaved;

  /// No description provided for @activeCoupons.
  ///
  /// In en, this message translates to:
  /// **'Active Coupons'**
  String get activeCoupons;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @groceryStore.
  ///
  /// In en, this message translates to:
  /// **'Grocery Store'**
  String get groceryStore;

  /// No description provided for @couponRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Coupon Redeemed'**
  String get couponRedeemed;

  /// No description provided for @coffeeShop.
  ///
  /// In en, this message translates to:
  /// **'Coffee Shop'**
  String get coffeeShop;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
