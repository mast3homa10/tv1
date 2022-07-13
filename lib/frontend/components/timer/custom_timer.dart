import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'timer_controller.dart';
import '../../../constants.dart';

class CustomTimer extends StatelessWidget {
  const CustomTimer(
      {Key? key, this.maxSecond = kMaxSeconds, required this.controller})
      : super(key: key);
  final int maxSecond;
  final TimerController controller;

  @override
  Widget build(BuildContext context) {
    controller.reset(maxSecond);
    controller.start();
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
