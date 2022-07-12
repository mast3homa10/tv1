import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tv1/backend/models/get_transaction_status_model.dart';

import '../../../../backend/api/get_transaction_status.dart';
import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../../components/timer/custom_timer.dart';
import '../../exchange/exchange_page_controller.dart';
import '../steps_page_controller.dart';

class Step1 extends StatefulWidget {
  const Step1({
    Key? key,
  }) : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  final finalController = Get.put(FinalStepsController());

  final exchangeController = Get.put(ExchangePageController());

  final addressController = Get.put(AddressPageController());
  Timer? timer;
  bool isWaitting = true;
  GetTransactionStatusModel? transactionStatus;
  String text = '';
  String subject = '';

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      transactionStatus = await GetTransactionStatusApi()
          .getExchangeRate(finalController.transaction.value.id);
      setState(() {
        log('status : ${transactionStatus!.txStatus}');
      });
      if (transactionStatus!.txStatus == 'waiting') {
      } else {
        dispose();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    finalController.updateStep();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
          child: Container(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Theme.of(context).appBarTheme.backgroundColor),
            child: Column(
              children: [
                if (exchangeController.isFixedPressed.value)
                  Column(
                    children: [
                      Text(
                        'زمان باقی مانده برای ارسال ',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      CustomTimer(
                          maxSecond: 600,
                          controller: finalController.timerController.value),
                    ],
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مقدار واریزی توسط شما: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Row(
                      //   children: const [
                      //     Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Icon(Icons.copy),
                      //     ),
                      //     VerticalDivider(
                      //       width: 10.0,
                      //       thickness: 2.0,
                      //     ),
                      //   ],
                      // ),
                      Text(
                        '${exchangeController.sourceAmount}',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لطفا مقدار  ${exchangeController.sourceCurrency!.symbol!.toUpperCase()}'
                      ' (${exchangeController.sourceCurrency!.inNetwork!.toUpperCase()})'
                      ' مشخص شده را به آدرس زیر واریز نمایید: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: const Icon(Icons.copy),
                                onPressed: () {
                                  FlutterClipboard.copy(finalController
                                          .transaction.value.payinAddress!)
                                      .then((value) {
                                    log('copied');

                                    Get.snackbar('توجه!', 'آدرس کپی شد');
                                  });
                                }),
                          ),
                          const VerticalDivider(
                            width: 10.0,
                            thickness: 2.0,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            '${finalController.transaction.value.payinAddress}',
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.green),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  text =
                      finalController.transaction.value.payinAddress.toString();
                  setState(() {});
                  _onShare(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).appBarTheme.backgroundColor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'به اشتراک گذاری',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Icon(Icons.share)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  buildSnakBar(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).appBarTheme.backgroundColor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'مشاهده بارکد QR',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        const Icon(Icons.qr_code)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).appBarTheme.backgroundColor),
          child: ExpansionTile(
              collapsedIconColor: Theme.of(context).iconTheme.color,
              collapsedBackgroundColor:
                  Theme.of(context).appBarTheme.backgroundColor,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              iconColor: Theme.of(context).iconTheme.color,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'مقدار ${exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                      '(${exchangeController.destinationCurrency!.inNetwork!.toUpperCase()})'
                      ' دریافتی شما :',
                      style: Theme.of(context).textTheme.headline4),
                  Text(
                    '(${exchangeController.destinationCurrency!.inNetwork!.toUpperCase()})'
                    '  ${exchangeController.destinationAmount}   ~',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Colors.green),
                  ),
                ],
              ),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                        ' آدرس کیف پول '
                        '${exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                        '(${exchangeController.destinationCurrency!.inNetwork!.toUpperCase()}) شما: ',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      addressController.textAddressController.text,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.green),
                    ),
                  ),
                ),
              ]),
        ),
        if (isWaitting) const CircularProgressIndicator(),
      ],
    );
  }

  void _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(text,
        subject: subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  void buildSnakBar(BuildContext context) {
    showBottomSheet(
        // isDismissible: true,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(50),
        //   ),
        // ),
        // clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_back_ios),
                          Text(
                            'بازگشت',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      QrImage(
                          size: 200,
                          data: finalController.transaction.value.payinAddress
                              .toString(),
                          backgroundColor: Colors.white),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        height: 100,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerTheme.color ??
                                    Colors.grey),
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      icon: const Icon(Icons.copy),
                                      onPressed: () {
                                        FlutterClipboard.copy(finalController
                                                .transaction
                                                .value
                                                .payinAddress!)
                                            .then((value) {
                                          log('copied');

                                          Get.snackbar('توجه!', 'آدرس کپی شد');
                                        });
                                      }),
                                ),
                                const VerticalDivider(
                                  width: 10.0,
                                  thickness: 2.0,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  '${finalController.transaction.value.payinAddress}',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
