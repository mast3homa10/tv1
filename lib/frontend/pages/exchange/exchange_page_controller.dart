import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../constants.dart';
import '../../../backend/api/init_table.dart';
import '../../../backend/api/get_exchange_rate.dart';
import '../../../backend/api/check_pair_be_vaild.dart';
import '../../../backend/models/currency_model.dart';
import '../../../backend/api/estimate_exchange_amount.dart';
import '../../../backend/models/check_pair_be_vaild_model.dart';
import '../../../backend/models/estimate_exchange_amount_model.dart';
import '../../../backend/models/get_exchange_rate_model.dart';
import '../../../backend/models/init_tabel_model.dart';

class ExchangePageController extends GetxController {
  TextEditingController sourceTextController = TextEditingController();
  TextEditingController destinationTextController = TextEditingController();

  var sourceAmount = 0.0.obs;
  var destinationAmount = 0.0.obs;
  var maximumExchangeAmount = 0.0.obs;
  var minimumExchangeAmount = 0.0.obs;

  CheckPairBeVaildModel? pairBeValid;
  GetExchangeRateModel? exchangeRate;
  EstimateExchangeAmountModel? estimateAmount;

  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  late Timer sendOnStoppedTyping = Timer(const Duration(milliseconds: 800),
      () => log('request on stopped typing'));

  var isFirstTyping = false.obs;
  var isSecondTyping = false.obs;
// use ""firstOnChange"" & ""secondOnChange"" to send request after stop typing
  firstOnChange(value) {
    isFirstTyping = true.obs;
    const duration = Duration(milliseconds: 600);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => updateExchange(
              source: sourceCurrency,
              destination: destinationCurrency,
            ));
    update();
  }

  secondOnChange(value) {
    isSecondTyping = true.obs;
    const duration = Duration(milliseconds: 600);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => updateExchange(
            isForReverse: true,
            source: sourceCurrency,
            destination: destinationCurrency));
    update();
  }

  RxBool isConnectToNetwork = false.obs;
  RxBool isTrying = false.obs;
  //check connection to network with "checkConnection" function.
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        message(title: 'Connection', content: 'connected');
        isConnectToNetwork = true.obs;
        isTrying = false.obs;
        update();

        //get init table
        _initTable();
        isTrying = false.obs;
        update();
      } else {
        message(title: 'Connection', content: 'not connected');
        isConnectToNetwork = false.obs;
        isTrying = true.obs;

        update();
      }
    } on SocketException catch (_) {
      log('$_');
      message(title: 'Connection', content: 'not connected');
      isConnectToNetwork = false.obs;
      update();
    }
  }

  CurrencyModel? sourceCurrency;
  CurrencyModel? destinationCurrency;
  updateCurrencyChoice(
      {required CurrencyModel currency,
      var isForReverse = false,
      required int item}) {
    if (item == 1) {
      destinationCurrency = currency;
      updateExchange(
          destination: destinationCurrency,
          source: sourceCurrency,
          isForReverse: isForReverse);
    } else {
      sourceCurrency = currency;
      updateExchange(destination: destinationCurrency, source: sourceCurrency);
    }
    update();
  }

  var searchItem = 0.obs;
  updateSearchItem(int index) {
    searchItem = index.obs;
    update();
  }

  RxBool isReversed = false.obs;
// "updateReversed" change source with destination currency.
  updateReversed() {
    isReversed = isReversed.value ? false.obs : true.obs;
    if (isReversed.value) {
      updateExchange(source: destinationCurrency, destination: sourceCurrency);
    } else {
      updateExchange(source: sourceCurrency, destination: destinationCurrency);
    }
    update();
    message(title: 'is reversed', content: isReversed.value);
  }

  InitTabelModel? initEstimate;
  List<CurrencyModel>? forSellList;
  List<CurrencyModel>? forBuyList;
  List<CurrencyModel>? currencyList = [];
