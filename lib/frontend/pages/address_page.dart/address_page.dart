import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../../frontend/components/nav_bar/second_nav_bar.dart';
import '../../../constants.dart';
import 'sub_screen/add_address_screen.dart';
import 'sub_screen/address_book_screen.dart';

class AddressPage extends StatelessWidget {
  AddressPage({
    Key? key,
  }) : super(key: key);

  final subScreen = [
    const AddAddressScreen(),
    const AddressBookScreen(),
  ];
  final controller = Get.put(AddressPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: kAppbar,
        body: GetBuilder<AddressPageController>(
            builder: (controller) => Column(
                  children: [
                    SizedBox(
                      width: Get.width,
                      height: Get.height * 0.15,
                      child: TopNavBar(
                          selectedIndex: controller.currentTopItem.toInt(),
                          showElevation: true,
                          itemCornerRadius: 24,
                          curve: Curves.easeIn,
                          onItemSelected: (index) =>
                              controller.getCurrentTopItem(index),
                          items: topItems),
                    ),
                    subScreen[controller.currentTopItem.value],
                  ],
                )));
  }
}

List<TopNavBarItem> topItems = [
  // TopNavBarItem(
  //   inactiveColor: Colors.black,
  //   activeColor: kLightButtonColor,
  //   icon: const Icon(FontAwesomeIcons.qrcode),
  //   title: const Text('اسکن کیف پول'),
  //   textAlign: TextAlign.center,
  // ),
  TopNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(FontAwesomeIcons.wallet),
    title: const Text('اضافه کردن کیف پول'),
    textAlign: TextAlign.center,
  ),
  TopNavBarItem(
    inactiveColor: Colors.black,
    activeColor: kLightButtonColor,
    icon: const Icon(
      FontAwesomeIcons.book,
    ),
    title: const Text('دفترچه آدرس '),
    textAlign: TextAlign.center,
  ),
];
