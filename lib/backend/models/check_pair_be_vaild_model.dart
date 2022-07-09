class CheckPairBeVaildModel {
  String? sourceCurrency;
  String? sourceNetwork;
  String? destinationCurrency;
  String? destinationNetwork;
  Map<String, dynamic>? type;
  CheckPairBeVaildModel(
      {this.sourceCurrency = 'test',
      this.sourceNetwork = 'test',
      this.destinationCurrency = 'test',
      this.destinationNetwork = 'test',
      this.type});

  CheckPairBeVaildModel.fromJson(json) {
    sourceCurrency = json["checkPair"][0]["sourceCurrency"];
    sourceNetwork = json["checkPair"][0]["sourceNetwork"];
    destinationCurrency = json["checkPair"][0]["destinationCurrency"];
    destinationNetwork = json["checkPair"][0]["destinationNetwork"];
    if (json["checkPair"][0]["type"] != null) {
      type = json["checkPair"][0]["type"];
    }
  }
  @override
  toString() =>
      "\n {sourceCurrency: $sourceCurrency}, {destinationCurrency: $destinationCurrency}, {type: $type}";
}
