import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv1/frontend/pages/address/address_page.dart';

import '../exchange/exchange_page.dart';
import '../../../frontend/pages/history/history_page.dart';
import '../../../frontend/pages/menu/menu_page.dart';
import '../../../frontend/pages/support/support_page.dart';

class DashboardBodyController extends GetxController {
  var isScreenChange = false.obs;

  final screens = [
    const MenuPage(),
    const SupportPage(),
    const ExchangePage(),
    HistoryPage(),
  ];
  final screens2 = [
    const MenuPage(),
    const SupportPage(),
    AddressPage(),
    HistoryPage(),
  ];
  changeScreen() {
    isScreenChange = isScreenChange.value ? false.obs : true.obs;
    update();
    log('is screen change :${isScreenChange.value}');
  }

  var currentPage = 2.obs;
  getCurrentPage(int index) {
    currentPage = index.obs;
    update();
  }

  /// The onBackPressed is for Restrict Android backButton
  Future<bool?> onBackPressed(BuildContext context) async {
    Get.defaultDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: "توجه!",
      titleStyle: Theme.of(context).textTheme.headline4,
      content: Text(
        'آیا میخواید از برنامه خارج شوید؟',
        style: Theme.of(context).textTheme.headline4,
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text(
                'بله',
                style: TextStyle(
                    fontSize: 20, fontFamily: "Yekanbakh", color: Colors.green),
              ),
              onPressed: () {
                exit(0);
              },
            ),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              child: const Text(
                'خیر',
                style: TextStyle(
                    fontSize: 20, fontFamily: "Yekanbakh", color: Colors.red),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ],
    );
    return null;
  }
}
