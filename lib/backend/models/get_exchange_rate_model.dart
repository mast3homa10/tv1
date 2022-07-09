class GetExchangeRateModel {
  String? sourceCurrency;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationNetwork;
  String? type;
  String? maximumExchangeAmount;
  double? minimumExchangeAmount;

  GetExchangeRateModel({
    this.maximumExchangeAmount = '',
    this.minimumExchangeAmount = 0,
    this.destinationCurrency = 'test',
    this.destinationNetwork = 'test',
    this.sourceCurrency = 'test',
    this.sourceNetwork = 'test',
    this.type = 'test',
  });

  GetExchangeRateModel.fromJson(json) {
    destinationCurrency = json['destinationCurrency'];
    destinationNetwork = json['destinationNetwork'];
    sourceCurrency = json['sourceCurrency'];
    sourceNetwork = json['sourceNetwork'];
    type = json['type'];
    maximumExchangeAmount = json['maximumExchangeAmount'].toString();
    minimumExchangeAmount = json['minimumExchangeAmount'];
  }

  @override
  toString() =>
      "\n {minimumExchangeAmount: $minimumExchangeAmount}, {type: $type ...},";
}
