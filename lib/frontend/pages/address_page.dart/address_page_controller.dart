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
  var currentTopItem = 0.obs;

  getCurrentTopItem(int index) {
    currentTopItem = index.obs;
    update();
  }

  var isSupportAddressMustBeEmpty = false.obs;
  setSupportAddress() => isSupportAddressMustBeEmpty = true.obs;

  var isSecondBoxShow = false.obs;
  showSecondBox() => isSecondBoxShow = true.obs;

  var isPressed = false.obs;
  var currenButton = Button.first.obs;
  var textAddressController = TextEditingController();
  var textSupportAddressController = TextEditingController();
  var exchangeController = ExchangePageController();
  late BuildContext context;

  addAddress() async {
    isPressed = true.obs;

    if (currenButton == Button.first.obs) {
      if (textAddressController.text.isEmpty) {
        isPressed = false.obs;

        Get.snackbar(
            'توجه!', "برای شروع تبادل باید آدرس کیف پول خود را وارد کنید.");
      } else {
        ValidationAddressModel? validAddress = await ValidationAddressApi()
            .getValidation(
                address: textAddressController.text,
                currencyNetwork:
                    exchangeController.destinationCurrency!.inNetwork!);
        if (validAddress!.isValid == 'true') {
          showSecondBox();
          currenButton = Button.second.obs;
          isPressed = false.obs;
        } else {
          isPressed = false.obs;

          Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
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
                currencyNetwork: exchangeController.sourceCurrency!.inNetwork!);
        if (validAddress!.isValid == 'true') {
          currenButton = Button.last.obs;
          isPressed = false.obs;
        } else {
          isPressed = false.obs;

          Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
        }

        isPressed = false.obs;
      }
    } else {
      var create = await CreateTransactionApi().create();
      final finalController = Get.put(FinalStepsController());
      finalController.setTransactioin(create!);

      log('here:${create.payinAddress}');
      Get.to(() => const StepsPage());

      isPressed = false.obs;
    }
  }
}
