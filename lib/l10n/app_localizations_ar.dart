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
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get propertyBooking => 'حجز العقارات';
}
