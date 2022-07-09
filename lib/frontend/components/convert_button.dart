import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../pages/exchange/exchange_page_controller.dart';
import '../../constants.dart';

class ReversedButton extends StatelessWidget {
  ReversedButton({
    Key? key,
  }) : super(key: key);
  final exchangePageController = ExchangePageController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ??
              kLightChangerColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color:
                Theme.of(context).dividerTheme.color ?? const Color(0xFFEEEEEE),
            style: BorderStyle.solid,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              FontAwesomeIcons.arrowUp,
              size: 20,
            ),
            Icon(
              FontAwesomeIcons.arrowDown,
              size: 20,
            ),
          ],
        ),
      ),
      onTap: () {
        Get.snackbar("توجه !", "در حال توسعه ...");
        exchangePageController.changeReversed();
      },
    );
  }
}
