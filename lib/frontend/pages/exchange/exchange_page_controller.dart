import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../backend/api/check_pair_be_vaild.dart';
import '../../../backend/api/estimate_exchange_amount.dart';
import '../../../backend/api/get_exchange_rate.dart';
import '../../../backend/models/check_pair_be_vaild_model.dart';
import '../../../backend/models/estimate_exchange_amount_model.dart';
import '../../../backend/models/init_tabel_model.dart';
import '../../../backend/api/init_table.dart';
import '../../../backend/models/currency_model.dart';

class ExchangePageController extends GetxController {
  TextEditingController sourceTextController = TextEditingController();
  TextEditingController destinationTextController = TextEditingController();

  var isSupportAddressMustBeEmpty = false.obs;
  setSupportAddress() => isSupportAddressMustBeEmpty = true.obs;

  var isSecondBoxShow = false.obs;
  showSecondBox() => isSecondBoxShow = true.obs;

  RxBool connectToNetwork = false.obs;
  RxBool isFixed = false.obs;
  RxBool isReversed = false.obs;
  var currentTopItem = 0.obs;
  var searchController = 0.obs;
  var userAddress = ''.obs;
  var supportAddress = ''.obs;
  var maximumExchangeAmount = 0.0.obs;
  var minimumExchangeAmount = 0.0.obs;
  CurrencyModel? sourceCurrency;
  var sourceAmount = 0.0.obs;
  CurrencyModel? destinationCurrency;
  var destinationAmount = 0.0.obs;
  List<CurrencyModel>? forSellList;
  List<CurrencyModel>? forBuyList;
  List<CurrencyModel>? currencyList = [];
  InitTabelModel? estimate;
  CheckPairBeVaildModel? pairBeValid;
  @override
  void onInit() {
    checkConnection();
    super.onInit();
  }

  late Timer searchOnStoppedTyping =
      Timer(const Duration(milliseconds: 800), () => search('here'));

  onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    searchOnStoppedTyping.cancel();
    update();
    /* setState(
        () => searchOnStoppedTyping = new Timer(duration, () => search(value))); */
    searchOnStoppedTyping = Timer(duration, () => search(value));
    update();
  }

  search(value) {
    log('hello world from search . the value is $value');
  }

  updateEstimateAmount(double sellAmount, double buyAmount) {
    sourceAmount = 0.0.obs;
    destinationAmount = 0.0.obs;
    sourceAmount = sellAmount.obs;
    destinationAmount = buyAmount.obs;
    sourceTextController.text = sourceAmount.toString();
    destinationTextController.text = destinationAmount.toString();
    update();
  }

  validation({
    CurrencyModel? currencyForBuy,
    CurrencyModel? currencyForSell,
  }) async {
    String tempType = isFixed.value ? "fix" : "not-fix";

    pairBeValid = await CheckPairBeVaildApi().getPairBeVaild(
      type: tempType,
      sourceNetwork: currencyForSell!.inNetwork,
      sourceCurrency: currencyForSell.symbol,
      destinationNetwork: currencyForBuy!.inNetwork,
      destinationCurrency: currencyForBuy.symbol,
    );
    message(title: 'pair be vaild ', content: pairBeValid!);
    if (pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
      var exchangeRate = await GetExchangeRateApi().getExchangeRate(
        type: tempType,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
      );
      minimumExchangeAmount = exchangeRate!.minimumExchangeAmount!.obs;
      maximumExchangeAmount = double.parse(
              exchangeRate.maximumExchangeAmount! == ''
                  ? '0'
                  : exchangeRate.maximumExchangeAmount!)
          .obs;
      EstimateExchangeAmountModel? est =
          await EstimateExchangeAmountApi().getAmount(
        type: tempType,
        sourceNetwork: currencyForSell.inNetwork,
        sourceCurrency: currencyForSell.symbol,
        destinationNetwork: currencyForBuy.inNetwork,
        destinationCurrency: currencyForBuy.symbol,
        directionOfExchangeFlow: 'direct',
        sourceAmount: minimumExchangeAmount.value,
      );
      updateEstimateAmount(
          minimumExchangeAmount.value, est!.destinationAmount ?? 0);
      log("forSellAmount :$sourceAmount");
      log("estimate amount :${est.destinationAmount}");
      message(title: 'get exchange rate ', content: exchangeRate);
    } else if (!pairBeValid!.type!['fix'] && pairBeValid!.type!['not-fix']) {
    } else {
      Get.snackbar('توجه!', "این جفت ارز با هم قابل مبادله نیستند");
    }

    update();
  }

  //check connection to network
  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');
        connectToNetwork = true.obs;
        //get init table
        var initTable = await InitTableApi().initTable();
        estimate = initTable!['estimate'] ?? [];

        updateEstimateAmount(
            estimate!.sourceAmount!, estimate!.destinationAmount!);
        log('Estimate Amount : ${estimate!.destinationAmount}.');

        // get currency list
        currencyList = initTable['list'] ?? {};
        /*         
        currencyList = await CurrencyListApi().getList();
        */
        sourceCurrency = currencyList!
            .where((item) => item.engName!.toLowerCase() == 'bitcoin')
            .first;
        log("sourceCurrency is ${sourceCurrency!.engName} .");
        destinationCurrency = currencyList!
            .where((item) => item.engName!.toLowerCase() == 'ethereum')
            .first;
        log("destinationCurrency is ${destinationCurrency!.engName} .");

        // Source currency will be selected from ""sellList"".
        forSellList = currencyList!
            .where((item) => item.availableForSell == true)
            .toList();

        // Destination currency  will be selected from ""buyList"".
        forBuyList = currencyList!
            .where((item) => item.availableForBuy == true)
            .toList();
        /*      
        log("forSellList :$forSellList");
        log("forBuyList :$forBuyList");
        */
        update();
      }
    } on SocketException catch (_) {
      log('not connected');
      connectToNetwork = false.obs;
      update();
    }
  }

  setAddress(String address) {
    userAddress = address.obs;
    update();
  }

  updateCurrencyChoice({required CurrencyModel currency, required int item}) {
    if (item == 1) {
      destinationCurrency = currency;
      validation(
          currencyForBuy: destinationCurrency, currencyForSell: sourceCurrency);
    } else {
      sourceCurrency = currency;
      validation(
          currencyForBuy: destinationCurrency, currencyForSell: sourceCurrency);
    }
    update();
  }

  cahngeSearchController(int index) {
    searchController = index.obs;
    update();
  }

  getCurrentTopItem(int index) {
    currentTopItem = index.obs;
    update();
  }

  RxBool isScreenChange = false.obs;
  changeScreen() {
    isScreenChange = isScreenChange.value ? false.obs : true.obs;
    update();
    message(title: 'is screen Change', content: isScreenChange.value);
  }

  changeReversed() {
    isReversed = isReversed.value ? false.obs : true.obs;
    update();
    message(title: 'is reversed', content: isReversed.value);
  }

// for dispaly lock icon (fix) or not
  updateFix() {
    isFixed = isFixed.value ? false.obs : true.obs;
    update();
    message(title: 'is Icon Change', content: isFixed.value);
  }

  message({String title = '', var content}) {
    log('$title : $content');
  }
}
