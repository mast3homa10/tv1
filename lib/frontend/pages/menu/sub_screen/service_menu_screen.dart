import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../frontend/components/custom_menu_item.dart';

class ServiceMenuScreen extends StatelessWidget {
  ServiceMenuScreen({
    Key? key,
  }) : super(key: key);
  final menu = [
    const CustomMenuItem(
      label: 'دفترچه آدرس',
      icon: FontAwesomeIcons.bookOpen,
      buildSubScreen: NewWidget(),
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

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).appBarTheme.backgroundColor),
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('بیاید اولین آدرس شما را ثبت کنیم!',
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontSize: 24)),
                Text(
                  'دفترچه آدرس بخشی برای ذخیره کردن آدرس کیف پول های شماست که دیگه نیازی نباشه دنبالشون بگردین',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ))),
        Center(
            child: Text('هیچ کیف پولی ذخیره نشده',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Colors.grey,
                    ))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).backgroundColor,
            onPressed: () {
              log('here');
              Get.snackbar('توجه!', 'در حال توصعه ...');
            },
            tooltip: 'Increment',
            label: Icon(
              Icons.add,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ],
    );
  }
}

class AddAddress extends StatelessWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(child: Text('test')),
      ),
    );
  }
}
