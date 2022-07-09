import 'package:flutter/material.dart';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../components/toggel_bar.dart';
import '../../pages/menu/menu_page_controller.dart';
import 'sub_screen/service_menu_screen.dart';
import 'sub_screen/setting_menu_screen.dart';
import 'sub_screen/support_menu_screen.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (MenuPageController controller) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.3,
              child: Center(
                child: Column(
                  children: [
                    CarouselSlider(
                      items: controller.sliderItems,
                      options: CarouselOptions(
                          height: 150,
                          autoPlay: true,
                          onPageChanged: (index, reason) =>
                              controller.changeSliderItem(index)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DotsIndicator(
                        dotsCount: controller.sliderItems.length,
                        position: controller.sliderItemIndex.toDouble(),
                        decorator: DotsDecorator(
                          size: const Size(10.0, 10.0),
                          color: Theme.of(context).appBarTheme.backgroundColor!,
                          activeSize: const Size(15.0, 15.0),
                          activeColor: Theme.of(context).backgroundColor,
                          activeShape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(500.0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.12,
              child: ToggleBar(
                  w: 110,
                  labels: const ['پشتیبانی', 'سرویس', 'تنظیمات'],
                  backgroundBorder: Border.all(width: 0.0),
                  onSelectionUpdated: (index) =>
                      controller.changeMeneItemIndex(index)),
            ),
            SizedBox(
              height: Get.height * 0.34,
              child: IndexedStack(
                index: controller.menuItemIndex.toInt(),
                children: [
                  SupportMenuScreen(),
                  ServiceMenuScreen(),
                  SettingMenuScreen(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
