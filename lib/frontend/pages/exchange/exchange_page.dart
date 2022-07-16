import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tv1/frontend/components/try_again_button.dart';

import '../../../constants.dart';
import '../../components/exchange_box.dart';
import '../../../frontend/components/convert_button.dart';
import '../../../frontend/components/custom_big_button.dart';
import '../../../frontend/components/custom_search_delegate.dart';
import '../../../frontend/components/timer/timer_controller.dart';
import '../../../frontend/pages/address/address_page.dart';
import 'exchange_page_controller.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  State<ExchangePage> createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage>
    with TickerProviderStateMixin {
  final double widgetATop = 0;
  final double widgetBTop = 180;
  bool isSwapped = false;
  bool isMassegeShow = false;

  late AnimationController controller;
  late Animation<double> addressAnimation;
  animationListener() => setState(() {});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Initialize animations
    controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    addressAnimation = Tween(
      begin: 0.0,
      end: widgetBTop - widgetATop,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ))
      ..addListener(animationListener);
  }

  @override
  dispose() {
    // Dispose of animation controller
    controller.dispose();
    super.dispose();
  }

  final timerController = Get.put(TimerController());

  final exchangeController = Get.put(ExchangePageController());

  @override
  Widget build(BuildContext context) {
    var tweenValue = addressAnimation.value;

    return GetBuilder<ExchangePageController>(
      builder: (exchangeController) {
        try {
          return GestureDetector(
            onTap: () {
              exchangeController.isSourceHasLimitation = false.obs;
              exchangeController.isDestanitionHasLimitation = false.obs;
              exchangeController.update();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: exchangeController.isTrying.value
                  ? kSpinkit
                  : !exchangeController.isConnectToNetwork.value
                      ? TryAgainButton()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // the Expanded widget below contains ''' cryptocurrency calculator '''.
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Stack(
                                  children: [
                                    /// for sell box
                                    Positioned(
                                        top: widgetATop + tweenValue,
                                        width: Get.width,
                                        child: buildFirstBox()),

                                    // exchange result & swap button

                                    Positioned(
                                      top: 110,
                                      width: Get.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            buildResult(
                                                context, exchangeController),

                                            // Reversed button
                                            buildSwapButton(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if ((isSwapped
                                        ? exchangeController
                                            .isDestanitionHasLimitation.value
                                        : exchangeController
                                            .isSourceHasLimitation.value))
                                      Positioned(
                                          top: (widgetATop + 75) + tweenValue,
                                          width: Get.width,
                                          child: isSwapped
                                              ? buildHintBox(isforReverse: true)
                                              : buildHintBox()),
                                    // for buy box
                                    Positioned(
                                        top: widgetBTop - tweenValue,
                                        width: Get.width,
                                        child: buildSecondBox()),
                                    if ((isSwapped
                                        ? exchangeController
                                            .isSourceHasLimitation.value
                                        : exchangeController
                                            .isDestanitionHasLimitation.value))
                                      Positioned(
                                          top: (widgetBTop + 75) - tweenValue,
                                          width: Get.width,
                                          child: isSwapped
                                              ? buildSecondHintBox()
                                              : buildSecondHintBox(
                                                  isforReverse: true)),
                                  ],
                                ),
                              ),
                            ),

                            // the padding widget below contains '''add address button'''.
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CustomBigButton(
                                label: 'وارد کردن آدرس',
                                onPressed: () {
                                  // Get.snackbar('توجه!', "در حال توسعه ...");
                                  if (timerController.timer != null) {
                                    timerController.stopTimer();
                                  }

                                  Get.to(AddressPage());
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          );
        } catch (e) {
          return kSpinkit;
        }
      },
    );
  }

  Widget buildFirstBox() => ExchangeBox(
        isHaveIcon: exchangeController.isSwaped.value ? true : false,
        isIconChange: exchangeController.isFixedPressed.value,
        textController: exchangeController.isSwaped.value
            ? exchangeController.destinationTextController
            : exchangeController.sourceTextController,
        currency: exchangeController.sourceCurrency,
        onPressed: () {
          // launch searchbox by tap here
          if (exchangeController.isSwaped.value) {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(currentBox: 1));
          } else {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(currentBox: 0));
          }
        },
        openIconPressed: () {
          buildFixSnakBar(context);
          exchangeController.updateFix();
          exchangeController.isSecondTyping = true.obs;
          exchangeController.updateExchange(
              source: exchangeController.destinationCurrency,
              destination: exchangeController.sourceCurrency,
              isForReverse: true);
        },
        closeIconPressed: () {
          exchangeController.updateFix();
          exchangeController.isFirstTyping = true.obs;
          exchangeController.updateExchange(
            source: exchangeController.destinationCurrency,
            destination: exchangeController.sourceCurrency,
          );
        },
      );
  Widget buildSecondBox() => ExchangeBox.second(
        isHaveIcon: exchangeController.isSwaped.value ? false : true,
        isIconChange: exchangeController.isFixedPressed.value,
        textController: exchangeController.isSwaped.value
            ? exchangeController.sourceTextController
            : exchangeController.destinationTextController,
        currency: exchangeController.destinationCurrency,
        onPressed: () {
          // launch searchbox by tap here
          if (exchangeController.isSwaped.value) {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(currentBox: 0));
          } else {
            showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  currentBox: 1,
                ));
          }
        },
        openIconPressed: () {
          buildFixSnakBar(context);
          exchangeController.updateFix();
          exchangeController.isSecondTyping = true.obs;
          exchangeController.updateExchange(
              source: exchangeController.sourceCurrency,
              destination: exchangeController.destinationCurrency,
              isForReverse: true);
        },
        closeIconPressed: () {
          exchangeController.updateFix();
          exchangeController.isFirstTyping = true.obs;
          exchangeController.updateExchange(
            source: exchangeController.sourceCurrency,
            destination: exchangeController.destinationCurrency,
          );
        },
      );

  Widget buildSwapButton() => SwapButton(onTap: () {
        setState(() {
          if (!exchangeController.destinationCurrency!.availableForSell!) {
            Get.snackbar('توجه!',
                ' ارز ${exchangeController.destinationCurrency!.faName} قابل فروش نیست');
          } else {
            if (!exchangeController.sourceCurrency!.availableForBuy!) {
              Get.snackbar('توجه!',
                  ' ارز ${exchangeController.sourceCurrency!.faName} قابل خرید نیست');
            } else {
              isSwapped ? controller.reverse() : controller.forward();
              exchangeController.updateSwap();
              isSwapped = !isSwapped;
              isMassegeShow = !isMassegeShow;
            }
          }
        });
      });

  Widget buildResult(
      BuildContext context, ExchangePageController exchangeController) {
    var source = exchangeController.sourceAmount.value;
    var destination = exchangeController.destinationAmount.value;
    return GestureDetector(
      onTap: () => buildHelpSnakbar(context),
      child: Row(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "${exchangeController.destinationCurrency!.symbol!.toUpperCase()} ",
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 1.0,
                      ),
                ),
                Text(
                  kPersianDigit((destination / source).toStringAsFixed(8)),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 1.0,
                      ),
                ),
                Text(
                  '  ~',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                Text(
                  '  ${exchangeController.sourceCurrency!.symbol!.toUpperCase()} ',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                Text(
                  ' ${kPersianDigit('1')}',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        /*    Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '  ~',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 20),
                ),
                Text(
                  '  ${exchangeController.sourceCurrency!.symbol!.toUpperCase()} ',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  ' ${kPersianDigit('1')}',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ],
            ),
         */
      ]),
    );
  }

  Widget buildHintBox({bool isforReverse = false}) => GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          height: 70,
          child: Column(
            children: [
              if (exchangeController.minimumExchangeAmount.value >
                  exchangeController.amount.value)
                Row(
                  children: [
                    Text(
                      'کمترین مقدار قابل مبادله ',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      '${exchangeController.sourceCurrency!.symbol!.toUpperCase()}'
                      ':',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        exchangeController.sourceTextController.text =
                            kPersianDigit(
                                exchangeController.minimumExchangeAmount.value);
                        exchangeController.firstOnChange(
                            exchangeController.sourceTextController.text);
                        exchangeController.isSourceHasLimitation = false.obs;
                        exchangeController.isDestanitionHasLimitation =
                            false.obs;
                        exchangeController.update();
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide?>(
                              const BorderSide(color: Colors.red, width: 0))),
                      child: Text(
                          ' ${exchangeController.exchangeRate!.minimumExchangeAmount!}',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
  Widget buildSecondHintBox({bool isforReverse = false}) => GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
          ),
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          height: 100,
          child: Column(
            children: [
              if (exchangeController.minimumExchangeAmount.value >
                  exchangeController.amount.value)
                Row(
                  children: [
                    Text(
                      'کمترین مقدار قابل مبادله ',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    Text(
                      '${exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                      ':',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        if (isSwapped) {
                          exchangeController.sourceTextController.text =
                              kPersianDigit(exchangeController
                                  .minimumExchangeAmount.value);
                          exchangeController.firstOnChange(
                              exchangeController.sourceTextController.text);
                        } else {
                          exchangeController.destinationTextController.text =
                              kPersianDigit(exchangeController
                                  .minimumExchangeAmount.value);
                          exchangeController.secondOnChange(exchangeController
                              .destinationTextController.text);
                        }
                        exchangeController.isSourceHasLimitation = false.obs;
                        exchangeController.isDestanitionHasLimitation =
                            false.obs;
                        exchangeController.update();
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide?>(
                              const BorderSide(color: Colors.red, width: 0))),
                      child: Text(
                          ' ${exchangeController.minimumExchangeAmount}',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  )),
                    ),
                  ],
                ),
              if (exchangeController.maximumExchangeAmount.value <
                  exchangeController.amount.value)
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'بیشترین مقدار قابل مبادله ',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          '${isSwapped ? exchangeController.sourceCurrency!.symbol!.toUpperCase() : exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                          ':',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                            ' ${exchangeController.exchangeRate!.maximumExchangeAmount!}',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.black,
                                    )),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        if (isSwapped) {
                          exchangeController.destinationTextController.text =
                              kPersianDigit(exchangeController
                                  .minimumExchangeAmount.value);
                          exchangeController.secondOnChange(exchangeController
                              .destinationTextController.text);
                        }
                        {
                          exchangeController.sourceTextController.text =
                              kPersianDigit(exchangeController
                                  .minimumExchangeAmount.value);
                          exchangeController.firstOnChange(
                            exchangeController.sourceTextController.text,
                          );
                        }

                        exchangeController.isSecondTyping = false.obs;
                        exchangeController.isSourceHasLimitation = false.obs;
                        exchangeController.isDestanitionHasLimitation =
                            false.obs;
                        exchangeController.update();
                      },
                      style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide?>(
                              const BorderSide(color: Colors.red, width: 0))),
                      child: Text('معامله با نرخ شناور',
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );

  void buildFixSnakBar(BuildContext context) {
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return Container(
            height: Get.height * 0.3,
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerTheme.color,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'این یک نرخ مورد انتظار است',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'تغییر اکنون بهترین نرخرا برای شما در لحظه مبادله انتخاب می کند'
                      '\n هزینه های شبکه و سایر هزینه های مبادله در نرخ گنجانده شده است'
                      '\n ما هییچ هزنیه اضافی را تضمین نمی کنیم .',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void buildHelpSnakbar(BuildContext context) {
    showModalBottomSheet(
        isDismissible: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return Container(
            height: Get.height * 0.3,
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerTheme.color,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'این یک نرخ مورد انتظار است',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'تغییر اکنون بهترین نرخرا برای شما در لحظه مبادله انتخاب می کند'
                      '\n هزینه های شبکه و سایر هزینه های مبادله در نرخ گنجانده شده است'
                      '\n ما هییچ هزنیه اضافی را تضمین نمی کنیم .',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
