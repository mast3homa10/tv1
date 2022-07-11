import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:clipboard/clipboard.dart';
import 'package:get/get.dart';

import '../../../../backend/api/get_transaction_status.dart';
import '../../../../backend/models/get_transaction_status_model.dart';
import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../exchange/exchange_page_controller.dart';
import '../steps_page_controller.dart';

class Step2 extends StatefulWidget {
  const Step2({
    Key? key,
  }) : super(key: key);

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final finalController = Get.put(FinalStepsController());

  final exchangeController = Get.put(ExchangePageController());

  final addressController = Get.put(AddressPageController());
  Timer? timer;
  bool isWaitting = true;
  GetTransactionStatusModel? transactionStatus;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) async {
      transactionStatus = await GetTransactionStatusApi()
          .getExchangeRate(finalController.transaction.value.id);
      setState(() {});
      // Transaction status:
      //   new,
      //   waiting,
      //   confirming,
      //   exchanging,
      //   sending,
      //   finished,
      //   failed,
      //   refunded,
      //   verifying
      if (transactionStatus!.txStatus == 'confirming' ||
          transactionStatus!.txStatus == 'exchanging' ||
          transactionStatus!.txStatus == 'sending') {
        log('status : ${transactionStatus!.txStatus}');
      } else {
        await Future.delayed(const Duration(seconds: 15));
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مقدار واریزی شما: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      '${exchangeController.sourceAmount}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مقدار دریافتی شما: ',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'آدرس کیف پول  ${exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                      ' (${exchangeController.destinationCurrency!.inNetwork!.toUpperCase()})'
                      ' دریافتی شما: ',
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
                                      .then((value) => log('copied'));
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
                            addressController.textAddressController.text,
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
                ),
                if (addressController.textSupportAddressController.text != '')
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'آدرس کیف پول بازپرداخت  ${exchangeController.sourceCurrency!.symbol!.toUpperCase()}'
                            ' (${exchangeController.sourceCurrency!.inNetwork!.toUpperCase()})'
                            '  شما: ',
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
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  addressController
                                      .textSupportAddressController.text,
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
              ],
            ),
          ),
        ),
        Container(
            padding: const EdgeInsets.all(25.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.green,
                ),
                color: Colors.green.withOpacity(0.08)),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
                Text(
                  'مبادله شما با بهترین نرخ ارز در حال انجامم می باشد.',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Colors.green,
                      ),
                ),
              ],
            ))
      ],
    );
  }
}
