import 'package:flutter/material.dart';
import 'services/preferences_service.dart'; // top of file


class SettingsModel extends ChangeNotifier {
  /// по умолчанию – "как в системе"
  ThemeMode _themeMode = ThemeMode.system;
  /// null  →  брать системный язык
  Locale?   _locale;

  ThemeMode get themeMode => _themeMode;
  Locale?   get locale    => _locale;

  void updateThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// передаём null, чтобы вернуться к системному языку
  void updateLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }

  final _prefs = PreferencesService();

  void saveToCloud() => _prefs.save(this);
  void restoreFromCloud() => _prefs.loadInto(this);
  
}
