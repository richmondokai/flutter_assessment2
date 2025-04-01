import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the application's theme state and persists it.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  /// Returns the current theme mode.
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme(); // Load theme preference when the provider is initialized
  }

  /// Toggles between light and dark mode and saves the preference.
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(_themeMode);
    notifyListeners();
  }

  /// Loads the saved theme preference from SharedPreferences.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Saves the current theme preference in SharedPreferences.
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', mode == ThemeMode.dark);
  }
}
