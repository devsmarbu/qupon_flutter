class ApiEndpoints {
  static const String baseUrl = 'https://qupon.marbu.in';
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
}
