// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كوبون';

  @override
  String get back => 'رجوع';

  @override
  String get beautyAndSpa => 'التجميل والسبا';

  @override
  String offersAvailable(int count) {
    return '$count عرض متاح';
  }

  @override
  String get locationDoha => '٨٧٤ شارع القوافل، (فندق أجنحة الضيافة) الدوحة';

  @override
  String get offerDescription =>
      'ليلة واحدة لشخصين بالغين وطفلين في غرفة ديلوكس';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String qarPrice(String price) {
    return '$price ر.ق';
  }

  @override
  String timeLeft(int days, int hours, int minutes) {
    return 'متبقي $days يوم و $hours ساعة و $minutes دقيقة';
  }

  @override
  String get offerTitle => 'أبو ظبي: ليلة واحدة لشخصين شاملة الإفطار...';

  @override
  String get drawerHome => 'الرئيسية';

  @override
  String get drawerOffers => 'عروضي';

  @override
  String get drawerCart => 'سلة المشتريات';

  @override
  String get drawerProfile => 'الملف الشخصي';

  @override
  String get drawerSettings => 'الإعدادات';

  @override
  String get drawerLanguage => 'اللغة';

  @override
  String get toggleLanguage => 'English';

  @override
  String get continueShopping => 'الاستمرار في التسوق';

  @override
  String get shoppingCartTitle => 'عربة التسوق';

  @override
  String get cartEmptyTitle => 'عربتك فارغة';

  @override
  String get cartEmptySubtitle => 'تصفح الصفقات وأضف الكوبونات إلى عربتك.';

  @override
  String get browseDeals => 'تصفح الصفقات';

  @override
  String get pastDealsTitle => 'الصفقات السابقة';

  @override
  String get pastDealsSubtitle =>
      'تصفح العروض منتهية الصلاحية واطلب كوبوناتك المفضلة للعودة.';

  @override
  String pastDealsCount(int count) {
    return '$count صفقات سابقة';
  }

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get requestCoupon => 'اطلب الكوبون';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String subtotal(int count) {
    return 'المجموع الفرعي ($count)';
  }

  @override
  String get totalSavings => 'إجمالي التوفير';

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get giftThisOrder => 'إهداء هذا الطلب';

  @override
  String get giftSubtitle =>
      'أرسل تفاصيل الكوبون لشخص آخر عبر الرسائل النصية القصيرة.';

  @override
  String get payVia => 'الدفع عن طريق';

  @override
  String get stripe => 'سترايب';

  @override
  String get wallet => 'المحفظة';

  @override
  String walletBalance(String balance) {
    return 'الرصيد: $balance ر.ق';
  }

  @override
  String get skipCash => 'سكيب كاش';

  @override
  String get checkoutLabel => 'الدفع';

  @override
  String checkoutWithPrice(String price) {
    return 'الدفع · $price ر.ق';
  }

  @override
  String youSave(String amount) {
    return 'وفرت $amount ر.ق';
  }

  @override
  String get checkoutSuccessTitle => 'تم تقديم الطلب بنجاح!';

  @override
  String get checkoutSuccessMessage =>
      'تم إرسال تفاصيل الكوبون الخاص بك. شكراً لتسوقك مع كوبون!';

  @override
  String get goBackHome => 'العودة للرئيسية';

  @override
  String get welcomeTitle => 'مرحباً';

  @override
  String get welcomeSubtitle => 'ابدأ باستخدام حسابك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get byContinuing => 'بالاستمرار، فإنك توافق على ';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get and => ' و ';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'yourname@domain.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => '........';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'سجل الآن';

  @override
  String get orLoginWith => 'أو سجل الدخول عبر';

  @override
  String get google => 'جوجل';

  @override
  String get facebook => 'فيسبوك';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'جون دو';

  @override
  String get emailHintRegister => 'john@example.com';

  @override
  String get passwordHintRegister => '........';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get phoneNumberHint => '٥٥٥٥ ٥٥٥٥';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => '........';

  @override
  String get registerButton => 'تسجيل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get backToStorefront => 'العودة إلى المتجر';

  @override
  String get errorEmailEmpty => 'البريد الإلكتروني لا يمكن أن يكون فارغاً';

  @override
  String get errorInvalidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get errorPasswordEmpty => 'كلمة المرور لا يمكن أن تكون فارغة';

  @override
  String get errorPasswordLength => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get errorFullNameEmpty => 'الاسم الكامل لا يمكن أن يكون فارغاً';

  @override
  String get errorPhoneEmpty => 'رقم الهاتف لا يمكن أن يكون فارغاً';

  @override
  String get errorInvalidQatarPhone =>
      'الرجاء إدخال رقم هاتف قطري صحيح مكون من 8 أرقام';

  @override
  String get errorInvalidPhoneWithCountryCode =>
      'الرجاء إدخال رقم هاتف محمول صحيح مع رمز الدولة';

  @override
  String get errorPasswordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorOtpEmpty => 'رمز التحقق لا يمكن أن يكون فارغاً';

  @override
  String get errorOtpLength =>
      'رمز التحقق يجب أن يكون مكوناً من 6 أرقام بالضبط';

  @override
  String get errorGoogleSignInNotConfigured =>
      'تسجيل الدخول باستخدام جوجل غير مهيأ بعد.';

  @override
  String get errorFacebookSignInNotConfigured =>
      'تسجيل الدخول باستخدام فيسبوك غير مهيأ بعد.';

  @override
  String get successRegistration =>
      'تم التسجيل بنجاح! الرجاء التحقق من رقم الهاتف الخاص بك.';

  @override
  String get successOtpVerified =>
      'تم التحقق من رمز التحقق بنجاح! الرجاء تسجيل الدخول.';

  @override
  String get successOtpResent => 'تم إعادة إرسال رمز التحقق بنجاح!';

  @override
  String get successResetLinkSent => 'تم إرسال رابط إعادة التعيين بنجاح!';

  @override
  String errorFailedToRegister(String code) {
    return 'فشل التسجيل. أرجع الخادم الرمز $code';
  }

  @override
  String errorFailedToLogin(String code) {
    return 'فشل تسجيل الدخول. أرجع الخادم الرمز $code';
  }

  @override
  String errorFailedToVerifyOtp(String code) {
    return 'فشل التحقق من رمز التحقق. أرجع الخادم الرمز $code';
  }

  @override
  String errorFailedToResendOtp(String code) {
    return 'فشل إعادة إرسال رمز التحقق. أرجع الخادم الرمز $code';
  }

  @override
  String errorFailedToSendResetLink(String code) {
    return 'فشل إرسال رابط إعادة التعيين. أرجع الخادم الرمز $code';
  }

  @override
  String get errorUnknownNetwork => 'حدث خطأ غير معروف في الشبكة';

  @override
  String get errorNetworkCategoryOffers => 'خطأ في الشبكة أثناء جلب عروض الفئة';

  @override
  String get errorEmptyCategoryResponse =>
      'استجابة فارغة من واجهة برمجة التطبيقات للفئة';

  @override
  String get errorEmptyHomeResponse =>
      'استجابة فارغة من واجهة برمجة التطبيقات للرئيسية';

  @override
  String successSignIn(String email) {
    return 'تم تسجيل الدخول بنجاح كـ $email';
  }

  @override
  String get dashboardTitle => 'لوحة التحكم الخاصة بي';

  @override
  String dashboardSubtitle(int orders, int coupons, String period) {
    return 'عرض $orders طلبات · $coupons كوبونات · $period';
  }

  @override
  String get searchHint => 'البحث في الطلبات، الكوبونات...';

  @override
  String get filtersBtn => 'تصفية';

  @override
  String get filterTitle => 'فلتر';

  @override
  String get filterDateRange => 'تصفية حسب النطاق الزمني';

  @override
  String get periodAllTime => 'كل الوقت';

  @override
  String get periodToday => 'اليوم';

  @override
  String get periodLast7Days => 'آخر 7 أيام';

  @override
  String get periodLast30Days => 'آخر 30 يوم';

  @override
  String get periodLast90Days => 'آخر 90 يوم';

  @override
  String get periodThisMonth => 'هذا الشهر';

  @override
  String get periodThisYear => 'هذه السنة';

  @override
  String get customDateRange => 'نطاق تاريخ مخصص';

  @override
  String get startDate => 'تاريخ البدء';

  @override
  String get endDate => 'تاريخ الانتهاء';

  @override
  String get filterStatus => 'تصفية حسب الحالة';

  @override
  String get statusAll => 'الكل';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusExpired => 'منتهي الصلاحية';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get filterVendor => 'تصفية حسب البائع';

  @override
  String get selectVendor => 'اختر البائع';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get resetFilters => 'إعادة ضبط الفلاتر';

  @override
  String get totalSpent => 'إجمالي الإنفاق';

  @override
  String get couponsUsed => 'الكوبونات المستخدمة';

  @override
  String get totalSaved => 'إجمالي المدخرات';

  @override
  String get activeCoupons => 'الكوبونات النشطة';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get groceryStore => 'متجر البقالة';

  @override
  String get couponRedeemed => 'تم استخدام الكوبون';

  @override
  String get coffeeShop => 'مقهى';
}
