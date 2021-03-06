import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../dashboard/dashboard_body_controller.dart';

import '../../components/custom_button.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);
  final int currentItem = 0;
  final List dataItems = [
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
                              '?????????? ??????????',
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
                                            '????????????',
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
                                            '14 ???? ?????????? 1401',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          Text(
                                            '????????????',
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
              '???????? ?????? ?????????????? ??????????????!',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '?????? ???????????? ?????? ?????? ???? ?????? ???? ?????????? ???????????? ????. \n?????? ???? ???????????? ?????????? ?????????? ?????? ???? ???????? ?????? ???????? ????????',
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomButton(
              label: '???????? ??????????',
              onPressed: () {
                // Get.snackbar(
                //   '????????!',
                //   "???? ?????? ?????????? ...",
                // );
                controller.getCurrentPage(2);
              },
            ),
          ),
        ],
      );

  List<String> menuItems = [
    '???????? ????',
    '???? ???????????? ????????????',
    '??????????',
    '???? ?????? ??????????',
    '?????????? ??????',
    '????????',
    '?????????????????? ????',
    '???? ?????? ??????????',
    '?????????? ??????',
    '??????',
  ];
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
            height: Get.height * 0.7,
            color: Theme.of(context).bottomSheetTheme.backgroundColor,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Theme.of(context).dividerTheme.color,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 16 / 4.8,
                                  crossAxisCount: 2),
                          itemCount: menuItems.length,
                          itemBuilder: ((context, index) => Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, right: 4.0),
                                      child: TextButton(
                                        onPressed: () {
                                          Get.snackbar(
                                              '????????!', '???? ?????? ?????????? ...');
                                        },
                                        child: Text(
                                          menuItems[index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
