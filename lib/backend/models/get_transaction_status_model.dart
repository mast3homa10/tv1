class GetTransactionStatusModel {
  String? txId;
  String? txStatus;
  String? actionsAvailable;
  String? sourceCurrency;
  String? sourceCurrencyImage;
  String? sourceCurrencyFaName;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationCurrencyImage;
  String? destinationCurrencyFaName;
  String? destinationNetwork;
  double? expectedAmountFromSource;
  double? expectedAmountToDestination;
  String? amountFromSource;
  String? amountToDestination;
  String? payinAddress;
  String? payoutAddress;
  String? payinExtraId;
  String? payoutExtraId;
  String? refundAddress;
  String? refundExtraId;
  String? createdAt;
  String? updatedAt;
  String? depositReceivedDate;
  String? payinHash;
  String? payoutHash;
  String? fromLegacyTicker;
  String? toLegacyTicker;

  GetTransactionStatusModel(
      {this.actionsAvailable,
      this.amountFromSource,
      this.amountToDestination,
      this.createdAt,
      this.depositReceivedDate,
      this.destinationCurrency,
      this.destinationCurrencyFaName,
      this.destinationCurrencyImage,
      this.destinationNetwork,
      this.expectedAmountFromSource,
      this.expectedAmountToDestination,
      this.fromLegacyTicker,
      this.payinAddress,
      this.payinExtraId,
      this.payinHash,
      this.payoutAddress,
      this.payoutExtraId,
      this.payoutHash,
      this.refundAddress,
      this.refundExtraId,
      this.sourceCurrency,
      this.sourceCurrencyFaName,
      this.sourceCurrencyImage,
      this.sourceNetwork,
      this.toLegacyTicker,
      this.txId,
      this.txStatus,
      this.updatedAt});

  GetTransactionStatusModel.fromJson(json) {
    actionsAvailable = json['actionsAvailable'];
    amountFromSource = json['amountFromSource'];
    amountToDestination = json['amountToDestination'];
    createdAt = json['createdAt'];
    depositReceivedDate = json['depositReceivedDate'];
    destinationCurrency = json['destinationCurrency'];
    destinationCurrencyFaName = json['destinationCurrencyFaName'];
    destinationCurrencyImage = json['destinationCurrencyImage'];
    destinationNetwork = json['destinationNetwork'];
    expectedAmountFromSource = json['expectedAmountFromSource'];
    expectedAmountToDestination = json['expectedAmountToDestination'];
    fromLegacyTicker = json['fromLegacyTicker'];
    payinAddress = json['payinAddress'];
    payinExtraId = json['payinExtraId'];
    payinHash = json['payinHash'];
    payoutAddress = json['payoutAddress'];
    payoutExtraId = json['payoutExtraId'];
    payoutHash = json['payoutHash'];
    refundAddress = json['refundAddress'];
    refundExtraId = json['refundExtraId'];
    sourceCurrency = json['sourceCurrency'];
    sourceCurrencyFaName = json['sourceCurrencyFaName'];
    sourceCurrencyImage = json['sourceCurrencyImage'];
    sourceNetwork = json['sourceNetwork'];
    toLegacyTicker = json['toLegacyTicker'];
    txId = json['txId'];
    txStatus = json['txStatus'];
    updatedAt = json['updatedAt'];
  }

  @override
  toString() => "\n {txId: $txId}, {txStatus: $txStatus ...},";
}
