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

  /// No description provided for @requestCouponHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. I missed this deal and would love to buy it again...'**
  String get requestCouponHint;

  /// No description provided for @couponQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Coupon QR Code'**
  String get couponQrCodeTitle;

  /// No description provided for @qrCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code to the vendor to redeem your purchase.'**
  String get qrCodeSubtitle;

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

  /// No description provided for @coffeeShop.
  ///
  /// In en, this message translates to:
  /// **'Coffee Shop'**
  String get coffeeShop;

  /// No description provided for @qrCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCodeLabel;

  /// No description provided for @showQrCode.
  ///
  /// In en, this message translates to:
  /// **'Show QR Code'**
  String get showQrCode;

  /// No description provided for @noOffersInCategory.
  ///
  /// In en, this message translates to:
  /// **'No offers available in this category.'**
  String get noOffersInCategory;

  /// No description provided for @couponOptionBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get couponOptionBasic;

  /// No description provided for @couponViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get couponViewDetails;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @noPastDealsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No past deals available'**
  String get noPastDealsAvailable;

  /// No description provided for @requestCouponShort.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestCouponShort;

  /// No description provided for @requestThisCoupon.
  ///
  /// In en, this message translates to:
  /// **'Request this coupon'**
  String get requestThisCoupon;

  /// No description provided for @requestCouponDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us why you want {name} back. The vendor and admin will review your message.'**
  String requestCouponDescription(String name);

  /// No description provided for @yourMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get yourMessage;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @daysLeftShort.
  ///
  /// In en, this message translates to:
  /// **'{days}d left'**
  String daysLeftShort(int days);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{item} other{items}}'**
  String itemCount(int count);

  /// No description provided for @myWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get myWishlist;

  /// No description provided for @noItemsInWishlist.
  ///
  /// In en, this message translates to:
  /// **'No items in your wishlist yet'**
  String get noItemsInWishlist;

  /// No description provided for @animalCare.
  ///
  /// In en, this message translates to:
  /// **'Animal Care'**
  String get animalCare;

  /// No description provided for @animalCareComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Animal Care offers coming soon...'**
  String get animalCareComingSoon;

  /// No description provided for @foodDrinks.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks'**
  String get foodDrinks;

  /// No description provided for @foodDrinksComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Food & Drinks offers coming soon...'**
  String get foodDrinksComingSoon;

  /// No description provided for @failedToLoadOffers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load offers. Please try again.'**
  String get failedToLoadOffers;

  /// No description provided for @noOffersInCollection.
  ///
  /// In en, this message translates to:
  /// **'No offers available in this collection currently'**
  String get noOffersInCollection;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for coupons, vendors...'**
  String get searchPlaceholder;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @recipientPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient Phone'**
  String get recipientPhoneLabel;

  /// No description provided for @giftPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'We will send the coupon code(s) to this number after payment.'**
  String get giftPhoneHint;

  /// No description provided for @qatarPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).'**
  String get qatarPhoneHint;

  /// No description provided for @vendorLabel.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get vendorLabel;

  /// No description provided for @offerLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offerLabel;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @couponUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon URL'**
  String get couponUrlLabel;

  /// No description provided for @couponCopiedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get couponCopiedClipboard;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @redeemByLabel.
  ///
  /// In en, this message translates to:
  /// **'Redeem By'**
  String get redeemByLabel;

  /// No description provided for @timeLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeftLabel;

  /// No description provided for @dealPrice.
  ///
  /// In en, this message translates to:
  /// **'Deal Price'**
  String get dealPrice;

  /// No description provided for @detailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsLabel;

  /// No description provided for @healthWellness.
  ///
  /// In en, this message translates to:
  /// **'Health & Wellness'**
  String get healthWellness;

  /// No description provided for @travelTourism.
  ///
  /// In en, this message translates to:
  /// **'Travel & Tourism'**
  String get travelTourism;

  /// No description provided for @entertainmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainmentLabel;

  /// No description provided for @beautyLabel.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get beautyLabel;

  /// No description provided for @viewCartLabel.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get viewCartLabel;

  /// No description provided for @appNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Qupon'**
  String get appNameLabel;

  /// No description provided for @thisOfferExpired.
  ///
  /// In en, this message translates to:
  /// **'This Offer has Expired'**
  String get thisOfferExpired;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @couponCodeQr.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCodeQr;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Homes'**
  String get navHome;

  /// No description provided for @navPastDeals.
  ///
  /// In en, this message translates to:
  /// **'Past Deals'**
  String get navPastDeals;

  /// No description provided for @navSearchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search for coupons, vendors...'**
  String get navSearchPlaceholder;

  /// No description provided for @navSearchLoading.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get navSearchLoading;

  /// No description provided for @navSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No coupons found.'**
  String get navSearchEmpty;

  /// No description provided for @navSearchError.
  ///
  /// In en, this message translates to:
  /// **'Search failed. Please try again.'**
  String get navSearchError;

  /// No description provided for @navPortals.
  ///
  /// In en, this message translates to:
  /// **'Portals:'**
  String get navPortals;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// No description provided for @navVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get navVendor;

  /// No description provided for @navInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Influencer'**
  String get navInfluencer;

  /// No description provided for @footerAddress.
  ///
  /// In en, this message translates to:
  /// **'Doha, Qatar, West Bay, Al Reem Tower, Building number 37, 11th floor, office 46, P.O. Box 24355'**
  String get footerAddress;

  /// No description provided for @footerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get footerPhone;

  /// No description provided for @footerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get footerEmail;

  /// No description provided for @footerFollowUs.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get footerFollowUs;

  /// No description provided for @footerCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get footerCompany;

  /// No description provided for @footerAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get footerAboutUs;

  /// No description provided for @footerCouponPage.
  ///
  /// In en, this message translates to:
  /// **'Coupon Page'**
  String get footerCouponPage;

  /// No description provided for @footerSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get footerSupport;

  /// No description provided for @footerTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get footerTerms;

  /// No description provided for @footerRefundPolicy.
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get footerRefundPolicy;

  /// No description provided for @footerContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get footerContactUs;

  /// No description provided for @footerPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get footerPrivacyPolicy;

  /// No description provided for @footerMyAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get footerMyAccount;

  /// No description provided for @footerMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get footerMyOrders;

  /// No description provided for @footerMyWishlist.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get footerMyWishlist;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coupons you saved for later.'**
  String get wishlistSubtitle;

  /// No description provided for @wishlistBackDashboard.
  ///
  /// In en, this message translates to:
  /// **'Back to dashboard'**
  String get wishlistBackDashboard;

  /// No description provided for @wishlistLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading wishlist…'**
  String get wishlistLoading;

  /// No description provided for @wishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmpty;

  /// No description provided for @wishlistEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on a coupon to save it here.'**
  String get wishlistEmptyHint;

  /// No description provided for @wishlistBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse coupons'**
  String get wishlistBrowse;

  /// No description provided for @wishlistRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get wishlistRemove;

  /// No description provided for @wishlistRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from wishlist.'**
  String get wishlistRemoved;

  /// No description provided for @wishlistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load wishlist.'**
  String get wishlistLoadError;

  /// No description provided for @wishlistRemoveError.
  ///
  /// In en, this message translates to:
  /// **'Could not remove from wishlist.'**
  String get wishlistRemoveError;

  /// No description provided for @footerPortal.
  ///
  /// In en, this message translates to:
  /// **'Portal'**
  String get footerPortal;

  /// No description provided for @footerPortalPartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get footerPortalPartner;

  /// No description provided for @footerPoweredByPrefix.
  ///
  /// In en, this message translates to:
  /// **'Powered by:'**
  String get footerPoweredByPrefix;

  /// No description provided for @footerPoweredByBrand.
  ///
  /// In en, this message translates to:
  /// **'Paradigm Marketing And Advertising'**
  String get footerPoweredByBrand;

  /// No description provided for @cmsScrollTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get cmsScrollTop;

  /// No description provided for @cmsReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get cmsReadMore;

  /// No description provided for @cmsReadLess.
  ///
  /// In en, this message translates to:
  /// **'Read Less'**
  String get cmsReadLess;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactTitle;

  /// No description provided for @contactHeroAlt.
  ///
  /// In en, this message translates to:
  /// **'Contact Qupon'**
  String get contactHeroAlt;

  /// No description provided for @contactSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send A Message'**
  String get contactSendMessage;

  /// No description provided for @contactGetInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get In Touch'**
  String get contactGetInTouch;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get contactName;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get contactSubject;

  /// No description provided for @contactMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get contactMessage;

  /// No description provided for @contactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get contactPhoneLabel;

  /// No description provided for @contactEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get contactEmailLabel;

  /// No description provided for @contactLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Our Location'**
  String get contactLocationLabel;

  /// No description provided for @contactSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get contactSubmit;

  /// No description provided for @contactSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get contactSubmitting;

  /// No description provided for @contactSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank you. Your message has been sent.'**
  String get contactSubmitSuccess;

  /// No description provided for @contactSubmitError.
  ///
  /// In en, this message translates to:
  /// **'We could not send your message. Please try again.'**
  String get contactSubmitError;

  /// No description provided for @homeLimitedOffer.
  ///
  /// In en, this message translates to:
  /// **'Limited Time Offer'**
  String get homeLimitedOffer;

  /// No description provided for @homeShopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get homeShopNow;

  /// No description provided for @homeShopByCategory.
  ///
  /// In en, this message translates to:
  /// **'Shop by Category'**
  String get homeShopByCategory;

  /// No description provided for @homeTrendingOffers.
  ///
  /// In en, this message translates to:
  /// **'🔥 Trending Offers'**
  String get homeTrendingOffers;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeActiveOffers.
  ///
  /// In en, this message translates to:
  /// **'Active Offers'**
  String get homeActiveOffers;

  /// No description provided for @homeBestInFood.
  ///
  /// In en, this message translates to:
  /// **'🍔 Best in Food'**
  String get homeBestInFood;

  /// No description provided for @homeViewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get homeViewMore;

  /// No description provided for @homeTopFashion.
  ///
  /// In en, this message translates to:
  /// **'👗 Top Fashion Deals'**
  String get homeTopFashion;

  /// No description provided for @homeElectronics.
  ///
  /// In en, this message translates to:
  /// **'💻 Electronics & Tech'**
  String get homeElectronics;

  /// No description provided for @homeSports.
  ///
  /// In en, this message translates to:
  /// **'⚽ Sports & Outdoors'**
  String get homeSports;

  /// No description provided for @couponValidTill.
  ///
  /// In en, this message translates to:
  /// **'Valid till'**
  String get couponValidTill;

  /// No description provided for @couponExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get couponExpired;

  /// No description provided for @couponGetCode.
  ///
  /// In en, this message translates to:
  /// **'Get Code'**
  String get couponGetCode;

  /// No description provided for @couponViewDeal.
  ///
  /// In en, this message translates to:
  /// **'View Deal'**
  String get couponViewDeal;

  /// No description provided for @couponOff.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get couponOff;

  /// No description provided for @couponStartingAt.
  ///
  /// In en, this message translates to:
  /// **'Starting at'**
  String get couponStartingAt;

  /// No description provided for @couponOfferPrice.
  ///
  /// In en, this message translates to:
  /// **'You pay'**
  String get couponOfferPrice;

  /// No description provided for @couponListPrice.
  ///
  /// In en, this message translates to:
  /// **'Was'**
  String get couponListPrice;

  /// No description provided for @couponExp.
  ///
  /// In en, this message translates to:
  /// **'Exp:'**
  String get couponExp;

  /// No description provided for @couponD.
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get couponD;

  /// No description provided for @couponH.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get couponH;

  /// No description provided for @couponM.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get couponM;

  /// No description provided for @couponS.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get couponS;

  /// No description provided for @couponLeft.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get couponLeft;

  /// No description provided for @couponSocialProofShort.
  ///
  /// In en, this message translates to:
  /// **'🔥 {count} bought'**
  String couponSocialProofShort(Object count);

  /// No description provided for @couponSocialProofShortOne.
  ///
  /// In en, this message translates to:
  /// **'🔥 1 bought'**
  String get couponSocialProofShortOne;

  /// No description provided for @couponDetailsAboutDeal.
  ///
  /// In en, this message translates to:
  /// **'Offer Description'**
  String get couponDetailsAboutDeal;

  /// No description provided for @couponDetailsHowToUse.
  ///
  /// In en, this message translates to:
  /// **'How to Use'**
  String get couponDetailsHowToUse;

  /// No description provided for @couponDetailsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get couponDetailsTerms;

  /// No description provided for @couponDetailsAboutVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor Details'**
  String get couponDetailsAboutVendor;

  /// No description provided for @couponDetailsVisitStore.
  ///
  /// In en, this message translates to:
  /// **'Visit Store'**
  String get couponDetailsVisitStore;

  /// No description provided for @couponDetailsSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select Option'**
  String get couponDetailsSelectOption;

  /// No description provided for @couponDetailsViewVendor.
  ///
  /// In en, this message translates to:
  /// **'View Vendor Profile'**
  String get couponDetailsViewVendor;

  /// No description provided for @couponDetailsDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get couponDetailsDiscount;

  /// No description provided for @couponDetailsImportantNotes.
  ///
  /// In en, this message translates to:
  /// **'Important Notes'**
  String get couponDetailsImportantNotes;

  /// No description provided for @couponDetailsPrice.
  ///
  /// In en, this message translates to:
  /// **'You pay'**
  String get couponDetailsPrice;

  /// No description provided for @couponDetailsYouPay.
  ///
  /// In en, this message translates to:
  /// **'You pay'**
  String get couponDetailsYouPay;

  /// No description provided for @couponDetailsYouSave.
  ///
  /// In en, this message translates to:
  /// **'You save'**
  String get couponDetailsYouSave;

  /// No description provided for @couponDetailsGetDeal.
  ///
  /// In en, this message translates to:
  /// **'Get Deal Now'**
  String get couponDetailsGetDeal;

  /// No description provided for @couponDetailsBuyAsGift.
  ///
  /// In en, this message translates to:
  /// **'Buy as Gift'**
  String get couponDetailsBuyAsGift;

  /// No description provided for @couponDetailsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get couponDetailsSave;

  /// No description provided for @couponDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get couponDetailsSaved;

  /// No description provided for @couponDetailsWishlist.
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get couponDetailsWishlist;

  /// No description provided for @couponDetailsWishlistSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get couponDetailsWishlistSaved;

  /// No description provided for @couponDetailsCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get couponDetailsCart;

  /// No description provided for @couponDetailsCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get couponDetailsCheckout;

  /// No description provided for @couponDetailsBack.
  ///
  /// In en, this message translates to:
  /// **'Back to Listings'**
  String get couponDetailsBack;

  /// No description provided for @couponDetailsPurchaseProgress.
  ///
  /// In en, this message translates to:
  /// **'Purchase availability'**
  String get couponDetailsPurchaseProgress;

  /// No description provided for @couponDetailsPurchased.
  ///
  /// In en, this message translates to:
  /// **'purchased'**
  String get couponDetailsPurchased;

  /// No description provided for @couponDetailsSocialProof.
  ///
  /// In en, this message translates to:
  /// **'🔥 {count} people grabbed this deal'**
  String couponDetailsSocialProof(Object count);

  /// No description provided for @couponDetailsSocialProofOne.
  ///
  /// In en, this message translates to:
  /// **'🔥 1 person grabbed this deal'**
  String get couponDetailsSocialProofOne;

  /// No description provided for @couponDetailsSocialProofFirst.
  ///
  /// In en, this message translates to:
  /// **'✨ Be the first to grab this deal'**
  String get couponDetailsSocialProofFirst;

  /// No description provided for @couponDetailsOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get couponDetailsOf;

  /// No description provided for @couponDetailsRemaining.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get couponDetailsRemaining;

  /// No description provided for @couponDetailsSoldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold out'**
  String get couponDetailsSoldOut;

  /// No description provided for @couponDetailsSoldOutHint.
  ///
  /// In en, this message translates to:
  /// **'This coupon has reached its purchase limit.'**
  String get couponDetailsSoldOutHint;

  /// No description provided for @couponDetailsExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'This offer has expired'**
  String get couponDetailsExpiredTitle;

  /// No description provided for @couponDetailsExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'This coupon is no longer available for purchase. You can request it from Past Deals and we will notify the vendor.'**
  String get couponDetailsExpiredMessage;

  /// No description provided for @couponDetailsNotPublishedMessage.
  ///
  /// In en, this message translates to:
  /// **'This coupon has not been published.'**
  String get couponDetailsNotPublishedMessage;

  /// No description provided for @couponDetailsRequestCoupon.
  ///
  /// In en, this message translates to:
  /// **'Request Coupon'**
  String get couponDetailsRequestCoupon;

  /// No description provided for @couponDetailsShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get couponDetailsShare;

  /// No description provided for @couponShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get couponShareTitle;

  /// No description provided for @couponShareDescription.
  ///
  /// In en, this message translates to:
  /// **'Send this deal to friends or copy the link.'**
  String get couponShareDescription;

  /// No description provided for @couponShareLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon link'**
  String get couponShareLinkLabel;

  /// No description provided for @couponShareCopyBtn.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get couponShareCopyBtn;

  /// No description provided for @couponShareCopiedBtn.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get couponShareCopiedBtn;

  /// No description provided for @couponShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied to clipboard'**
  String get couponShareCopied;

  /// No description provided for @couponShareCopyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not copy link. Please copy it manually.'**
  String get couponShareCopyFailed;

  /// No description provided for @couponShareNative.
  ///
  /// In en, this message translates to:
  /// **'Share via device'**
  String get couponShareNative;

  /// No description provided for @couponShareNativeFailed.
  ///
  /// In en, this message translates to:
  /// **'Sharing was cancelled or is not available.'**
  String get couponShareNativeFailed;

  /// No description provided for @vendorProfileBack.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get vendorProfileBack;

  /// No description provided for @vendorProfileAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get vendorProfileAbout;

  /// No description provided for @vendorProfileContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get vendorProfileContact;

  /// No description provided for @vendorProfileFollowUs.
  ///
  /// In en, this message translates to:
  /// **'Follow us'**
  String get vendorProfileFollowUs;

  /// No description provided for @vendorProfileLandline.
  ///
  /// In en, this message translates to:
  /// **'Landline'**
  String get vendorProfileLandline;

  /// No description provided for @vendorProfileOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers by'**
  String get vendorProfileOffers;

  /// No description provided for @vendorProfileNoOffersTitle.
  ///
  /// In en, this message translates to:
  /// **'No Active Offers'**
  String get vendorProfileNoOffersTitle;

  /// No description provided for @vendorProfileNoOffersDesc.
  ///
  /// In en, this message translates to:
  /// **'This vendor currently doesn\'t have any active coupons available.'**
  String get vendorProfileNoOffersDesc;

  /// No description provided for @couponFormMaxPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total coupons available for purchase'**
  String get couponFormMaxPurchases;

  /// No description provided for @couponFormMaxPurchasesHint.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of customers who can buy this coupon. Leave blank for unlimited.'**
  String get couponFormMaxPurchasesHint;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get cartTitle;

  /// No description provided for @cartContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get cartContinueShopping;

  /// No description provided for @cartEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Browse deals and add coupons to your cart.'**
  String get cartEmptyDesc;

  /// No description provided for @cartBrowseDeals.
  ///
  /// In en, this message translates to:
  /// **'Browse deals'**
  String get cartBrowseDeals;

  /// No description provided for @cartOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get cartOrderSummary;

  /// No description provided for @cartSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotal;

  /// No description provided for @cartTotalSavings.
  ///
  /// In en, this message translates to:
  /// **'Total savings'**
  String get cartTotalSavings;

  /// No description provided for @cartTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cartTotal;

  /// No description provided for @cartPayVia.
  ///
  /// In en, this message translates to:
  /// **'Pay via'**
  String get cartPayVia;

  /// No description provided for @cartBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get cartBalance;

  /// No description provided for @cartCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckout;

  /// No description provided for @cartProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get cartProcessing;

  /// No description provided for @cartNoPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'No payment methods available.'**
  String get cartNoPaymentMethods;

  /// No description provided for @cartAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to cart'**
  String get cartAdded;

  /// No description provided for @cartExpiredInCart.
  ///
  /// In en, this message translates to:
  /// **'One or more items in your cart have expired. Remove them to continue.'**
  String get cartExpiredInCart;

  /// No description provided for @checkoutGiftTitle.
  ///
  /// In en, this message translates to:
  /// **'Gift this order'**
  String get checkoutGiftTitle;

  /// No description provided for @checkoutGiftDesc.
  ///
  /// In en, this message translates to:
  /// **'Send the coupon details to someone else by SMS.'**
  String get checkoutGiftDesc;

  /// No description provided for @checkoutGiftPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient mobile number'**
  String get checkoutGiftPhoneLabel;

  /// No description provided for @checkoutGiftPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'We will text the coupon code(s) to this number after payment.'**
  String get checkoutGiftPhoneHint;

  /// No description provided for @commonQatarPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).'**
  String get commonQatarPhoneHint;

  /// No description provided for @pastDealsTotal.
  ///
  /// In en, this message translates to:
  /// **'{count} past deals'**
  String pastDealsTotal(Object count);

  /// No description provided for @pastDealsLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more…'**
  String get pastDealsLoadingMore;

  /// No description provided for @pastDealsRequestButton.
  ///
  /// In en, this message translates to:
  /// **'Request Coupon'**
  String get pastDealsRequestButton;

  /// No description provided for @pastDealsRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Request this coupon'**
  String get pastDealsRequestTitle;

  /// No description provided for @pastDealsRequestDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us why you want {name} back. The vendor and admin will review your message.'**
  String pastDealsRequestDescription(Object name);

  /// No description provided for @pastDealsRequestDescriptionGeneric.
  ///
  /// In en, this message translates to:
  /// **'Tell us why you want this coupon back.'**
  String get pastDealsRequestDescriptionGeneric;

  /// No description provided for @pastDealsMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get pastDealsMessageLabel;

  /// No description provided for @pastDealsMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. I missed this deal and would love to buy it again…'**
  String get pastDealsMessagePlaceholder;

  /// No description provided for @pastDealsMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a message.'**
  String get pastDealsMessageRequired;

  /// No description provided for @pastDealsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get pastDealsSubmit;

  /// No description provided for @pastDealsSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get pastDealsSubmitting;

  /// No description provided for @pastDealsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pastDealsCancel;

  /// No description provided for @pastDealsSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your request was sent successfully.'**
  String get pastDealsSubmitSuccess;

  /// No description provided for @pastDealsSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not send your request. Please try again.'**
  String get pastDealsSubmitError;

  /// No description provided for @pastDealsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No past deals yet'**
  String get pastDealsEmptyTitle;

  /// No description provided for @pastDealsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Expired coupons will appear here once offers end.'**
  String get pastDealsEmptyHint;

  /// No description provided for @pastDealsNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No past deals match your search'**
  String get pastDealsNoMatch;

  /// No description provided for @pastDealsNoMatchHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword or clear the search.'**
  String get pastDealsNoMatchHint;

  /// No description provided for @pastDealsClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get pastDealsClearSearch;

  /// No description provided for @filterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get filterAllTime;

  /// No description provided for @filterStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterStatusActive;

  /// No description provided for @filterStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterStatusExpired;

  /// No description provided for @filterStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get filterStatusPending;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: '**
  String get filterDateLabel;

  /// No description provided for @filterStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get filterStatusLabel;

  /// No description provided for @filterVendorLabel.
  ///
  /// In en, this message translates to:
  /// **'Vendor: '**
  String get filterVendorLabel;

  /// No description provided for @awaitingRedemption.
  ///
  /// In en, this message translates to:
  /// **'Awaiting Redemption'**
  String get awaitingRedemption;

  /// No description provided for @redeemedLabel.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemedLabel;

  /// No description provided for @shopByCategory.
  ///
  /// In en, this message translates to:
  /// **'Shop By Category'**
  String get shopByCategory;

  /// No description provided for @electronicsLabel.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronicsLabel;

  /// No description provided for @viewAllLabel.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllLabel;

  /// No description provided for @qrDialogVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get qrDialogVendor;

  /// No description provided for @qrDialogOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get qrDialogOffer;

  /// No description provided for @qrDialogStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get qrDialogStatus;

  /// No description provided for @qrDialogOrderRef.
  ///
  /// In en, this message translates to:
  /// **'Order Ref'**
  String get qrDialogOrderRef;

  /// No description provided for @qrDialogExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get qrDialogExpiry;

  /// No description provided for @qrDialogRedeemCode.
  ///
  /// In en, this message translates to:
  /// **'Redeem Code'**
  String get qrDialogRedeemCode;

  /// No description provided for @qrDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get qrDialogClose;
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
