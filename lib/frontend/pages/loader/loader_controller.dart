import 'package:get/get.dart';
import 'package:tv1/frontend/pages/dashboard/dashboard_body.dart';

class LoaderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Get.offAll(DashboardBody());
  }
}
