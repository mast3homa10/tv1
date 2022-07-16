import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../components/toggel_bar.dart';
import '../../../components/custom_big_button.dart';

class AddressBookScreen extends StatefulWidget {
  const AddressBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  int counter = 0;
  final subScreen = [
    const Text('test1'),
    const Text('test2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.12,
          child: ToggleBar(
              labels: const ['موردعلاقه ها', 'آدرس های اخیر'],
              backgroundBorder: Border.all(width: 0.0),
              onSelectionUpdated: (index) {
                setState(() {
                  counter = index;
                });
              }),
        ),
        SizedBox(
          height: Get.height < 700 ? Get.height * 0.45 : Get.height * 0.5,
          // height: Get.height < 700 ? Get.height * 0.35 : Get.height * 0.4,
          child: IndexedStack(
            index: counter,
            children: subScreen,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: CustomBigButton(
            label: 'اضافه کردن کیف پول',
            onPressed: () {
              Get.snackbar('توجه!', "در حال توسعه ...");
            },
          ),
        ),
      ],
    );
  }
}
