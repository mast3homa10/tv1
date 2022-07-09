import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../frontend/components/custom_menu_item.dart';

class ServiceMenuScreen extends StatelessWidget {
  ServiceMenuScreen({
    Key? key,
  }) : super(key: key);
  final menu = [
    const CustomMenuItem(
      label: 'دفترچه آدرس',
      icon: FontAwesomeIcons.bookOpen,
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
}
