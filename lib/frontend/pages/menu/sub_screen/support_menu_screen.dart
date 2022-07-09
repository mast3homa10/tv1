import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../frontend/components/custom_menu_item.dart';

class SupportMenuScreen extends StatelessWidget {
  SupportMenuScreen({
    Key? key,
  }) : super(key: key);
  final menu = [
    const CustomMenuItem(
      label: 'آموزش استفاده',
      icon: FontAwesomeIcons.bookOpenReader,
      buildSubScreen: Text(''),
    ),
    const CustomMenuItem(
        label: 'سوالات متداول',
        icon: FontAwesomeIcons.circleQuestion,
        buildSubScreen: Text('')),
    const CustomMenuItem(
        label: 'گذاشتن نظر',
        icon: FontAwesomeIcons.comment,
        buildSubScreen: Text('')),
    const CustomMenuItem(
        label: 'شرایط و قوانین',
        icon: FontAwesomeIcons.circleExclamation,
        buildSubScreen: Text('')),
    const CustomMenuItem(
        label: 'حریم خصوصی',
        icon: FontAwesomeIcons.circleExclamation,
        buildSubScreen: Text('')),
    const CustomMenuItem(
        label: 'ریسک افشای اطلاعات',
        icon: FontAwesomeIcons.circleExclamation,
        buildSubScreen: Text('')),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menu.length,
      itemBuilder: (context, index) => menu[index],
    );
  }
}
