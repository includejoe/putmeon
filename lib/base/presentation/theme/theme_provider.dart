import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkMode = false;
  late SharedPreferences _prefs;

  ThemeProvider() {
    _initPrefs();
  }

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  toggleTheme() {
    isDarkMode = !isDarkMode;
    _savePrefs();
    notifyListeners();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    isDarkMode = _prefs.getBool("IS_DARK_MODE") ?? false;
    notifyListeners();
  }

  void _savePrefs() {
    _prefs.setBool("IS_DARK_MODE", isDarkMode);
  }
}