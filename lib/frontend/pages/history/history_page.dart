import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../dashboard/dashboard_body_controller.dart';

import '../../components/custom_big_button.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardBodyController>(builder: (controller) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
              width: 70,
              child: AspectRatio(
                aspectRatio: 1 / 0.5,
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
            ),
            Center(
              child: Text(
                'هنوز هیچ تراکنیش نداشتید!',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'همه تراکنش های شما در این جا ذخیره خواهند شد. \nشما می توانید اولین تبادل خود را همین حال آغاز کنید',
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomBigButton(
                label: 'شروع تبادل',
                onPressed: () {
                  // Get.snackbar(
                  //   'توجه!',
                  //   "در حال توسعه ...",
                  // );
                  controller.getCurrentPage(2);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
