class EstimateExchangeAmountModel {
  String? sourceCurrency;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationNetwork;
  String? type;
  String? directionOfExchangeFlow;
  String? rateId;
  String? minAndMaxEstimatedTime;
  String? message;
  double? sourceAmount;
  double? destinationAmount;
  String? validUntil;

  EstimateExchangeAmountModel({
    this.destinationAmount,
    this.destinationCurrency,
    this.destinationNetwork,
    this.directionOfExchangeFlow,
    this.message,
    this.minAndMaxEstimatedTime,
    this.rateId,
    this.sourceAmount,
    this.sourceCurrency,
    this.sourceNetwork,
    this.type,
    this.validUntil,
  });

  EstimateExchangeAmountModel.fromJson(json) {
    destinationAmount = json['destinationAmount'].toDouble();
    destinationCurrency = json['destinationCurrency'];
    destinationNetwork = json['destinationNetwork'];
    directionOfExchangeFlow = json['directionOfExchangeFlow'];
    rateId = json['rateId'];
    sourceAmount = json['sourceAmount'].toDouble();
    sourceCurrency = json['sourceCurrency'];
    sourceNetwork = json['sourceNetwork'];
    type = json['type'];
    message = json['message'];
    minAndMaxEstimatedTime = json['minAndMaxEstimatedTime'];
    validUntil = json['validUntil'];
  }

  @override
  toString() => "\n{{rateId: $rateId},\n{sourceAmount: $sourceAmount},"
      "\n{destinationAmount: $destinationAmount},\n{type: $type},"
      "\n{directionOfExchangeFlow: $directionOfExchangeFlow},\n...}";
}
