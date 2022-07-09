import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_body.dart';
import 'intro/model/page_decoration.dart';
import 'intro/introduction_screen.dart';
import 'intro/model/page_view_model.dart';

class GuidePage extends StatelessWidget {
  GuidePage({Key? key}) : super(key: key);
  final introKey = GlobalKey<IntroductionScreenState>();
  final String guideText1 = '1. دریافت مقدار رمزارز و کیف پول\n'
      '2. ارسال ارز برای میادله\n'
      '3. وجه خود را دریافت کنید';

  Widget _buildImage() {
    return Image.asset('assets/images/logo.png', width: 350);
  }

  @override
  Widget build(BuildContext context) {
    final kPageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context)
          .textTheme
          .headline2!
          .copyWith(fontWeight: FontWeight.w700),
      bodyTextStyle: Theme.of(context).textTheme.headline5!,

      // bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Theme.of(context).scaffoldBackgroundColor,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalHeader: const Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16),
            child: null,
          ),
        ),
      ),

      pages: [
        PageViewModel(
            title: "تبادل کریپتو در 3 مرحله",
            bodyWidget: Text(
              guideText1,
              style: Theme.of(context).textTheme.headline5,
            ),
            image: _buildImage(),
            decoration: kPageDecoration),
        PageViewModel(
          title: "خرید و فروش کریپتو برای فیات",
          bodyWidget: Text("مبادله وجه با تمامی کارت های عضو شتال",
              style: Theme.of(context).textTheme.headline5),
          image: _buildImage(),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "نرخ ثابت برای 20 دقیقه",
          bodyWidget: Text(
            "اگه مشکلی باشه با ما از طرق چت حلش کنین",
            style: Theme.of(context).textTheme.headline5,
          ),
          image: _buildImage(),
          decoration: kPageDecoration,
        ),
        PageViewModel(
          title: "پشتیبانی 24 ساعته",
          bodyWidget: Text(
            "ارتباط با ما از طریق چت",
            style: Theme.of(context).textTheme.headline5,
          ),
          image: _buildImage(),
          decoration: kPageDecoration,
        ),
      ],
      done: Container(
        height: 62,
        width: 164,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Text(
            'بستن راهنما',
            style: Theme.of(context).textTheme.headline4!,
          ),
        ),
      ),
      onDone: () {
        Get.off(DashboardBody());
      }, //_onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      showDoneButton: false,
      showBackButton: false,
      showNextButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,

      rtl: true, // Display as right-to-left
      // skip:
      //     const Text('رد کردن', style: TextStyle(fontWeight: FontWeight.w600)),
      nextStyle: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide.lerp(
              const BorderSide(
                width: 10.0,
              ),
              const BorderSide(),
              10.0),
        ),
      ),
      doneStyle: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide.lerp(
              const BorderSide(
                width: 10.0,
              ),
              const BorderSide(),
              10.0),
        ),
      ),
      next: Container(
        height: 62,
        width: 164,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).backgroundColor,
            style: BorderStyle.solid,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(color: Theme.of(context).backgroundColor, blurRadius: 10)
          ],
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.angleRight,
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 20,
              ),
              Text(
                'بعدی',
                //todo : change style
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
              ),
            ],
          ),
        ),
      ),

      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).appBarTheme.backgroundColor!,
        activeSize: const Size(15.0, 15.0),
        activeColor: Theme.of(context).backgroundColor,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(500.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}



////////////////////////////////////////////
///
//next: ConstrainedBox(
      //   constraints: const BoxConstraints.tightFor(width: 186, height: 62),
      //   child: CustomSmallButton(
      //     press: () {},
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: const [
      //         Icon(
      //           FontAwesomeIcons.angleRight,
      //           color: kBackgroundColorLightMode,
      //           size: 20,
      //         ),
      //         Text(
      //           'بعدی',
      //           style: kButtonTextStyle_2,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // doneStyle: ButtonStyle(
      //   side: MaterialStateProperty.all(
      //     BorderSide.lerp(
      //         BorderSide(
      //           width: 10.0,
      //         ),
      //         BorderSide(),
      //         10.0),
      //   ),
      // ),
      // done: Container(
      //   height: 62,
      //   width: 164,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      //   child: const Center(
      //     child: Text(
      //       'بستن راهنما',
      //       style: TextStyle(
      //           fontFamily: 'Yekanbakh', fontSize: 18, color: Colors.black),
      //     ),
      //   ),
      // ),
      