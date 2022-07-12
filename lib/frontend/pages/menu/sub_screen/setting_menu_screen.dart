import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../frontend/components/custom_menu_item.dart';

class SettingMenuScreen extends StatelessWidget {
  SettingMenuScreen({
    Key? key,
  }) : super(key: key);
  final isSelected = false;
  final menu = [
    CustomMenuItem(
      label: 'نوتیفیکیشن ها',
      icon: FontAwesomeIcons.bell,
      buildSubScreen: SwitchListTile(
        value: false,
        onChanged: (_) {},
        title: const Text(
          'اجاره دادن به نوتیفیکیشن',
        ),
      ),
    ),
    CustomMenuItem(
      label: 'رمز عبور',
      icon: FontAwesomeIcons.lock,
      buildSubScreen: SwitchListTile(
        value: false,
        onChanged: (_) {},
        title: const Text(
          'رمز عبور',
        ),
      ),
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
