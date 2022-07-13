import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'frontend/components/toggle_switch_button.dart';

// bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh
const Color kLightBackgroundColor = Color(0xFFE5E5E5);
const Color kLightAppBarColor = Color(0xFFEFF4FF);
const Color kLightNavBarColor = Color(0xFFEFF4FF);
const Color kLightButtonColor = Color(0xFFA822E7);
const Color kLightChangerColor = Color(0xFF0F1119);
const Color kLightIconColor = Colors.black;
const Color kLightDividerColor = Colors.grey;

const Color kDarkBackgroundColor = Color(0xFF171C28);
const Color kDarkAppBarColor = Color(0xFF0F1119);
const Color kDarkNavBarColor = Color(0xFF0E0F17);
const Color kDarkButtonColor = Color(0xFF27E2FF);
const Color kDarkChangerColor = Color(0xFFEFF4FF);
const Color kDarkIconColor = Colors.white;
const Color kDarkDividerColor = Color(0xFFFFFFFF);

Map<String, Color> kNetworkColorList = {
  'btc': const Color(0xFFFF9800),
  'eth': const Color(0xFF457C9B),
  'bsc': const Color(0xFFB59154),
  'trx': const Color(0xFFF55246),
  'cchain': const Color(0xFFF55246),
  'polygon': const Color(0xFFDA0050),
  'luna': const Color(0xFFB4BFCE),
  'bep2': const Color(0xFFB4BFCE),
  'xchain': const Color(0xFF5E17FE),
};

const kMaxSeconds = 125;

AppBar kAppbar = AppBar(
  automaticallyImplyLeading: false,
  elevation: 0.0,
  title: const SizedBox(
    height: 40,
    width: 40,
    child: AspectRatio(
      aspectRatio: 1 / 0.5,
      child: Image(
        image: AssetImage('assets/images/logo.png'),
      ),
    ),
  ),
  actions: const [
    ToggleSwitchButton(),
  ],
);

String kPersianDigit(var digit) {
  String num = digit.toString();
  return num.toPersianDigit();
}
