// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../frontend/pages/exchange/exchange_page_controller.dart';
import '../theme/theme_provider.dart';
import 'toggle_switch/widgets/animated_toggle_switch.dart';

class ToggleSwitchButton extends StatefulWidget {
  const ToggleSwitchButton({Key? key}) : super(key: key);

  @override
  State<ToggleSwitchButton> createState() => _ToggleSwitchButtonState();
}

class _ToggleSwitchButtonState extends State<ToggleSwitchButton> {
  int value = 0;
  bool positive = false;
  final exchangeController = Get.put(ExchangePageController());

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedToggleSwitch<bool>.dual(
        innerColor: Colors.grey.shade400,
        current: positive,
        first: false,
        second: true,
        dif: 0.5,
        borderColor: Colors.transparent,
        borderWidth: 2.0,
        indicatorSize: const Size(30.0, double.infinity),
        height: 40,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2.5),
          ),
        ],
        onChanged: (b) {
          if (exchangeController.isFixed.value) {
            Get.snackbar(
                'توجه!', "تا زمان اتمام تایمر امکان تغییر تم وجود ندارد");
          } else {
            setState(() {
              positive = b;
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme();
            });
          }
        },
        colorBuilder: (b) => b ? Colors.black : Colors.white,
        iconBuilder: (value) => value
            ? const Icon(
                FontAwesomeIcons.solidSun,
                color: Colors.white,
              )
            : const Icon(
                FontAwesomeIcons.moon,
                color: Colors.black,
              ),
      ),
    );
  }
}
