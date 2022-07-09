class CreateTransactionModel {
  String? id;
  String? sourceCurrency;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationNetwork;

  String? payoutAddress;
  String? type;
  String? directionOfExchangeFlow;
  String? rateId;

  String? refundExtraId;
  String? refundAddress;
  String? payinAddress;
  String? payinExtraId;
  String? payoutExtraId;
  String? payoutExtraIdName;
  double? sourceAmount;
  double? destinationAmount;
  CreateTransactionModel(
      {this.id = 'test',
      this.sourceAmount = 0.1,
      this.destinationAmount = 2100.903587,
      this.destinationCurrency = 'test',
      this.destinationNetwork = 'test',
      this.directionOfExchangeFlow = 'test',
      this.payinAddress = 'test',
      this.payinExtraId = 'test',
      this.payoutAddress = 'test',
      this.payoutExtraId = 'test',
      this.payoutExtraIdName = 'test',
      this.rateId = 'test',
      this.refundAddress = 'test',
      this.refundExtraId = 'test',
      this.sourceCurrency = 'test',
      this.sourceNetwork = 'test',
      this.type});

  CreateTransactionModel fromJson(json) => CreateTransactionModel(
      id: json['id'],
      destinationAmount: json['destinationAmount'],
      destinationCurrency: json['destinationCurrency'],
      destinationNetwork: json['destinationNetwork'],
      directionOfExchangeFlow: json['directionOfExchangeFlow'],
      payinAddress: json['payinAddress'],
      payinExtraId: json['payinExtraId'],
      payoutAddress: json['payoutAddress'],
      payoutExtraId: json['payoutExtraId'],
      payoutExtraIdName: json['payoutExtraIdName'],
      rateId: json['rateId'],
      refundAddress: json['refundAddress'],
      refundExtraId: json['refundExtraId'],
      sourceAmount: json['sourceAmount'],
      sourceCurrency: json['sourceCurrency'],
      sourceNetwork: json['sourceNetwork'],
      type: json['type']);

  @override
  toString() =>
      "\n {id: $id}, {destinationAmount: $destinationAmount}, {destinationCurrency: $destinationCurrency ...}";
}
