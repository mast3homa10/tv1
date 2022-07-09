import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tv1/frontend/components/custom_big_button.dart';
import 'package:tv1/frontend/pages/dashboard/dashboard_body.dart';

import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../exchange/exchange_page_controller.dart';
import '../steps_page_controller.dart';

class Step3 extends StatefulWidget {
  const Step3({
    Key? key,
  }) : super(key: key);

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final finalController = Get.put(FinalStepsController());

  final exchangeController = Get.put(ExchangePageController());

  final addressController = Get.put(AddressPageController());

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                      Column(
                        children: [
                          Text(
                            '14 خرداد 1401',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.add),
                              Text(
                                'مشاهده TXID',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'مقدار دریافتی شما: ',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Text(
                            ' 54654646685 ~',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '14 خرداد 1401',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Row(
                            children: [
                              const Icon(Icons.add),
                              Text(
                                'مشاهده TXID',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'آدرس کیف پول  ${exchangeController.destinationCurrency!.symbol!.toUpperCase()}'
                        ' (${exchangeController.destinationCurrency!.inNetwork!.toUpperCase()})'
                        ' دریافتی شما: ',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        addressController.textAddressController.text,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.end,
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(40.0),
          child: CustomBigButton(
            onPressed: () {
              Get.to(() => DashboardBody());
              finalController.currentstep = 0.obs;
            },
            label: 'مبادله جدید',
          ),
        ),
        GestureDetector(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.share),
              ),
              Text('اشتراک گذاری جزئیات مبادله',
                  style: Theme.of(context).textTheme.headline5)
            ],
          ),
          onTap: () {
            Get.snackbar('توجه!', 'در حال توسعه ...');
          },
        )
      ],
    );
  }
}
