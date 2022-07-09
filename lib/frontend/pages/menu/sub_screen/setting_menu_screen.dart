import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../frontend/components/custom_menu_item.dart';
import '../../../../frontend/components/toggle_switch_button.dart';

class SettingMenuScreen extends StatelessWidget {
  SettingMenuScreen({
    Key? key,
  }) : super(key: key);
  final isSelected = false;
  final menu = [
    CustomMenuItem(
      label: 'نوتیفیکیشن ها',
      icon: FontAwesomeIcons.bell,
      buildSubScreen: Row(children: [
        const Text(
          'اجاره دادن به نوتیفیکیشن',
        ),
        const ToggleSwitchButton(),
        ToggleButtons(
          isSelected: const [
            true,
            false,
          ],
          children: const [
            Text('data'),
            Text('data'),
          ],
        ),
      ]),
    ),
    const CustomMenuItem(
      label: 'رمز عبور',
      icon: FontAwesomeIcons.lock,
      buildSubScreen: Text(''),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menu.length,
      itemBuilder: (context, index) => menu[index],
    );
  }

  Widget buildNotificationSubScreen() {
    return Row(
      children: const [
        Text('اجاره دادن به نوتیفیکیشن'),
      ],
    );
  }
}
