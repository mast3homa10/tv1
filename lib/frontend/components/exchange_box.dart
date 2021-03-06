import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tv1/frontend/components/timer/custom_timer.dart';

import '../pages/exchange/exchange_page_controller.dart';
import '../../backend/models/currency_model.dart';
import '../../backend/network_constants.dart';
import '../../constants.dart';

class ExchangeBox extends StatelessWidget {
  final int boxId;
  final TextEditingController? textController;
  final CurrencyModel? currency;
  final String? initialValue;
  final bool isHaveIcon;
  final bool isIconChange;
  final VoidCallback? openIconPressed;
  final VoidCallback? closeIconPressed;
  final VoidCallback? onPressed;
  ExchangeBox({
    Key? key,
    this.boxId = 0,
    this.textController,
    this.initialValue,
    this.currency,
    this.isHaveIcon = false,
    this.isIconChange = false,
    this.onPressed,
    this.openIconPressed,
    this.closeIconPressed,
  }) : super(key: key);

  ExchangeBox.second({
    Key? key,
    this.boxId = 1,
    this.textController,
    this.initialValue,
    this.currency,
    this.isHaveIcon = true,
    this.isIconChange = false,
    this.onPressed,
    this.openIconPressed,
    this.closeIconPressed,
  }) : super(key: key);

  final controller = Get.put(ExchangePageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 90,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).dividerTheme.color ?? const Color(0xFFEEEEEE),
          style: BorderStyle.solid,
          width: 2.0,
        ),
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
          child: Row(
        children: [
          // start search page by click the following text button
          SizedBox(
            width: Get.width * 0.35,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(17),
                      ),
                    ),
                    child: TextButton(
                      onPressed: onPressed,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey.withOpacity(0.2)),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(17)))),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  width: 0,
                                  color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor ??
                                      Theme.of(context)
                                          .scaffoldBackgroundColor))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // image part
                          Row(
                            children: [
                              if (currency!.symbol!.length < 8)
                                AspectRatio(
                                  aspectRatio: 11 / 9,
                                  child: SvgPicture.network(
                                    '$imgUrl${currency!.legacyTicker}.svg',
                                    semanticsLabel: 'A shark?!',
                                    placeholderBuilder:
                                        (BuildContext context) => Container(),
                                  ),
                                ),
                              Text(
                                currency!.symbol!.toUpperCase(),
                                style: Theme.of(context).textTheme.headline4,
                                maxLines: 1,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                            ],
                          ),
                          Icon(
                            FontAwesomeIcons.angleDown,
                            color: Theme.of(context).dividerTheme.color,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(17),
                        ),
                        color: kNetworkColorList[
                                currency!.inNetwork!.toLowerCase()] ??
                            Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(
                        child: Text(
                          currency!.inNetwork!.toUpperCase(),
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(
            width: 2.0,
            thickness: 1.0,
            indent: 3,
            endIndent: 3,
          ),

          Expanded(
              flex: 4,
              child: boxId == 1
                  ? buildBuyBox(context, controller)
                  : buildSellBox(context, controller)),
          // following part is for provide for fixer.
          Expanded(child: buildFixIcon(context)),
        ],
      )),
    );
  }

//
  Widget buildSellBox(
          BuildContext context, ExchangePageController controller) =>
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: (controller.isSwapped.value
                  ? controller.isFirstTyping.value
                  : controller.isSecondTyping.value)
              ? GestureDetector(
                  onTap: () {
                    if (controller.isSwapped.value) {
                      controller.isFirstTyping = false.obs;
                      controller.destinationTextController.text = '';
                    } else {
                      controller.isSecondTyping = false.obs;
                      controller.sourceTextController.text = '';
                    }

                    controller.update();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20), child: kSpinkit),
                )
              : Form(
                  key: key,
                  child: TextFormField(
                    controller: textController,
                    toolbarOptions: const ToolbarOptions(
                        copy: false,
                        paste: false,
                        cut: false,
                        selectAll: false),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.greenAccent,
                              width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.red,
                              width: 5.0),
                        ),
                        hintText: '?????????? ???? ???????? ????????',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: Theme.of(context).dividerTheme.color)),
                    onChanged: controller.isSwapped.value
                        ? controller.secondOnChange
                        : controller.firstOnChange,
                  ),
                ));
  Widget buildBuyBox(BuildContext context, ExchangePageController controller) =>
      Padding(
          padding: const EdgeInsets.all(10.0),
          child: (controller.isSwapped.value
                  ? controller.isSecondTyping.value
                  : controller.isFirstTyping.value)
              ? GestureDetector(
                  onTap: () {
                    if (controller.isSwapped.value) {
                      controller.isSecondTyping = false.obs;
                      controller.sourceTextController.text = '';
                    } else {
                      controller.isFirstTyping = false.obs;
                      controller.destinationTextController.text = '';
                    }

                    controller.update();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(20), child: kSpinkit),
                )
              : Form(
                  key: key,
                  child: TextFormField(
                    controller: textController,
                    toolbarOptions: const ToolbarOptions(
                        copy: false,
                        paste: false,
                        cut: false,
                        selectAll: false),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.greenAccent,
                              width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor ??
                                  Colors.red,
                              width: 5.0),
                        ),
                        hintText: '?????????? ???? ???????? ????????',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline3!
                            .copyWith(
                                color: Theme.of(context).dividerTheme.color)),
                    onChanged: controller.isSwapped.value
                        ? controller.firstOnChange
                        : controller.secondOnChange,
                  ),
                ));

  Widget? buildImage(String? legacyTicker) {
    try {
      return AspectRatio(
        aspectRatio: 0.35,
        child: SvgPicture.network(
          '$imgUrl$legacyTicker.svg',
          semanticsLabel: 'A shark?!',
          placeholderBuilder: (BuildContext context) => Container(),
        ),
      );
    } catch (e) {
      log('$e');
    }
    return null;
  }

  Widget buildFixIcon(BuildContext context) {
    if (isHaveIcon) {
      return GetBuilder<ExchangePageController>(
        builder: (controller) {
          return isIconChange
              ? Column(
                  children: [
                    //todo: set timer for exchange box
                    if (controller.isFixedPressed.value &&
                        boxId == 0 &&
                        controller.isSwapped.value)
                      CustomTimer(
                        seconds: controller.time.value,
                      ),

                    if (controller.isFixedPressed.value && boxId == 1)
                      CustomTimer(
                        seconds: controller.time.value,
                      ),

                    IconButton(
                      onPressed: closeIconPressed,
                      icon: Icon(
                        CupertinoIcons.lock,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ],
                )
              : IconButton(
                  onPressed: openIconPressed,
                  icon: Icon(
                    CupertinoIcons.lock_open,
                    color: Theme.of(context).dividerTheme.color,
                  ),
                );
        },
      );
    } else {
      return Container();
    }
  }
}
