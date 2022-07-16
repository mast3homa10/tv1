import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';

class WelcomePageController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    log('welcome');
    checkConnection();
  }

  RxBool isConnectToNetwork = false.obs;
  RxBool isTrying = false.obs;
  //check connection to network with "checkConnection" function.

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        message(title: 'Connection', content: 'connected');
        isConnectToNetwork = true.obs;
        isTrying = false.obs;
        update();

        //get init table
        isTrying = false.obs;
        update();
      } else {
        message(title: 'Connection', content: 'not connected');
        isConnectToNetwork = false.obs;
        isTrying = true.obs;

        update();
      }
    } on SocketException catch (_) {
      log('$_');
      message(title: 'Connection', content: 'not connected');
      isConnectToNetwork = false.obs;
      update();
    }
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
