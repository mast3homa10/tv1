import 'package:get/get.dart';

import '../address/address_page_controller.dart';
import '../dashboard/dashboard_body_controller.dart';
import '../exchange/exchange_page_controller.dart';
import '../menu/menu_page_controller.dart';
import '../steps/steps_page_controller.dart';
import 'welcome_page_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomePageController>(() => WelcomePageController());
    Get.lazyPut<DashboardBodyController>(() => DashboardBodyController());
    Get.lazyPut<ExchangePageController>(() => ExchangePageController());
    Get.lazyPut<MenuPageController>(() => MenuPageController());
    Get.lazyPut<FinalStepsController>(() => FinalStepsController());
    Get.lazyPut<AddressPageController>(() => AddressPageController());
  }
}
