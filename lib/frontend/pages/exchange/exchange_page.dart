import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tv1/frontend/pages/dashboard/dashboard_body_controller.dart';

import '../../../frontend/components/try_again_button.dart';
import '../../../constants.dart';
import '../../components/exchange_box.dart';
import '../../components/swap_button.dart';
import '../../components/custom_button.dart';
import '../../../frontend/components/custom_search_delegate.dart';
import '../../components/hint_box.dart';
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

  late AnimationController animationController;
  late Animation<double> addressAnimation;
  animationListener() => setState(() {});

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Initialize animations
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    addressAnimation = Tween(
      begin: 0.0,
      end: widgetBTop - widgetATop,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
    ))
      ..addListener(animationListener);
  }

  @override
  dispose() {
    // Dispose of animation controller
    animationController.dispose();
    super.dispose();
  }

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
              exchangeController.isDestinationHasLimitation = false.obs;
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
                                        child: _buildFirstBox()),
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
                                            _buildResult(
                                                context, exchangeController),
                                            _buildSwapButton(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // first hit box
                                    if ((isSwapped
                                        ? exchangeController
                                            .isDestinationHasLimitation.value
                                        : exchangeController
                                            .isSourceHasLimitation.value))
                                      Positioned(
                                          top: (widgetATop + 75) + tweenValue,
                                          width: Get.width,
                                          child: isSwapped
                                              ? HintBox.first(
                                                  controller:
                                                      exchangeController,
                                                  isforReverse: true)
                                              : HintBox.first(
                                                  controller:
                                                      exchangeController)),
                                    // for buy box
                                    Positioned(
                                        top: widgetBTop - tweenValue,
                                        width: Get.width,
                                        child: _buildSecondBox()),

                                    //seond hit box
                                    if ((isSwapped
                                        ? exchangeController
                                            .isSourceHasLimitation.value
                                        : exchangeController
                                            .isDestinationHasLimitation.value))
                                      Positioned(
                                          top: (widgetBTop + 75) - tweenValue,
                                          width: Get.width,
                                          child: isSwapped
                                              ? HintBox.second(
                                                  controller:
                                                      exchangeController,
                                                )
                                              : HintBox.second(
                                                  controller:
                                                      exchangeController,
                                                  isforReverse: true)),
                                  ],
                                ),
                              ),
                            ),

                            // the padding widget below contains '''add address button'''.
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CustomButton(
                                label: 'وارد کردن آدرس',
                                onPressed: () {
                                  // Get.to(AddressPage());
                                  final dashboardController =
                                      Get.put(DashboardBodyController());
                                  dashboardController.changeScreen();
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

  Widget _buildFirstBox() => ExchangeBox(
        isHaveIcon: exchangeController.isSwapped.value ? true : false,
        isIconChange: exchangeController.isFixedPressed.value,
        textController: exchangeController.isSwapped.value
            ? exchangeController.destinationTextController
            : exchangeController.sourceTextController,
        currency: exchangeController.sourceCurrency,
        onPressed: () {
          // launch searchbox by tap here
          if (exchangeController.isSwapped.value) {
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
          _buildFixSnakBar(context);
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
  Widget _buildSecondBox() => ExchangeBox.second(
        isHaveIcon: exchangeController.isSwapped.value ? false : true,
        isIconChange: exchangeController.isFixedPressed.value,
        textController: exchangeController.isSwapped.value
            ? exchangeController.sourceTextController
            : exchangeController.destinationTextController,
        currency: exchangeController.destinationCurrency,
        onPressed: () {
          // launch searchbox by tap here
          if (exchangeController.isSwapped.value) {
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
          _buildFixSnakBar(context);
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

  Widget _buildSwapButton() => SwapButton(onTap: () {
        setState(() {
          if (!exchangeController.destinationCurrency!.availableForSell!) {
            Get.snackbar('توجه!',
                ' ارز ${exchangeController.destinationCurrency!.faName} قابل فروش نیست');
          } else {
            if (!exchangeController.sourceCurrency!.availableForBuy!) {
              Get.snackbar('توجه!',
                  ' ارز ${exchangeController.sourceCurrency!.faName} قابل خرید نیست');
            } else {
              isSwapped
                  ? animationController.reverse()
                  : animationController.forward();
              exchangeController.updateSwap();
              isSwapped = !isSwapped;
              isMassegeShow = !isMassegeShow;
            }
          }
        });
      });

  Widget _buildResult(
      BuildContext context, ExchangePageController exchangeController) {
    var source = exchangeController.sourceAmount.value;
    var destination = exchangeController.destinationAmount.value;
    return GestureDetector(
      onTap: () => _buildHelpSnakbar(context),
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

  void _buildFixSnakBar(BuildContext context) {
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
                      'تغییر اکنون بهترین نرخ را برای شما در لحظه مبادله انتخاب می کند'
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

  void _buildHelpSnakbar(BuildContext context) {
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
