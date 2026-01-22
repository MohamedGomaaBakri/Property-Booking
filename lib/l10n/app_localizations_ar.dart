// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get userCode => 'كود المستخدم';

  @override
  String get password => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get userCodeHint => 'أدخل كود المستخدم';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get userCodeRequired => 'كود المستخدم مطلوب';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get logoText => 'Arab Investors \n for Projects management';

  @override
  String get propertyBooking => 'حجز العقارات';

  @override
  String get loginError => 'خطأ في تسجيل الدخول';

  @override
  String get invalidCredentials => 'كود المستخدم أو كلمة المرور غير صحيحة';

  @override
  String get userNotFound => 'كود المستخدم غير موجود';

  @override
  String get invalidPassword => 'كلمة المرور غير صحيحة';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get welcomeBack => 'مرحباً بعودتك،';

  @override
  String get guest => 'ضيف';

  @override
  String get propertyManager => 'مدير العقارات';

  @override
  String get availableZones => 'المناطق المتاحة';

  @override
  String get errorLoadingZones => 'خطأ في تحميل المناطق';

  @override
  String get pleaseTryAgainLater => 'يرجى المحاولة مرة أخرى لاحقاً';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noZonesAvailable => 'لا توجد مناطق متاحة';

  @override
  String get checkBackLaterForUpdates => 'تحقق لاحقاً للحصول على التحديثات';

  @override
  String get projects => 'المشاريع';

  @override
  String get errorLoadingProjects => 'خطأ في تحميل المشاريع';

  @override
  String get noProjectsAvailable => 'لا توجد مشاريع متاحة';

  @override
  String get noProjectsFoundInZone => 'لم يتم العثور على مشاريع في هذه المنطقة';

  @override
  String get unknownZone => 'منطقة غير معروفة';

  @override
  String get zoneCode => 'كود المنطقة: ';

  @override
  String get unknownProject => 'مشروع غير معروف';

  @override
  String get projectCode => 'كود المشروع: ';
}
