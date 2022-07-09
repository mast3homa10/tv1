import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(String isDarkThemeOn) {
    _themeMode = isDarkThemeOn == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return _themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isDarkMode', isOn);
    // themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    log('Is theme  dark ? : $isDarkMode');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode
        ? prefs.setString('theme', 'light')
        : prefs.setString('theme', 'dark');
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;

    var s = prefs.getString('theme');
    log('theme change to  $s');

    notifyListeners();
  }

  ThemeMode get theme => _themeMode;
}
