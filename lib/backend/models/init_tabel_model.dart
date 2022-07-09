class InitTabelModel {
  String? sourceCurrency;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationNetwork;
  String? type;
  String? directionOfExchangeFlow;
  String? rateId;
  String? minAndMaxEstimatedTime;
  String? message;
  double? sourceAmount = 0.0002242;
  double? destinationAmount = 0.0018322;
  String? validUntil;

  InitTabelModel(
      {this.sourceCurrency = 'btc',
      this.sourceNetwork = 'btc',
      this.destinationCurrency = 'eth',
      this.destinationNetwork = 'eth',
      this.type = 'not-fix',
      this.directionOfExchangeFlow = 'direct',
      this.rateId = '',
      this.minAndMaxEstimatedTime = '10-60',
      this.message = '',
      this.sourceAmount = 0.0002242,
      this.destinationAmount = 0.0018322,
      this.validUntil = ''});
  InitTabelModel.fromJson(json)
      : sourceCurrency = json['sourceCurrency'],
        sourceNetwork = json['sourceNetwork'],
        destinationCurrency = json['destinationCurrency'],
        destinationNetwork = json['destinationNetwork'],
        type = json['type'],
        directionOfExchangeFlow = json['directionOfExchangeFlow'],
        rateId = json['rateId'],
        minAndMaxEstimatedTime = json['minAndMaxEstimatedTime'],
        message = json['message'],
        sourceAmount = json['sourceAmount'],
        destinationAmount = json['destinationAmount'],
        validUntil = json['validUntil'];

  @override
  toString() =>
      "\n {sourceAmount: $sourceAmount}, {destinationAmount: $destinationAmount ...},";
}
