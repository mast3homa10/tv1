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
    this.destinationAmount = 2087.933444,
    this.destinationCurrency = 'test',
    this.destinationNetwork = 'test',
    this.directionOfExchangeFlow = 'test',
    this.message = 'test',
    this.minAndMaxEstimatedTime = 'test',
    this.rateId = 'test',
    this.sourceAmount = 0.1,
    this.sourceCurrency = 'test',
    this.sourceNetwork = 'test',
    this.type = 'test',
    this.validUntil = 'test',
  });

  EstimateExchangeAmountModel fromJson(json) => EstimateExchangeAmountModel(
        destinationAmount: json['destinationAmount'],
        destinationCurrency: json['destinationCurrency'],
        destinationNetwork: json['destinationNetwork'],
        directionOfExchangeFlow: json['directionOfExchangeFlow'],
        rateId: json['rateId'],
        sourceAmount: json['sourceAmount'],
        sourceCurrency: json['sourceCurrency'],
        sourceNetwork: json['sourceNetwork'],
        type: json['type'],
        message: json['message'],
        minAndMaxEstimatedTime: json['minAndMaxEstimatedTime'],
        validUntil: json['validUntil'],
      );

  @override
  toString() =>
      "\n {rateId: $rateId}, {destinationAmount: $destinationAmount}, {destinationCurrency: $destinationCurrency ...}";
}
