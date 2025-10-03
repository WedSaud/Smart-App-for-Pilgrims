import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // Default language is English

  Locale get locale => _locale;

  // Constructor to initialize the language from shared preferences
  LanguageProvider() {
    _loadLanguage();
  }

  // Change the language and notify listeners
  void changeLanguage(Locale locale) async {
    _locale = locale;
    notifyListeners();
    _saveLanguage(locale.languageCode); // Save to SharedPreferences
  }

  // Load the saved language from shared preferences
  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Save the selected language to shared preferences
  Future<void> _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', languageCode);
  }
}
