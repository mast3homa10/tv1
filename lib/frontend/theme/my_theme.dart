import 'package:flutter/material.dart';

import '../../constants.dart';

class MyThemes {
  static final darkTheme = ThemeData(
      cardColor: const Color(0xFF0A0C11),
      backgroundColor: kDarkButtonColor,
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      textTheme: const TextTheme(
        headline1: TextStyle(fontFamily: 'Yekanbakh', fontSize: 45),
        headline2: TextStyle(fontFamily: 'Yekanbakh', fontSize: 30),
        headline3: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
        headline4: TextStyle(fontFamily: 'Yekanbakh', fontSize: 18),
        headline5: TextStyle(fontFamily: 'Yekanbakh', fontSize: 16),
        button: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
      ).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Color(0xFF040507)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFF27E2FF),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle:
              const TextStyle(fontFamily: 'Yekanbakh', fontSize: 16).apply(
            color: Colors.white,
          ),
          primary: kDarkButtonColor, // This is a custom color variable
          side: const BorderSide(
            width: 2,
            color: kDarkButtonColor,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F1119),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xFF0F1119),
      ),
      dividerTheme: const DividerThemeData(color: kDarkDividerColor),
      iconTheme: const IconThemeData(color: kDarkIconColor));
////////////////////////////////////////////////////////////////////////////////////
//////////////////////////// Light Theme //////////////////////////////////////////
  static final lightTheme = ThemeData(
      backgroundColor: kLightButtonColor,
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFFA822E7),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headline1: TextStyle(fontFamily: 'Yekanbakh', fontSize: 45),
        headline2: TextStyle(fontFamily: 'Yekanbakh', fontSize: 30),
        headline3: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
        headline4: TextStyle(fontFamily: 'Yekanbakh', fontSize: 18),
        headline5: TextStyle(fontFamily: 'Yekanbakh', fontSize: 16),
        button: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
      ).apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      bottomSheetTheme:
          const BottomSheetThemeData(backgroundColor: Color(0xFFFFFFFF)),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
              fontFamily: 'Yekanbakh', fontSize: 16, color: Colors.black),
          primary: kLightButtonColor, // This is a custom color variable
          side: const BorderSide(
            width: 2,
            color: kLightButtonColor,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEFF4FF),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFFEFF4FF)),
      dividerTheme: const DividerThemeData(color: kLightDividerColor),
      iconTheme: const IconThemeData(color: kLightIconColor));
}
