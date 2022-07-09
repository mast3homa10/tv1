import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';

class CustomMenuItem extends StatelessWidget {
  const CustomMenuItem({
    Key? key,
    this.label = '',
    this.buildSubScreen,
    this.icon = Icons.add,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final Widget? buildSubScreen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Icon(icon),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(BorderSide(
                          width: 0,
                          color: Theme.of(context).scaffoldBackgroundColor))),
                  onPressed: () {
                    // Get.snackbar('توجه!', 'در حال توسعه ...');
                    showBottomSheet(
                        context: context,
                        builder: (context) => Scaffold(
                              body: Column(
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                      side: MaterialStateProperty
                                          .all<BorderSide>(BorderSide(
                                              width: 0.0,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(label,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3),
                                        Icon(FontAwesomeIcons.angleLeft,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color),
                                      ],
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  buildSubScreen!,
                                ],
                              ),
                            ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).dividerTheme.color
                            ),
                      ),
                      Icon(
                        FontAwesomeIcons.angleLeft,
                        color: Theme.of(context).iconTheme.color,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  height: 0,
                  endIndent: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
