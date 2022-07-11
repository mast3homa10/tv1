import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tv1/backend/api/currency_list_api.dart';

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
  var isTyping = false.obs;
  var mainAddress = ''.obs;
  var supportAddress = ''.obs;

  RxBool connectToNetwork = false.obs;
  RxBool isFixed = false.obs;
  RxBool isReversed = false.obs;
  var searchItem = 0.obs;

  var maximumExchangeAmount = 0.0.obs;
  var minimumExchangeAmount = 0.0.obs;
  CurrencyModel? sourceCurrency;
  var sourceAmount = 0.0.obs;
  CurrencyModel? destinationCurrency;
  var destinationAmount = 0.0.obs;
  List<CurrencyModel>? forSellList;
  List<CurrencyModel>? forBuyList;
  List<CurrencyModel>? currencyList = [];
  CheckPairBeVaildModel? pairBeValid;
  GetExchangeRateModel? exchangeRate;
  InitTabelModel? estimate;
  EstimateExchangeAmountModel? estimateAmount;
  var tempType = ''.obs;

  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  late Timer sendOnStoppedTyping = Timer(const Duration(milliseconds: 800),
      () => log('request on stopped typing'));

// use '''onChangeHandler''' to send request after stop typing
  firstOnChange(value) {
    const duration = Duration(milliseconds: 600);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => updateExchange(
              source: sourceCurrency,
              destination: destinationCurrency,
            ));

    // () => updateExchange(
    // source: sourceCurrency, destination: destinationCurrency));
    update();
  }

  secondOnChange(value) {
    const duration = Duration(milliseconds: 800);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => updateExchange(
            isForReverse: true,
            source: sourceCurrency,
            destination: destinationCurrency));

    update();
  }

  //check connection to network
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        message(title: 'Connection', content: 'connected');
        connectToNetwork = true.obs;
        //get init table
        initTable();
        update();
      }
    } on SocketException catch (_) {
      message(title: 'Connection', content: 'not connected');
      connectToNetwork = false.obs;
      update();
    }
  }

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

  updateSearchItem(int index) {
    searchItem = index.obs;
    update();
  }

// updateReversed update '''fix''' value.
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

  initTable() async {
    var initTableData = await InitTableApi().initTable();
    estimate = initTableData!['estimate'] ?? [];
    sourceAmount = estimate!.sourceAmount!.obs;
    sourceTextController.text = sourceAmount.toString();
    destinationAmount = estimate!.destinationAmount!.obs;
    destinationTextController.text = destinationAmount.toString();
    // get currency list
    currencyList = initTableData['list'] ?? {};
    sourceCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'bitcoin')
        .first;
    log("sourceCurrency is ${sourceCurrency!.engName} .");

    destinationCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'ethereum')
        .first;
    log("destinationCurrency is ${destinationCurrency!.engName} .");

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
    tempType = isFixed.value ? "fix".obs : "not-fix".obs;
    pairBeValid = await CheckPairBeVaildApi().getPairBeVaild(
      type: tempType.toString(),
      sourceNetwork: currencyForSell!.inNetwork,
      sourceCurrency: currencyForSell.symbol,
      destinationNetwork: currencyForBuy!.inNetwork,
      destinationCurrency: currencyForBuy.symbol,
    );
    message(title: 'pair be vaild ', content: pairBeValid!);

    if (pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      _exchangeRate(
          isForReverse: isForReverse,
          currencyForSell: currencyForSell,
          currencyForBuy: currencyForBuy,
          type: tempType.value);
    } else if (!pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      _exchangeRate(
          currencyForSell: currencyForSell,
          currencyForBuy: currencyForBuy,
          type: "not-fix");
    } else {
      Get.snackbar('توجه!', "این جفت ارز با هم قابل مبادله نیستند");
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
        ? double.parse(destinationTextController.text)
        : double.parse(sourceTextController.text);
    if (amount < minimumExchangeAmount.value) {
      Get.defaultDialog(
          title: 'توجه!',
          content: const Text('مقدار وارد شده کمتر از مقدار مجاز میباشد.'));
      destinationTextController.text = '';
    }
    /* else if (amount > maximumExchangeAmount.value) {
      Get.defaultDialog(
          title: 'توجه!',
          content: const Text('مقدار وارد شده بیشتر از مقدار مجاز میباشد.'));
    } */
    else {
      _estimateAmount(
          currencyForSell: currencyForSell,
          currencyForBuy: currencyForBuy,
          type: type,
          amount: amount,
          isForReverse: isForReverse,
          directionOfExchangeFlow: isForReverse ? 'reverse' : 'direct');
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
      log('here dasf');

      estimateAmount = await EstimateExchangeAmountApi().getAmount(
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

    sourceAmount = estimateAmount!.sourceAmount!.obs;
    sourceTextController.text = sourceAmount.toString();
    destinationAmount = estimateAmount!.destinationAmount!.obs;
    destinationTextController.text = destinationAmount.toString();

    message(title: 'forSellAmount :', content: sourceAmount);
    message(
        title: 'estimate amount :', content: estimateAmount!.destinationAmount);
    update();
  }

  updateExchange({var source, var destination, var isForReverse = false}) {
    _pairBeVaild(
        currencyForSell: source,
        currencyForBuy: destination,
        isForReverse: isForReverse);
    update();
  }

  updateList() async {
    var currencyList2 = await CurrencyListApi().getList();

    sourceCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'bitcoin')
        .first;
    log("sourceCurrency is ${sourceCurrency!.engName} .");

    destinationCurrency = currencyList!
        .where((item) => item.engName!.toLowerCase() == 'ethereum')
        .first;
    log("destinationCurrency is ${destinationCurrency!.engName} .");

    // Source currency will be selected from "forSellList".
    forSellList =
        currencyList!.where((item) => item.availableForSell == true).toList();

    // Destination currency  will be selected from "forBuyList".
    forBuyList =
        currencyList!.where((item) => item.availableForBuy == true).toList();
    update();
  }

// for dispaly lock icon (fix) or not.
  updateFix() {
    isFixed = isFixed.value ? false.obs : true.obs;
    update();
    message(title: 'is Icon Change', content: isFixed.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
