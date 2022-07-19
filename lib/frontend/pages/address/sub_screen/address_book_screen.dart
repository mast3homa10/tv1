import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../frontend/pages/address/address_page_controller.dart';
import '../../../components/toggel_bar.dart';
import '../../../components/custom_button.dart';

class AddressBookScreen extends StatelessWidget {
  AddressBookScreen({
    Key? key,
  }) : super(key: key);

  final subScreen = [
    const Favorite(),
    const Favorite(),
  ];
  final List<ToggleBarItem> items = [
    ToggleBarItem(title: 'آدرس های اخیر'),
    ToggleBarItem(title: 'موردعلاقه ها'),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressPageController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: Get.height * 0.12,
            child: ToggleBar(
                selectedIndex: controller.currentToggleItem.value,
                items: items,
                onItemSelected: (index) => controller.getToggleItem(index)),
          ),
          SizedBox(
            // height: Get.height < 700 ? Get.height * 0.5 : Get.height * 0.55,
            height: Get.height < 700 ? Get.height * 0.4 : Get.height * 0.46,
            child: IndexedStack(
              index: controller.currentToggleItem.value,
              children: subScreen,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
              label: 'اضافه کردن کیف پول',
              onPressed: () {
                // Get.snackbar('توجه!', "در حال توسعه ...");
                // Get.to(() => AddressPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Favorite extends StatelessWidget {
  const Favorite({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child: Text(
          'هیج کیف پولی یافت نشد',
          style: Theme.of(context).textTheme.headline5,
        )),
      ],
    );
  }
}
