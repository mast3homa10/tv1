import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../components/exchange_box.dart';
import '../../../frontend/components/convert_button.dart';
import '../../../frontend/components/custom_big_button.dart';
import '../../../frontend/components/custom_search_delegate.dart';
import '../../../frontend/components/timer/timer_controller.dart';
import '../../../frontend/pages/address_page.dart/address_page.dart';
import 'exchange_page_controller.dart';

class ExchangePage extends StatelessWidget {
  ExchangePage({Key? key}) : super(key: key);

  final timerController = Get.put(TimerController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExchangePageController>(
      builder: (exchangeController) {
        try {
          if (!exchangeController.connectToNetwork.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // the Expanded widget below contains ''' cryptocurrency calculator '''.
                  Expanded(
                    child: SizedBox(
                      height: Get.height * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            /// for sell box
                            ExchangeBox(
                              textController:
                                  exchangeController.sourceTextController,
                              currency: exchangeController.isReversed.value
                                  ? exchangeController.destinationCurrency
                                  : exchangeController.sourceCurrency,
                              onPressed: () {
                                // launch searchbox by tap here
                                showSearch(
                                    context: context,
                                    delegate:
                                        CustomSearchDelegate(currentBox: 0));
                              },
                            ),
                            // exchange result
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildResult(context, exchangeController),

                                  // Reversed button
                                  ReversedButton(
                                      onTap: exchangeController.updateReversed),
                                ],
                              ),
                            ),
                            // for buy box
                            ExchangeBox.second(
                              textController:
                                  exchangeController.destinationTextController,
                              currency: exchangeController.isReversed.value
                                  ? exchangeController.sourceCurrency
                                  : exchangeController.destinationCurrency,
                              onPressed: () {
                                // launch searchbox by tap here
                                showSearch(
                                    context: context,
                                    delegate: CustomSearchDelegate(
                                      currentBox: 1,
                                    ));
                              },
                              isIconChange: exchangeController.isFixed.value,
                              openIconPressed: () {
                                buildSnakBar(context);
                                exchangeController.updateFix();
                              },
                              closeIconPressed: () {
                                timerController.stopTimer();
                                exchangeController.updateFix();
                              },
                            ),
                          ],
                        ),
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
            );
          }
        } catch (e) {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void buildSnakBar(BuildContext context) {
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

  Widget buildResult(
      BuildContext context, ExchangePageController exchangeController) {
    var source = exchangeController.sourceAmount.value;
    var destination = exchangeController.destinationAmount.value;
    return Column(children: [
      Row(
        children: [
          Text(
            ' هر یک  '
            '${exchangeController.sourceCurrency!.symbol!.toUpperCase()} ~ ',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Text(
                    "${exchangeController.destinationCurrency!.symbol!.toUpperCase()} ",
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                  ),
                  Text(
                    (destination / source).toStringAsFixed(8),
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Icon(FontAwesomeIcons.circleArrowDown,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
