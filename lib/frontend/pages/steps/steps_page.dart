import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/toggle_switch_button.dart';
import '../exchange/exchange_page_controller.dart';
import 'steps_page_controller.dart';
import 'sub_screen/step1.dart';
import 'sub_screen/step2.dart';
import 'sub_screen/step3.dart';

class StepsPage extends StatefulWidget {
  const StepsPage({Key? key}) : super(key: key);

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  final finalController = Get.put(FinalStepsController());
  final exchangeController = Get.put(ExchangePageController());
  List<Widget> steps = [
    const Step1(),
    const Step2(),
    const Step3(),
  ];
  List<String> appBarLabels = [
    'در انتظار واریز شما',
    'در حال تبادل',
    'پایان مبادله',
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FinalStepsController>(
        builder: (finalController) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.0,
                title: Text(appBarLabels[finalController.currentstep.value]),
                actions: const [
                  ToggleSwitchButton(),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0,
                          bottom: 8.0,
                          right: Get.width * 0.15,
                          left: Get.width * 0.15),
                      margin: const EdgeInsets.only(
                          top: 8.0, right: 8.0, left: 8.0),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Theme.of(context).appBarTheme.backgroundColor),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 35, maxWidth: Get.width * 0.8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: finalController.stepsLabel.length,
                          itemBuilder: (context, index) => SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color:
                                          finalController.currentstep.value >=
                                                  index
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      finalController.stepsLabel[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(fontSize: 27.0),
                                    ),
                                  ),
                                ),
                                if (index < 2)
                                  SizedBox(
                                    width: Get.width * 0.2,
                                    child: Divider(
                                      color:
                                          (finalController.currentstep.value -
                                                      1) >=
                                                  index
                                              ? Colors.green
                                              : Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                      thickness: 8,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    IndexedStack(
                      index: finalController.currentstep.value,
                      children: steps,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: biuldNavbar(),
            ));
  }

  Widget biuldNavbar() => Container(
        height: 60,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        decoration:
            BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'آی دی تراکنش: ',
                style: Theme.of(context).textTheme.headline4,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                FlutterClipboard.copy(
                                        finalController.transaction.value.id!)
                                    .then((value) => log('copied'));
                                Get.snackbar("توجه!", "کپی شد");
                              }),
                        ),
                        Expanded(
                          child: Text(
                            '${finalController.transaction.value.id}',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
