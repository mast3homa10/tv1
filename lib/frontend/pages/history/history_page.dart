import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../dashboard/dashboard_body_controller.dart';

import '../../components/custom_big_button.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);
  final int currentItem = 0;
  List dataItems = [
    'fdasadffasdfdasfaf',
    'fdasadffasdfd54984965asd9849faasfaf',
    'fdasad651ffasdfd54984965asdaasfaf',
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardBodyController>(builder: (controller) {
      return Scaffold(body: buildHistoryPage(context, controller));
    });
  }

  Widget buildHistoryPage(
          BuildContext context, DashboardBodyController controller) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context).backgroundColor)
                    ],
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0)),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  child: GestureDetector(
                    onTap: () => buildMenuSnakBar(context),
                    child: Container(
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'وضعیت سفارش',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                            )
                          ],
                        ))),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: Get.height * 0.5, maxWidth: Get.width),
                      child: ListView.builder(
                        itemCount: dataItems.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                                leading: SizedBox(
                                  width: Get.width * 0.7,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'مبادله',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          Text(
                                            '231235465468',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '14 ام خرداد 1401',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          Text(
                                            'مبادله',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Text(
                                  'test',
                                  style: Theme.of(context).textTheme.headline4,
                                )),
                            const Divider()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  Widget buildNotransactionPage(
          BuildContext context, DashboardBodyController controller) =>
      Column(
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
      );

  void buildMenuSnakBar(BuildContext context) {
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
