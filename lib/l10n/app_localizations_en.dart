// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Login';

  @override
  String get userCode => 'User Code';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get userCodeHint => 'Enter user code';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get userCodeRequired => 'User code is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get propertyBooking => 'Property Booking';
}
