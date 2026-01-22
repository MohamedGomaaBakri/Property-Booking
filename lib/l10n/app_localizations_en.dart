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
  String get logoText => 'Arab Investors \n for Projects management';

  @override
  String get propertyBooking => 'Property Booking';

  @override
  String get loginError => 'Login Error';

  @override
  String get invalidCredentials => 'Invalid user code or password';

  @override
  String get userNotFound => 'User code not found';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String get guest => 'Guest';

  @override
  String get propertyManager => 'Property Manager';

  @override
  String get availableZones => 'Available Zones';

  @override
  String get errorLoadingZones => 'Error loading zones';

  @override
  String get pleaseTryAgainLater => 'Please try again later';

  @override
  String get retry => 'Retry';

  @override
  String get noZonesAvailable => 'No zones available';

  @override
  String get checkBackLaterForUpdates => 'Check back later for updates';

  @override
  String get projects => 'Projects';

  @override
  String get errorLoadingProjects => 'Error loading projects';

  @override
  String get noProjectsAvailable => 'No projects available';

  @override
  String get noProjectsFoundInZone => 'No projects found in this zone';

  @override
  String get unknownZone => 'Unknown Zone';

  @override
  String get zoneCode => 'Zone Code: ';

  @override
  String get unknownProject => 'Unknown Project';

  @override
  String get projectCode => 'Project Code: ';
}
