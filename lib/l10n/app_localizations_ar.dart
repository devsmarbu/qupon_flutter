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
  String get cartEmptyTitle => 'عربة التسوق فارغة';

  @override
  String get cartEmptySubtitle => 'تصفح الصفقات وأضف الكوبونات إلى عربتك.';

  @override
  String get browseDeals => 'تصفح الصفقات';

  @override
  String get pastDealsTitle => 'الصفقات السابقة';

  @override
  String get pastDealsSubtitle =>
      'تصفح العروض المنتهية واطلب إعادة كوبوناتك المفضلة.';

  @override
  String pastDealsCount(int count) {
    return '$count صفقات سابقة';
  }

  @override
  String get expired => 'منتهي الصلاحية';

  @override
  String get requestCoupon => 'اطلب الكوبون';

  @override
  String get requestCouponHint =>
      'مثال: لقد فاتني هذا العرض وأود شراءه مرة أخرى...';

  @override
  String get couponQrCodeTitle => 'رمز الاستجابة السريعة للكوبون';

  @override
  String get qrCodeSubtitle => 'قم بتقديم رمز QR للبائع لاسترداد مشترياتك.';

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
  String get coffeeShop => 'مقهى';

  @override
  String get qrCodeLabel => 'رمز QR';

  @override
  String get showQrCode => 'عرض رمز QR';

  @override
  String get noOffersInCategory => 'لا توجد عروض متاحة في هذه الفئة حالياً';

  @override
  String get couponOptionBasic => 'أساسي';

  @override
  String get couponViewDetails => 'عرض التفاصيل';

  @override
  String get retryLabel => 'إعادة المحاولة';

  @override
  String get noPastDealsAvailable => 'لا توجد عروض سابقة متاحة حالياً.';

  @override
  String get requestCouponShort => 'اطلب الكوبون';

  @override
  String get requestThisCoupon => 'طلب هذا الكوبون';

  @override
  String requestCouponDescription(String name) {
    return 'أخبرنا لماذا تريد إعادة $name. سيراجع البائع والمسؤول رسالتك.';
  }

  @override
  String get yourMessage => 'رسالتك';

  @override
  String get submitRequest => 'إرسال الطلب';

  @override
  String get cancelLabel => 'إلغاء';

  @override
  String get navCategories => 'الفئات';

  @override
  String daysLeftShort(int days) {
    return '$days يوم متبقي';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: 'لا توجد عناصر',
    );
    return '$_temp0';
  }

  @override
  String get myWishlist => 'قائمة رغباتي';

  @override
  String get noItemsInWishlist => 'لا توجد عناصر في قائمة رغباتك حالياً';

  @override
  String get animalCare => 'رعاية الحيوانات';

  @override
  String get animalCareComingSoon => 'عروض رعاية الحيوانات قريباً...';

  @override
  String get foodDrinks => 'مطاعم ومأكولات';

  @override
  String get foodDrinksComingSoon => 'عروض الأطعمة والمشروبات قريباً...';

  @override
  String get failedToLoadOffers => 'فشل تحميل العروض. يرجى المحاولة مرة أخرى.';

  @override
  String get noOffersInCollection =>
      'لا توجد عروض متاحة في هذه المجموعة حالياً';

  @override
  String get searchPlaceholder => 'البحث عن كوبونات، موردين...';

  @override
  String get subtotalLabel => 'المجموع الفرعي';

  @override
  String get recipientPhoneLabel => 'رقم جوال المستلم';

  @override
  String get giftPhoneHint => 'سنرسل رمز/رموز الكوبون إلى هذا الرقم بعد الدفع.';

  @override
  String get qatarPhoneHint =>
      'رقم جوال قطري، 8 أرقام (مثال 50123456 أو +974 50123456).';

  @override
  String get vendorLabel => 'البائع';

  @override
  String get offerLabel => 'العرض';

  @override
  String get codeLabel => 'الكود';

  @override
  String get couponUrlLabel => 'رابط الكوبون';

  @override
  String get couponCopiedClipboard => 'تم نسخ الرابط في الحافظة';

  @override
  String get priceLabel => 'السعر';

  @override
  String get statusLabel => 'الحالة';

  @override
  String get redeemByLabel => 'تاريخ الاسترداد';

  @override
  String get timeLeftLabel => 'الوقت المتبقي';

  @override
  String get dealPrice => 'سعر الصفقة';

  @override
  String get detailsLabel => 'التفاصيل';

  @override
  String get healthWellness => 'صحة وجمال';

  @override
  String get travelTourism => 'سياحة وسفر';

  @override
  String get entertainmentLabel => 'ترفيه';

  @override
  String get beautyLabel => 'الجمال';

  @override
  String get viewCartLabel => 'عرض السلة';

  @override
  String get appNameLabel => 'كوبون';

  @override
  String get thisOfferExpired => 'انتهى هذا العرض';

  @override
  String get openInMaps => 'افتح في الخرائط';

  @override
  String get navAccount => 'الحساب';

  @override
  String get deleteLabel => 'حذف';

  @override
  String get couponCodeQr => 'رمز الكوبون';

  @override
  String get navHome => 'بيت';

  @override
  String get navPastDeals => 'الصفقات السابقة';

  @override
  String get navSearchPlaceholder => 'ابحث عن كوبونات، متاجر...';

  @override
  String get navSearchLoading => 'جاري البحث...';

  @override
  String get navSearchEmpty => 'لم يتم العثور على كوبونات.';

  @override
  String get navSearchError => 'فشل البحث. يرجى المحاولة مرة أخرى.';

  @override
  String get navPortals => 'البوابات:';

  @override
  String get navAdmin => 'المسؤول';

  @override
  String get navVendor => 'البائع';

  @override
  String get navInfluencer => 'المؤثر';

  @override
  String get footerAddress =>
      'الدوحة، قطر، الخليج الغربي، برج الريم، مبنى رقم 37، الطابق 11، مكتب 46، ص.ب 24355';

  @override
  String get footerPhone => 'الهاتف:';

  @override
  String get footerEmail => 'البريد:';

  @override
  String get footerFollowUs => 'تابعنا';

  @override
  String get footerCompany => 'الشركة';

  @override
  String get footerAboutUs => 'من نحن';

  @override
  String get footerCouponPage => 'صفحة الكوبونات';

  @override
  String get footerSupport => 'الدعم';

  @override
  String get footerTerms => 'الشروط والأحكام';

  @override
  String get footerRefundPolicy => 'سياسة الاسترداد';

  @override
  String get footerContactUs => 'اتصل بنا';

  @override
  String get footerPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get footerMyAccount => 'حسابي';

  @override
  String get footerMyOrders => 'طلباتي';

  @override
  String get footerMyWishlist => 'قائمة أمنياتي';

  @override
  String get wishlistTitle => 'قائمة أمنياتي';

  @override
  String get wishlistSubtitle => 'الكوبونات التي حفظتها لاحقاً.';

  @override
  String get wishlistBackDashboard => 'العودة للوحة التحكم';

  @override
  String get wishlistLoading => 'جاري تحميل قائمة الأمنيات…';

  @override
  String get wishlistEmpty => 'قائمة أمنياتك فارغة';

  @override
  String get wishlistEmptyHint => 'اضغط على القلب على أي كوبون لحفظه هنا.';

  @override
  String get wishlistBrowse => 'تصفح الكوبونات';

  @override
  String get wishlistRemove => 'إزالة';

  @override
  String get wishlistRemoved => 'تمت الإزالة من قائمة الأمنيات.';

  @override
  String get wishlistLoadError => 'تعذر تحميل قائمة الأمنيات.';

  @override
  String get wishlistRemoveError => 'تعذر الإزالة من قائمة الأمنيات.';

  @override
  String get footerPortal => 'البوابة';

  @override
  String get footerPortalPartner => 'الشريك';

  @override
  String get footerPoweredByPrefix => 'بدعم من:';

  @override
  String get footerPoweredByBrand => 'بارادايم للتسويق والإعلان';

  @override
  String get cmsScrollTop => 'العودة للأعلى';

  @override
  String get cmsReadMore => 'اقرأ المزيد';

  @override
  String get cmsReadLess => 'اقرأ أقل';

  @override
  String get contactTitle => 'اتصل بنا';

  @override
  String get contactHeroAlt => 'اتصل بكوبون';

  @override
  String get contactSendMessage => 'أرسل رسالة';

  @override
  String get contactGetInTouch => 'تواصل معنا';

  @override
  String get contactName => 'اسمك';

  @override
  String get contactPhone => 'الهاتف';

  @override
  String get contactEmail => 'البريد الإلكتروني';

  @override
  String get contactSubject => 'الموضوع';

  @override
  String get contactMessage => 'رسالتك';

  @override
  String get contactPhoneLabel => 'رقم الهاتف';

  @override
  String get contactEmailLabel => 'البريد الإلكتروني';

  @override
  String get contactLocationLabel => 'موقعنا';

  @override
  String get contactSubmit => 'إرسال';

  @override
  String get contactSubmitting => 'جارٍ الإرسال…';

  @override
  String get contactSubmitSuccess => 'شكراً لك. تم إرسال رسالتك.';

  @override
  String get contactSubmitError => 'تعذر إرسال رسالتك. يرجى المحاولة مرة أخرى.';

  @override
  String get homeLimitedOffer => 'عرض لفترة محدودة';

  @override
  String get homeShopNow => 'تسوق الآن';

  @override
  String get homeShopByCategory => 'تسوق حسب الفئة';

  @override
  String get homeTrendingOffers => '🔥 عروض رائجة';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeActiveOffers => 'عروض نشطة';

  @override
  String get homeBestInFood => '🍔 الأفضل في الطعام';

  @override
  String get homeViewMore => 'عرض المزيد';

  @override
  String get homeTopFashion => '👗 أفضل صفقات الأزياء';

  @override
  String get homeElectronics => '💻 إلكترونيات وتقنية';

  @override
  String get homeSports => '⚽ رياضة وخارجية';

  @override
  String get couponValidTill => 'صالح حتى';

  @override
  String get couponExpired => 'منتهي';

  @override
  String get couponGetCode => 'احصل على الرمز';

  @override
  String get couponViewDeal => 'عرض الصفقة';

  @override
  String get couponOff => 'خصم';

  @override
  String get couponStartingAt => 'تبدأ من';

  @override
  String get couponOfferPrice => 'تدفع';

  @override
  String get couponListPrice => 'كان';

  @override
  String get couponExp => 'ينتهي:';

  @override
  String get couponD => 'ي';

  @override
  String get couponH => 'س';

  @override
  String get couponM => 'د';

  @override
  String get couponS => 'ث';

  @override
  String get couponLeft => 'متبقي';

  @override
  String couponSocialProofShort(Object count) {
    return '🔥 $count عملية شراء';
  }

  @override
  String get couponSocialProofShortOne => '🔥 عملية شراء واحدة';

  @override
  String get couponDetailsAboutDeal => 'وصف العرض';

  @override
  String get couponDetailsHowToUse => 'كيفية الاستخدام';

  @override
  String get couponDetailsTerms => 'الشروط والأحكام';

  @override
  String get couponDetailsAboutVendor => 'تفاصيل البائع';

  @override
  String get couponDetailsVisitStore => 'زيارة المتجر';

  @override
  String get couponDetailsSelectOption => 'اختر المتغير';

  @override
  String get couponDetailsViewVendor => 'عرض ملف تعريف البائع';

  @override
  String get couponDetailsDiscount => 'الخصم';

  @override
  String get couponDetailsImportantNotes => 'ملاحظات هامة';

  @override
  String get couponDetailsPrice => 'المبلغ المستحق';

  @override
  String get couponDetailsYouPay => 'المبلغ المستحق';

  @override
  String get couponDetailsYouSave => 'انت وفرت';

  @override
  String get couponDetailsGetDeal => 'احصل على الصفقة الآن';

  @override
  String get couponDetailsBuyAsGift => 'شراء كهدية';

  @override
  String get couponDetailsSave => 'حفظ';

  @override
  String get couponDetailsSaved => 'تم الحفظ';

  @override
  String get couponDetailsWishlist => 'أضف إلى قائمة الأمنيات';

  @override
  String get couponDetailsWishlistSaved => 'إزالة من قائمة الأمنيات';

  @override
  String get couponDetailsCart => 'عربة التسوق';

  @override
  String get couponDetailsCheckout => 'الدفع';

  @override
  String get couponDetailsBack => 'العودة للقوائم';

  @override
  String get couponDetailsPurchaseProgress => 'توفر الشراء';

  @override
  String get couponDetailsPurchased => 'تم شراؤها';

  @override
  String couponDetailsSocialProof(Object count) {
    return '🔥 $count شخصاً حصلوا على هذه الصفقة';
  }

  @override
  String get couponDetailsSocialProofOne => '🔥 شخص واحد حصل على هذه الصفقة';

  @override
  String get couponDetailsSocialProofFirst => '✨ كن أول من يحصل على هذه الصفقة';

  @override
  String get couponDetailsOf => 'من';

  @override
  String get couponDetailsRemaining => 'متبقية';

  @override
  String get couponDetailsSoldOut => 'نفدت الكمية';

  @override
  String get couponDetailsSoldOutHint =>
      'وصل هذا الكوبون إلى الحد الأقصى للشراء.';

  @override
  String get couponDetailsExpiredTitle => 'انتهى هذا العرض';

  @override
  String get couponDetailsExpiredMessage =>
      'لم يعد هذا الكوبون متاحاً للشراء. يمكنك طلبه من الصفقات السابقة وسنبلغ البائع.';

  @override
  String get couponDetailsNotPublishedMessage => 'لم يتم نشر هذا الكوبون.';

  @override
  String get couponDetailsRequestCoupon => 'طلب الكوبون';

  @override
  String get couponDetailsShare => 'مشاركة';

  @override
  String get couponShareTitle => 'مشاركة';

  @override
  String get couponShareDescription =>
      'أرسل هذا العرض إلى الأصدقاء أو انسخ الرابط.';

  @override
  String get couponShareLinkLabel => 'رابط الكوبون';

  @override
  String get couponShareCopyBtn => 'نسخ';

  @override
  String get couponShareCopiedBtn => 'تم النسخ';

  @override
  String get couponShareCopied => 'تم نسخ الرابط';

  @override
  String get couponShareCopyFailed => 'تعذر نسخ الرابط. انسخه يدويًا.';

  @override
  String get couponShareNative => 'مشاركة عبر الجهاز';

  @override
  String get couponShareNativeFailed => 'تم إلغاء المشاركة أو أنها غير متاحة.';

  @override
  String get vendorProfileBack => 'العودة للرئيسية';

  @override
  String get vendorProfileAbout => 'نبذة';

  @override
  String get vendorProfileContact => 'تواصل';

  @override
  String get vendorProfileFollowUs => 'تابعنا';

  @override
  String get vendorProfileLandline => 'هاتف أرضي';

  @override
  String get vendorProfileOffers => 'عروض';

  @override
  String get vendorProfileNoOffersTitle => 'لا توجد عروض نشطة';

  @override
  String get vendorProfileNoOffersDesc =>
      'لا يوجد لدى هذا البائع كوبونات نشطة حالياً.';

  @override
  String get couponFormMaxPurchases => 'إجمالي الكوبونات المتاحة للشراء';

  @override
  String get couponFormMaxPurchasesHint =>
      'الحد الأقصى لعدد العملاء الذين يمكنهم شراء هذا الكوبون. اتركه فارغًا لعدم التحديد.';

  @override
  String get cartTitle => 'عربة التسوق';

  @override
  String get cartContinueShopping => 'متابعة التسوق';

  @override
  String get cartEmptyDesc => 'تصفح العروض وأضف الكوبونات إلى عربتك.';

  @override
  String get cartBrowseDeals => 'تصفح العروض';

  @override
  String get cartOrderSummary => 'ملخص الطلب';

  @override
  String get cartSubtotal => 'المجموع الفرعي';

  @override
  String get cartTotalSavings => 'إجمالي التوفير';

  @override
  String get cartTotal => 'الإجمالي';

  @override
  String get cartPayVia => 'الدفع عبر';

  @override
  String get cartBalance => 'الرصيد';

  @override
  String get cartCheckout => 'الدفع';

  @override
  String get cartProcessing => 'جاري المعالجة…';

  @override
  String get cartNoPaymentMethods => 'لا توجد طرق دفع متاحة.';

  @override
  String get cartAdded => 'تمت الإضافة إلى السلة';

  @override
  String get cartExpiredInCart =>
      'انتهت صلاحية عنصر أو أكثر في سلتك. أزلها للمتابعة.';

  @override
  String get checkoutGiftTitle => 'إهداء هذا الطلب';

  @override
  String get checkoutGiftDesc => 'أرسل تفاصيل الكوبون لشخص آخر عبر رسالة نصية.';

  @override
  String get checkoutGiftPhoneLabel => 'رقم جوال المستلم';

  @override
  String get checkoutGiftPhoneHint =>
      'سنرسل رمز/رموز الكوبون إلى هذا الرقم بعد الدفع.';

  @override
  String get commonQatarPhoneHint =>
      'رقم قطري من 8 أرقام (مثل 50123456 أو +974 50123456).';

  @override
  String pastDealsTotal(Object count) {
    return '$count صفقة سابقة';
  }

  @override
  String get pastDealsLoadingMore => 'جاري تحميل المزيد…';

  @override
  String get pastDealsRequestButton => 'طلب الكوبون';

  @override
  String get pastDealsRequestTitle => 'اطلب هذا الكوبون';

  @override
  String pastDealsRequestDescription(Object name) {
    return 'أخبرنا لماذا تريد إعادة $name. سيراجع البائع والمسؤول رسالتك.';
  }

  @override
  String get pastDealsRequestDescriptionGeneric =>
      'أخبرنا لماذا تريد إعادة هذا الكوبون.';

  @override
  String get pastDealsMessageLabel => 'رسالتك';

  @override
  String get pastDealsMessagePlaceholder =>
      'مثال: فاتني هذا العرض وأود شراءه مرة أخرى…';

  @override
  String get pastDealsMessageRequired => 'يرجى إدخال رسالة.';

  @override
  String get pastDealsSubmit => 'إرسال الطلب';

  @override
  String get pastDealsSubmitting => 'جاري الإرسال…';

  @override
  String get pastDealsCancel => 'إلغاء';

  @override
  String get pastDealsSubmitSuccess => 'تم إرسال طلبك بنجاح.';

  @override
  String get pastDealsSubmitError => 'تعذر إرسال طلبك. يرجى المحاولة مرة أخرى.';

  @override
  String get pastDealsEmptyTitle => 'لا توجد صفقات سابقة بعد';

  @override
  String get pastDealsEmptyHint =>
      'ستظهر الكوبونات المنتهية هنا بعد انتهاء العروض.';

  @override
  String get pastDealsNoMatch => 'لا توجد صفقات سابقة تطابق بحثك';

  @override
  String get pastDealsNoMatchHint => 'جرّب كلمة مختلفة أو امسح البحث.';

  @override
  String get pastDealsClearSearch => 'مسح البحث';

  @override
  String get filterAllTime => 'كل الوقت';

  @override
  String get filterStatusActive => 'نشط';

  @override
  String get filterStatusExpired => 'منتهي';

  @override
  String get filterStatusPending => 'معلق';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterDateLabel => 'التاريخ: ';

  @override
  String get filterStatusLabel => 'الحالة: ';

  @override
  String get filterVendorLabel => 'المورد: ';

  @override
  String get awaitingRedemption => 'في انتظار الاسترداد';

  @override
  String get redeemedLabel => 'تم الاسترداد';

  @override
  String get shopByCategory => 'تسوق حسب الفئة';

  @override
  String get electronicsLabel => 'إلكترونيات';

  @override
  String get viewAllLabel => 'عرض الكل';

  @override
  String get qrDialogVendor => 'البائع';

  @override
  String get qrDialogOffer => 'العرض';

  @override
  String get qrDialogStatus => 'الحالة';

  @override
  String get qrDialogOrderRef => 'مرجع الطلب';

  @override
  String get qrDialogExpiry => 'تاريخ الانتهاء';

  @override
  String get qrDialogRedeemCode => 'رمز الاسترداد';

  @override
  String get qrDialogClose => 'إغلاق';
}
