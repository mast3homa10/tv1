import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../components/custom_small_button.dart';
import '../guide/guide_page.dart';
import '../dashboard/dashboard_body.dart';
import 'welcome_page_controller.dart';

class WelcomePage extends GetView<WelcomePageController> {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: Get.height * 0.1,
            ),
            Container(
              decoration: const BoxDecoration(
                  // color: kBackgroundColorLightMode,
                  image: DecorationImage(
                      image: AssetImage('assets/images/welcomebackground.png'),
                      fit: BoxFit.cover)),
              child: Center(
                child: Container(
                  height: 320,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlue.withOpacity(0.05),
                        spreadRadius: 15,
                        blurRadius: 27,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'خوش آمدید به',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.lightBlue.withOpacity(0.1),
                              spreadRadius: 15,
                              blurRadius: 27,
                              offset: const Offset(
                                  0, 5), // changes position of shadow
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: const AspectRatio(
                          aspectRatio: 20 / 9,
                          child: Image(
                            image: AssetImage('assets/images/logo.png'),
                          ),
                        ),
                      ),
                      Text(
                        'تهران اکسچنج',
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'صرافی به حد و حصر کریپتو با بیش از 1000 \n'
                        'جفت تجاری سریع و ایمن',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 166, height: 62),
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // Get.snackbar('توجه!', "در حال توسعه ...");
                          Get.off(GuidePage());
                        },
                        child: Center(
                          child: Text(
                            'مطالعه راهنما',
                            style: Theme.of(context).textTheme.button!.copyWith(
                                color: Theme.of(context).backgroundColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints.tightFor(width: 166, height: 62),
                      child: CustomSmallButton(
                        child: Text(
                          'شروع تبادل',
                          style: Theme.of(context).textTheme.button!.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        onPressed: () {
                          Get.off(DashboardBody());
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
