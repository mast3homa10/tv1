import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend/models/currency_model.dart';
import '../../constants.dart';
import '../pages/exchange/exchange_page_controller.dart';

class HintBox extends StatelessWidget {
  const HintBox.first({
    Key? key,
    required this.controller,
    this.isforReverse = false,
    this.boxId = 0,
  }) : super(key: key);
  const HintBox.second({
    Key? key,
    required this.controller,
    this.isforReverse = false,
    this.boxId = 1,
  }) : super(key: key);

  final ExchangePageController controller;
  final bool isforReverse;
  final int boxId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0)),
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        height: 80,
        child: boxId == 0
            ? Column(
                children: [
                  if (controller.minimumExchangeAmount.value >
                      controller.amount.value)
                    CustomMessage.min(
                      context: context,
                      controller: controller,
                      hintId: 0,
                      currency: controller.sourceCurrency,
                    ),
                  if (controller.maximumExchangeAmount.value > 0 &&
                      controller.maximumExchangeAmount.value <
                          controller.amount.value)
                    CustomMessage.max(
                      context: context,
                      controller: controller,
                      hintId: 0,
                      currency: controller.sourceCurrency,
                    ),
                ],
              )
            : Column(
                children: [
                  if (controller.minimumExchangeAmount.value >
                      controller.amount.value)
                    CustomMessage.min(
                      context: context,
                      controller: controller,
                      hintId: 1,
                      currency: controller.destinationCurrency,
                    ),
                  if (controller.maximumExchangeAmount.value <
                          controller.amount.value &&
                      controller.maximumExchangeAmount.value > 0)
                    CustomMessage.max(
                        context: context,
                        controller: controller,
                        hintId: 1,
                        currency: controller.destinationCurrency),
                ],
              ),
      ),
    );
  }
}

class CustomMessage extends StatelessWidget {
  const CustomMessage.min(
      {Key? key,
      required this.context,
      required this.controller,
      required this.hintId,
      this.currency,
      this.action = 'min'})
      : super(key: key);
  const CustomMessage.max(
      {Key? key,
      required this.context,
      required this.controller,
      required this.hintId,
      this.currency,
      this.action = 'max'})
      : super(key: key);

  final BuildContext context;
  final ExchangePageController controller;
  final String action;
  final int hintId;
  final CurrencyModel? currency;

  @override
  Widget build(BuildContext context) {
    if (action == 'min') {
      return Row(
        children: [
          Text(
            'کمترین مقدار قابل مبادله ',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          ),
          Text(
            '${currency!.symbol!.toUpperCase()}'
            ':',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              if (controller.isSwapped.value) {
                if (hintId == 0) {
                  controller.destinationTextController.text =
                      kPersianDigit(controller.minimumExchangeAmount.value);
                  controller.secondOnChange(
                      controller.destinationTextController.text);
                } else {
                  controller.sourceTextController.text =
                      kPersianDigit(controller.minimumExchangeAmount.value);
                  controller
                      .firstOnChange(controller.sourceTextController.text);
                }
              } else {
                if (hintId == 0) {
                  controller.sourceTextController.text =
                      kPersianDigit(controller.minimumExchangeAmount.value);
                  controller
                      .firstOnChange(controller.sourceTextController.text);
                } else {
                  controller.destinationTextController.text =
                      kPersianDigit(controller.minimumExchangeAmount.value);
                  controller.secondOnChange(
                      controller.destinationTextController.text);
                }
              }

              controller.isSourceHasLimitation = false.obs;
              controller.isDestinationHasLimitation = false.obs;
              controller.update();
            },
            style: ButtonStyle(
                side: MaterialStateProperty.all<BorderSide?>(
                    const BorderSide(color: Colors.red, width: 0))),
            child: Text(' ${controller.exchangeRate!.minimumExchangeAmount!}',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    )),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Text(
                'ّ بیشترین مقدار قابل مبادله ',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              Text(
                '${currency!.symbol!.toUpperCase()}'
                ':',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black),
              ),
              TextButton(
                onPressed: () {
                  if (hintId == 0) {
                    controller.sourceTextController.text =
                        kPersianDigit(controller.maximumExchangeAmount.value);
                    controller
                        .firstOnChange(controller.sourceTextController.text);
                  } else {
                    /* if (controller.isSwapped.value) {
                      controller.destinationTextController.text =
                          kPersianDigit(controller.minimumExchangeAmount.value);
                      controller.secondOnChange(
                          controller.destinationTextController.text);
                    }
                    {
                      controller.sourceTextController.text =
                          kPersianDigit(controller.minimumExchangeAmount.value);
                      controller.firstOnChange(
                        controller.sourceTextController.text,
                      );
                    } */
                  }
                  controller.isSecondTyping = false.obs;
                  controller.isSourceHasLimitation = false.obs;
                  controller.isDestinationHasLimitation = false.obs;
                  controller.update();
                },
                style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide?>(
                        const BorderSide(color: Colors.red, width: 0))),
                child:
                    Text(' ${controller.exchangeRate!.maximumExchangeAmount!}',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            )),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget buildSwimingFee(hitid, isSwapped) {
    if (isSwapped) {
      return TextButton(
        onPressed: () {
          if (controller.isSwapped.value) {
            controller.destinationTextController.text =
                kPersianDigit(controller.minimumExchangeAmount.value);
            controller
                .secondOnChange(controller.destinationTextController.text);
          }
          {
            controller.sourceTextController.text =
                kPersianDigit(controller.minimumExchangeAmount.value);
            controller.firstOnChange(
              controller.sourceTextController.text,
            );
          }

          controller.isSecondTyping = false.obs;
          controller.isSourceHasLimitation = false.obs;
          controller.isDestinationHasLimitation = false.obs;
          controller.update();
        },
        style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide?>(
                const BorderSide(color: Colors.red, width: 0))),
        child: Text('معامله با نرخ شناور',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                )),
      );
    } else {
      return TextButton(
        onPressed: () {
          if (controller.isSwapped.value) {
            controller.destinationTextController.text =
                kPersianDigit(controller.minimumExchangeAmount.value);
            controller
                .secondOnChange(controller.destinationTextController.text);
          }
          {
            controller.sourceTextController.text =
                kPersianDigit(controller.minimumExchangeAmount.value);
            controller.firstOnChange(
              controller.sourceTextController.text,
            );
          }

          controller.isSecondTyping = false.obs;
          controller.isSourceHasLimitation = false.obs;
          controller.isDestinationHasLimitation = false.obs;
          controller.update();
        },
        style: ButtonStyle(
            side: MaterialStateProperty.all<BorderSide?>(
                const BorderSide(color: Colors.red, width: 0))),
        child: Text('معامله با نرخ شناور',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                )),
      );
    }
  }
}
