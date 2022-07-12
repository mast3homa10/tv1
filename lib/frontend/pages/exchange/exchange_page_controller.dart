import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
  RxBool isFixedPressed = false.obs;
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
  var pairBeValidType = ''.obs;

  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  late Timer sendOnStoppedTyping = Timer(const Duration(milliseconds: 800),
      () => log('request on stopped typing'));

// use ""firstOnChange"" & ""secondOnChange"" to send request after stop typing
  firstOnChange(value) {
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

  //check connection to network with "checkConnection" function.
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        message(title: 'Connection', content: 'connected');
        connectToNetwork = true.obs;
        //get init table
        _initTable();
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

// "_initTable" is for get currency list and default currecnys (estimate)
  _initTable() async {
    var initTableData = await InitTableApi().initTable();
    estimate = initTableData!['estimate'] ?? [];
    sourceAmount = estimate!.sourceAmount!.obs;
    sourceTextController.text = sourceAmount.toString();
    destinationAmount = estimate!.destinationAmount!.obs;
    destinationTextController.text = destinationAmount.toString();
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
    log('is fix : $isFixed');
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
        if (isFixedPressed.value || isForReverse && isFixed) {
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
      if (!currencyForBuy.availableForSell ||
          !currencyForSell.availableForBuy) {
        Get.defaultDialog(
            title: 'توجه!',
            content: const Text('امکان فروش برای ارزهای مورد نظر ممکن نیست'));
        return;
      } else {
        isFixedPressed = true.obs;
        update();
        exchangeRate = await GetExchangeRateApi().getExchangeRate(
          type: type,
          isForReverse: isForReverse,
          sourceNetwork: currencyForBuy.inNetwork,
          sourceCurrency: currencyForBuy.symbol,
          destinationNetwork: currencyForSell.inNetwork,
          destinationCurrency: currencyForSell.symbol,
        );
      }
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
          content: Text('مقدار وارد شده کمتر از مقدار مجاز میباشد.'
              '\nکمترین مقدار مجاز : ${minimumExchangeAmount.value}'));
      destinationTextController.text = '';
    } else if (amount > maximumExchangeAmount.value &&
        maximumExchangeAmount.value > 0) {
      Get.defaultDialog(
          title: 'توجه!',
          content: Text('مقدار وارد شده بیشتر از مقدار مجاز میباشد.'
              '\nبیشترین مقدار مجاز : ${maximumExchangeAmount.value}'));
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

// for dispaly lock icon (fix) or not.
  updateFix() {
    isFixedPressed = isFixedPressed.value ? false.obs : true.obs;
    update();
    message(title: 'is Icon Change', content: isFixedPressed.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}

/*   if (pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      if (isFixed.value) {
        _exchangeRate(
            isForReverse: isForReverse,
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: 'fix');
      } else {
        _exchangeRate(
            isForReverse: isForReverse,
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: 'not_fix');
      }
    } else if (!pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      if (isFixed.value) {
        Get.defaultDialog(
          title: "توجه!",
          content: const Text(
            'جفت ارز انتخابی قابلیت استفاده از نرخ ثابت را ندارند',
          ),
        );
        isFixed = false.obs;
        update();
      } else {
        _exchangeRate(
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: "not-fix");
      }
    } else {
      Get.defaultDialog(
        title: "توجه!",
        content: const Text(
          "این جفت ارز با هم قابل مبادله نیستند",
        ),
      );
    } */
