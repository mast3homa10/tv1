import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuPageController extends GetxController {
  var menuItemIndex = 0.obs;
  var sliderItemIndex = 0.obs;
  final sliderItems = const [
    AspectRatio(
      aspectRatio: 20 / 9,
      child: Image(
        image: AssetImage('assets/images/logo.png'),
      ),
    ),
    AspectRatio(
      aspectRatio: 20 / 9,
      child: Image(
        image: AssetImage('assets/images/logo.png'),
      ),
    ),
    AspectRatio(
      aspectRatio: 20 / 9,
      child: Image(
        image: AssetImage('assets/images/logo.png'),
      ),
    ),
  ];
  changeMeneItemIndex(int index) {
    menuItemIndex = index.obs;
    update();
  }

  changeSliderItem(int index) {
    sliderItemIndex = index.obs;
    update();
  }
}
