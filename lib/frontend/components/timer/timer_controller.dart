import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../constants.dart';

class TimerController extends GetxController {
  var seconds = kMaxSeconds.obs;
  var isTimerOn = false.obs;
  var conuter = 0.obs;
  var time = ''.obs;
  Timer? timer;

  @override
  void onClose() {
    isTimerOn = false.obs;
    stop();
    super.onClose();
  }

  reset(int maxSeconds) {
    seconds = maxSeconds.obs;
  }

  start() {
    isTimerOn = true.obs;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      countDown();
    });
  }

  stop() {
    reset(kMaxSeconds);
    isTimerOn = false.obs;
    timer?.cancel();
    log('finish');
  }

  countDown() {
    if (seconds > 0) {
      seconds--;
      time =
          '${((seconds / 60).truncate() % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}'
              .obs;
      log('$time');
    } else {
      log('ths end of timer');
      stop();
    }
  }
}
