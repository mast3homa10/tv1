import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../../../backend/api/create_transaction.dart';
import '../../../../backend/api/validation_address.dart';
import '../../../../backend/models/validation_address_model.dart';
import '../../exchange/exchange_page_controller.dart';
import '../../steps/steps_page_controller.dart';
import '../../../components/address_box.dart';
import '../../steps/steps_page.dart';
import '../../../components/custom_big_button.dart';
import '../../../../enums.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final addressController = Get.put(AddressPageController());
  final exchangeController = Get.find<ExchangePageController>();
  bool isPressed = false;
  bool isFirstBoxValid = false;
  bool isssecondBoxValid = false;
  Button currenButton = Button.first;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: Get.height * 0.37,
            child: Column(
              children: [
                AddressBox(
                  isActive: isFirstBoxValid,
                  hintText: 'وارد کردن آدرس',
                  textController: addressController.textAddressController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                      child: GestureDetector(
                        child: Text(
                          'کیف پول ندارید؟',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        onTap: () {
                          Get.snackbar('توجه!', 'در حال توسعه ...');
                        },
                      ),
                    ),
                  ],
                ),
                if (addressController.isSecondBoxShow.value)
                  AddressBox.support(
                    isActive: isssecondBoxValid,
                    hintText: ' وارد کردن آدرس پشتیبان',
                    textController:
                        addressController.textSupportAddressController,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height < 700 ? Get.height * 0.2 : Get.height * 0.25,
            // height: Get.height < 700 ? Get.height * 0.1 : Get.height * 0.15,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomBigButton(
              isPressed: isPressed,
              label:
                  currenButton == Button.first || currenButton == Button.second
                      ? 'بعدی'
                      : 'شروع تبادل',
              onPressed: () async {
                setState(() {
                  isPressed = true;
                });
                if (currenButton == Button.first) {
                  if (addressController.textAddressController.text.isEmpty) {
                    setState(() {
                      isPressed = false;
                    });
                    Get.snackbar('توجه!',
                        "برای شروع تبادل باید آدرس کیف پول خود را وارد کنید.");
                  } else {
                    ValidationAddressModel? validAddress =
                        await ValidationAddressApi().getValidation(
                            address:
                                addressController.textAddressController.text,
                            currencyNetwork:
                                exchangeController.sourceCurrency!.inNetwork!);
                    if (validAddress!.isValid == 'true') {
                      setState(() {
                        addressController.showSecondBox();
                        currenButton = Button.second;
                        isPressed = false;
                        isFirstBoxValid = true;
                      });
                    } else {
                      setState(() {
                        isPressed = false;
                      });
                      Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
                    }
                  }
                } else if (currenButton == Button.second) {
                  if (addressController
                          .textSupportAddressController.text.isEmpty &&
                      currenButton == Button.second) {
                    Get.defaultDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
                                setState(() {
                                  currenButton = Button.last;
                                  isPressed = false;
                                  isssecondBoxValid = true;
                                });
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
                                setState(() {
                                  isPressed = false;
                                });
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    ValidationAddressModel? validAddress =
                        await ValidationAddressApi().getValidation(
                            address: addressController
                                .textSupportAddressController.text,
                            currencyNetwork:
                                exchangeController.sourceCurrency!.inNetwork!);
                    if (validAddress!.isValid == 'true') {
                      setState(() {
                        currenButton = Button.last;
                        isPressed = false;
                        isssecondBoxValid = true;
                      });
                    } else {
                      setState(() {
                        isPressed = false;
                      });
                      Get.snackbar('توجه!', "آدرس وارد شده معتبر نیست");
                    }
                    setState(() {
                      isPressed = false;
                    });
                  }
                } else {
                  var create = await CreateTransactionApi().create();
                  final finalController = Get.put(FinalStepsController());
                  finalController.setTransactioin(create!);

                  log('here:${create.payinAddress}');
                  Get.to(() => const StepsPage());
                  setState(() {
                    isPressed = false;
                  });
                }
              },
            ),
          )
        ],
      );
    });
  }
}
