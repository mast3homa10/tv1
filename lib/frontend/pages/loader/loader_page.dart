import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv1/constants.dart';
import 'package:tv1/frontend/pages/loader/loader_controller.dart';

class LoaderPage extends StatelessWidget {
  LoaderPage({Key? key}) : super(key: key);
  final loaderController = Get.put(LoaderController());
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: kSpinkit),
    );
  }
}
