import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../backend/api/create_transaction.dart';
import '../../../backend/api/validation_address.dart';
import '../../../backend/models/validation_address_model.dart';
import '../exchange/exchange_page_controller.dart';
import '../steps/steps_page.dart';
import '../steps/steps_page_controller.dart';
import '../../../enums.dart';

class AddressPageController extends GetxController {
  var currentTopItem = 1.obs;
  getCurrentTopItem(int index) {
    currentTopItem = index.obs;
    update();
  }

  var currentToggleItem = 1.obs;
  getToggleItem(int index) {
    currentToggleItem = index.obs;
    update();
  }

  var isSupportAddressMustBeEmpty = false.obs;
  setSupportAddress() => isSupportAddressMustBeEmpty = true.obs;

  var isSecondBoxShow = false.obs;
  showSecondBox() => isSecondBoxShow = true.obs;

  var isPressed = false.obs;
  var isFirstBoxValid = false.obs;
  var isssecondBoxValid = false.obs;
  var currenButton = Button.first.obs;
  var textAddressController = TextEditingController();
  var textSupportAddressController = TextEditingController();
  var exchangeController = Get.put(ExchangePageController());
  late BuildContext context;

  addAddress(BuildContext context) async {
    isPressed = true.obs;
    update();
    if (currenButton.value == Button.first) {
      if (textAddressController.text.isEmpty) {
        isPressed = false.obs;
        update();
        Get.snackbar(
            'توجه!', "برای شروع تبادل باید آدرس کیف پول خود را وارد کنید.");
      } else {
        ValidationAddressModel? validAddress = await ValidationAddressApi()
            .getValidation(
                address: textAddressController.text,
                currencyNetwork:
                    exchangeController.destinationCurrency!.inNetwork!);
        log('validation address :$validAddress');

        if (validAddress!.isValid == 'true') {
          showSecondBox();
          currenButton = Button.second.obs;
          isPressed = false.obs;
          isFirstBoxValid = true.obs;

          update();
        } else {
          Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
          isPressed = false.obs;
          update();
        }
      }
    } else if (currenButton.value == Button.second) {
      if (textSupportAddressController.text.isEmpty &&
          currenButton.value == Button.second) {
        Get.defaultDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: "توجه!",
          titleStyle: Theme.of(context).textTheme.headline4,
          content: Text(
            "آیا از خالی گذاشتن آدرس بازپرداخت مطمئن هستید؟ ",
            style: Theme.of(context).textTheme.headline4,
          ),
          onWillPop: () async {
            isPressed = false.obs;
            update();

            return true;
          },
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    'بله',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Yekanbakh",
                        color: Colors.green),
                  ),
                  onPressed: () {
                    currenButton = Button.last.obs;
                    isPressed = false.obs;
                    isssecondBoxValid = true.obs;
                    update();

                    Get.back();
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  child: const Text(
                    'خیر',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Yekanbakh",
                        color: Colors.red),
                  ),
                  onPressed: () {
                    isPressed = false.obs;
                    update();
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        );
      } else {
        ValidationAddressModel? validAddress = await ValidationAddressApi()
            .getValidation(
                address: textSupportAddressController.text,
                currencyNetwork:
                    exchangeController.sourceCurrency!.legacyTicker!);
        if (validAddress!.isValid == 'true') {
          currenButton = Button.last.obs;
          isPressed = false.obs;
          isssecondBoxValid = true.obs;
          update();
        } else {
          isPressed = false.obs;
          update();

          Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
        }

        isPressed = false.obs;
        update();
      }
    } else {
      var create = await CreateTransactionApi().create();
      final finalController = Get.put(FinalStepsController());
      finalController.setTransactioin(create!);

      log('here:${create.payinAddress}');
      Get.to(() => const StepsPage());

      isPressed = false.obs;
      update();
    }
  }
}
