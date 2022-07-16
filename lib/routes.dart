import 'package:get/get.dart';

import '../../frontend/pages/welcome/welcome_binding.dart';
import 'frontend/pages/address/address_page.dart';
import 'frontend/pages/address/sub_screen/qr_code_screen.dart';
import 'frontend/pages/exchange/exchange_page.dart';
import 'frontend/pages/steps/steps_page.dart';
import 'frontend/pages/guide/guide_page.dart';
import 'frontend/pages/menu/menu_page.dart';
import 'frontend/pages/welcome/welcome_page.dart';
import 'frontend/pages/dashboard/dashboard_body.dart';

List<GetPage<dynamic>> routes = [
  GetPage(
    name: '/',
    page: () => const WelcomePage(),
    binding: WelcomeBinding(),
  ),
  GetPage(
    name: '/guide_page',
    page: () => GuidePage(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/dashboard_body',
    page: () => DashboardBody(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/exchange_page',
    page: () => const ExchangePage(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/address_page',
    page: () => AddressPage(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/menu_page',
    page: () => const MenuPage(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/scanner_page',
    page: () => const QRCodeScreen(),
    transition: Transition.downToUp,
  ),
  GetPage(
    name: '/steps_page',
    page: () => const StepsPage(),
    transition: Transition.downToUp,
  ),
];
