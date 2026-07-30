// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Qupon';

  @override
  String get back => 'Back';

  @override
  String get beautyAndSpa => 'Beauty & Spa';

  @override
  String offersAvailable(int count) {
    return '$count offers available';
  }

  @override
  String get locationDoha =>
      '874 St Al Qawafell Street, (Al Diyafa Suites Hotel) Doha';

  @override
  String get offerDescription =>
      'ONE NIGHT FOR TWO ADULTS AND TWO CHILDREN IN DELUX';

  @override
  String get viewDetails => 'View Details';

  @override
  String qarPrice(String price) {
    return 'QAR $price';
  }

  @override
  String timeLeft(int days, int hours, int minutes) {
    return '${days}d ${hours}h ${minutes}m left';
  }

  @override
  String get offerTitle => 'Abu Dhabi: 1 Night for Two with Breakfast...';

  @override
  String get drawerHome => 'Home';

  @override
  String get drawerOffers => 'My Offers';

  @override
  String get drawerCart => 'Cart';

  @override
  String get drawerProfile => 'Profile';

  @override
  String get drawerSettings => 'Settings';

  @override
  String get drawerLanguage => 'Language';

  @override
  String get toggleLanguage => 'عربي';

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get shoppingCartTitle => 'Shopping Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Browse deals and add coupons to your cart.';

  @override
  String get browseDeals => 'Browse deals';

  @override
  String get pastDealsTitle => 'Past Deals';

  @override
  String get pastDealsSubtitle =>
      'Browse expired offers and request your favourite coupons to come back.';

  @override
  String pastDealsCount(int count) {
    return '$count past deals';
  }

  @override
  String get expired => 'Expired';

  @override
  String get requestCoupon => 'Request Coupon';

  @override
  String get orderSummary => 'Order summary';

  @override
  String subtotal(int count) {
    return 'Subtotal ($count)';
  }

  @override
  String get totalSavings => 'Total savings';

  @override
  String get totalLabel => 'Total';

  @override
  String get giftThisOrder => 'Gift this order';

  @override
  String get giftSubtitle => 'Send the coupon details to someone else by SMS.';

  @override
  String get payVia => 'Pay via';

  @override
  String get stripe => 'Stripe';

  @override
  String get wallet => 'Wallet';

  @override
  String walletBalance(String balance) {
    return 'Balance: QAR $balance';
  }

  @override
  String get skipCash => 'SkipCash';

  @override
  String get checkoutLabel => 'Checkout';

  @override
  String checkoutWithPrice(String price) {
    return 'Checkout · QAR $price';
  }

  @override
  String youSave(String amount) {
    return 'You save QAR $amount';
  }

  @override
  String get checkoutSuccessTitle => 'Order Placed Successfully!';

  @override
  String get checkoutSuccessMessage =>
      'Your coupon details have been sent. Thank you for shopping with Qupon!';

  @override
  String get goBackHome => 'Go Back Home';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Get started with your account';

  @override
  String get createAccount => 'Create Account';

  @override
  String get login => 'Login';

  @override
  String get byContinuing => 'By continuing you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get and => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'yourname@domain.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '........';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign up';

  @override
  String get orLoginWith => 'OR LOGIN WITH';

  @override
  String get google => 'Google';

  @override
  String get facebook => 'Facebook';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'John Doe';

  @override
  String get emailHintRegister => 'john@example.com';

  @override
  String get passwordHintRegister => '........';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get phoneNumberHint => '5555 5555';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => '........';

  @override
  String get registerButton => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get backToStorefront => 'Back to storefront';

  @override
  String get errorEmailEmpty => 'Email cannot be empty';

  @override
  String get errorInvalidEmail => 'Please enter a valid email address';

  @override
  String get errorPasswordEmpty => 'Password cannot be empty';

  @override
  String get errorPasswordLength => 'Password must be at least 6 characters';

  @override
  String get errorFullNameEmpty => 'Full name cannot be empty';

  @override
  String get errorPhoneEmpty => 'Phone number cannot be empty';

  @override
  String get errorInvalidQatarPhone =>
      'Please enter a valid 8-digit mobile number';

  @override
  String get errorInvalidPhoneWithCountryCode =>
      'Please enter a valid mobile number with country code';

  @override
  String get errorPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get errorOtpEmpty => 'OTP code cannot be empty';

  @override
  String get errorOtpLength => 'OTP code must be exactly 6 digits';

  @override
  String get errorGoogleSignInNotConfigured =>
      'Google Sign-In is not configured yet.';

  @override
  String get errorFacebookSignInNotConfigured =>
      'Facebook Sign-In is not configured yet.';

  @override
  String get successRegistration =>
      'Registration successful! Please verify your phone number.';

  @override
  String get successOtpVerified => 'OTP Verified successfully! Please Sign In.';

  @override
  String get successOtpResent => 'OTP resent successfully!';

  @override
  String get successResetLinkSent => 'Reset link sent successfully!';

  @override
  String errorFailedToRegister(String code) {
    return 'Failed to register. Server returned code $code';
  }

  @override
  String errorFailedToLogin(String code) {
    return 'Failed to login. Server returned code $code';
  }

  @override
  String errorFailedToVerifyOtp(String code) {
    return 'Failed to verify OTP. Server returned code $code';
  }

  @override
  String errorFailedToResendOtp(String code) {
    return 'Failed to resend OTP. Server returned code $code';
  }

  @override
  String errorFailedToSendResetLink(String code) {
    return 'Failed to send reset link. Server returned code $code';
  }

  @override
  String get errorUnknownNetwork => 'Unknown network error occurred';

  @override
  String get errorNetworkCategoryOffers =>
      'Network error while fetching category offers';

  @override
  String get errorEmptyCategoryResponse => 'Empty response from category API';

  @override
  String get errorEmptyHomeResponse => 'Empty response from home API';

  @override
  String successSignIn(String email) {
    return 'Successfully signed in as $email';
  }

  @override
  String get dashboardTitle => 'My Dashboard';

  @override
  String dashboardSubtitle(int orders, int coupons, String period) {
    return 'Showing $orders orders · $coupons coupons · $period';
  }

  @override
  String get searchHint => 'Search orders, coupons...';

  @override
  String get filtersBtn => 'Filters';

  @override
  String get filterTitle => 'Filter';

  @override
  String get filterDateRange => 'Filter by Date Range';

  @override
  String get periodAllTime => 'All time';

  @override
  String get periodToday => 'Today';

  @override
  String get periodLast7Days => 'Last 7 days';

  @override
  String get periodLast30Days => 'Last 30 days';

  @override
  String get periodLast90Days => 'Last 90 days';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodThisYear => 'This year';

  @override
  String get customDateRange => 'Custom Date Range';

  @override
  String get startDate => 'Start date';

  @override
  String get endDate => 'End date';

  @override
  String get filterStatus => 'Filter by Status';

  @override
  String get statusAll => 'All';

  @override
  String get statusActive => 'Active';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusPending => 'Pending';

  @override
  String get filterVendor => 'Filter by Vendor';

  @override
  String get selectVendor => 'Select Vendor';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get resetFilters => 'Reset Filters';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get couponsUsed => 'Coupons Used';

  @override
  String get totalSaved => 'Total Saved';

  @override
  String get activeCoupons => 'Active Coupons';

  @override
  String get myOrders => 'My Orders';

  @override
  String get seeAll => 'See All';

  @override
  String get groceryStore => 'Grocery Store';

  @override
  String get couponRedeemed => 'Coupon Redeemed';

  @override
  String get coffeeShop => 'Coffee Shop';
}