// "_initTable" is for get currency list and default currecnys (estimate)
  _initTable() async {
    var initTableData = await InitTableApi().initTable();
    initEstimate = initTableData!['estimate'] ?? [];
    sourceAmount = initEstimate!.sourceAmount!.obs;
    sourceTextController.text = kPersianDigit(sourceAmount);
    destinationAmount = initEstimate!.destinationAmount!.obs;
    destinationTextController.text = kPersianDigit(destinationAmount);
    // save currencys in "currnecylist".
    currencyList = initTableData['list'] ?? {};
    //get default "source" & "destination" currencys.
    sourceCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'bitcoin')
        .first;
    log("sourceCurrency is ${sourceCurrency!.engName} .");

    destinationCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'ethereum')
        .first;
    log("destinationCurrency is ${destinationCurrency!.engName} .");

    // divide [currencyList] to 2 sub lists : "forSellList" ,"forBuyList"
    // Source currency will be selected from "forSellList".
    forSellList =
        currencyList!.where((item) => item.availableForSell == true).toList();

    // Destination currency  will be selected from "forBuyList".
    forBuyList =
        currencyList!.where((item) => item.availableForBuy == true).toList();
    update();
  }

  _pairBeVaild(
      {var currencyForBuy,
      var currencyForSell,
      var isForReverse = false}) async {
    pairBeValid = await CheckPairBeVaildApi().getPairBeVaild(
      type: isFixedPressed.value ? "fix" : "not-fix",
      sourceNetwork: currencyForSell!.inNetwork,
      sourceCurrency: currencyForSell.symbol,
      destinationNetwork: currencyForBuy!.inNetwork,
      destinationCurrency: currencyForBuy.symbol,
    );
    bool isFixed = pairBeValid!.type!['fix'];
    message(title: 'is fix ', content: '$isFixed');
    message(title: 'pair be vaild ', content: pairBeValid!);

    if (!pairBeValid!.type!['fix'] && !pairBeValid!.type!['not-fix']) {
      Get.defaultDialog(
        title: "توجه!",
        content: const Text(
          "این جفت ارز با هم قابل مبادله نیستند",
        ),
      );
    } else {
      if (!pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
        if (isFixedPressed.value) {
          Get.defaultDialog(
            title: "توجه!",
            content: const Text(
              'جفت ارز انتخابی قابلیت استفاده از نرخ ثابت را ندارند',
            ),
          );
          isFixedPressed = false.obs;
          update();
        } else {
          _exchangeRate(
              currencyForSell: currencyForSell,
              currencyForBuy: currencyForBuy,
              type: "not-fix");
        }
      } else {
        if (isForReverse && isFixed) {
          _exchangeRate(
              isForReverse: isForReverse,
              currencyForSell: currencyForSell,
              currencyForBuy: currencyForBuy,
              type: 'fix');
        } else {
          _exchangeRate(
              currencyForSell: currencyForSell,
              currencyForBuy: currencyForBuy,
              type: 'not-fix');
        }
      }
    }

    update();
  }

  _exchangeRate(
      {var currencyForSell,
      var currencyForBuy,
      var type,
      var isForReverse = false}) async {
    if (isForReverse) {
      exchangeRate = await GetExchangeRateApi().getExchangeRate(
        type: type,
        isForReverse: isForReverse,
        sourceNetwork: currencyForBuy.inNetwork,
        sourceCurrency: currencyForBuy.symbol,
        destinationNetwork: currencyForSell.inNetwork,
        destinationCurrency: currencyForSell.symbol,
      );
    } else {
      exchangeRate = await GetExchangeRateApi().getExchangeRate(
        type: type,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
      );
    }
    minimumExchangeAmount = exchangeRate!.minimumExchangeAmount!.obs;
    maximumExchangeAmount = double.parse(
            exchangeRate!.maximumExchangeAmount! == ''
                ? '0'
                : exchangeRate!.maximumExchangeAmount!)
        .obs;

    message(title: 'get exchange rate ', content: exchangeRate);
    double amount = 0;

    amount = isForReverse
        ? double.parse(destinationTextController.text.toEnglishDigit())
        : double.parse(sourceTextController.text.toEnglishDigit());
    var currencyName =
        isForReverse ? destinationCurrency!.faName : sourceCurrency!.faName;

    if (amount < minimumExchangeAmount.value) {
      Get.defaultDialog(
          title: 'توجه!',
          content: Text(
              'مقدار $currencyName وارد شده کمتر از مقدار مجاز میباشد.'
              '\nکمترین مقدار مجاز : ${kPersianDigit(minimumExchangeAmount.value)}'),
          onWillPop: () async {
            if (isForReverse) {
              destinationTextController.text =
                  kPersianDigit(minimumExchangeAmount.value);
              secondOnChange(destinationTextController.text);
            } else {
              sourceTextController.text =
                  kPersianDigit(minimumExchangeAmount.value);
              firstOnChange(sourceTextController.text);
            }
            return true;
          });
      destinationTextController.text = '';
    } else if (amount > maximumExchangeAmount.value &&
        maximumExchangeAmount.value > 0) {
      Get.defaultDialog(
          title: 'توجه!',
          content: Text('مقدار $currencyName شده بیشتر از مقدار مجاز میباشد.'
              '\nبیشترین مقدار مجاز : ${kPersianDigit(maximumExchangeAmount.value)}'));
    } else {
      if (isForReverse) {
        _estimateAmount(
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: 'fix',
            amount: amount,
            isForReverse: isForReverse,
            directionOfExchangeFlow: 'reverse');
      } else {
        _estimateAmount(
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: type,
            amount: amount,
            isForReverse: isForReverse,
            directionOfExchangeFlow: 'direct');
      }
    }
    update();
  }

  _estimateAmount(
      {var currencyForSell,
      var currencyForBuy,
      String directionOfExchangeFlow = 'direct',
      double amount = 0,
      bool isForReverse = false,
      String type = "not-fix"}) async {
    if (isForReverse) {
      estimateAmount = await EstimateExchangeAmountApi().getAmount(
        isForReverse: isForReverse,
        type: type,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
        directionOfExchangeFlow: directionOfExchangeFlow,
        destinationAmount: amount,
      );
    } else {
      estimateAmount = await EstimateExchangeAmountApi().getAmount(
        type: type,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
        directionOfExchangeFlow: directionOfExchangeFlow,
        sourceAmount: amount,
      );
    }
    message(title: 'Estimate amount', content: estimateAmount);
    if (estimateAmount!.validUntil != '') {
      message(title: 'valid Until ', content: "${estimateAmount!.validUntil}");
      DateTime date1 = DateTime.now();
      DateTime date2 = DateTime.parse(estimateAmount!.validUntil!);
      var time = date2.difference(date1).inSeconds.obs;

      message(title: 'time ', content: ' $time');
    }
    if (isFirstTyping.value) {
      isFirstTyping = false.obs;
      destinationAmount = estimateAmount!.destinationAmount!.obs;
      destinationTextController.text = kPersianDigit(destinationAmount);
    } else {
      isSecondTyping = false.obs;
      sourceAmount = estimateAmount!.sourceAmount!.obs;
      sourceTextController.text = kPersianDigit(sourceAmount);
    }

    message(
        title: 'for sell amount(source) ',
        content: estimateAmount!.sourceAmount);
    message(
        title: 'for buy amount(destination) ',
        content: estimateAmount!.destinationAmount);
    update();
  }

  updateExchange({var source, var destination, var isForReverse = false}) {
    _pairBeVaild(
        currencyForSell: source,
        currencyForBuy: destination,
        isForReverse: isForReverse);
    update();
  }

  RxBool isFixedPressed = false.obs;
// for dispaly lock icon (fix) or not.
  updateFix() {
    isFixedPressed = isFixedPressed.value ? false.obs : true.obs;
    update();
    message(title: 'is fix enable', content: isFixedPressed.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
