import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../frontend/components/custom_small_button.dart';
import '../../../../frontend/pages/address_page.dart/address_page_controller.dart';
import '../../exchange/exchange_page_controller.dart';
import '../../../components/address_box.dart';
import '../../../../enums.dart';

class SetAddressScreen extends StatefulWidget {
  const SetAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SetAddressScreen> createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  final addressController = Get.put(AddressPageController());
  final exchangeController = Get.find<ExchangePageController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressPageController>(builder: (addressController) {
      return Column(
        children: [
          SizedBox(
            height: Get.height * 0.37,
            child: Column(
              children: [
                AddressBox(
                  isActive: addressController.isFirstBoxValid.value,
                  hintText:
                      'وارد کردن آدرس ${exchangeController.destinationCurrency?.symbol?.toUpperCase()}',
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
                    isActive: addressController.isssecondBoxValid.value,
                    hintText: ' وارد کردن آدرس پشتیبان',
                    textController:
                        addressController.textSupportAddressController,
                  ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height < 700 ? Get.height * 0.2 : Get.height * 0.25,
          ),
          buildNextButton(addressController),
        ],
      );
    });
  }

  buildNextButton(AddressPageController addressController) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomSmallButton(
              onPressed: () => addressController.addAddress(context),
              child: SizedBox(
                  height: 60,
                  width: 120,
                  child: Center(
                    child: addressController.isPressed.value
                        ? const CircularProgressIndicator()
                        : Text(
                            addressController.currenButton.value ==
                                        Button.first ||
                                    addressController.currenButton.value ==
                                        Button.second
                                ? 'بعدی'
                                : 'شروع تبادل',
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                          ),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle?>(
                    Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(color: Theme.of(context).backgroundColor),
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(color: Theme.of(context).backgroundColor)),
                  shape: MaterialStateProperty.all<OutlinedBorder?>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              onPressed: () => Get.back(),
              child: const Padding(
                padding: EdgeInsets.only(
                    left: 35.0, right: 35.0, top: 8.0, bottom: 8.0),
                child: Text(
                  'بازگشت',
                ),
              ),
            ),
          ),
        ],
      );
}



 /*  () async {
                setState(() {
                  isPressed = true;
                });
                log('current boutton: $currenButton');

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
                            currencyNetwork: exchangeController
                                .destinationCurrency!.inNetwork!);
                    log('current boutton: $currenButton');

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
                      Get.snackbar(
                          'توجه!',
                          'آدرس کیف پول '
                              '${exchangeController.sourceCurrency!.symbol!.toUpperCase()} '
                              'وارد شده معتبر نیست');
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
               */
            