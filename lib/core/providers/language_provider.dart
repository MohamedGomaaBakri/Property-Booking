import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('ar');

  Locale get currentLocale => _currentLocale;

  bool get isArabic => _currentLocale.languageCode == 'ar';

  void toggleLanguage() {
    _currentLocale = _currentLocale.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
    notifyListeners();
  }

  void setLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}
