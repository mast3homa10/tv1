import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key, this.seconds = 120}) : super(key: key);
  final int seconds;
  @override
  State<CustomTimer> createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  var time = '';
  var seconds = 120;
  Timer? timer;
  @override
  void initState() {
    super.initState();

    startTimer();
    setState(() {
      if (widget.seconds > 0) {
        seconds = widget.seconds;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    setState(() {});
    log('finish');
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        seconds--;
        setState(() {});
        time =
            '${((seconds / 60).truncate() % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
        // log(time);
      } else {
        // Get.snackbar('توجه!', "زمان به پایان رسید");
        timer?.cancel();
        setState(() {});
        log('finish');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
      child: Builder(
        builder: (context) => SizedBox(
          width: 50,
          child: Center(
            child: Text(
              '${((seconds / 60).truncate() % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
/* class CustomTimer extends StatelessWidget {
  const CustomTimer(
      {Key? key, this.maxSecond = kMaxSeconds, required this.controller})
      : super(key: key);
  final int maxSecond;
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    controller.setTimer(maxSecond);
    controller.startTimer();
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
      child: Obx(
        () => SizedBox(
          width: 50,
          child: Center(
            child: Text(
              '${((controller.seconds.value / 60).truncate() % 60).toString().padLeft(2, '0')}:${(controller.seconds.value % 60).toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
 */