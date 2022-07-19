import 'dart:io';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../constants.dart';
import '../../../backend/api/init_table.dart';
import '../../../backend/api/get_exchange_rate.dart';
import '../../../backend/api/check_pair_be_valid.dart';
import '../../../backend/models/currency_model.dart';
import '../../../backend/api/estimate_exchange_amount.dart';
import '../../../backend/models/check_pair_be_valid_model.dart';
import '../../../backend/models/estimate_exchange_amount_model.dart';
import '../../../backend/models/get_exchange_rate_model.dart';
import '../../../backend/models/init_table_model.dart';

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

  var isSourceHasLimitation = false.obs;
  var isDestinationHasLimitation = false.obs;
  var amount = 0.0.obs;

  @override
  void onInit() {
    checkConnection();

    super.onInit();
  }

  late Timer sendOnStoppedTyping = Timer(const Duration(milliseconds: 800),
      () => log('request on stopped typing'));

  //
  var isTimerStop = false.obs;
  updateTimer() {
    isTimerStop = isTimerStop.value ? false.obs : true.obs;
    update();
  }

  var isFirstTyping = false.obs;
  var isSecondTyping = false.obs;
// use ""firstOnChange"" & ""secondOnChange"" to send request after stop typing
  firstOnChange(value) {
    isFirstTyping = true.obs;
    isSourceHasLimitation = false.obs;
    isDestinationHasLimitation = false.obs;
    const duration = Duration(milliseconds: 600);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => isSwapped.value
            ? updateExchange(
                source: destinationCurrency,
                destination: sourceCurrency,
                isFix: isFixedPressed.value ? true : false,
                isForReverse: false,
              )
            : updateExchange(
                source: sourceCurrency,
                destination: destinationCurrency,
                isFix: isFixedPressed.value ? true : false,
                isForReverse: false,
              ));
    update();
  }

  secondOnChange(value) {
    isSecondTyping = true.obs;
    isFixedPressed = true.obs;
    isSourceHasLimitation = false.obs;
    isDestinationHasLimitation = false.obs;
    const duration = Duration(milliseconds: 600);
    sendOnStoppedTyping.cancel();
    sendOnStoppedTyping = Timer(
        duration,
        () => isSwapped.value
            ? updateExchange(
                isFix: true,
                isForReverse: true,
                source: destinationCurrency,
                destination: sourceCurrency)
            : updateExchange(
                isFix: true,
                isForReverse: true,
                source: sourceCurrency,
                destination: destinationCurrency));
    isFixedPressed = true.obs;

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
      {required CurrencyModel currency, var isFix = false, required int item}) {
    if (isSwapped.value) {
      if (item == 1) {
        sourceCurrency = currency;
        updateExchange(
            destination: sourceCurrency,
            source: destinationCurrency,
            isForReverse: false);
        isFirstTyping = true.obs;
      } else {
        destinationCurrency = currency;
        updateExchange(
          destination: sourceCurrency,
          source: destinationCurrency,
          isFix: isFix,
          isForReverse: true,
        );
        isFirstTyping = true.obs;
      }
    } else {
      if (item == 1) {
        destinationCurrency = currency;
        updateExchange(
          destination: destinationCurrency,
          source: sourceCurrency,
          isFix: isFix,
          isForReverse: true,
        );
        isFirstTyping = true.obs;
      } else {
        sourceCurrency = currency;
        updateExchange(
          destination: destinationCurrency,
          source: sourceCurrency,
          isForReverse: false,
        );
        isFirstTyping = true.obs;
      }
    }

    update();
  }

  var searchItem = 0.obs;
  updateSearchItem(int index) {
    searchItem = index.obs;
    update();
  }

  RxBool isSwapped = false.obs;

// "updateSwap" change source with destination currency.
  updateSwap() {
    isSwapped = !isSwapped.value ? false.obs : true.obs;

    if (isSwapped.value) {
      isFirstTyping = true.obs;
      if (isFixedPressed.value) {
        updateExchange(
          source: destinationCurrency,
          destination: sourceCurrency,
          isFix: true,
          isForReverse: false,
        );
      } else {
        updateExchange(
          source: destinationCurrency,
          destination: sourceCurrency,
          isForReverse: false,
        );
      }
    } else {
      isFirstTyping = true.obs;

      if (isFixedPressed.value) {
        updateExchange(
          source: sourceCurrency,
          destination: destinationCurrency,
          isFix: true,
          isForReverse: false,
        );
      } else {
        updateExchange(
          source: sourceCurrency,
          destination: destinationCurrency,
          isForReverse: false,
        );
      }
    }
    update();
    message(title: 'is Swapped', content: isSwapped.value);
  }

  InitTabelModel? initEstimate;
  List<CurrencyModel>? forSellList;
  List<CurrencyModel>? forBuyList;
  List<CurrencyModel>? currencyList = [];
