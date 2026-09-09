class ApiEndpoints {
  static const bool isDevelopment = false; // Set to true for development
  static const String devBaseUrl = 'https://qupon.marbu.in'; // Replace with your dev URL
  static const String prodBaseUrl = 'https://qupon.qa';
  static const String baseUrl = isDevelopment ? devBaseUrl : prodBaseUrl;
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String resendOtp = '/api/auth/resend-otp';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String storefrontHome = '/api/storefront/home';
  static const String categoryDetail = '/api/storefront/categories/';
  static const String pastDeals = '/api/storefront/past-deals';
  static const String cart = '/api/cart';
  static const String paymentGateways = '/api/payment-gateways';
  static const String checkout = '/api/checkout';
  static const String checkoutConfirm = '/api/checkout/confirm';
  static const String categories = '/api/categories';
  static const String dashboard = '/api/me/dashboard';
  static const String wishlist = '/api/me/wishlist';
  static const String orders = '/api/me/orders';
  static const String deleteAccount = '/api/me/delete-account';
  static const String search = '/api/storefront/search';
  static const String storefrontLabels = '/api/storefront/labels/';

  // Web pages / Policy URLs
  static const String privacyPolicyUrl = '$baseUrl/privacy-policy';
  static const String termsUrl = '$baseUrl/terms-and-conditions';
  static const String refundPolicyUrl = '$baseUrl/refund-policy';
  static const String contactUsUrl = '$baseUrl/contact-us';
}

