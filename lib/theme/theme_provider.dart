import 'package:flutter/material.dart';
import 'package:thrive/theme/dark_mode.dart';
import 'package:thrive/theme/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // initial theme - lightMode
  ThemeData _themeData = lightMode;

  // get the current theme
  ThemeData get themeData => _themeData;

  // check if current theme is darkMode
  bool get isDarkMode => _themeData == darkMode;

  // set new theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle between themes
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