// "_initTable" is for get currency list and default currencies (estimate)
  _initTable() async {
    var initTableData = await InitTableApi().initTable();
    initEstimate = initTableData!['estimate'] ?? [];
    sourceAmount = initEstimate!.sourceAmount!.obs;
    sourceTextController.text = kPersianDigit(sourceAmount);
    destinationAmount = initEstimate!.destinationAmount!.obs;
    destinationTextController.text = kPersianDigit(destinationAmount);
    // save currencies in "currencyList".
    currencyList = initTableData['list'] ?? {};
    //get default "source" & "destination" currencies.
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

  updateExchange({
    var source,
    var destination,
    var isFix = false,
    var isForReverse = false,
  }) {
    _pairBeValid(
        currencyForSell: source,
        currencyForBuy: destination,
        isFix: isFix,
        isForReverse: isForReverse);
    update();
  }

  _pairBeValid(
      {var currencyForBuy,
      var currencyForSell,
      var isFix = false,
      var isForReverse = false}) async {
    pairBeValid = await CheckPairBeVaildApi().getPairBeVaild(
      type: isFixedPressed.value ? "fix" : "not-fix",
      sourceNetwork: currencyForSell!.inNetwork,
      sourceCurrency: currencyForSell.symbol,
      destinationNetwork: currencyForBuy!.inNetwork,
      destinationCurrency: currencyForBuy.symbol,
    );
    bool isAvalibleFix = pairBeValid!.type!['fix'];
    message(title: 'fix can be ', content: '$isAvalibleFix');
    message(title: 'pair be valid ', content: pairBeValid!);

    if (!pairBeValid!.type!['fix'] && !pairBeValid!.type!['not-fix']) {
      Get.defaultDialog(
        title: "توجه!",
        content: const Text(
          "این جفت ارز با هم قابل مبادله نیستند",
        ),
      );
      isFixedPressed = false.obs;
      update();
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
        if (isFix && isAvalibleFix) {
          if (isForReverse) {
            _exchangeRate(
                isForReverse: isFix,
                currencyForSell: currencyForSell,
                currencyForBuy: currencyForBuy,
                type: 'fix');
          } else {
            _exchangeRate(
                isForReverse: !isFix,
                currencyForSell: currencyForSell,
                currencyForBuy: currencyForBuy,
                type: 'fix');
          }
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
      var isFix = false,
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

    message(title: 'minimumExchangeAmount ', content: minimumExchangeAmount);
    message(title: 'maximumExchangeAmount ', content: maximumExchangeAmount);
    message(title: 'get exchange rate ', content: exchangeRate);

    double tempAmount = isForReverse
        ? double.parse(destinationTextController.text.toEnglishDigit())
        : double.parse(sourceTextController.text.toEnglishDigit());
    amount = tempAmount.obs;
    if (amount < minimumExchangeAmount.value ||
        (amount > maximumExchangeAmount.value &&
            maximumExchangeAmount.value > 0)) {
      if (isForReverse) {
        isDestinationHasLimitation = true.obs;
      } else {
        isSourceHasLimitation = true.obs;
      }
      update();
    } else {
      if (isFix) {
        if (isForReverse) {
          _estimateAmount(
              currencyForSell: currencyForSell,
              currencyForBuy: currencyForBuy,
              type: 'fix',
              amount: amount.value,
              isForReverse: isForReverse,
              directionOfExchangeFlow: 'reverse');
        } else {
          _estimateAmount(
              currencyForSell: currencyForSell,
              currencyForBuy: currencyForBuy,
              type: 'fix',
              amount: amount.value,
              isForReverse: isForReverse,
              directionOfExchangeFlow: 'direct');
        }
      } else {
        _estimateAmount(
            currencyForSell: currencyForSell,
            currencyForBuy: currencyForBuy,
            type: type,
            amount: amount.value,
            isForReverse: isForReverse,
            directionOfExchangeFlow: 'direct');
      }
    }
    update();
  }

  var time = 0.obs;
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
      time = date2.difference(date1).inSeconds.obs;
      update();
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

  RxBool isFixedPressed = false.obs;
// for display lock icon (fix) or not.
  updateFix() {
    isFixedPressed = isFixedPressed.value ? false.obs : true.obs;
    isSourceHasLimitation = false.obs;
    isDestinationHasLimitation = false.obs;
    update();
    message(title: 'is fix enable', content: isFixedPressed.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
