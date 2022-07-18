import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../exchange/exchange_page_controller.dart';
import '../../components/nav_bar/bottom_nav_bar.dart';
import '../../../constants.dart';
import '../../pages/dashboard/dashboard_body_controller.dart';

class DashboardBody extends StatelessWidget {
  DashboardBody({Key? key}) : super(key: key);
  final exchangePageController = ExchangePageController();
  final dashboardBodyController = DashboardBodyController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardBodyController>(builder: (dashboardController) {
      return WillPopScope(
        onWillPop: () async {
          if (dashboardController.isScreenChange.value) {
            dashboardController.changeScreen();
            return false;
          } else {
            bool? result = await dashboardController.onBackPressed(context);
            result ??= false;
            return result;
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: kAppbar,
          body: SafeArea(
            // the indexed stack widget change screen by help of nav bar
            child: IndexedStack(
              index: dashboardController.currentPage.value,
              children: dashboardController.isScreenChange.value
                  ? dashboardController.screens2
                  : dashboardController.screens,
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: 82,
            child: Column(
              children: [
                const Divider(
                  height: 3,
                  thickness: 2,
                ),
                Expanded(
                  child: BottomNavBar(
                      selectedIndex: dashboardController.currentPage.value,
                      showElevation: true,
                      itemCornerRadius: 24,
                      curve: Curves.easeIn,
                      onItemSelected: (index) =>
                          dashboardController.getCurrentPage(index),
                      items: items),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

List<BottomNavBarItem> items = [
  BottomNavBarItem(
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.ellipsisVertical),
    title: const Text('منو'),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.headset),
    title: const Text('پشتیبانی'),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(
      // ignore: deprecated_member_use
      FontAwesomeIcons.exchange,
    ),
    title: const Text('مبادله '),
    textAlign: TextAlign.center,
  ),
  BottomNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.clockRotateLeft),
    title: const Text('تاریخچه سفارشات'),
    textAlign: TextAlign.center,
  ),
];
