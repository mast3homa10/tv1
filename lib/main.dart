import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'frontend/theme/my_theme.dart';
import 'frontend/theme/theme_provider.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SharedPreferences.getInstance().then((prefs) {
    var isDarkTheme = prefs.getString("theme") ?? 'light';
    log("theme is $isDarkTheme");
    log("height : ${Get.height}");
    log("width : ${Get.width}");
    runApp(ChangeNotifierProvider(
        create: (context) => ThemeProvider(isDarkTheme),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return GetMaterialApp(
            themeMode: themeProvider.theme,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            locale: const Locale('fa', 'IR'),
            getPages: routes,
            initialRoute: '/',
          );
        }));
  });
}
