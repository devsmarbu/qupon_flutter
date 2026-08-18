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
  String get requestCouponHint =>
      'e.g. I missed this deal and would love to buy it again...';

  @override
  String get couponQrCodeTitle => 'Your Coupon QR Code';

  @override
  String get qrCodeSubtitle =>
      'Show this QR code to the vendor to redeem your purchase.';

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
  String get coffeeShop => 'Coffee Shop';

  @override
  String get qrCodeLabel => 'QR Code';

  @override
  String get showQrCode => 'Show QR Code';

  @override
  String get noOffersInCategory => 'No offers available in this category.';

  @override
  String get couponOptionBasic => 'Basic';

  @override
  String get couponViewDetails => 'View Details';

  @override
  String get retryLabel => 'Retry';

  @override
  String get noPastDealsAvailable => 'No past deals available';

  @override
  String get requestCouponShort => 'Request';

  @override
  String get requestThisCoupon => 'Request this coupon';

  @override
  String requestCouponDescription(String name) {
    return 'Tell us why you want $name back. The vendor and admin will review your message.';
  }

  @override
  String get yourMessage => 'Your Message';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get navCategories => 'Categories';

  @override
  String daysLeftShort(int days) {
    return '${days}d left';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'items',
      one: 'item',
    );
    return '$count $_temp0';
  }

  @override
  String get myWishlist => 'My Wishlist';

  @override
  String get noItemsInWishlist => 'No items in your wishlist yet';

  @override
  String get animalCare => 'Animal Care';

  @override
  String get animalCareComingSoon => 'Animal Care offers coming soon...';

  @override
  String get foodDrinks => 'Food & Drinks';

  @override
  String get foodDrinksComingSoon => 'Food & Drinks offers coming soon...';

  @override
  String get failedToLoadOffers => 'Failed to load offers. Please try again.';

  @override
  String get noOffersInCollection =>
      'No offers available in this collection currently';

  @override
  String get searchPlaceholder => 'Search for coupons, vendors...';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get recipientPhoneLabel => 'Recipient Phone';

  @override
  String get giftPhoneHint =>
      'We will send the coupon code(s) to this number after payment.';

  @override
  String get qatarPhoneHint =>
      'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).';

  @override
  String get vendorLabel => 'Vendor';

  @override
  String get offerLabel => 'Offer';

  @override
  String get codeLabel => 'Code';

  @override
  String get couponUrlLabel => 'Coupon URL';

  @override
  String get couponCopiedClipboard => 'Link copied to clipboard';

  @override
  String get priceLabel => 'Price';

  @override
  String get statusLabel => 'Status';

  @override
  String get redeemByLabel => 'Redeem By';

  @override
  String get timeLeftLabel => 'Time Left';

  @override
  String get dealPrice => 'Deal Price';

  @override
  String get detailsLabel => 'Details';

  @override
  String get healthWellness => 'Health & Wellness';

  @override
  String get travelTourism => 'Travel & Tourism';

  @override
  String get entertainmentLabel => 'Entertainment';

  @override
  String get beautyLabel => 'Beauty';

  @override
  String get viewCartLabel => 'View Cart';

  @override
  String get appNameLabel => 'Qupon';

  @override
  String get thisOfferExpired => 'This Offer has Expired';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get navAccount => 'Account';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get couponCodeQr => 'Coupon Code';

  @override
  String get navHome => 'Homes';

  @override
  String get navPastDeals => 'Past Deals';

  @override
  String get navSearchPlaceholder => 'Search for coupons, vendors...';

  @override
  String get navSearchLoading => 'Searching...';

  @override
  String get navSearchEmpty => 'No coupons found.';

  @override
  String get navSearchError => 'Search failed. Please try again.';

  @override
  String get navPortals => 'Portals:';

  @override
  String get navAdmin => 'Admin';

  @override
  String get navVendor => 'Vendor';

  @override
  String get navInfluencer => 'Influencer';

  @override
  String get footerAddress =>
      'Doha, Qatar, West Bay, Al Reem Tower, Building number 37, 11th floor, office 46, P.O. Box 24355';

  @override
  String get footerPhone => 'Phone:';

  @override
  String get footerEmail => 'Email:';

  @override
  String get footerFollowUs => 'Follow Us';

  @override
  String get footerCompany => 'Company';

  @override
  String get footerAboutUs => 'About Us';

  @override
  String get footerCouponPage => 'Coupon Page';

  @override
  String get footerSupport => 'Support';

  @override
  String get footerTerms => 'Terms & Conditions';

  @override
  String get footerRefundPolicy => 'Refund Policy';

  @override
  String get footerContactUs => 'Contact Us';

  @override
  String get footerPrivacyPolicy => 'Privacy Policy';

  @override
  String get footerMyAccount => 'My Account';

  @override
  String get footerMyOrders => 'My Orders';

  @override
  String get footerMyWishlist => 'My Wishlist';

  @override
  String get wishlistTitle => 'My Wishlist';

  @override
  String get wishlistSubtitle => 'Coupons you saved for later.';

  @override
  String get wishlistBackDashboard => 'Back to dashboard';

  @override
  String get wishlistLoading => 'Loading wishlist…';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get wishlistEmptyHint => 'Tap the heart on a coupon to save it here.';

  @override
  String get wishlistBrowse => 'Browse coupons';

  @override
  String get wishlistRemove => 'Remove';

  @override
  String get wishlistRemoved => 'Removed from wishlist.';

  @override
  String get wishlistLoadError => 'Could not load wishlist.';

  @override
  String get wishlistRemoveError => 'Could not remove from wishlist.';

  @override
  String get footerPortal => 'Portal';

  @override
  String get footerPortalPartner => 'Partner';

  @override
  String get footerPoweredByPrefix => 'Powered by:';

  @override
  String get footerPoweredByBrand => 'Paradigm Marketing And Advertising';

  @override
  String get cmsScrollTop => 'Scroll to top';

  @override
  String get cmsReadMore => 'Read More';

  @override
  String get cmsReadLess => 'Read Less';

  @override
  String get contactTitle => 'Contact Us';

  @override
  String get contactHeroAlt => 'Contact Qupon';

  @override
  String get contactSendMessage => 'Send A Message';

  @override
  String get contactGetInTouch => 'Get In Touch';

  @override
  String get contactName => 'Your Name';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactSubject => 'Subject';

  @override
  String get contactMessage => 'Your Message';

  @override
  String get contactPhoneLabel => 'Phone Number';

  @override
  String get contactEmailLabel => 'Email Address';

  @override
  String get contactLocationLabel => 'Our Location';

  @override
  String get contactSubmit => 'Submit';

  @override
  String get contactSubmitting => 'Sending…';

  @override
  String get contactSubmitSuccess => 'Thank you. Your message has been sent.';

  @override
  String get contactSubmitError =>
      'We could not send your message. Please try again.';

  @override
  String get homeLimitedOffer => 'Limited Time Offer';

  @override
  String get homeShopNow => 'Shop Now';

  @override
  String get homeShopByCategory => 'Shop by Category';

  @override
  String get homeTrendingOffers => '🔥 Trending Offers';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeActiveOffers => 'Active Offers';

  @override
  String get homeBestInFood => '🍔 Best in Food';

  @override
  String get homeViewMore => 'View More';

  @override
  String get homeTopFashion => '👗 Top Fashion Deals';

  @override
  String get homeElectronics => '💻 Electronics & Tech';

  @override
  String get homeSports => '⚽ Sports & Outdoors';

  @override
  String get couponValidTill => 'Valid till';

  @override
  String get couponExpired => 'Expired';

  @override
  String get couponGetCode => 'Get Code';

  @override
  String get couponViewDeal => 'View Deal';

  @override
  String get couponOff => 'OFF';

  @override
  String get couponStartingAt => 'Starting at';

  @override
  String get couponOfferPrice => 'You pay';

  @override
  String get couponListPrice => 'Was';

  @override
  String get couponExp => 'Exp:';

  @override
  String get couponD => 'd';

  @override
  String get couponH => 'h';

  @override
  String get couponM => 'm';

  @override
  String get couponS => 's';

  @override
  String get couponLeft => 'left';

  @override
  String couponSocialProofShort(Object count) {
    return '🔥 $count bought';
  }

  @override
  String get couponSocialProofShortOne => '🔥 1 bought';

  @override
  String get couponDetailsAboutDeal => 'Offer Description';

  @override
  String get couponDetailsHowToUse => 'How to Use';

  @override
  String get couponDetailsTerms => 'Terms & Conditions';

  @override
  String get couponDetailsAboutVendor => 'Vendor Details';

  @override
  String get couponDetailsVisitStore => 'Visit Store';

  @override
  String get couponDetailsSelectOption => 'Select Option';

  @override
  String get couponDetailsViewVendor => 'View Vendor Profile';

  @override
  String get couponDetailsDiscount => 'Discount';

  @override
  String get couponDetailsImportantNotes => 'Important Notes';

  @override
  String get couponDetailsPrice => 'You pay';

  @override
  String get couponDetailsYouPay => 'You pay';

  @override
  String get couponDetailsYouSave => 'You save';

  @override
  String get couponDetailsGetDeal => 'Get Deal Now';

  @override
  String get couponDetailsBuyAsGift => 'Buy as Gift';

  @override
  String get couponDetailsSave => 'Save';

  @override
  String get couponDetailsSaved => 'Saved';

  @override
  String get couponDetailsWishlist => 'Add to wishlist';

  @override
  String get couponDetailsWishlistSaved => 'Remove from wishlist';

  @override
  String get couponDetailsCart => 'Cart';

  @override
  String get couponDetailsCheckout => 'Checkout';

  @override
  String get couponDetailsBack => 'Back to Listings';

  @override
  String get couponDetailsPurchaseProgress => 'Purchase availability';

  @override
  String get couponDetailsPurchased => 'purchased';

  @override
  String couponDetailsSocialProof(Object count) {
    return '🔥 $count people grabbed this deal';
  }

  @override
  String get couponDetailsSocialProofOne => '🔥 1 person grabbed this deal';

  @override
  String get couponDetailsSocialProofFirst =>
      '✨ Be the first to grab this deal';

  @override
  String get couponDetailsOf => 'of';

  @override
  String get couponDetailsRemaining => 'left';

  @override
  String get couponDetailsSoldOut => 'Sold out';

  @override
  String get couponDetailsSoldOutHint =>
      'This coupon has reached its purchase limit.';

  @override
  String get couponDetailsExpiredTitle => 'This offer has expired';

  @override
  String get couponDetailsExpiredMessage =>
      'This coupon is no longer available for purchase. You can request it from Past Deals and we will notify the vendor.';

  @override
  String get couponDetailsNotPublishedMessage =>
      'This coupon has not been published.';

  @override
  String get couponDetailsRequestCoupon => 'Request Coupon';

  @override
  String get couponDetailsShare => 'Share';

  @override
  String get couponShareTitle => 'Share';

  @override
  String get couponShareDescription =>
      'Send this deal to friends or copy the link.';

  @override
  String get couponShareLinkLabel => 'Coupon link';

  @override
  String get couponShareCopyBtn => 'Copy';

  @override
  String get couponShareCopiedBtn => 'Copied';

  @override
  String get couponShareCopied => 'Link copied to clipboard';

  @override
  String get couponShareCopyFailed =>
      'Could not copy link. Please copy it manually.';

  @override
  String get couponShareNative => 'Share via device';

  @override
  String get couponShareNativeFailed =>
      'Sharing was cancelled or is not available.';

  @override
  String get vendorProfileBack => 'Back to Home';

  @override
  String get vendorProfileAbout => 'About';

  @override
  String get vendorProfileContact => 'Contact';

  @override
  String get vendorProfileFollowUs => 'Follow us';

  @override
  String get vendorProfileLandline => 'Landline';

  @override
  String get vendorProfileOffers => 'Offers by';

  @override
  String get vendorProfileNoOffersTitle => 'No Active Offers';

  @override
  String get vendorProfileNoOffersDesc =>
      'This vendor currently doesn\'t have any active coupons available.';

  @override
  String get couponFormMaxPurchases => 'Total coupons available for purchase';

  @override
  String get couponFormMaxPurchasesHint =>
      'Maximum number of customers who can buy this coupon. Leave blank for unlimited.';

  @override
  String get cartTitle => 'Shopping Cart';

  @override
  String get cartContinueShopping => 'Continue shopping';

  @override
  String get cartEmptyDesc => 'Browse deals and add coupons to your cart.';

  @override
  String get cartBrowseDeals => 'Browse deals';

  @override
  String get cartOrderSummary => 'Order summary';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartTotalSavings => 'Total savings';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartPayVia => 'Pay via';

  @override
  String get cartBalance => 'Balance';

  @override
  String get cartCheckout => 'Checkout';

  @override
  String get cartProcessing => 'Processing…';

  @override
  String get cartNoPaymentMethods => 'No payment methods available.';

  @override
  String get cartAdded => 'Added to cart';

  @override
  String get cartExpiredInCart =>
      'One or more items in your cart have expired. Remove them to continue.';

  @override
  String get checkoutGiftTitle => 'Gift this order';

  @override
  String get checkoutGiftDesc =>
      'Send the coupon details to someone else by SMS.';

  @override
  String get checkoutGiftPhoneLabel => 'Recipient mobile number';

  @override
  String get checkoutGiftPhoneHint =>
      'We will text the coupon code(s) to this number after payment.';

  @override
  String get commonQatarPhoneHint =>
      'Qatar mobile number, 8 digits (e.g. 50123456 or +974 50123456).';

  @override
  String pastDealsTotal(Object count) {
    return '$count past deals';
  }

  @override
  String get pastDealsLoadingMore => 'Loading more…';

  @override
  String get pastDealsRequestButton => 'Request Coupon';

  @override
  String get pastDealsRequestTitle => 'Request this coupon';

  @override
  String pastDealsRequestDescription(Object name) {
    return 'Tell us why you want $name back. The vendor and admin will review your message.';
  }

  @override
  String get pastDealsRequestDescriptionGeneric =>
      'Tell us why you want this coupon back.';

  @override
  String get pastDealsMessageLabel => 'Your message';

  @override
  String get pastDealsMessagePlaceholder =>
      'e.g. I missed this deal and would love to buy it again…';

  @override
  String get pastDealsMessageRequired => 'Please enter a message.';

  @override
  String get pastDealsSubmit => 'Submit request';

  @override
  String get pastDealsSubmitting => 'Submitting…';

  @override
  String get pastDealsCancel => 'Cancel';

  @override
  String get pastDealsSubmitSuccess => 'Your request was sent successfully.';

  @override
  String get pastDealsSubmitError =>
      'Could not send your request. Please try again.';

  @override
  String get pastDealsEmptyTitle => 'No past deals yet';

  @override
  String get pastDealsEmptyHint =>
      'Expired coupons will appear here once offers end.';

  @override
  String get pastDealsNoMatch => 'No past deals match your search';

  @override
  String get pastDealsNoMatchHint =>
      'Try a different keyword or clear the search.';

  @override
  String get pastDealsClearSearch => 'Clear search';

  @override
  String get filterAllTime => 'All Time';

  @override
  String get filterStatusActive => 'Active';

  @override
  String get filterStatusExpired => 'Expired';

  @override
  String get filterStatusPending => 'Pending';

  @override
  String get filterAll => 'All';

  @override
  String get filterDateLabel => 'Date: ';

  @override
  String get filterStatusLabel => 'Status: ';

  @override
  String get filterVendorLabel => 'Vendor: ';

  @override
  String get awaitingRedemption => 'Awaiting Redemption';

  @override
  String get redeemedLabel => 'Redeemed';

  @override
  String get shopByCategory => 'Shop By Category';

  @override
  String get electronicsLabel => 'Electronics';

  @override
  String get viewAllLabel => 'View All';

  @override
  String get qrDialogVendor => 'Vendor';

  @override
  String get qrDialogOffer => 'Offer';

  @override
  String get qrDialogStatus => 'Status';

  @override
  String get qrDialogOrderRef => 'Order Ref';

  @override
  String get qrDialogExpiry => 'Expiry';

  @override
  String get qrDialogRedeemCode => 'Redeem Code';

  @override
  String get qrDialogClose => 'Close';
}
